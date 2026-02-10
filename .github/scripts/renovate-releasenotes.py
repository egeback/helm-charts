#!/usr/bin/env python

import os
import sys
import typer

from git import Repo
from loguru import logger
from pathlib import Path

from ruamel.yaml import YAML
from ruamel.yaml.comments import CommentedMap
from ruamel.yaml.scalarstring import LiteralScalarString
from typing import List

app = typer.Typer(add_completion=False)


def _setup_logging(debug):
    """
    Setup the log formatter for this script
    """

    log_level = "INFO"
    if debug:
        log_level = "DEBUG"

    logger.remove()
    logger.add(
        sys.stdout,
        colorize=True,
        format="<level>{message}</level>",
        level=log_level,
    )

def _bump_patch_version(version_str: str) -> str:
    """
    Increments the patch version of a semver string
    """
    parts = version_str.split('.')
    if len(parts) >= 3:
        try:
            patch = int(parts[2])
            parts[2] = str(patch + 1)
            return '.'.join(parts)
        except ValueError:
            pass
    return version_str


@app.command()
def main(
    chart_folders: List[Path] = typer.Argument(
        ..., help="Folders containing the chart to process"),
    check_branch: str = typer.Option(
        None, help="The branch to compare against."),
    chart_base_folder: Path = typer.Option(
        "charts", help="The base folder where the charts reside."),
    debug: bool = False,
):
    _setup_logging(debug)

    git_repository = Repo(search_parent_directories=True)

    if check_branch:
        logger.info(f"Trying to find branch {check_branch}...")
        branch = next(
            (ref for ref in git_repository.remotes.origin.refs if ref.name == check_branch),
            None
        )
    else:
        logger.info(f"Trying to determine default branch...")
        branch = next(
            (ref for ref in git_repository.remotes.origin.refs if ref.name == "origin/HEAD"),
            None
        )

    if not branch:
        logger.error(
            f"Could not find branch {check_branch} to compare against.")
        raise typer.Exit(1)

    logger.info(f"Comparing against branch {branch}")

    for chart_folder in chart_folders:
        chart_folder = chart_base_folder.joinpath(chart_folder)
        if not chart_folder.is_dir():
            logger.error(f"Could not find folder {str(chart_folder)}")
            raise typer.Exit(1)

        chart_metadata_file = chart_folder.joinpath('Chart.yaml')
        values_file = chart_folder.joinpath('values.yaml')

        if not chart_metadata_file.is_file():
            logger.error(f"Could not find file {str(chart_metadata_file)}")
            raise typer.Exit(1)

        logger.info(f"Updating changelog and version for chart {chart_folder}")

        yaml = YAML(typ=['rt', 'string'])
        yaml.indent(mapping=2, sequence=4, offset=2)
        yaml.explicit_start = True
        yaml.preserve_quotes = True
        yaml.width = 4096

        old_chart_metadata = yaml.load(
            git_repository.git.show(f"{branch}:{chart_metadata_file}")
        )
        new_chart_metadata = yaml.load(chart_metadata_file.read_text())

        # Check if appVersion changed
        app_version_changed = False
        if "appVersion" in new_chart_metadata and "appVersion" in old_chart_metadata:
            if new_chart_metadata["appVersion"] != old_chart_metadata["appVersion"]:
                app_version_changed = True
                logger.info(f"Detected appVersion change: {old_chart_metadata['appVersion']} -> {new_chart_metadata['appVersion']}")

        # Check if values.yaml changed
        values_changed = False
        if values_file.is_file():
            try:
                old_values_content = git_repository.git.show(f"{branch}:{values_file}")
                new_values_content = values_file.read_text()
                if old_values_content != new_values_content:
                    values_changed = True
                    logger.info("Detected changes in values.yaml")
            except Exception as e:
                logger.warning(f"Could not compare values.yaml: {e}")

        try:
            old_chart_dependencies = old_chart_metadata["dependencies"]
        except KeyError:
            old_chart_dependencies = []

        try:
            new_chart_dependencies = new_chart_metadata["dependencies"]
        except KeyError:
            new_chart_dependencies = []

        annotations = []
        
        # Add annotation for appVersion change
        if app_version_changed:
            annotations.append({
                "kind": "changed",
                "description": f"Update application to {new_chart_metadata['appVersion']}"
            })
        
        # Add annotation for values.yaml changes (excluding appVersion changes already covered)
        if values_changed and not app_version_changed:
             annotations.append({
                "kind": "changed",
                "description": "Update image tags or configuration in values.yaml"
            })

        for dependency in new_chart_dependencies:
            old_dep = None
            if "alias" in dependency.keys():
                old_dep = next(
                    (old_dep for old_dep in old_chart_dependencies if "alias" in old_dep.keys(
                    ) and old_dep["alias"] == dependency["alias"]),
                    None
                )
            else:
                old_dep = next(
                    (old_dep for old_dep in old_chart_dependencies if old_dep["name"] == dependency["name"]),
                    None
                )

            add_annotation = False
            if old_dep:
                if dependency["version"] != old_dep["version"]:
                    add_annotation = True
            else:
                add_annotation = True

            if add_annotation:
                if "alias" in dependency.keys():
                    annotations.append({
                        "kind": "changed",
                        "description": f"Upgraded `{dependency['name']}` chart dependency to version {dependency['version']} for alias '{dependency['alias']}'"
                    })
                else:
                    annotations.append({
                        "kind": "changed",
                        "description": f"Upgraded `{dependency['name']}` chart dependency to version {dependency['version']}"
                    })

        if annotations:
            # Bump chart version
            old_version = new_chart_metadata.get("version", "0.1.0")
            new_version = _bump_patch_version(old_version)
            new_chart_metadata["version"] = new_version
            logger.info(f"Bumping chart version: {old_version} -> {new_version}")

            # Update annotations - ensure they are properly formatted for ArtifactHub
            # We use a separate YAML dumper to ensure strings are quoted if they contain special characters
            ah_yaml = YAML()
            ah_yaml.indent(mapping=2, sequence=4, offset=2)
            ah_yaml.width = 4096
            annotations_str = ah_yaml.dump_to_string(annotations)

            if not "annotations" in new_chart_metadata:
                new_chart_metadata["annotations"] = CommentedMap()

            new_chart_metadata["annotations"]["artifacthub.io/changes"] = LiteralScalarString(
                annotations_str)
            
            yaml.dump(new_chart_metadata, chart_metadata_file)


if __name__ == "__main__":
    app()

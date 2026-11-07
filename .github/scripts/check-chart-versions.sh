#!/usr/bin/env bash
# Fail when a chart changed without a chart version bump.
#
#   check-chart-versions.sh --base <git-ref> [chart...]
#       PRs: compare each chart against <git-ref> (the target branch).
#   check-chart-versions.sh --release-tags [chart...]
#       main: compare each chart against its release tag <chart>-<version>.
#       A chart whose tag does not exist yet is about to be released: OK.
#
# Charts default to every directory under charts/. README.md is ignored:
# helm-docs regenerates it without a chart change.
set -euo pipefail

mode="${1:-}"; shift || true
case "$mode" in
  --base) base="${1:?--base needs a git ref}"; shift ;;
  --release-tags) base="" ;;
  *) echo "usage: $0 --base <ref> [chart...] | --release-tags [chart...]" >&2; exit 2 ;;
esac

charts=("$@")
if [ ${#charts[@]} -eq 0 ]; then
  for dir in charts/*/; do charts+=("$(basename "$dir")"); done
fi

version_of() { # <ref|WORKTREE> <chart>
  if [ "$1" = WORKTREE ]; then
    awk '/^version:/ {print $2; exit}' "charts/$2/Chart.yaml"
  else
    # A chart that does not exist at <ref> yet (new chart) has no version there
    { git show "$1:charts/$2/Chart.yaml" 2>/dev/null || true; } | awk '/^version:/ {print $2; exit}'
  fi
}

failed=0
for chart in "${charts[@]}"; do
  [ -f "charts/$chart/Chart.yaml" ] || continue
  version="$(version_of WORKTREE "$chart")"

  if [ -n "$base" ]; then
    ref="$base"
    base_version="$(version_of "$ref" "$chart")"
    if [ -z "$base_version" ]; then
      echo "ok    $chart $version (new chart)"; continue
    fi
    if [ "$base_version" != "$version" ]; then
      echo "ok    $chart $base_version -> $version"; continue
    fi
  else
    ref="refs/tags/$chart-$version"
    if ! git rev-parse -q --verify "$ref" >/dev/null; then
      echo "ok    $chart $version (not released yet)"; continue
    fi
  fi

  changed="$(git diff --name-only "$ref" -- "charts/$chart" | grep -v '/README\.md$' || true)"
  if [ -n "$changed" ]; then
    echo "FAIL  $chart $version changed without a version bump (vs ${ref#refs/tags/}):"
    sed 's/^/        /' <<<"$changed"
    failed=1
  else
    echo "ok    $chart $version (unchanged)"
  fi
done

if [ "$failed" -ne 0 ]; then
  echo "::error::Bump the version in Chart.yaml of the charts above (and add an artifacthub.io/changes entry)."
fi
exit "$failed"

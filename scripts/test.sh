#!/usr/bin/env bash
# Test presets by Renovate's dry-run.
# Each directory tests/<preset> has:
#   files/: files scanned by Renovate
#   expected.json: dependencies Renovate extracts from files/ with <preset>.json
# --dry-run=extract doesn't look up new versions, so the result doesn't depend on network and tokens.
# Run with UPDATE=true to update expected.json.
#
# Usage: bash scripts/test.sh [<preset> ...]

set -euo pipefail

# The latest Renovate is used because the hosted Renovate app, which most users use, is always the latest.
# Renovate requires Node.js 24
node_version=24.22.1 # renovate: depName=node

renovate() {
	# The lower bound prevents npx from using an older Renovate installed globally.
	# With a bare "renovate" or "renovate@latest", npx used the global Renovate v37.
	npx -y -p "node@$node_version" -p "renovate@>=44" -- renovate "$@"
}

echo "[INFO] Renovate $(renovate --version)" >&2

if [ $# -eq 0 ]; then
	for dir in tests/*/; do
		set -- "$@" "$(basename "$dir")"
	done
fi

tempdir=$(mktemp -d)
trap 'rm -rf "$tempdir"' EXIT

failed=false
for preset in "$@"; do
	echo "[INFO] Testing $preset" >&2
	work=$tempdir/$preset
	mkdir -p "$work"
	cp -R "tests/$preset/files" "$work/repo"
	# Replace the preset parameter so that the preset is applied to all files
	jq 'walk(if type == "string" then gsub("\\{\\{arg0\\}\\}"; ".*") else . end)' "$preset.json" >"$work/config.json"
	(
		cd "$work/repo"
		LOG_FORMAT=json LOG_LEVEL=info RENOVATE_CONFIG_FILE=../config.json \
			renovate --platform=local --dry-run=extract --onboarding=false --require-config=ignored
	) >"$work/log.json"
	# Drop fields depending on a token such as skipReason
	grep '^{' "$work/log.json" | jq -s '
		[
			.[]
			| select(.msg == "Extracted dependencies")
			| .packageFiles
			| to_entries[]
			| .key as $manager
			| .value[]
			| .packageFile as $file
			| .deps[]
			| {manager: $manager, packageFile: $file, depName, packageName, currentValue, currentDigest, datasource, replaceString}
			| with_entries(select(.value != null))
		]
		| sort_by(.packageFile)' >"$work/actual.json"
	if [ "${UPDATE:-}" = true ]; then
		cp "$work/actual.json" "tests/$preset/expected.json"
		continue
	fi
	if ! diff -u "tests/$preset/expected.json" "$work/actual.json"; then
		echo "[ERROR] The result of $preset is different from tests/$preset/expected.json" >&2
		failed=true
	fi
done

if [ "$failed" = true ]; then
	exit 1
fi

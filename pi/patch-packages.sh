#!/usr/bin/env bash
# Re-apply local patches to installed pi packages. Safe to run repeatedly.
# Run after `pi update` (which reinstalls packages and drops the patches).
#
# Patches live in pi/patches/<package>@<version>.patch. A patch is only applied
# when the installed version matches, so pin that version in pi/settings.json.

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
modules=~/.pi/agent/npm/node_modules

for patchfile in patches/*.patch; do
	[[ -e $patchfile ]] || continue
	spec=$(basename "$patchfile" .patch)
	name=${spec%@*}
	want=${spec##*@}
	dir=$modules/$name

	if [[ ! -f $dir/package.json ]]; then
		echo "⚠️  $name isn't installed; skipping $patchfile"
		continue
	fi
	have=$(sed -n 's/^[[:space:]]*"version":[[:space:]]*"\([^"]*\)".*/\1/p' "$dir/package.json" | head -1)
	if [[ $have != "$want" ]]; then
		echo "⚠️  $name is $have but $patchfile targets $want; skipping (rebase the patch or pin $want)"
		continue
	fi

	if patch -d "$dir" -p1 -R --dry-run -s -f < "$patchfile" >/dev/null 2>&1; then
		echo "✓ $name@$have already patched"
	elif patch -d "$dir" -p1 -N --dry-run -s -f < "$patchfile" >/dev/null 2>&1; then
		patch -d "$dir" -p1 -N -s -f < "$patchfile"
		echo "✓ patched $name@$have"
	else
		echo "⚠️  $patchfile doesn't apply cleanly to $name@$have; skipping"
	fi
done

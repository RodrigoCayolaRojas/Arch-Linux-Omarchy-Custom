#!/bin/bash
#
# Privileged groups are never granted by the default install. The scripts that
# could grant them have been removed, and nothing references them anymore. Raw
# input-device access is granted only by the optional controller and ydotool
# installers.

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

export OMARCHY_PROVISIONING_DIR="$TMPDIR/provisioning"
export OMARCHY_PATH="$ROOT"

[[ ! -e "$ROOT/install/config/docker.sh" ]] || fail "docker group grant is removed"
[[ ! -e "$ROOT/install/config/browser-policy.sh" ]] || fail "browser-policy group grant is removed"
[[ ! -e "$ROOT/install/hardware/input-group.sh" ]] || fail "blanket input-group grant is removed"

! grep -E 'docker\.sh|browser-policy\.sh|input-group' "$ROOT/install/config/all.sh" "$ROOT/install/hardware/all.sh" >/dev/null ||
  fail "install entrypoints no longer call the removed privileged-grant scripts"
pass "default install has no privileged-group grants"
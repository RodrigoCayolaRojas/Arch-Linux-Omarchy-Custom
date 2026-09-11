#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

test_tmp=$(mktemp -d)
trap 'rm -rf "$test_tmp"' EXIT

mock_bin="$test_tmp/bin"
test_home="$test_tmp/home"
marker="$test_home/.local/state/omarchy/preinstalls-removed"
pkg_log="$test_tmp/packages"
mkdir -p "$mock_bin" "$test_home/.local/state/omarchy"

for command in omarchy-webapp-remove-all omarchy-tui-remove-all omarchy-refresh-applications hyprctl; do
  printf '#!/bin/bash\nexit 0\n' >"$mock_bin/$command"
done

cat >"$mock_bin/gum" <<'SH'
#!/bin/bash
[[ $1 == confirm ]] && exit "${OMARCHY_TEST_CONFIRM:-0}"
exit 0
SH

cat >"$mock_bin/omarchy-pkg-add" <<'SH'
#!/bin/bash
printf '%s\n' "$@" >"$OMARCHY_TEST_PKG_LOG"
exit "${OMARCHY_TEST_PKG_ADD_STATUS:-0}"
SH

cat >"$mock_bin/omarchy-pkg-drop" <<'SH'
#!/bin/bash
printf '%s\n' "$@" >"$OMARCHY_TEST_PKG_LOG"
SH

chmod +x "$mock_bin"/*

# $ROOT/bin after the mocks: Remove Preinstalls asks omarchy-install-hermes-cli
# whether the wrapper is Omarchy's rather than matching the marker itself, and
# that is the real command at runtime. The mocks still shadow what they name.
export PATH="$mock_bin:$ROOT/bin:$PATH"
export HOME="$test_home"
export OMARCHY_TEST_PKG_LOG="$pkg_log"

# Preinstalls now cover only launchers (web apps, TUIs, mise stubs), never a
# package set: the Fujitsu profile ships no preinstalled desktop applications,
# so both scripts run without touching omarchy-pkg-add/omarchy-pkg-drop.
"$ROOT/bin/omarchy-install-preinstalls" >/dev/null
[[ ! -s $pkg_log ]] || fail "Install Preinstalls no longer installs packages"
pass "Install Preinstalls restores launchers without installing packages"

"$ROOT/bin/omarchy-remove-preinstalls" >/dev/null
[[ ! -s $pkg_log ]] || fail "Remove Preinstalls no longer removes packages"
pass "Remove Preinstalls removes launchers without touching packages"

# The bindings key off the marker, so it has to track what is actually installed.
touch "$marker"
"$ROOT/bin/omarchy-install-preinstalls" >/dev/null
[[ ! -e $marker ]] || fail "restore clears the opt-out marker"
pass "restore clears the opt-out marker"

rm -f "$marker"
OMARCHY_TEST_CONFIRM=1 "$ROOT/bin/omarchy-remove-preinstalls" >/dev/null
[[ ! -e $marker ]] || fail "declining Remove Preinstalls changes nothing"
pass "declining Remove Preinstalls changes nothing"

"$ROOT/bin/omarchy-remove-preinstalls" >/dev/null
[[ -f $marker ]] || fail "Remove Preinstalls records the opt-out"
pass "Remove Preinstalls records the opt-out"

# Hermes' wrapper is only a preinstall when omarchy-install-hermes-cli wrote it.
# The desktop app's command and an official install live at the same path and
# are the user's, whether or not any package says so.
hermes="$test_home/.local/bin/hermes"
mkdir -p "$(dirname "$hermes")"

printf '%s\n' "#!/bin/bash" "# Written by omarchy-install-hermes-cli." >"$hermes"
chmod +x "$hermes"
"$ROOT/bin/omarchy-remove-preinstalls" >/dev/null
[[ ! -e $hermes ]] || fail "Remove Preinstalls deletes the Omarchy Hermes wrapper"
pass "Remove Preinstalls deletes the Omarchy Hermes wrapper"

printf '%s\n' "#!/bin/bash" "exec $test_home/.hermes/hermes-agent/venv/bin/hermes \"\$@\"" >"$hermes"
chmod +x "$hermes"
"$ROOT/bin/omarchy-remove-preinstalls" >/dev/null
[[ -x $hermes ]] || fail "Remove Preinstalls keeps the desktop app's Hermes command"
pass "Remove Preinstalls keeps the desktop app's Hermes command"

official_body="#!/bin/bash
unset PYTHONPATH
unset PYTHONHOME
exec $test_home/.hermes/hermes-agent/venv/bin/hermes \"\$@\""
printf '%s\n' "$official_body" >"$hermes"
chmod +x "$hermes"
"$ROOT/bin/omarchy-remove-preinstalls" >/dev/null
[[ -x $hermes && $(cat "$hermes") == "$official_body" ]] || fail "Remove Preinstalls keeps an official Hermes install"
pass "Remove Preinstalls keeps an official Hermes install"

printf '%s\n' "#!/bin/bash" "# Replaces the stub omarchy-install-hermes-cli used to write." >"$hermes"
chmod +x "$hermes"
"$ROOT/bin/omarchy-remove-preinstalls" >/dev/null
[[ -x $hermes ]] || fail "Remove Preinstalls keeps a wrapper that merely mentions the installer"
pass "Remove Preinstalls keeps a wrapper that merely mentions the installer"

rm -f "$hermes"
ln -s "$test_home/nowhere/hermes" "$hermes"
"$ROOT/bin/omarchy-remove-preinstalls" >/dev/null
[[ -L $hermes ]] || fail "Remove Preinstalls keeps a foreign hermes link"
pass "Remove Preinstalls keeps a foreign hermes link"

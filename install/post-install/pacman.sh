# Configure pacman after package installation completes. Offline target package
# installs use the live ISO's offline pacman.conf until this final restore.
cp -f "$OMARCHY_PATH/default/pacman/pacman-${OMARCHY_MIRROR:-stable}.conf" /etc/pacman.conf
cp -f "$OMARCHY_PATH/default/pacman/mirrorlist-${OMARCHY_MIRROR:-stable}" /etc/pacman.d/mirrorlist

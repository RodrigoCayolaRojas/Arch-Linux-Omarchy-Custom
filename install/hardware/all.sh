# Fujitsu P727 profile: only Intel graphics, audio, network and thermal
# management. Everything self-gates on detection, so it also works unchanged
# on any other Intel laptop.

run_logged "$OMARCHY_INSTALL/hardware/network.sh"
run_logged "$OMARCHY_INSTALL/hardware/set-wireless-regdom.sh"
run_logged "$OMARCHY_INSTALL/hardware/bluetooth.sh"
run_logged "$OMARCHY_INSTALL/hardware/vulkan.sh"
run_logged "$OMARCHY_INSTALL/hardware/fix-synaptic-touchpad.sh"

run_logged "$OMARCHY_INSTALL/hardware/intel/video-acceleration.sh"
run_logged "$OMARCHY_INSTALL/hardware/intel/lpmd.sh"
run_logged "$OMARCHY_INSTALL/hardware/intel/thermald.sh"
run_logged "$OMARCHY_INSTALL/hardware/intel/sof-firmware.sh"

run_logged "$OMARCHY_INSTALL/hardware/speaker-tuning.sh"
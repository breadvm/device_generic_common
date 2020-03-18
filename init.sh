#
# Copyright (C) 2013 The Android-x86 Open Source Project
#
# License: GNU Public License v2 or later
#

function set_property()
{
	# this must be run before post-fs stage
	echo $1=$2 >> /x86.prop
}

function init_sharedir()
{
	mkdir -p /mnt/share
	mountsf share /mnt/share
	#chown root:system /mnt/share
	#chmod 0775 /mnt/share
}

function init_misc()
{

}

function init_hal_audio()
{
	return
}

function init_hal_bluetooth()
{
	return
}

function init_hal_camera()
{
	return
}

function init_hal_gps()
{
	# TODO
	return
}

function set_drm_mode()
{
	return
}

function init_hal_lights()
{
#	chown 1000.1000 /sys/class/backlight/*/brightness
}

function init_hal_power()
{
	for p in /sys/class/rtc/*; do
		echo disabled > $p/device/power/wakeup
	done

	# TODO
	case "$PRODUCT" in
		*)
			;;
	esac
}

function init_hal_sensors()
{
	return
}

function init_ril()
{
	return
}

function init_cpu_governor()
{
	governor=$(getprop cpu.governor)

	[ $governor ] && {
		for cpu in $(ls -d /sys/devices/system/cpu/cpu?); do
			echo $governor > $cpu/cpufreq/scaling_governor || return 1
		done
	}
}

function do_init()
{
	init_misc
	init_hal_audio
	init_hal_bluetooth
	init_hal_camera
	init_hal_gps
	init_hal_lights
	init_hal_power
	init_hal_sensors
	init_ril
	chmod 640 /x86.prop
	post_init
}

function do_netconsole()
{
	return
}

function do_sharedfolder()
{
	init_sharedir
}
function do_bootcomplete()
{
	init_cpu_governor

	[ -z "$(getprop persist.sys.root_access)" ] && setprop persist.sys.root_access 3


#	[ -d /proc/asound/card0 ] || modprobe snd-dummy
	for c in $(grep '\[.*\]' /proc/asound/cards | awk '{print $1}'); do
		f=/system/etc/alsa/$(cat /proc/asound/card$c/id).state
		if [ -e $f ]; then
			alsa_ctl -f $f restore $c
		else
			alsa_ctl init $c
			alsa_amixer -c $c set Master on
			alsa_amixer -c $c set Master 100%
			alsa_amixer -c $c set Headphone on
			alsa_amixer -c $c set Headphone 100%
			alsa_amixer -c $c set Speaker 100%
			alsa_amixer -c $c set Capture 100%
			alsa_amixer -c $c set Capture cap
			alsa_amixer -c $c set PCM 100 unmute
			alsa_amixer -c $c set SPO unmute
			alsa_amixer -c $c set 'Mic Boost' 3
			alsa_amixer -c $c set 'Internal Mic Boost' 3
		fi
	done
}

function do_hci()
{
	local hci=`hciconfig | grep ^hci | cut -d: -f1`
	local btd="`getprop init.svc.bluetoothd`"
	log -t bluetoothd -p i "$btd ($hci)"
	if [ -n "`getprop hal.bluetooth.uart`" ]; then
		[ "`getprop init.svc.bluetoothd`" = "running" ] && hciconfig $hci up
	fi
}

PATH=/sbin:/system/bin:/system/xbin
DMIPATH=/sys/class/dmi/id
BOARD=$(cat $DMIPATH/board_name)
PRODUCT=$(cat $DMIPATH/product_name)

# import cmdline variables
for c in `cat /proc/cmdline`; do
	case $c in
		androidboot.hardware=*)
			;;
		*=*)
			eval $c
			;;
	esac
done

[ -n "$DEBUG" ] && set -x || exec &> /dev/null

# import the vendor specific script
hw_sh=/vendor/etc/init.sh
[ -e $hw_sh ] && source $hw_sh

case "$1" in
	netconsole)
		[ -n "$DEBUG" ] && do_netconsole
		;;
	bootcomplete)
		do_bootcomplete
		;;
	hci)
		do_hci
		;;
	sharedfolder)
		do_sharedfolder
	;;
	init|"")
		do_init
		;;
esac

return 0

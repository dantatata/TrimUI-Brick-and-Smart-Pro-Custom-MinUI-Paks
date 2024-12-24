#!/bin/sh

while :; do
    syncsettings.elf
done &
LOOP_PID=$!

export CART_PATH=$(readlink -f "$(dirname "$1")")
export PAK_PATH=$(readlink -f "$(dirname "$0")")

export picodir=$PAK_PATH/PICO8_Wrapper
cd $picodir
export PATH=$PATH:$PWD/bin
export HOME=$picodir
export PATH=${picodir}:$PATH
export LD_LIBRARY_PATH="$picodir/lib:/usr/lib:$LD_LIBRARY_PATH"


if ! [ -f $picodir/bin/pico8_64 ] || ! [ -f $picodir/bin/pico8.dat ]; then
	LD_LIBRARY_PATH="/mnt/SDCARD/System/lib:/usr/trimui/lib:$LD_LIBRARY_PATH"
	/mnt/SDCARD/System/usr/trimui/scripts/infoscreen.sh -m "To use the official PICO-8, you need to add your purchased binaries (pico8_64 and pico8.dat)." -fs 25 -t 5
fi

main() {
	#echo 1008000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	echo performance >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	mount --bind "$CART_PATH" "$picodir/.lexaloffle/pico-8/carts"
	if [[ "$(basename "$1")" == "Run Splore.p8.png" ]]; then
		pico8_64 -splore -preblit_scale 3
    else
		pico8_64 -preblit_scale 3 -run "$1"
	fi
	umount "$picodir/.lexaloffle/pico-8/carts"
	echo ondemand >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
}

main "$1"

kill $LOOP_PID

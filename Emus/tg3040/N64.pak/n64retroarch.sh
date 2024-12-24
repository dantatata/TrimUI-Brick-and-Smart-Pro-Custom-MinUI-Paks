#!/bin/sh

#overclock.elf userspace 2 1344 384 1080 0

while :; do
    syncsettings.elf
done &
LOOP_PID=$!

echo $0 $*
RA_DIR=/mnt/SDCARD/Tools/$PLATFORM/RetroArch.pak
EMU_DIR=/mnt/SDCARD/Emus/$PLATFORM/N64.pak

./performance.sh

cd $RA_DIR/

#disable netplay
NET_PARAM=

#touch /tmp/trimui_inputd/input_dpad_to_joystick
HOME=$RA_DIR/ $RA_DIR/ra64.trimui -v $NET_PARAM -L $RA_DIR/.retroarch/cores/mupen64plus_libretro.so "$*"

kill $LOOP_PID
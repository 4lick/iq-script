#!/bin/sh -e
DEVICE=$1
[ "$DEVICE" = "" ] && DEVICE=fr920xt_sim

killall simulator || true
connectiq
./build.sh $DEVICE
monkeydo bin/${AppName}.prg $DEVICE

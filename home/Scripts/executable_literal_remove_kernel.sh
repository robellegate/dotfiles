#!/bin/bash

sudo dnf list installed kernel\*
echo
echo -n "Please select kernel version you want to remove (exp: 5.15.0-60.fc36): "
read KERNEL_VER
sudo dnf remove \
    kernel-$KERNEL_VER \
    kernel-core-$KERNEL_VER \
    kernel-debug-$KERNEL_VER \
    kernel-debug-core-$KERNEL_VER \
    kernel-debug-devel-$KERNEL_VER \
    kernel-debug-devel-matched-$KERNEL_VER \
    kernel-debug-modules-$KERNEL_VER \
    kernel-debug-modules-extra-$KERNEL_VER \
    kernel-debug-modules-internal-$KERNEL_VER \
    kernel-devel-$KERNEL_VER \
    kernel-devel-matched-$KERNEL_VER \
    kernel-modules-$KERNEL_VER \
    kernel-modules-extra-$KERNEL_VER \
    kernel-modules-internal-$KERNEL_VER

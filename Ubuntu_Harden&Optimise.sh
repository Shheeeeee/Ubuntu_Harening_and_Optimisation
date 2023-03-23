#!/bin/bash


## Initial setup


# Disable mounting of cramfs filesystems
echo "install cramfs /bin/true" > /etc/modprobe.d/cramfs.conf

# Disable mounting of squashfs filesystems
echo "install squashfs /bin/true" > /etc/modprobe.d/squashfs.conf

# Disable mounting of udf filesystems
echo "install udf /bin/true" > /etc/modprobe.d/udf.conf


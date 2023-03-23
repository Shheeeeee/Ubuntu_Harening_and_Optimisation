#!/bin/bash


### Initial setup

## Disable unused filesystems

# Disable mounting of cramfs filesystems
echo "install cramfs /bin/true" > /etc/modprobe.d/cramfs.conf

# Disable mounting of squashfs filesystems
echo "install squashfs /bin/true" > /etc/modprobe.d/squashfs.conf

# Disable mounting of udf filesystems
echo "install udf /bin/true" > /etc/modprobe.d/udf.conf

## Configure /tmp

# Create a new partition for /tmp
sudo mkdir /tmp_new
sudo chmod 1777 /tmp_new

# Copy the contents of /tmp to the new partition
sudo rsync -aXS /tmp/ /tmp_new/

# Mount the new partition as /tmp
sudo mount -o remount,rw,nodev,noexec,nosuid,strictatime /tmp_new /tmp

# Update /etc/fstab to persist the changes
echo "/tmp_new /tmp none rw,nodev,noexec,nosuid,strictatime 0 0" | sudo tee -a /etc/fstab

# Remove the old /tmp directory and symlink to the new one
sudo rm -rf /tmp
sudo ln -s /tmp_new /tmp


#!/bin/bash


############## 1. Initial setup

######## 1.1 Filesystem Configuration

###### 1.1.1 Disable unused filesystems

# Disable mounting of cramfs filesystems
echo "install cramfs /bin/true" > /etc/modprobe.d/cramfs.conf

# Disable mounting of squashfs filesystems
echo "install squashfs /bin/true" > /etc/modprobe.d/squashfs.conf

# Disable mounting of udf filesystems
echo "install udf /bin/true" > /etc/modprobe.d/udf.conf


###### 1.1.2 Configure /tmp

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


############## 3. Network configuration

######## 3.1 Disable unused network protocols and devices

# Disable IPV6
echo "Disabling IPV6"
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p

# Disable wireless interfaces
echo "Disabling wireless interfaces"
ifconfig -a | grep wlan | awk '{print $1}' | while read interface; do
  ifconfig $interface down
  echo "Wireless interface $interface has been disabled"
done


######## 3.2 Network parameters (Host only)

# Ensure packet redirect sending is disabled
echo "net.ipv4.conf.all.send_redirects=0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.send_redirects=0" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.accept_redirects=0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_redirects=0" >> /etc/sysctl.conf

# Ensure IP forwarding is disabled
echo "net.ipv4.ip_forward=0" >> /etc/sysctl.conf

# Reload sysctl configuration
sysctl -p


######## 3.5 Firewall Configuration (Host only)

###### 3.5.1 Configure UncomplicatedFirewall

# Install ufw if not already installed
sudo apt-get -y install ufw

# Uninstall iptables-persistent if installed
sudo apt-get -y remove iptables-persistent

# Enable ufw service
sudo systemctl enable ufw

# Configure ufw loopback traffic
sudo ufw allow in on lo

# Configure ufw outbound connections


# Configure ufw firewall rules for all open ports


# Set ufw default deny policy


###### 3.5.2 Configure nftables


# Ensure nftables is installed
apt-get install nftables -y

# Ensure ufw is uninstalled or disabled with nftables
ufw disable

# Ensure iptables are flushed with nftables
iptables -F
iptables -X

# Ensure a nftables table exists
nft add table inet filter

# Ensure nftables base chains exist
nft add chain inet filter input { type filter hook input priority 0 \; }
nft add chain inet filter forward { type filter hook forward priority 0 \; }
nft add chain inet filter output { type filter hook output priority 0 \; }

# Ensure nftables loopback traffic is configured
nft add rule inet filter input iif lo accept
nft add rule inet filter output oif lo accept

# Ensure nftables outbound and established connections are configured
nft add rule inet filter input ct state established,related accept
nft add rule inet filter output ct state established,related accept

# Ensure nftables default deny firewall policy
nft add rule inet filter input drop
nft add rule inet filter forward drop






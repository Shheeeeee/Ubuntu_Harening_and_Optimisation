#!/bin/bash


# update le system
sudo apt-get update

############################ 1. Initial setup

################ 1.1 Filesystem Configuration

############ 1.1.1 Disable unused filesystems

# Disable mounting of cramfs filesystems
echo "install cramfs /bin/true" > /etc/modprobe.d/cramfs.conf

# Disable mounting of squashfs filesystems
echo "install squashfs /bin/true" > /etc/modprobe.d/squashfs.conf

# Disable mounting of udf filesystems
echo "install udf /bin/true" > /etc/modprobe.d/udf.conf


############ 1.1.2 Configure /tmp

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

############ 1.1.3 Configure /var
############ 1.1.4 Configure /var/tmp
############ 1.1.5 Configure /var/log
############ 1.1.6 Configure /var/log/audit
############ 1.1.7 Configure /home
############ 1.1.8 Configure /dev/shm
############ 1.1.9 Disable Automounting

# ------- Disable automounting
gsettings set org.gnome.desktop.media-handling automount false

############ 1.1.10 Disable USB Storage

# ------- Disable USB storage
echo "blacklist usb-storage" | sudo tee -a /etc/modprobe.d/blacklist.conf
sudo update-initramfs -u

################ 1.2 Configure Software Uptdates
################ 1.3 Filesystem Integrity Checking
################ 1.4 Secure Boot Settings
################ 1.5 Additional Process Hardening
################ 1.6 Mandatory Access Control
############ 1.6.1 Configure AppArmor
################ 1.7 Command Line Warning Banners
################ 1.8 GNOME Display Manager

############################ 2. Services
################ 2.1 Configure Time Synchronization
############ 2.1.1 Ensure time sychronization is in use
# ------- for chrony
apt install chrony
systemctl stop systemd-timesyncd.service
systemctl --now mask systemd-timesyncd.service
apt purge ntp

# ------- for systemd-timesyncd
#apt purge chrony
#apt purge ntp

# ------- for ntp
#apt install ntp
#systemctl stop systemd-timesyncd.service
#systemctl --now mask systemd-timesyncd.service
#apt purge chrony

############ 2.1.2 Configure chrony

# Configure Chrony with the specified authorized time server
sudo sed -i 's/^pool /#pool /g' /etc/chrony/chrony.conf
sudo sed -i '/# Please consider joining the pool/ a server your.time.server iburst' /etc/chrony/chrony.conf

# Configure Chrony to run as user _chrony
sudo sed -i 's/^#.*\b(user|group)\b.*/\1 _chrony/' /etc/chrony/chrony.conf

# Enable and start the Chrony service
sudo systemctl enable chrony.service
sudo systemctl start chrony.service

############ 2.1.3 Configure systemd-timesyncd
#///////
############ 2.1.4 configure ntp
#///////
################ 2.2 Special Purpose Services
# ------- Ensure X Window System is not installed 
apt purge xserver-xorg

# ------- Ensure Avahi Server is not installed 
systemctl stop avahi-daaemon.service
systemctl stop avahi-daemon.socket
apt purge avahi-daemon

# ------- Ensure CUPS is not installed 
apt purge cups

# ------- Ensure DHCP Server is not installed 
apt purge isc-dhcp-server

# ------- Ensure LDAP server is not installed 
apt purge slapd

# ------- Ensure NFS is not installed 
apt purge nfs-kernel-server

# ------- Ensure DNS Server is not installed 
apt purge bind9

# ------- Ensure FTP Server is not installed 
apt purge vsftpd

# ------- Ensure HTTP server is not installed 
apt purge apache2

# ------- Ensure IMAP and POP3 server are not installed
apt purge dovecot-imapd dovecot-pop3d

# ------- Ensure Samba is not installed 
apt purge samba

# ------- Ensure HTTP Proxy Server is not installed 
apt purge squid

# ------- Ensure SNMP Server is not installed 
apt purge snmp

# ------- Ensure NIS Server is not installed 
apt purge nis

# ------- Ensure mail transfer agent is configured for local-only mode 

# Install postfix if it's not already installed
sudo apt-get install -y postfix

# Edit the main Postfix configuration file
sudo sed -i '/^inet_interfaces/s/.*/inet_interfaces = loopback-only/' /etc/postfix/main.cf

# Restart Postfix to apply the changes
sudo systemctl restart postfix

# ------- Ensure rsync service is either not installed or masked
apt purge rsync


################ 2.3 Service Clients

# ------- Ensure NIS Client is not installed 
apt purge nis

# ------- Ensure rsh client is not installed 
apt purge rsh-client

# ------- Ensure talk client is not installed 
apt purge talk

# ------- Ensure telnet client is not installed 
apt purge telnet

# ------- Ensure LDAP client is not installed 
apt purge ldap-utils

# ------- Ensure RPC is not installed 
apt purge rpcbind

################ 2.4 Ensure nonessential services are removed or masked
#apt purge <package_name>


############################ 3. Network configuration

################ 3.1 Disable unused network protocols and devices

# ------- Disable IPV6
echo "Disabling IPV6"
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p

# ------- Disable wireless interfaces
echo "Disabling wireless interfaces"
ifconfig -a | grep wlan | awk '{print $1}' | while read interface; do
  ifconfig $interface down
  echo "Wireless interface $interface has been disabled"
done


################ 3.2 Network parameters (Host only)

# ------- Ensure packet redirect sending is disabled
echo "net.ipv4.conf.all.send_redirects=0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.send_redirects=0" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.accept_redirects=0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_redirects=0" >> /etc/sysctl.conf

# ------- Ensure IP forwarding is disabled
echo "net.ipv4.ip_forward=0" >> /etc/sysctl.conf

# Reload sysctl configuration
sysctl -p

################ 3.3 Network parameters (Host and Router)

# ------- Ensure source routed packets are not accepted

# Update the sysctl.conf file to disable accepting source routed packets
echo "net.ipv4.conf.all.accept_source_route = 0" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_source_route = 0" | sudo tee -a /etc/sysctl.conf
#echo "net.ipv6.conf.all.accept_source_route = 0" | sudo tee -a /etc/sysctl.conf
#echo "net.ipv6.conf.default.accept_source_route = 0" | sudo tee -a /etc/sysctl.conf

# Reload the sysctl configuration
sudo sysctl -p

# ------- Ensure ICMP redirects are not accepted 

# Update the sysctl.conf file to disable accepting ICMP redirects
echo "net.ipv4.conf.all.accept_redirects = 0" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_redirects = 0" | sudo tee -a /etc/sysctl.conf

# Reload the sysctl configuration
sudo sysctl -p

# ------- Ensure secure ICMP redirects are not accepted
# the previous lines for the none secure ICMP redirects is suppose to also not accept the secure ICMP redirects

# ------- Ensure suspicious packets are logged 

# Update the sysctl.conf file to log suspicious packets
echo "net.ipv4.conf.all.log_martians = 1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.conf.default.log_martians = 1" | sudo tee -a /etc/sysctl.conf

# Reload the sysctl configuration
sudo sysctl -p

# ------- Ensure broadcast ICMP requests are ignored 

# Update the sysctl.conf file to ignore broadcast ICMP requests
echo "net.ipv4.icmp_echo_ignore_broadcasts = 1" | sudo tee -a /etc/sysctl.conf

# Reload the sysctl configuration
sudo sysctl -p

# ------- Ensure bogus ICMP responses are ignored 

# Update the sysctl.conf file to ignore bogus ICMP responses
echo "net.ipv4.icmp_ignore_bogus_error_responses = 1" | sudo tee -a /etc/sysctl.conf

# Reload the sysctl configuration
sudo sysctl -p

# ------- Ensure Reverse Path Filtering is enabled 

# Update the sysctl.conf file to enable Reverse Path Filtering
echo "net.ipv4.conf.all.rp_filter = 1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.conf.default.rp_filter = 1" | sudo tee -a /etc/sysctl.conf

# Reload the sysctl configuration
sudo sysctl -p

# ------- Ensure TCP SYN Cookies is enabled 

# Update the sysctl.conf file to enable TCP SYN Cookies
echo "net.ipv4.tcp_syncookies = 1" | sudo tee -a /etc/sysctl.conf

# Reload the sysctl configuration
sudo sysctl -p

# ------- Ensure IPv6 router advertisements are not accepted

# Update the sysctl.conf file to reject IPv6 router advertisements
echo "net.ipv6.conf.all.accept_ra = 0" | sudo tee -a /etc/sysctl.conf
echo "net.ipv6.conf.default.accept_ra = 0" | sudo tee -a /etc/sysctl.conf

# Reload the sysctl configuration
sudo sysctl -p

################ 3.4 Uncommon Network Protocols

# ------- Ensure DCCP is disabled 

{
  l_mname="dccp" # set module name
  if ! modprobe -n -v "$l_mname" | grep -P -- '^\h*install\/bin\/(true|false)'; then
    echo -e " - setting module: \"$l_mname\" to be not loadable"
    echo -e "install $l_mname /bin/false" >> /etc/modprobe.d/"$l_mname".conf
  fi
  if lsmod | grep "$l_mname" > /dev/null 2>&1; then 
  echo -e " - unloading module \"$l_mname\""
  modprobe -r "$l_mname"
  fi
  if ! grep -Pq -- "^\h*blacklist\h+$l_mname\b" /etc/modprobe.d/*; then
  echo -e " - deny listing \"$l_mname\""
  echo -e "blacklist $l_mname" >> /etc/modprobe.d/"$l_mname".conf
  fi
}

# ------- Ensure SCTP is disabled 

{
  l_mname="sctp" # set module name
  if ! modprobe -n -v "$l_mname" | grep -P -- '^\h*install\/bin\/(true|false)'; then
  echo -e " - setting module: \"$l_mname\" to be not loadable"
  echo -e "install $l_mname /bin/false" >> /etc/modprobe.d/"$l_mname".conf
  fi
  if lsmod | grep "$l_mname" > /dev/null 2>&1; then
  echo -e " - unloading module \"$l_mname\""
  modprobe -r "$l_mname"
  fi
  if ! grep -Pq -- "^\h*blacklist\h+$l_mname\b" /etc/modprobe.d/*; then
  echo -e " - deny listing \"$l_mname\""
  echo -e "blacklist $l_mname" >> /etc/modprobe.d/"$l_mname".conf
  fi
}

# ------- Ensure RDS is disabled 

{
  l_mname="rds" # set module name
  if ! modprobe -n -v "$l_mname" | grep -P -- '^\h*install\/bin\/(true|false)'; then
  echo -e " - setting module: \"$l_mname\" to be not loadable"
  echo -e "install $l_mname /bin/false" >> /etc/modprobe.d/"$l_mname".conf
  fi
  if lsmod | grep "$l_mname" > /dev/null 2>&1; then
  echo -e " - unloading module \"$l_mname\""
  modprobe -r "$l_mname"
  fi
  if ! grep -Pq -- "^\h*blacklist\h+$l_mname\b" /etc/modprobe.d/*; then
  echo -e " - deny listing \"$l_mname\""
  echo -e "blacklist $l_mname" >> /etc/modprobe.d/"$l_mname".conf
  fi
}

# ------- Ensure TIPC is disabled 

{
l_mname="tipc" # set module name
  if ! modprobe -n -v "$l_mname" | grep -P -- '^\h*install\/bin\/(true|false)'; then
  echo -e " - setting module: \"$l_mname\" to be not loadable"
  echo -e "install $l_mname /bin/false" >> /etc/modprobe.d/"$l_mname".conf
  fi
  if lsmod | grep "$l_mname" > /dev/null 2>&1; then
  echo -e " - unloading module \"$l_mname\""
  modprobe -r "$l_mname"
  fi
  if ! grep -Pq -- "^\h*blacklist\h+$l_mname\b" /etc/modprobe.d/*; then
  echo -e " - deny listing \"$l_mname\""
  echo -e "blacklist $l_mname" >> /etc/modprobe.d/"$l_mname".conf
  fi
}


################ 3.5 Firewall Configuration (Host only)
############ 3.5.1 Configure UncomplicatedFirewall

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


############ 3.5.2 Configure nftables


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


############ 3.5.3 Configure iptables
##### 3.5.3.1 Configure ipatables software
##### 3.5.3.1 Configure IPV4 iptables
##### 3.5.3.1 Configure IPV6 ipatables

############################ 4. Logging and auditing
################ 4.1 Configure System Accounting (auditd)
############ 4.1.1 Ensure auditing is enabled

# ------- Ensure auditd is installed 
apt install auditd audispd-plugins

# ------- Ensure auditd service is enabled and active 
systemctl --now enable auditd

# ------- Ensure auditing for processes that start prior to auditd is enabled  
update-grub

# ------- Ensure audit_backlog_limit is sufficient  
update-grub

############ 4.1.2 Configure Data Retention

# ------- Ensure audit log storage size is configured   

# Set the max log file size to 100 MB, you can change it
sudo sed -i 's/^max_log_file[[:space:]]*=[[:space:]]*[0-9]*$/max_log_file = 100/' /etc/audit/auditd.conf
sudo systemctl reload auditd.service

# ------- Ensure audit logs are not automatically deleted   

# Set the max log retention to unlimited
sudo sed -i 's/^max_log_file_action[[:space:]]*=[[:space:]]*[[:alpha:]]*$/max_log_file_action = keep_logs/' /etc/audit/auditd.conf
sudo systemctl reload auditd.service

# ------- Ensure system is disabled when audit logs are full   



############ 4.1.3 Configure auditd rules
############ 4.1.4 Configure auditd file access
################ 4.2 Configure Logging
############ 4.2.1 Configure journald
##### 4.2.1.1 Ensure journald is configured to send logs to a remote log host
############ 4.2.2 Configure rsyslog

############################ 5. Access, Authentification and Authorization
################ 5.1 Configure time-based job schedulers
################ 5.2 Configure SSH Server
################ 5.3 Configure privilege escalation
################ 5.4 Configure PAM
################ 5.5 User Accounts and Environement
############ 5.5.1 Set Shadow Password Suite Parameters

############################ 6. System Maintenance
################ 6.1 System File Permissions
################ 6.2 Local User and Group Settings






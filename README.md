# Ubuntu Hardening and Optimisation script


> __Note__  

Work in progress, Based on [CIS_Ubuntu_Linux_22.04_LTS_Benchmark_v1.0.0](https://downloads.cisecurity.org/#/).

## 1. Initial Setup
### 1.1 Filesystem Configuration
#### 1.1.1 Disable unused filesystems

- [x] Disable mounting of cramfs filesystems  
- [x] Disable mounting of squashfs filesystems  
- [x] Disable mounting of udf filesystems  

#### 1.1.2 Configure /tmp

- [x] Ensure /tmp is a separate partition 
- [x] Ensure nodev option set on /tmp partition
- [x] Ensure noexec option set on /tmp partition 
- [x] Ensure nosuid option set on /tmp partition

#### 1.1.3 Configure /var
#### 1.1.4 Configure /var/tmp
#### 1.1.5 Configure /var/log
#### 1.1.6 Configure /var/log/audit
#### 1.1.7 Configure /home
#### 1.1.8 Configure /dev/shm
### 1.2 Configure Software Uptdates
### 1.3 Filesystem Integrity Checking
### 1.4 Secure Boot Settings
### 1.5 Additional Process Hardening
### 1.6 Mandatory Access Control
#### 1.6.1 Configure AppArmor
### 1.7 Command Line Warning Banners
### 1.8 GNOME Display Manager

## 2. Services
### 2.1 Configure Time Synchronization
#### 2.1.1 Ensure time sychronization is in use
> __Warning__  you need to choose only one of the 3 following time sychronization tools (chrony or systemd-timesyncd or ntp). And then only configure the one that you chose.
 
- [x] Install chrony
- [x] Install systemd-timesyncd (commented)
- [x] Install ntp (commented)

#### 2.1.2 Configure chrony

- [x] Ensure chrony is configured with authorized timeserver (may need to be manually done)
- [x] Ensure chrony is running as user _chrony 
- [x] Ensure chrony is enabled and running 

#### 2.1.3 Configure systemd-timesyncd
/////
#### 2.1.4 configure ntp
//////

### 2.2 Special Purpose Services

- [x] Ensure X Window System is not installed 
- [x] Ensure Avahi Server is not installed 
- [x] Ensure CUPS is not installed 
- [x] Ensure DHCP Server is not installed 
- [x] Ensure LDAP server is not installed
- [x] Ensure NFS is not installed 
- [x] Ensure DNS Server is not installed 
- [x] Ensure FTP Server is not installed 
- [x] Ensure HTTP server is not installed 
- [x] Ensure IMAP and POP3 server are not installed
- [x] Ensure Samba is not installed 
- [x] Ensure HTTP Proxy Server is not installed 
- [x] Ensure SNMP Server is not installed 
- [x] Ensure NIS Server is not installed 
- [x] Ensure mail transfer agent is configured for local-only mode 
- [x] Ensure rsync service is either not installed or masked

### 2.3 Service Clients

- [x] Ensure NIS Client is not installed   
- [x] Ensure rsh client is not installed   
- [x] Ensure talk client is not installed  
- [x] Ensure telnet client is not installed  
- [x] Ensure LDAP server is not installed  
- [x] Ensure RPC is not installed   

### 2.4 Ensure nonessential services are removed or masked
If you want to remove any another package that you don't need, juste insert his name in the script and uncomment the line. 

## 3. Network configuration
### 3.1 Disable unused network protocols and devices

- [x] Disable IPV6  
- [x] Disable wireless interfaces  

### 3.2 Network parameters (Host only)

- [x] Ensure packet redirect sending is disabled  
- [x] Ensure IP forwarding is disabled  

### 3.3 Network parameters (Host & Router)

- [x] Ensure source routed packets are not accepted  
- [x] Ensure ICMP redirects are not accepted
- [x] Ensure secure ICMP redirects are not accepted
- [x] Ensure suspicious packets are logged 
- [x] Ensure broadcast ICMP requests are ignored 
- [x] Ensure bogus ICMP responses are ignored 
- [x] Ensure Reverse Path Filtering is enabledEnsure TCP SYN Cookies is enabled  bogus ICMP responses are ignored 
- [x] Ensure IPv6 router advertisements are not accepted

### 3.4 Uncommon Network Protocols

- [x] Ensure DCCP is disabled 
- [x] Ensure SCTP is disabled
- [x] Ensure RDS is disabled 
- [x] Ensure TIPC is disabled

### 3.5 Firewall Configuration (Host only)
#### 3.5.1 Configure UncomplicatedFirewall

- [x] Ensure ufw is installed
- [x] Ensure iptables-persistent is not installed with ufw 
- [x] Ensure ufw service is enabled
- [x] Ensure ufw loopback traffic is configured 
- [ ] Ensure ufw outbound connections are configured (manually done)
- [ ] Ensure ufw firewall rules exist for all open ports (manually done)
- [ ] Ensure ufw default deny firewall policy (manually done)


#### 3.5.2 Configure nftables

- [x] Ensure nftables is installed
- [x] Ensure ufw is uninstalled or disabled with nftables 
- [x] Ensure iptables are flushed with nftables
- [ ] Ensure a nftables table exists 
- [ ] Ensure nftables base chains exist
- [ ] Ensure nftables loopback traffic is configured 
- [ ] Ensure nftables outbound and established connections are configured 
- [ ] Ensure nftables default deny firewall policy
- [ ] Ensure nftables service is enabled
- [ ] Ensure nftables rules are permanent 

#### 3.5.3 Configure iptables
##### 3.5.3.1 Configure ipatables software
##### 3.5.3.1 Configure IPV4 iptables
##### 3.5.3.1 Configure IPV6 ipatables

## 4. Logging and auditing
### 4.1 Configure System Accounting (auditd)
#### 4.1.1 Ensure auditing is enabled

- [x] Ensure auditd is installed 
- [x] Ensure auditd service is enabled and active 
- [x] Ensure auditing for processes that start prior to auditd is enabled  
- [x] Ensure audit_backlog_limit is sufficient

#### 4.1.2 Configure Data Retention

- [x] Ensure audit log storage size is configured   
- [x] Ensure audit logs are not automatically deleted   
- [ ] Ensure Ensure system is disabled when audit logs are full 

#### 4.1.3 Configure auditd rules
#### 4.1.4 Configure auditd file access
### 4.2 Configure Logging
#### 4.2.1 Configure journald
##### 4.2.1.1 Ensure journald is configured to send logs to a remote log host
#### 4.2.2 Configure rsyslog

## 5. Access, Authentification and Authorization
### 5.1 Configure time-based job schedulers
### 5.2 Configure SSH Server
### 5.3 Configure privilege escalation
### 5.4 Configure PAM
### 5.5 User Accounts and Environement
#### 5.5.1 Set Shadow Password Suite Parameters

## 6. System Maintenance
### 6.1 System File Permissions
### 6.2 Local User and Group Settings






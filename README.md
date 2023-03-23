# Ubuntu Harening and Optimisation script


> __Note__  

WIP Based on CIS_Ubuntu_Linux_22.04_LTS_Benchmark_v1.0.0

## Initial Setup


## Disable unused filesystems

- [x] Disable mounting of cramfs filesystems  
- [x] Disable mounting of squashfs filesystems  
- [x] Disable mounting of udf filesystems  

## Configure /tmp

- [x] Ensure /tmp is a separate partition 
- [x] Ensure nodev option set on /tmp partition
- [x] Ensure noexec option set on /tmp partition 
- [x] Ensure nosuid option set on /tmp partition


### 3. Network configuration

# 3.5.1 Configure UncomplicatedFirewall

- [x] Ensure ufw is installed
- [x] Ensure iptables-persistent is not installed with ufw 
- [x] Ensure ufw service is enabled
- [x] Ensure ufw loopback traffic is configured 
- [ ] Ensure ufw outbound connections are configured (manually done)
- [ ] Ensure ufw firewall rules exist for all open ports (manually done)
- [ ] Ensure ufw default deny firewall policy (manually done)


# 3.5.2 Configure nftables

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




## Active Recon

1) Discover hosts on target network/IP range/subnets
	- [ ] [[Dans Field Manual/1-Info Gathering/Network Enumeration/Host Enumeration#Host Discovery|NMAP Host Enumeration]] 
	- [ ] ICMP Sweep
	- [ ] TCP/UDP Host
	- [ ] Add discovered hostnames to **/etc/hosts**

2) For each active host, scan all TCP/UDP ports, document each.
	- [ ] [[Dans Field Manual/1-Info Gathering/Network Enumeration/Host Enumeration#Discovering Open UDP Ports|NMAP UDP Ports]]
	- [ ] [[Dans Field Manual/1-Info Gathering/Network Enumeration/Host Enumeration#|NMAP TCP Ports]]

3) Run service version scan on each open port with scripts and OS detection
	- [ ] [[NMAP Version and OS Detection]]
	- [ ] Document services and service versions

4) Perform individual service enumeration
	- [ ] [[DNS (53)]]
	- [ ] [[FTP]]
	- [ ] [[SSH (22)]]
	- [ ] [[Dans Field Manual/1-Info Gathering/Service Enumeration/Services/SMB (139,445)/SMB|SMB]]
	- [ ] 
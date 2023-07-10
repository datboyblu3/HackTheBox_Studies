

### Host Discovery

**Scan IPs in a text file**

```
sudo nmap -sn -oA test_scan -iL hosts.lst | grep for | cut -d" " -f5
```

**Determine if a host is alive**
```
sudo nmap 10.129.2.18 -sn -oA host
```

**Show all packets sent and received with the --packet-trace option**
```
sudo nmap 10.129.2.18 -sn -oA host -PE --packet-trace
```
	- sn : disables port scanning
	- PE : performs the ping scan by using "ICMP Echo requests against the target"
	- packet-trace : shows all packets sent and received


**Why does Nmap mark a host as "alive"**
```
sudo nmap 10.129.2.18 -sn -oA host -PE --reason
```
	- reason : displays the reason for specific result
**Scan top 10 tcp ports**
```
sudo nmap 10.129.2.28 --top-ports=10 
```
	- top-ports=10 scans the specified top ports that have been defined as most frequent

**** To have a clear view of the SYN scan, we disable the ICMP echo requests (`-Pn`), DNS resolution (`-n`), and ARP ping scan (`--disable-arp-ping`)
```
sudo nmap 10.129.2.28 -p 21 --packet-trace -Pn -n --disable-arp-ping
```
	- n : disables DNS resolution

### Connect Scan
- Most accurate and stealthy way to determine the state of a port, can bypass firewalls
- Does not leave unfinished connections or unsent packets on the target
- Useful when wanting to map the network and not disturb the services running behind it
- Is slower than other scans since it requires the scanner to wait for a response from the target after each packet it sends

```
sudo nmap 10.129.2.28 -p 443 --packet-trace --disable-arp-ping -Pn -n --reason -sT
```

### Filtered Ports

- There are several reasons why a port is shown as filtered:
	- firewall rules to drop specific connections
	- packets can either be dropped or rejected
- Dropped packets
	- nmap receives no response from target
	- retry rate (--max-retries) is set to 1 - meaning that nmap will resend the request to the target port to determine if the previous packet was not accidentally mishandled

### Discovering Open UDP Ports

#### UDP Port Scan

```
sudo nmap 10.129.2.28 -F -sU --stats-every=5s
```
	- F              : scans top 100 ports
	- sU             : performs a UDP scan
	- stats-every=5s : shows the progress of the scan every 5 seconds
-  This scan is slower than TCP scans


## Host Discovery

##### Scan IPs in a text file
```go
sudo nmap -sn -oA test_scan -iL filename.txt | grep for | cut -d" " -f5
```

##### Determine if a host is alive
```go
sudo nmap 10.129.2.18 -sn -oA host
```

##### Show all packets sent and received with the --packet-trace option
```bash
sudo nmap 10.129.2.18 -sn -oA host -PE --packet-trace
```

| sn           | disable port scanning                                                 |
| ------------ | --------------------------------------------------------------------- |
| PE           | performs the ping scan by using ICMP Echo requests against the target |
| packet-trace | shows all packets sent and received                                   |



**Why does Nmap mark a host as "alive"**
```go
sudo nmap 10.129.2.18 -sn -oA host -PE --reason
```
	- reason : displays the reason for specific result
**Scan top 10 tcp ports**
```go
sudo nmap 10.129.2.28 --top-ports=10 
```
	- top-ports=10 scans the specified top ports that have been defined as most frequent

**** To have a clear view of the SYN scan, we disable the ICMP echo requests (`-Pn`), DNS resolution (`-n`), and ARP ping scan (`--disable-arp-ping`)
```go
sudo nmap 10.129.2.28 -p 21 --packet-trace -Pn -n --disable-arp-ping
```
	- n : disables DNS resolution

#####  Connect Scan

>[!Info] Why use Connect Scan?
>- Most accurate and stealthy way to determine the state of a port, can bypass firewalls
>- Does not leave unfinished connections or unsent packets on the target
>- Useful when wanting to map the network and not disturb the services running behind it
>- Is slower than other scans since it requires the scanner to wait for a response from the target after each packet it sends
```go
sudo nmap 10.129.2.28 -p 443 --packet-trace --disable-arp-ping -Pn -n --reason -sT 
```

### Filtered Ports
>[!Info] Why filtered ports?
>There are several reasons why a port is shown as filtered:
>- firewall rules to drop specific connections
>- packets can either be dropped or rejected
>- Dropped packets
>- nmap receives no response from target
>- retry rate (--max-retries) is set to 1 - meaning that nmap will resend the request to the target port to determine if the previous packet was not accidentally mishandled
```go
sudo nmap 10.129.2.28 -p 445 --packet-trace --disable-arp-ping -Pn -n --reason -sT
```
### Discovering Open UDP Ports

#### UDP Port Scan

```go
sudo nmap 10.129.2.28 -F -sU --stats-every=5s
```
	- F              : scans top 100 ports
	- sU             : performs a UDP scan
	- stats-every=5s : shows the progress of the scan every 5 seconds
-  This scan is slower than TCP scans

### Banner Grabbing: NMAP Doesn't See Everything!!!

>[!Info]
>Sometimes nmap doesn't give you all the information you need to attack your target. Fire up a netcat listener and 
```go
nc -nv target_ip port
```

| Scanning Options | Description                       |
| ---------------- | --------------------------------- |
| -n               | numeric only IP addresses, no DNS |
| -v               | verbose                           |

## Performance

### Timeout
>[!Info] What is RTT?
> RTT stands for Round Trip Time, it describes the amount of time between when a package is sent and received by NMAP or some scanner.

#### Default Scan
```go
sudo nmap 10.129.2.0/24 -F --initial-rtt-timeout 50ms --max-rtt-timeout 100ms
```

| Scanning Options           | Description                                          |
| -------------------------- | ---------------------------------------------------- |
| -F                         | scans top 100 ports                                  |
| --initial-rtt-timeout 50ms | sets the specified time value as initial RTT timeout |
| --max-rtt-timeout 100ms    | sets the specified time value as maximum RTT timeout |
#### Optimized RTT
```go
sudo nmap 10.129.2.0/24 -F --initial-rtt-timeout 50ms --max-rtt-timeout 100ms
```

| Scanning Options      | Description                                           |
| --------------------- | ----------------------------------------------------- |
| -F                    | Scans top 100 ports                                   |
| --initial-rtt-timeout | Sets the specified time value as initial RTT timeout. |
| --max-rtt-timeout     | Sets the specified time value as maximum RTT timeout. |

### Max Retries

>[!info] What's the use of Max Retries?
> Another way to increase scan speed is by specifying the retry rate of sent packets (`--max-retries`). The default value is `10`, but we can reduce it to `0`. This means if Nmap does not receive a response for a port, it won't send any more packets to that port and will skip it

#### Default Scan
```go
sudo nmap 10.129.2.0/24 -F | grep "/tcp" | wc -l
```

#### Reduced Retries
```go
sudo nmap 10.129.2.0/24 -F --max-retries 0 | grep "/tcp" | wc -l
```

### Rates
>[!Info]
Work with the rate of packets sent, if you know the network bandwidth

#### Default Scan
```go
sudo nmap 10.129.2.0/24 -F -oN tnet.default
```

#### Optimized Scan
```go
sudo nmap 10.129.2.0/24 -F -oN tnet.minrate300 --min-rate 300
```

| Scanning Options    | Description                                                                             |
| ------------------- | --------------------------------------------------------------------------------------- |
| -oN tnet.minrate300 | saves the results in normal formats, starting the specified file name "tnet.minrate300" |
| --min-rate 300      | sets the minimum number of packets to be sent per second<br>                            |
#### Output Results to Text
```go
nmap -sS -sV 192.168.1.10 192.168.1.20 -oN scan_results.txt
```

#### Output Results in all formats
```go
nmap -sS -sV 192.168.1.10 192.168.1.20 -oA scan
```

#### Feed Results into a SIEM
```go
nmap -sS -sV -oX scan.xml 192.168.1.10 192.168.1.20
```


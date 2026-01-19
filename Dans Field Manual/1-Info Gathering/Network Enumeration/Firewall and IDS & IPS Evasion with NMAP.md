
## Determining Firewall Rules

> [!NOTE] 
> Nmap's TCP ACK scan (`-sA`) method is much harder to filter for firewalls and IDS/IPS systems than regular SYN (`-sS`) or Connect scans (`sT`) because they only send a TCP packet with only the `ACK` flag. 
> 
> When a port is closed or open, the host must respond with an `RST` flag. Unlike outgoing connections, all connection attempts (with the `SYN` flag) from external networks are usually blocked by firewalls. 
> 
> However, the packets with the `ACK` flag are often passed by the firewall because the firewall cannot determine whether the connection was first established from the external network or the internal network

### Syn-Scan
```go
sudo nmap 10.129.2.28 -p 21,22,25 -sS -Pn -n --disable-arp-ping --packet-trace
```

| Scanning Options   | Description                           |
| ------------------ | ------------------------------------- |
| -sS                | Performs SYN scan on specified ports. |
| -Pn                | Disables ICMP Echo requests.          |
| -n                 | Disables DNS resolution.              |
| --disable-arp-ping | Disables ARP ping.                    |
| --packet-trace     | Shows all packets sent and received.  |

### Ack-Scan
```go
sudo nmap 10.129.2.28 -p 21,22,25 -sA -Pn -n --disable-arp-ping --packet-trace
```

| Scanning Options   | Description                           |
| ------------------ | ------------------------------------- |
| -sA                | Performs ACK scan on specified ports. |
| -Pn                | Disables ICMP Echo requests.          |
| -n                 | Disables DNS resolution.              |
| --disable-arp-ping | Disables ARP ping.                    |
| --packet-trace     | Shows all packets sent and received.  |

### Sub-Heading 3

Command Example
```go

```

| Scanning Options | Description |
| ---------------- | ----------- |
|                  |             |
|                  |             |

----------------

## Decoys

> [!NOTE] What is a decoy and how are they used?
> There are cases in which administrators block specific subnets from different regions in principle. This prevents any access to the target network. Another example is when IPS should block us. For this reason, the Decoy scanning method (`-D`) is the right choice. 
> 
> With this method, Nmap generates various random IP addresses inserted into the IP header to disguise the origin of the packet sent. With this method, we can generate random (`RND`) a specific number (for example: `5`) of IP addresses separated by a colon (`:`). Our real IP address is then randomly placed between the generated IP addresses. 
> 
> In the next example, our real IP address is therefore placed in the second position. Another critical point is that the decoys must be alive. Otherwise, the service on the target may be unreachable due to SYN-flooding security mechanisms


> [!Warning] What type of scans can decoys be used for?
> SYN, ACK, ICMP scans, and OS detection scans.

### Scan using Decoys

```go
sudo nmap 10.129.2.28 -p 80 -sS -Pn -n --disable-arp-ping --packet-trace -D RND:5
```

| Scanning Options | Description                      |
| ---------------- | -------------------------------- |
| -D               | Decoy scanning method            |
| RND 5            | Generates 5 random number of IPs |

### Scanning using a difference Source IP


> [!NOTE] Title
> Another scenario would be that only individual subnets would not have access to the server's specific services. So we can also manually specify the source IP address (`-S`) to test if we get better results with this one.
```go
sudo nmap 10.129.2.28 -n -Pn -p 445 -O -S 10.129.2.200 -e tun0
```

| Scanning Options | Description                                   |
| ---------------- | --------------------------------------------- |
| -n               | Disables DNS resolution                       |
| -Pn              | Disables ping scans                           |
| -O               | Performs OS detection scan                    |
| -S               | Scans target with different Source IP address |
| -e tun0          | Sends all requests through the tun0 interface |

-----------------

## DNS Proxying


> [!NOTE] Title
> By default, `Nmap` performs a reverse DNS resolution unless otherwise specified to find more important information about our target. These DNS queries are also passed in most cases because the given web server is supposed to be found and visited. The DNS queries are made over the `UDP port 53`. The `TCP port 53` was previously only used for the so-called "`Zone transfers`" between the DNS servers or data transfer larger than 512 bytes. More and more, this is changing due to IPv6 and DNSSEC expansions. These changes cause many DNS requests to be made via TCP port 53. 
> 
> However, `Nmap` still gives us a way to specify DNS servers ourselves (`--dns-server <ns>,<ns>`). This method could be fundamental to us if we are in a demilitarized zone (`DMZ`). The company's DNS servers are usually more trusted than those from the Internet. So, for example, we could use them to interact with the hosts of the internal network. As another example, we can use `TCP port 53` as a source port (`--source-port`) for our scans. If the administrator uses the firewall to control this port and does not filter IDS/IPS properly, our TCP packets will be trusted and passed through.


NOTE: *The filtered port is 50000*
```go
sudo nmap 10.129.2.28 -p50000 -sS -Pn -n --disable-arp-ping --packet-trace --source-port 53
```

| Scanning Options | Description                    |
| ---------------- | ------------------------------ |
| -p50000          | Scans only the specified ports |
|                  |                                |


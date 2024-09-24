
## Determining Firewalls and Theirs Rules

- Consider using nmap's TCP ACK scan -sA as firewalls have a more difficult time filtering it than SYN or connect scans
- Packets with the ACK flag set are passed by the firewall because the firewall cannot determine whether the connection was first established from the outside or inside of the network.

Analyze the output of the following commands

**SYN-Scan**
```
sudo nmap 10.129.2.28 -p 21,22,25 -sS -Pn -n --disable-arp-ping --packet-trace
```

**ACK-Scan**
```
sudo nmap 10.129.2.28 -p 21,22,25 -sA -Pn -n --disable-arp-ping --packet-trace
```

## Detecting IDS/IPS

One way to determine if an IDS/IPS is present on the network is to scan from a single host (VPS). If the host is blocked and cannot reach out to the target network, the admin has taken security measures.

### Decoys

Decoy scans generates various random IPs inserted into the IP header to disguise the origin of the sent packet. This allows us to do a few things:
	-generate a specified number of IP addresses, separated by a colon

The real IP is randomly situated between the generated IP addresses.
```
nmap 10.129.2.28 -p 80 -sS -Pn -n --disable-arp-ping --packet-trace -D RND:5
```
	-D RND:5 Generates five random IP addresses that indicates the source IP connection comes from

Since spoofed packets can be filtered by ISPs and routers, use the "IP ID" manipulation in the headers in combination with your VPS servers IPs.

REMEMBER, DECOYS CAN BE USED WITH SYN, ACK, ICMP and OS detection SCANS!!

**Testing Firewall Rule**
```
 sudo nmap 10.129.2.28 -n -Pn -p445 -O
```

**Use Different Source IP**
```
sudo nmap 10.129.2.28 -n -Pn -p 445 -O -S 10.129.2.200 -e tun0
```
	-S           : scans the target by using different source IP address
	10.129.2.200 : specifies the source IP address
	-e tun0      : sends all requests through the specified interface


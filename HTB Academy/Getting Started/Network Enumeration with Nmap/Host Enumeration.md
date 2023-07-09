

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

**Why does Nmap mark a host as "alive"**
```
sudo nmap 10.129.2.18 -sn -oA host -PE --reason
```

**Scan top 10 tcp ports**
```
sudo nmap 10.129.2.28 --top-ports=10 
```

**** To have a clear view of the SYN scan, we disable the ICMP echo requests (`-Pn`), DNS resolution (`-n`), and ARP ping scan (`--disable-arp-ping`)
```
sudo nmap 10.129.2.28 -p 21 --packet-trace -Pn -n --disable-arp-ping
```


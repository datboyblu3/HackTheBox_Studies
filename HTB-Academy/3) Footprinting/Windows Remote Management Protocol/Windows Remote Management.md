
### RDP

- Utilizes TCP & UDP port 3389
- can be activated using the Server Manager and comes with the default setting to allow connections to the service only to hosts with Network level authentication (NLA).

**Footprinting RDP**

Nmap NSE script to discover RDP ports: --script rdp*
```
nmap -sV -sC 10.129.201.248 -p3389 --script rdp*
```


You can use --packet-trace to track the individual packages and inspect their contents manually
```
nmap -sV -sC 10.129.201.248 -p3389 --packet-trace --disable-arp-ping -n
```

The pearl script, rdp-sec-check.pl, can be used to verify the security settings on RDP servers based on handshakes

Installation
```
sudo cpan
```

RDP Security Check
```
./rdp-sec-check.pl 10.129.201.248
```

Linux RDP Clients
- remmina
- rdesktop
- xfreerdp

Initiate RDP sessions wit xfreerdp
```
xfreerdp /u:cry0l1t3 /p:"P455w0rd!" /v:10.129.201.248
```


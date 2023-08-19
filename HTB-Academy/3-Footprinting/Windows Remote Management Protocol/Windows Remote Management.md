
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

The pearl script, [rdp-sec-check.pl](https://github.com/CiscoCXSecurity/rdp-sec-check), can be used to verify the security settings on RDP servers based on handshakes

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


### WinRM

- Simple Object Access Protocol (SOAP) to establish connections to remote hosts and their applications
- Relies on TCP 5985, 5986....5986 used for HTTPS
- Ports 80 and 443 were previously used
-  *WInRS* - Windows Remote Shell lets us execute arbitrary commands on the remote system. The program is even included on Windows 7 by default
- Windows Server 2012, by default, has WinRM, although it must be configured for older versions

**Footprinting WinRM**
```
nmap -sV -sC 10.129.201.248 -p5985,5986 --disable-arp-ping -n
```

Determine if one or more servers can be reached by WinRm, use the Powershell cmdlet Test-WsMan

Linux provides an alternative called evil-winrm
```
evil-winrm -i 10.129.201.248 -u Cry0l1t3 -p P455w0rD!
```


### WMI

- Windows Management Instrumentation
- TCP port 135
- allows read and write access to almost all settings on Windows systems
- ls also an extension of the Common Information Model (CIM), core functionality of the standardized Web-Based Enterprise Management (WBEM) for the Windows platform
- Typically accessed via PowerShell, VBScript, or the Windows Management Instrumentation Console

**Footprinting WMI**

Initial WMI communication takes place on TCP port 135, then switches to a random port

Impacket's tool, wmiexec.py can be used for this
```
/usr/share/doc/python3-impacket/examples/wmiexec.py Cry0l1t3:"P455w0rD!"@10.129.201.248 "hostname"
```



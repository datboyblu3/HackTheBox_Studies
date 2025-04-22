
#### WINRM

>[! Note ]
> It is a network protocol based on XML web services using the [Simple Object Access Protocol](https://docs.microsoft.com/en-us/windows/win32/winrm/windows-remote-management-glossary) (`SOAP`) used for remote management of Windows systems. It takes care of the communication between [Web-Based Enterprise Management](https://en.wikipedia.org/wiki/Web-Based_Enterprise_Management) (`WBEM`) and the [Windows Management Instrumentation](https://docs.microsoft.com/en-us/windows/win32/wmisdk/wmi-start-page) (`WMI`), which can call the [Distributed Component Object Model](https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-dcom/4a893f3d-bd29-48cd-9f43-d9777a4415b0) (`DCOM`).


#### CrackMapExec

>[! Note ]
> Can be used for SMB, LDAP, MSSQL and others

**Usage**
`crackmapexec <proto> <target-IP> -u <user or userlist> -p <password or passwordlist>`

Example:
```go
crackmapexec winrm 10.129.42.197 -u user.list -p password.list
```


#### Evil-WinRM

Allows you to communicate with WinRM 

**Usage**
`evil-winrm -i <target-IP> -u <username> -p <password>`

Example:
```go
evil-winrm -i 10.129.42.197 -u user -p password
```

#### Hydra

**Hydra-SSH**
```go
hydra -L user.list -P password.list ssh://10.129.42.197
```

Hydra-RDP
```go
hydra -L user.list -P password.list rdp://10.129.42.197
```

Hydra-SMB
```go
hydra -L user.list -P password.list smb://10.129.42.197
```

#### xFreeRDP
```go
xfreerdp /v:10.129.42.197 /u:user /p:password
```

>[! Warning]
>
> If you can encounter an error while compiling Hydra to crack an SMB password, you can re-compile or use metasploit's `auxiliary/scanner/smb/smb_login` 

### Questions

IP
```go
10.129.249.226
```

SSH
```go
ssh USERNAME@10.129.249.226
```

1) Find the user for the WinRM service and crack their password. Then, when you log in, you will find the flag in a file there. Submit the flag you found as the answer.

##### NMAP

```go
nmap -sC -A 10.129.249.226            
Starting Nmap 7.95 ( https://nmap.org ) at 2025-04-20 22:09 EDT
Nmap scan report for 10.129.249.226
Host is up (0.13s latency).
Not shown: 992 closed tcp ports (reset)
PORT     STATE SERVICE       VERSION
22/tcp   open  ssh           OpenSSH for_Windows_7.7 (protocol 2.0)
| ssh-hostkey: 
|   2048 f8:7f:1a:49:37:df:4d:9f:1b:13:c3:9a:bd:de:55:b4 (RSA)
|   256 b9:c9:3a:f1:fc:3b:85:27:09:2a:69:c1:43:0b:97:9b (ECDSA)
|_  256 d1:a8:1a:e9:26:82:4b:a2:48:92:06:f8:ed:13:5d:71 (ED25519)
111/tcp  open  rpcbind       2-4 (RPC #100000)
| rpcinfo: 
|   program version    port/proto  service
|   100000  2,3,4        111/tcp   rpcbind
|   100000  2,3,4        111/tcp6  rpcbind
|   100000  2,3,4        111/udp   rpcbind
|   100000  2,3,4        111/udp6  rpcbind
|   100003  2,3         2049/udp   nfs
|   100003  2,3         2049/udp6  nfs
|   100003  2,3,4       2049/tcp   nfs
|   100003  2,3,4       2049/tcp6  nfs
|   100005  1,2,3       2049/tcp   mountd
|   100005  1,2,3       2049/tcp6  mountd
|   100005  1,2,3       2049/udp   mountd
|   100005  1,2,3       2049/udp6  mountd
|   100021  1,2,3,4     2049/tcp   nlockmgr
|   100021  1,2,3,4     2049/tcp6  nlockmgr
|   100021  1,2,3,4     2049/udp   nlockmgr
|   100021  1,2,3,4     2049/udp6  nlockmgr
|   100024  1           2049/tcp   status
|   100024  1           2049/tcp6  status
|   100024  1           2049/udp   status
|_  100024  1           2049/udp6  status
135/tcp  open  msrpc         Microsoft Windows RPC
139/tcp  open  netbios-ssn   Microsoft Windows netbios-ssn
445/tcp  open  microsoft-ds?
2049/tcp open  nlockmgr      1-4 (RPC #100021)
3389/tcp open  ms-wbt-server Microsoft Terminal Services
| rdp-ntlm-info: 
|   Target_Name: WINSRV
|   NetBIOS_Domain_Name: WINSRV
|   NetBIOS_Computer_Name: WINSRV
|   DNS_Domain_Name: WINSRV
|   DNS_Computer_Name: WINSRV
|   Product_Version: 10.0.17763
|_  System_Time: 2025-04-21T02:12:36+00:00
| ssl-cert: Subject: commonName=WINSRV
| Not valid before: 2025-04-20T02:10:51
|_Not valid after:  2025-10-20T02:10:51
|_ssl-date: 2025-04-21T02:12:44+00:00; +2m20s from scanner time.
5985/tcp open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-title: Not Found
|_http-server-header: Microsoft-HTTPAPI/2.0
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.95%E=4%D=4/20%OT=22%CT=1%CU=40819%PV=Y%DS=2%DC=T%G=Y%TM=6805A92
OS:0%P=aarch64-unknown-linux-gnu)SEQ(SP=100%GCD=1%ISR=10D%TI=I%CI=I%II=I%SS
OS:=S%TS=U)SEQ(SP=104%GCD=1%ISR=10D%TI=I%CI=I%II=I%SS=S%TS=U)SEQ(SP=106%GCD
OS:=1%ISR=10D%TI=I%CI=I%II=I%SS=S%TS=U)SEQ(SP=107%GCD=1%ISR=10A%TI=I%CI=I%I
OS:I=I%SS=S%TS=U)SEQ(SP=F9%GCD=1%ISR=FF%TI=I%CI=I%II=I%SS=S%TS=U)OPS(O1=M53
OS:CNW8NNS%O2=M53CNW8NNS%O3=M53CNW8%O4=M53CNW8NNS%O5=M53CNW8NNS%O6=M53CNNS)
OS:WIN(W1=FFFF%W2=FFFF%W3=FFFF%W4=FFFF%W5=FFFF%W6=FF70)ECN(R=Y%DF=Y%T=80%W=
OS:FFFF%O=M53CNW8NNS%CC=Y%Q=)T1(R=Y%DF=Y%T=80%S=O%A=S+%F=AS%RD=0%Q=)T2(R=Y%
OS:DF=Y%T=80%W=0%S=Z%A=S%F=AR%O=%RD=0%Q=)T3(R=Y%DF=Y%T=80%W=0%S=Z%A=O%F=AR%
OS:O=%RD=0%Q=)T4(R=Y%DF=Y%T=80%W=0%S=A%A=O%F=R%O=%RD=0%Q=)T5(R=Y%DF=Y%T=80%
OS:W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=80%W=0%S=A%A=O%F=R%O=%RD=0%Q=
OS:)T7(R=Y%DF=Y%T=80%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T=80%IPL=164%
OS:UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=80%CD=Z)

Network Distance: 2 hops
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| smb2-time: 
|   date: 2025-04-21T02:12:39
|_  start_date: N/A
|_clock-skew: mean: 2m19s, deviation: 0s, median: 2m19s
| smb2-security-mode: 
|   3:1:1: 
|_    Message signing enabled but not required

TRACEROUTE (using port 80/tcp)
HOP RTT       ADDRESS
1   265.52 ms 10.10.14.1
2   265.76 ms 10.129.249.226

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 83.91 seconds
```

SMB ports 135,139, and 445 are open

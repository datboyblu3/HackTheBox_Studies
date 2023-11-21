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
![[flag.png]]


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

```
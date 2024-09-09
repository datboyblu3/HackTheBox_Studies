# Linux Local Privilege Escalation - Skills Assessment

Username
```python
htb-student
```

Password
```python
Academy_LLPE!
```

IP
```python
10.129.30.244
```

SSH
```python
ssh htb-student@10.129.85.233
```


## TOC
- []()
- []()
- []()
- []()
- []()
- []()
- []()
- []()

## Enumeration

##### Enumerating the `/etc/passwd` file, there are three additional users: mrb3n,tomact, barry

```python
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
systemd-network:x:100:102:systemd Network Management,,,:/run/systemd:/usr/sbin/nologin
systemd-resolve:x:101:103:systemd Resolver,,,:/run/systemd:/usr/sbin/nologin
systemd-timesync:x:102:104:systemd Time Synchronization,,,:/run/systemd:/usr/sbin/nologin
messagebus:x:103:106::/nonexistent:/usr/sbin/nologin
syslog:x:104:110::/home/syslog:/usr/sbin/nologin
_apt:x:105:65534::/nonexistent:/usr/sbin/nologin
tss:x:106:111:TPM software stack,,,:/var/lib/tpm:/bin/false
uuidd:x:107:112::/run/uuidd:/usr/sbin/nologin
tcpdump:x:108:113::/nonexistent:/usr/sbin/nologin
landscape:x:109:115::/var/lib/landscape:/usr/sbin/nologin
pollinate:x:110:1::/var/cache/pollinate:/bin/false
sshd:x:111:65534::/run/sshd:/usr/sbin/nologin
systemd-coredump:x:999:999:systemd Core Dumper:/:/usr/sbin/nologin
mrb3n:x:1000:1000:Ben:/home/mrb3n:/bin/bash
lxd:x:998:100::/var/snap/lxd/common/lxd:/bin/false
mysql:x:112:118:MySQL Server,,,:/nonexistent:/bin/false
tomcat:x:997:997:Apache Tomcat:/:/bin/bash
barry:x:1001:1001::/home/barry:/bin/bash
htb-student:x:1002:1002::/home/htb-student:/bin/bash
```

##### Finding all writable files.
```python
htb-student@nix03:~$ find / -writable 2>/dev/null | cut -d "/" -f 2 | sort -u
dev
home
proc
run
snap
sys
tmp
usr
var
```

##### Flag1

```python
LLPE{d0n_ov3rl00k_h1dden_f1les!}
```

```python
htb-student@nix03:~$ ls -la
total 32
drwxr-xr-x 4 htb-student htb-student 4096 Sep  6  2020 .
drwxr-xr-x 5 root        root        4096 Sep  6  2020 ..
-rw------- 1 htb-student htb-student   57 Sep  6  2020 .bash_history
-rw-r--r-- 1 htb-student htb-student  220 Feb 25  2020 .bash_logout
-rw-r--r-- 1 htb-student htb-student 3771 Feb 25  2020 .bashrc
drwx------ 2 htb-student htb-student 4096 Sep  6  2020 .cache
drwxr-xr-x 2 root        root        4096 Sep  6  2020 .config
-rw-r--r-- 1 htb-student htb-student  807 Feb 25  2020 .profile
htb-student@nix03:~$ 
htb-student@nix03:~$ cd .config/
htb-student@nix03:~/.config$ 
-r--r-- 1 htb-student htb-student  807 Feb 25  2020 .profile
```

```python
htb-student@nix03:~/.config$ ls -la
total 12
drwxr-xr-x 2 root        root        4096 Sep  6  2020 .
drwxr-xr-x 4 htb-student htb-student 4096 Sep  6  2020 ..
-rw-r--r-- 1 htb-student www-data      33 Sep  6  2020 .flag1.txt
htb-student@nix03:~/.config$ cat .flag1.txt
LLPE{d0n_ov3rl00k_h1dden_f1les!}
```

##### Flag 2

```python
LLPE{ch3ck_th0se_cmd_l1nes!}
```

Flag2 is in the home directory of the user `barry` but I can't read it
```python
htb-student@nix03:/home/barry$ ls -la
total 40
drwxr-xr-x 5 barry barry 4096 Sep  5  2020 .
drwxr-xr-x 5 root  root  4096 Sep  6  2020 ..
-rwxr-xr-x 1 barry barry  360 Sep  6  2020 .bash_history
-rw-r--r-- 1 barry barry  220 Feb 25  2020 .bash_logout
-rw-r--r-- 1 barry barry 3771 Feb 25  2020 .bashrc
drwx------ 2 barry barry 4096 Sep  5  2020 .cache
-rwx------ 1 barry barry   29 Sep  5  2020 flag2.txt
drwxrwxr-x 3 barry barry 4096 Sep  5  2020 .local
-rw-r--r-- 1 barry barry  807 Feb 25  2020 .profile
drwx------ 2 barry barry 4096 Sep  5  2020 .ssh
```

Looking at the bash_history, `barry` ssh'd into `barry_adm@dmz1.inlanefreight.local` with the below password
```python
i_l0ve_s3cur1ty!
```

su'd into barry with the above password and gained #flag2
```python
 su barry
Password: 
barry@nix03:~$ ls -la
total 40
drwxr-xr-x 5 barry barry 4096 Sep  5  2020 .
drwxr-xr-x 5 root  root  4096 Sep  6  2020 ..
-rwxr-xr-x 1 barry barry  360 Sep  6  2020 .bash_history
-rw-r--r-- 1 barry barry  220 Feb 25  2020 .bash_logout
-rw-r--r-- 1 barry barry 3771 Feb 25  2020 .bashrc
drwx------ 2 barry barry 4096 Sep  5  2020 .cache
-rwx------ 1 barry barry   29 Sep  5  2020 flag2.txt
drwxrwxr-x 3 barry barry 4096 Sep  5  2020 .local
-rw-r--r-- 1 barry barry  807 Feb 25  2020 .profile
drwx------ 2 barry barry 4096 Sep  5  2020 .ssh
barry@nix03:~$ cat flag2.txt
LLPE{ch3ck_th0se_cmd_l1nes!}
```

##### Flag 3

```
LLPE{h3y_l00k_a_fl@g!}
```

Looking at the barry's bash_history, he took a look at the /var/log directory. I can read it because barry is part of the adm group
```python
-rw-r--r--   1 root      root            443077 Sep  5  2020 dpkg.log.1
-rw-r--r--   1 root      root             32096 Sep  6  2020 faillog
-rw-r-----   1 root      adm                 23 Sep  5  2020 flag3.txt
```

```python
barry@nix03:/var/log$ cat flag3.txt
LLPE{h3y_l00k_a_fl@g!}
barry@nix03:/var/log$ 
```

##### Flag 4
```python
└─$ nmap -sV -sC -p 80,443,22,1433,3689,8080 10.129.118.66
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-09-09 10:44 EDT
Nmap scan report for 10.129.118.66
Host is up (0.10s latency).

PORT     STATE  SERVICE    VERSION
22/tcp   open   ssh        OpenSSH 8.2p1 Ubuntu 4ubuntu0.1 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 3b:e8:7a:9d:bb:13:bb:94:db:5e:91:0b:46:e0:0a:6f (RSA)
|   256 b2:75:97:8c:4b:01:bc:5b:20:46:29:73:61:40:42:1e (ECDSA)
|_  256 33:89:87:4a:65:8d:f9:85:e1:f2:06:ab:71:fb:cb:23 (ED25519)
80/tcp   open   http       Apache httpd 2.4.41 ((Ubuntu))
|_http-server-header: Apache/2.4.41 (Ubuntu)
|_http-title: Inlane Freight
443/tcp  closed https
1433/tcp closed ms-sql-s
3689/tcp closed rendezvous
8080/tcp open   http       Apache Tomcat
|_http-title: Apache Tomcat
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

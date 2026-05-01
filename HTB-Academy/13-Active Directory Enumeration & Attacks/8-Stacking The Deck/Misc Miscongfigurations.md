

## Enumerating DNS Records

>[!info]
>A tool such as adidnsdump can enumerate all DNS records in a domain using a valid domain user account


##### Using adidnsdump
```go
adidnsdump -u inlanefreight\\forend ldap://172.16.5.5
```

##### Viewing the Contents of the records.csv File
```go
head records.csv
```

##### Using the -r Option to Resolve Unknown Records
```go
adidnsdump -u inlanefreight\\forend ldap://172.16.5.5 -r
```

##### Finding Passwords in the Description Field using Get-Domain User
```go
Get-DomainUser * | Select-Object samaccountname,description |Where-Object {$_.Description -ne $null}
```

##### Checking for PASSWD_NOTREQD Setting using Get-DomainUser
```go
Get-DomainUser -UACFilter PASSWD_NOTREQD | Select-Object samaccountname,useraccountcontrol
```



## Group Policy Preferences (GPP) Passwords

>[!info]
> When a new GPP is created, an .xml file is created in the SYSVOL share, which is also cached locally on endpoints that the Group Policy applies to.
> 
> These files can contain an array of configuration data and defined passwords. The `cpassword` attribute value is AES-256 bit encrypted. Any domain user can read these files as they are stored on the SYSVOL share, and all authenticated users in a domain, by default, have read access to this domain controller share
> 
> If you retrieve the cpassword value more manually, the `gpp-decrypt` utility can be used to decrypt the password

##### Decrypting the Password with gpp-decrypt
```go
gpp-decrypt VPe/o9YRyz2cksnYRbNeQj35w9KxQ5ttbvtRaAVqxaE
```

>[!hint] 
> GPP passwords can be located by searching or manually browsing the SYSVOL share or using tools such as:
> - PowerSploit's [Get-GPPPassword.ps1](https://github.com/PowerShellMafia/PowerSploit/blob/master/Exfiltration/Get-GPPPassword.ps1)
> - the GPP Metasploit Post Module
> - CrackMapExec
> - Python/Ruby scripts which will locate the GPP and return the decrypted cpassword value

##### Locating & Retrieving GPP Passwords with CrackMapExec
```go
crackmapexec smb -L | grep gpp
```

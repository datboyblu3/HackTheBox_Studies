>[!Info]
> Enumerating ACLs with PowerView and BloodHound


# PowerView

##### Find-InterestingDomainAcl

This will return too much information, so use PowerView

```go
Find-InterestingDomainAcl
```


Importing PowerView and using the user `wley`
```go
Import-Module .\PowerView.ps1
```

```go
$sid = Convert-NameToSid wley
```

##### Get-DomainObjectACL

>[!INFO]
> - Finds all domain objects the user has rights over
> - Does this by mapping the user's SID via the `$sid` variable to the `SecurityIdentifier` property
> - The SecurityIdentifier determines who has the given right over an object

```go
Get-DomainObjectACL -Identity * | ? {$_.SecurityIdentifier -eq $sid}
```
![[Pasted image 20260418095954.png]]
The output displays the `ObjectAceType`. You can either Google this value [which will lead you here](https://learn.microsoft.com/en-us/windows/win32/adschema/r-user-force-change-password). Or you can perform a reverse search via PowerShell

##### Performing a Reverse Search & Mapping to a GUID Value

Grab the guid and....
```go
$guid= "00299570-246d-11d0-a768-00aa006e0529"
```

```go
Get-ADObject -SearchBase "CN=Extended-Rights,$((Get-ADRootDSE).ConfigurationNamingContext)" -Filter {ObjectClass -like 'ControlAccessRight'} -Properties * |Select Name,DisplayName,DistinguishedName,rightsGuid| ?{$_.rightsGuid -eq $guid} | fl
```

>[!Info]
>PowerView can do the same with the `ResolveGUIDs` flag and produce it in a more human readable format

```go
Get-DomainObjectACL -ResolveGUIDs -Identity * | ? {$_.SecurityIdentifier -eq $sid}
```

##### Creating a List of Domain Users
```go
Get-ADUser -Filter * | Select-Object -ExpandProperty SamAccountName > ad_users.txt
```

Feed the users in the text file to the following foreach loop

>[!info] Explaining the below foreach loop
> - Get-ACL cmdlet retrieves ACL info for each domain user in`ad_users.txt` and feeds the users into the Get-ADUser cmdlet
> - Access property gives information about access rights
> - The `IdentityReference`, is set to the user we are in control of

```go
foreach($line in [System.IO.File]::ReadLines("C:\Users\htb-student\Desktop\ad_users.txt")) {get-acl "AD:\$(Get-ADUser $line)" | Select-Object Path -ExpandProperty Access | Where-Object {$_.IdentityReference -match 'INLANEFREIGHT\\wley'}}
```

##### Further Enumeration of Rights Using the damundsen
```go
$sid2 = Convert-NameToSid damundsen
```

```go
Get-DomainObjectACL -ResolveGUIDs -Identity * | ? {$_.SecurityIdentifier -eq $sid2} -Verbose
```

![[Pasted image 20260418094943.png]]

>[!info] 
> - damundsen has access to the Help Desk Level 1 group. 
> - If this group is nested into other groups, then damundsen will inherit the rights of the child groups as well, such as the Information Technology group shown below
> - damundsen can add members to the Help Desk Level 1 group via the `GenericWrite` privilege 

##### Investigating the Help Desk Level 1 Group with Get-DomainGroup
```go
Get-DomainGroup -Identity "Help Desk Level 1" | select memberof
```

##### Investigating the Information Technology Group
```go
$itgroupsid = Convert-NameToSid "Information Technology"
```

>[!info]
>The above search shows us that members of the IT group have GenericAll rights over the user `adunn` meaning:
>	- you can modify group membership
>	- force change a password
>	- perform targeted Kerberoasting attack and crack weak passwords

```go
$itgroupsid = Convert-NameToSid "Information Technology"
```

```go
Get-DomainObjectACL -ResolveGUIDs -Identity * | ? {$_.SecurityIdentifier -eq $itgroupsid} -Verbose
```

##### Looking for Interesting Access

>[!info]
> Determine the types of accesses the user `adunn` has

```go
$adunnsid = Convert-NameToSid adunn
```

```go
Get-DomainObjectACL -ResolveGUIDs -Identity * | ? {$_.SecurityIdentifier -eq $adunnsid} -Verbose
```

>[!warning] DCSync Potential!
> The highlight sections indicate the user can be leveraged to perform a DCSync attack

![[Pasted image 20260418145818.png]]

---------------------------------------------

# Questions

RDP
```go
xfreerdp /v:10.129.62.34 /u:htb-student /p:'Academy_student_AD!' /drive:HTB,/home/dan/Desktop/HTB/13-Active-Directory-Enumeration-And-Attacks/ACE /smart-sizing:2400x1200 /cert:ignore
```

##### Question 1: Using the skills learned in this section, enumerate the ActiveDirectoryRights that the user forend has over the user dpayne (Dagmar Payne).

Answer
```go
GenericAll
```

First import the PowerView script
```go
Import-Module .\PowerView.ps1
```

Get the sid for `forend`
```go
$sid = Convert-NameToSid forend
```

Get the Domain Object ACL for the user `forend`
```go
Get-DomainObjectACL -Identity * | ? {$_.SecurityIdentifier -eq $sid}
```

##### Question 2: What is the ObjectAceType of the first right that the forend user has over the GPO Management group? (two words in the format Word-Word)

Answer
```go

```

Start SharpHound
```go
.\SharpHound.exe -c All --zipfilename INLANEFREIGHT
```

![[Pasted image 20260421071925.png]]

Start bloodhound on the windows machine and upload the zip file
```go
bloodhound
```

In the search bar submit the following. 
```go
forend@inlanefreight.local
```

Select the `Node Info` tab and scroll down to Outbound Control Rights -> First Degree Object Control
![[Pasted image 20260421080054.png]]

The membership forend has over the GPO Management Group is `AddSelf`
![[Pasted image 20260421080150.png]]

Validated by the below screenshot:

![[Pasted image 20260421080725.png]]
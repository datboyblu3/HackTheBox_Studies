
## Active Directory PowerShell Module

##### Discover Modules
```go
Get-Module
```

##### Load ActiveDirectory Module
```go
Import-Module ActiveDirectory
```

```go
Get-Module
```

##### Get Domain Info
>[!info]
> Prints out helpful information like the domain SID, domain functional level, any child domains, and more
```go
Get-ADDomain
```

##### Get-ADUser
Filter accounts with the `ServicePrincipalName`
```go
Get-ADUser -Filter {ServicePrincipalName -ne "$null"} -Properties ServicePrincipalName
```

##### Checking for Trust Relationships

>[!info]
>Determines if they are trusts within our forest or with domains in other forests, the type of trust, the direction of the trust, and the name of the domain the relationship is with
```go
Get-ADTrust -Filter *
```

##### Group Enumeration
```go
Get-ADGroup -Filter * | select name
```

Take results from the above filter and feed into the command below

##### Detailed Group Info
```go
Get-ADGroup -Identity "Backup Operators"
```

##### Group Membership
```go
Get-ADGroupMember -Identity "Backup Operators"
```

### PowerView

##### Domain User Information
```go
Get-DomainUser -Identity mmorgan -Domain inlanefreight.local | Select-Object -Property name,samaccountname,description,memberof,whencreated,pwdlastset,lastlogontimestamp,accountexpires,admincount,userprincipalname,serviceprincipalname,useraccountcontrol
```

 ##### Recursive Group Membership
 >[!info]
 > Use the [Get-DomainGroupMember](https://powersploit.readthedocs.io/en/latest/Recon/Get-DomainGroupMember/) function to retrieve group-specific information. Adding the `-Recurse` switch tells PowerView that if it finds any groups that are part of the target group (nested group membership) to list out the members of those groups.
 
```go
Get-DomainGroupMember -Identity "Domain Admins" -Recurse
```

##### Trust Enumerations
>[!info]
> Thanks to the info gained from 'Recursive Group Membership', we can select our target(s) for priv esc
```go
Get-DomainTrustMapping
```

##### Testing for Local Admin Access
Works on local or remote admin access and will determine if the user is an admin on the host
```go
Test-AdminAccess -ComputerName ACADEMY-EA-MS01
```

##### Finding Users with SPN Set
```go
Get-DomainUser -SPN -Properties samaccountname,ServicePrincipalName
```

### SharpView

Enumerate information about a specific user
```go
.\SharpView.exe Get-DomainUser -Identity forend
```

### Snaffler

>[!Info]
>- Obtains a list of hosts within the domain and then enumerating those hosts for shares and readable directories. 
>- Once that is done, it iterates through any directories readable by our user and hunts for files that could serve to better our position within the assessment. 
>- Snaffler requires that it be run from a domain-joined host or in a domain-user context
```go 
.\Snaffler.exe -s -d inlanefreight.local -o snaffler.log -v data
```

### Bloodhound

##### SharpHound Collector
```go
.\SharpHound.exe -c All --zipfilename ILFREIGHT
```

# Questions

Username
```go
htb-student
```

Password
```go
Academy_student_AD!
```

RDP
```go
xfreerdp /v:10.129.37.189 /u:htb-student /p:'Academy_student_AD!' /d:INLANEFREIGHT.LOCAL /smart-sizing:3400x2000
```

### Question 1: Using Bloodhound, determine how many Kerberoastable accounts exist within the INLANEFREIGHT domain. (Submit the number as the answer)

```go
13
```



Start the SharpHound Collector
```go
.\SharpHound.exe -c All --zipfilename INLANEFREIGHT
```

Afterwards, start bloodhound and upload the zip file
```go
bloodhound
```

- In the search bar type "domain"
- Select the "Analysis" tab to the right and under "Kerberos Interaction" select "List all Kerberoastable Users"
### Question2: What PowerView function allows us to test if a user has administrative access to a local or remote host?
```go
TestAdmin-Access
```

### Question 3: Run Snaffler and hunt for a readable web config file. What is the name of the user in the connection string within the file?
```go
sa
```


```go
.\Snaffler.exe -s -d inlanefreight.local -o snaffler.log -v data
```

Config file is at:
```go
(\\ACADEMY-EA-DC01.INLANEFREIGHT.LOCAL\Department Shares\IT\Development\web.config)
```



```go
sudo crackmapexec smb 10.129.37.189 -u forend -p Klmcargo2 --get-file '\\ACADEMY-EA-DC01.INLANEFREIGHT.LOCAL\Department Shares\IT\Development\web.config' web.config
```


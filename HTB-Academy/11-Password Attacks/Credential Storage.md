
### Linux

Passwords are stored in the /etc/shadow file. Below is a snippet and format description of the syntax

```go
root@htb:~# cat /etc/shadow

...SNIP...
htb-student:$y$j9T$3QSBB6CbHEu...SNIP...f8Ms:18955:0:99999:7:::
```

### Windows Authentication Process

>[! Tip ] Local Security Authority
> is a protected subsystem that authenticates users and logs them into the local computer. In addition, the LSA maintains information about all aspects of local security on a computer. It also provides various services for translating between names and security IDs.
> 
> The LSA subsystem provides services for checking access to objects, checking user permissions, and generating monitoring messages

#### LSASS

>[! Hint ] Local Security Authentication Subsystem Service
>
>  This is a collection of many modules and has access to all authentication processes that can be found in `%SystemRoot%\System32\Lsass.exe`. This service is responsible for the local system security policy, user authentication, and sending security audit logs to the `Event log`. It is the vault for Windows-based operating systems.


#### SAM
>[! Hint ] Security Account Manager
>
> This is a database file in Windows operating systems that stores users' passwords. It can be used to authenticate local and remote users. User passwords are stored in a hash format in a registry structure as either an `LM` hash or an `NTLM` hash. This file is located in `%SystemRoot%/system32/config/SAM` and is mounted on HKLM/SAM. SYSTEM level permissions are required to view it.
>


#### SAM Database

>[! Hint ] Security Account Management Database
> 
> This is a database that stores the passwords of Windows users. User passwords are stored in a hash format in a registry structure as either an `LM` hash or an `NTLM` hash. This file is located in `%SystemRoot%/system32/config/SAM` and is mounted on HKLM/SAM. SYSTEM level permissions are required to view it.
>
> If the system has been assigned to a workgroup, it handles the SAM database locally and stores all existing users locally in this database. However, if the system has been joined to a domain, the Domain Controller (`DC`) must validate the credentials from the Active Directory database (`ntds.dit`), which is stored in `%SystemRoot%\ntds.dit`.
>
> The `SYSKEY` (`syskey.exe`), when enabled, partially encrypts the hard disk copy of the SAM file so that the password hash values for all local accounts stored in the SAM are encrypted with a key.

#### Credential Manager

>[! Hint ] Credential Manager
>
> Credential Manager is a feature built-in to all Windows operating systems that allows users to save the credentials they use to access various network resources and websites. Saved credentials are stored based on user profiles in each user's `Credential Locker`. Credentials are encrypted and stored at the following location
>```powershell-session
C:\Users\[Username]\AppData\Local\Microsoft\[Vault/Credentials]\


#### NTDS

>[! Hint ]
>
> Windows systems will send all logon requests to Domain Controllers that belong to the same Active Directory forest. Each Domain Controller hosts a file called `NTDS.dit` that is kept synchronized across all Domain Controllers with the exception of [Read-Only Domain Controllers](https://docs.microsoft.com/en-us/windows/win32/ad/rodc-and-active-directory-schema). NTDS.dit is a database file that stores the data in Active Directory, including but not limited to:
> - User accounts (username & password hash)
> - Group accounts
> - Computer accounts
> - Group policy objects






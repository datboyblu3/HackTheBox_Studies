
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


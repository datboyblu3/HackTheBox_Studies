
## Enumerating the Password Policy - from Linux - Credentialed


>[!Tip]
> With valid domain credentials, the password policy can also be obtained remotely using tools such as CrackMapExec or rpcclient

### CrackMapExec
```go
crackmapexec smb 172.16.5.5 -u avazquez -p Password123 --pass-pol
```

### Enumerating the Password Policy - from Linux - SMB NULL Sessions

>[!Note] 
> SMB NULL session can be enumerated via enum4Linux, CrackMapExec and rpcclient

### rpcclient
*Afterwards, use command `querydomaininfo` to confirm NULL session access*

```go
rpcclient -U "" -N 172.16.5.5
```

### Common Windows enumeration tools and the ports they use:

| Tool      | Ports                                             |
| --------- | ------------------------------------------------- |
| nmblookup | 137/UDP                                           |
| nbtstat   | 137/UDP                                           |
| net       | 139/TCP, 135/TCP, TCP and UDP 135 and 49152-65535 |
| rpcclient | 135/TCP                                           |
| smbclient | 445/TCP                                           |

### enum4linux
```go
enum4linux -P 172.16.5.5
```

### enum4linux-ng

>[!Note] What's the difference?
>- Written in Python
>- Export data in YAML or JSON
>- Supports colored output
>```go
>enum4linux-ng -P 172.16.5.5 -oA ilfreight
>```


## Enumerating the Password Policy - from Linux - LDAP Anonymous Bind

>[! Note]
> [LDAP anonymous binds](https://docs.microsoft.com/en-us/troubleshoot/windows-server/identity/anonymous-ldap-operations-active-directory-disabled) allow unauthenticated attackers to retrieve information from the domain, such as a complete listing of users, groups, computers, user account attributes, and the domain password policy.
> Use LDAP-specific enumeration tools such as `windapsearch.py`, `ldapsearch`, `ad-ldapdomaindump.py`, etc., to pull the password policy.

### Using ldapsearch
```go
ldapsearch -h 172.16.5.5 -x -b "DC=INLANEFREIGHT,DC=LOCAL" -s sub "*" | grep -m 1 -B 10 pwdHistoryLength
```



## Enumerating the Password Policy - from Windows


--------------------------------

## Enumerating Null Session - from Windows


### Establishing a null session from Windows
```go
net use \\DC01\ipc$ "" /u:""
```

With null password
```go
net use \\DC01\ipc$ "" /u:guest
```

With incorrect passwords
```go
net use \\DC01\ipc$ "password" /u:guest
```

----------------

# Questions

Username
```go
htb-student
```

Password
```go
HTB_@cademy_stdnt!
```

SSH
```go
ssh htb-student@10.129.35.32
```

1) What is the default Minimum password length when a new domain is created? (One number)
```go
7
```



2)  What is the minPwdLength set to in the INLANEFREIGHT.LOCAL domain? (One number)

```go
ldapsearch -h 172.16.5.5 -x -b "DC=INLANEFREIGHT,DC=LOCAL" -s sub "*" | grep -m 1 -B 10 pwdHistoryLength
```


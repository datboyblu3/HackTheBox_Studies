
>[!INFO] Domain Trusts
> A trust creates a link between the authentication systems of two domains and may allow either one-way or two-way communication. Multiple types of trusts:
> 
> - `Parent-child`: Two or more domains within the same forest. The child domain has a two-way transitive trust with the parent domain, meaning that users in the child domain `corp.inlanefreight.local` could authenticate into the parent domain `inlanefreight.local`, and vice-versa.
> - `Cross-link`: A trust between child domains to speed up authentication.
> - `External`: A non-transitive trust between two separate domains in separate forests which are not already joined by a forest trust. This type of trust utilizes [SID filtering](https://www.serverbrain.org/active-directory-2008/sid-history-and-sid-filtering.html) or filters out authentication requests (by SID) not from the trusted domain.
> - `Tree-root`: A two-way transitive trust between a forest root domain and a new tree root domain. They are created by design when you set up a new tree root domain within a forest.
> - `Forest`: A transitive trust between two forest root domains.
> - [ESAE](https://docs.microsoft.com/en-us/security/compass/esae-retirement): A bastion forest used to manage Active Directory.


## Enumerating Trust Relationships

##### Using Get-ADTrust
```go
Import-Module activedirectory
```

```go
Get-ADTrust -Filter *
```


The results show two domain trusts: `LOGISTICS.INLANEFREIGHT.LOCAL`(IntraForest = child domain) and `FREIGHTLOGISTICS.LOCAL`(ForestTransitive = forest trust or external trust). 

![[Pasted image 20260507061519.png]]

>[!hint] PowerView and BloodHound
> PowerView and BloodHound can be used to enumerate the following:
> - trust relationships:
> - types of trusts established
> - authentication flow

##### Checking for Existing Trusts using Get-DomainTrust (PowerView)
```go
Get-DomainTrust
```

##### Using Get-DomainTrustMapping
```go
Get-DomainTrustMapping
```

##### Checking Users in the Child Domain using Get-DomainUser
```go
Get-DomainUser -Domain LOGISTICS.INLANEFREIGHT.LOCAL | select SamAccountName
```

##### Using netdom to query domain trust

>[!info]
> The `netdom query` sub-command of the `netdom` command-line tool in Windows can retrieve information about the domain, including a list of workstations, servers, and domain trusts

```go
netdom query /domain:inlanefreight.local trust
```

##### Using netdom to query domain controllers
```go
netdom query /domain:inlanefreight.local dc
```

##### Using netdom to query workstations and servers
```go
netdom query /domain:inlanefreight.local workstation
```

## BloodHound

>[!info]
> Use BloodHound to visualize these trust relationships by using the `Map Domain Trusts` pre-built query. Here we can easily see that two bidirectional trusts exist




------------------------------------------------

RDP
```go
xfreerdp /v:10.129.78.208 /u:htb-student /p:'Academy_student_AD!' /drive:HTB,/home/dan/Desktop/HTB/13-Active-Directory-Enumeration-And-Attacks/ACE /smart-sizing:2400x1200 /cert:ignore
```


##### Question 1: What is the child domain of INLANEFREIGHT.LOCAL? (format: FQDN, i.e., DEV.ACME.LOCAL)

Answer
```go
LOGISTICS.INLANEFREIGHT.LOCAL
```

##### Question 2: What domain does the INLANEFREIGHT.LOCAL domain have a forest transitive trust with?

Answer
```go
FREIGHTLOGISTICS.LOCAL
```

##### Question 3: What direction is this trust?
```go
BiDirectional
```


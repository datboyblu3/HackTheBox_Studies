>[!tldr] ICMP tunneling encapsulates your traffic within `ICMP packets` containing `echo requests` and `responses`. ICMP tunneling would only work when ping responses are permitted within a firewalled network.

>[!Note] Use the [ptunnel-ng](https://github.com/utoni/ptunnel-ng) tool to create a tunnel between our Ubuntu server and our attack host

## Setting up Ptunnel-ng


### Clone from GitHub
```go
git clone https://github.com/utoni/ptunnel-ng.git
```

### Build Ptunnel-ng with Autogen.sh
```go
sudo ./autogen.sh 
```

### Transfer Ptunnel-ng to Pivot Host
```go
scp -r ptunnel-ng ubuntu@10.129.115.205:~/
```

### Starting the ptunnel-ng Server on the Target Host
```go
sudo ./ptunnel-ng -r10.129.115.205 -R22
```

### Connecting to ptunnel-ng Server from Attack Host
```go
sudo ./ptunnel-ng -p10.129.115.205 -l2222 -r10.129.202.64 -R22
```

	NOTE: Always initiate the connection from port 2222. Connecting through local port 2222 allows us to send traffic through the ICMP tunnel.

### Tunneling an SSH connection through an ICMP Tunnel
```go
ssh -p2222 -lubuntu 127.0.0.1
```

### Enabling Dynamic Port Forwarding over SSH
```go
ssh -D 9050 -p2222 -lubuntu 127.0.0.1
```

### Proxychaining through the ICMP Tunnel - Scanning internal network (172.16.5.x)
```go
proxychains nmap -sV -sT 172.16.5.19 -p3389
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
10.129.115.205
```

SSH
```go
ssh ubuntu@10.129.115.205
```

xfreerdp
```go
xfreerdp /u:victor /p:pass@123 /v:172.16.5.19
```


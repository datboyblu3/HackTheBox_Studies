
Both **Dynamic Port Forwarding (DPF)** and **Local Port Forwarding (LPF)** are used to route traffic through an SSH tunnel, but they serve different purposes.

|Feature|Dynamic Port Forwarding (DPF)|Local Port Forwarding (LPF)|
|---|---|---|
|**Function**|Acts as a SOCKS proxy to forward traffic dynamically to different destinations.|Forwards traffic from a local port to a specific remote server/port.|
|**Use Case**|Useful when you need to tunnel multiple types of traffic (e.g., web browsing, RDP, etc.) through an SSH connection.|Useful when you need to securely access a specific remote service (e.g., accessing an internal database).|
|**How It Works**|Creates a local SOCKS proxy server that routes traffic dynamically based on the destination.|Maps a single local port to a fixed remote destination (IP & port).|
|**Command Example**|`ssh -D 1080 user@remote-host`|`ssh -L 8080:remote-host:80 user@jump-server`|
|**Flexibility**|More flexible—applications can use the proxy to reach multiple destinations.|Less flexible—only one fixed destination is allowed per tunnel.|
|**Common Use Cases**|- Bypassing firewalls/censorship (e.g., tunneling browser traffic). - Penetration testing (SOCKS proxy for pivoting).|- Secure access to an internal web service or database. - Remote development on a protected server.|

#### Scanning Pivot Target
```go
nmap -sT -p22,3306, 10.129.202.40
```

#### Local Port Forward - Single Port

The `-L` command tells the SSH client to request the SSH server to forward all the data we send via the port `1234` to `localhost:3306` on the Ubuntu server. You should be able to access the MySQL service locally on port 1234:
```go
ssh -L 1234:localhost:3306 ubuntu@10.129.202.64
```

#### Forwarding Multiple Ports
The below command forwards the apache web server's port 80 to your attack host's local port on `8080`
```go
ssh -L 1234:localhost:3306 -L 8080:localhost:80 ubuntu@10.129.202.64
```

#### Dynamic Port Forwarding

>[!Warning] 
> To inform proxychains that we must use port 9050, we must modify the proxychains configuration file located at `/etc/proxychains.conf`. We can add `socks4 127.0.0.1 9050` to the last line if it is not already there.

```go
ssh -D 9050 ubuntu@10.129.202.64
```

##### Using Nmap with Proxychains
```go
proxychains nmap -v -sn 172.16.5.1-200
```


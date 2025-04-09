### Questions

Add virtual hosts to my /etc/hosts file

```go
app.inlanefreight.local
```

```go
dev.inlanefreight.local
```

1) Determine the Apache version running on app.inlanefreight.local on the target system. (Format: 0.0.0)
```go
sudo echo "STIMP app.inlanefreight.local dev.inlanefreight.local" >> /etc/hosts
```

```go
curl -I https://inlanefreight.com
```

Answer: 
```go
2.4.41
```

2) Which CMS is used on app.inlanefreight.local on the target system? Respond with the name only, e.g., WordPress.

Identify any outdated software via nikto
```go
nmap -A -sV --script=http-enum 10.129.236.255
```

Answer:
```go
Joomla!
```

3) On which operating system is the dev.inlanefreight.local webserver running in the target system? Respond with the name only, e.g., Debian.
```go
nmap -A -sV --script=http-enum 10.129.236.255
```

Answer:
```go
Ubuntu
```


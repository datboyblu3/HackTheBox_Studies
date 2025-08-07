[Netsh](https://docs.microsoft.com/en-us/windows-server/networking/technologies/netsh/netsh-contexts) is a Windows command-line tool that can help with the network configuration of a particular Windows system. Here are just some of the networking related tasks we can use `Netsh` for:

- `Finding routes`
- `Viewing the firewall configuration`
- `Adding proxies`
- `Creating port forwarding rules`

Use `netsh.exe` to forward all data received on a specific port (say 8080) to a remote host on a remote port.

```go
C:\Windows\system32> netsh.exe interface portproxy add v4tov4 listenport=8080 listenaddress=10.129.15.150 connectport=3389 connectaddress=172.16.5.25
```

Verify Port Forwarding
```go
netsh.exe interface portproxy show v4tov4
```

From the attack host, connect to the target host via `xfreerdp`
```go
xfreerdp /v:10.129.42.198:8080 /u:victor /p:pass@123
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
10.129.114.46
```

SSH
```go
ssh ubuntu@10.129.104.92
```

DC
```go
172.16.5.19
```

```go
xfreerdp /v:10.129.114.46 /u:htb-student /p:HTB_@cademy_stdnt!
```

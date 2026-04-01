
## Identifying Hosts 

Identifying hosts with different tools

#### Wireshark
```go
sudo -E wireshark
```

### TCPDump
```go
sudo tcpdump -i ens224
```

### Responder
```go
sudo responder -I ens224 -A
```
	-A: executes in "Analyze" mode

### Fping
>[!Note] 
> Simultaneously sends ICMP packets against multiple hosts. Queries in a cyclical manner - it does not wait for a host to return before continuing

```go
fping -asgq 172.16.5.0/23
```
	-a: display alive targets
	-s: print stats at end of scan
	-g: generate target list from CIDR network
	-q: dont show per-target results

>[!tip] 
>Throw results into a list and perform further enumeration with Nmap

```go
sudo nmap -v -A -iL hosts.txt -oN /home/htb-student/Documents/host-enum
```

## Identifying Users
>[!Note]
> Find a way to establish a foothold in the domain by either obtaining clear text credentials or an NTLM password hash for a user, a SYSTEM shell on a domain-joined host, or a shell in the context of a domain user account.

### Kerbrute - Internal AD Username Enumeration

>[!tip] Insidetrust Wordlist
> Use kerbrute with a wordlist from this repo:
> [insidetrust](https://github.com/insidetrust/statistically-likely-usernames)

Navigate to the `kerbrute` directory and....
```go
sudo make all
```

### Enumerate Users with Kerbrute

>[!Note]
>In the lesson this command builds a list of 56 potential users
```go
kerbrute userenum -d INLANEFREIGHT.LOCAL --dc 172.16.5.5 jsmith.txt -o valid_ad_users
```

## Identifying Potential Vulnerabilities
>[!Note]
> - `NT AUTHORITY\SYSTEM` is a built in Windows OS that has the highest level of access in the OS and runs most Windows services.
> - Third party services often run in the context of this account by default
> - A `SYSTEM` domain joined account will be able to enumerate AD

#### Ways to gain SYSTEM level access on a host
- Remote Windows exploits: MS08-067, EternalBlue, or BlueKeep
- Abusing a service running in the context of a SYSTEM account
- Abusing the service account `SEImpersonate` via [Juicy Potato](https://github.com/ohpe/juicy-potato) - possible on older Windows OS's but not always with Server 2019
- Local privilege escalation flaws in Windows operating systems such as the Windows 10 Task Scheduler 0-day.
- Gaining admin access on a domain-joined host with a local account and using Psexec to launch a SYSTEM cmd window

# Questions

{{targetIP}} 
```go
10.129.32.132
```

Username
```go
htb-student
```

Password
```go
HTB_@cademy_stdnt!
```

SSH
```go
ssh htb-student@10.129.32.132
```

From your scans, what is the "commonName" of host 172.16.5.5 ?

>[!Note] 
> SSH into the machine and issue `cat /etc/hosts`
```go
ACADEMY-EA-DC01.INLANEFREIGHT.LOCAL
```

What host is running "Microsoft SQL Server 2019 15.00.2000.00"? (IP address, not Resolved name)

Other hosts on the network
```go
172.16.5.130
```

```go
172.16.5.225
```


```go
```
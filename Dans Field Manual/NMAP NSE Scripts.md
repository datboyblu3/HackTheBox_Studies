

**Service Enumeration Reference | Linux & Windows**

---

## ▶ FTP NSE [TCP/21]

|Script|Description|
|---|---|
|`ftp-anon`|Checks if FTP server allows anonymous login|
|`ftp-bounce`|Tests for FTP bounce attack vulnerability|
|`ftp-brute`|Performs brute-force password audit against FTP|
|`ftp-syst`|Sends SYST command and returns server OS info|
|`ftp-vsftpd-backdoor`|Checks for backdoor in vsftpd 2.3.4 (CVE-2011-2523)|
|`ftp-libopie`|Checks for OPIE authentication on FTP|

**Examples:**

```go
nmap -sV -p 21 --script=ftp-anon 192.168.1.1
nmap -p 21 --script=ftp-bounce 192.168.1.1
nmap -p 21 --script=ftp-brute --script-args userdb=u.txt,passdb=p.txt 192.168.1.1
nmap -p 21 --script=ftp-syst 192.168.1.1
nmap -p 21 --script=ftp-vsftpd-backdoor 192.168.1.1
nmap -p 21 --script=ftp-libopie 192.168.1.1
```

---

## ▶ SSH NSE [TCP/22]

|Script|Description|
|---|---|
|`ssh-auth-methods`|Lists supported authentication methods|
|`ssh-brute`|Performs brute-force password audit against SSH|
|`ssh-hostkey`|Shows the target's SSH host key and fingerprint|
|`ssh2-enum-algos`|Reports supported SSH2 algorithms (kex, cipher, MAC)|
|`ssh-publickey-acceptance`|Tests if a public key is accepted for authentication|

**Examples:**

```go
nmap -p 22 --script=ssh-auth-methods --script-args="ssh.user=root" 192.168.1.1
nmap -p 22 --script=ssh-brute --script-args userdb=u.txt,passdb=p.txt 192.168.1.1
nmap -p 22 --script=ssh-hostkey --script-args ssh_hostkey=full 192.168.1.1
nmap -p 22 --script=ssh2-enum-algos 192.168.1.1
nmap -p 22 --script=ssh-publickey-acceptance --script-args="publickeys=id_rsa.pub" 192.168.1.1
```

---

## ▶ SMB NSE [TCP/445, 139]

|Script|Description|
|---|---|
|`smb-enum-shares`|Enumerates SMB shares and permissions|
|`smb-enum-users`|Enumerates Windows users via SMB|
|`smb-enum-groups`|Enumerates local and domain groups|
|`smb-enum-sessions`|Enumerates active SMB sessions|
|`smb-os-discovery`|Retrieves OS, hostname, and domain via SMB|
|`smb-vuln-ms17-010`|Detects EternalBlue vulnerability (MS17-010)|
|`smb-vuln-ms08-067`|Checks for MS08-067 (Conficker) vulnerability|
|`smb-security-mode`|Returns SMB security level information|
|`smb2-capabilities`|Checks capabilities advertised over SMBv2|
|`smb-brute`|Performs brute-force auth against SMB|

**Examples:**

```go
nmap -p 445 --script=smb-enum-shares 192.168.1.1
nmap -p 445 --script=smb-enum-users 192.168.1.1
nmap -p 445 --script=smb-enum-groups 192.168.1.1
nmap -p 445 --script=smb-enum-sessions 192.168.1.1
nmap -p 445 --script=smb-os-discovery 192.168.1.1
nmap -p 445 --script=smb-vuln-ms17-010 192.168.1.1
nmap -p 445 --script=smb-vuln-ms08-067 --script-args=unsafe=1 192.168.1.1
nmap -p 445 --script=smb-security-mode 192.168.1.1
nmap -p 445 --script=smb2-capabilities 192.168.1.1
nmap -p 445 --script=smb-brute --script-args userdb=u.txt,passdb=p.txt 192.168.1.1
```

---

## ▶ HTTP / HTTPS NSE [TCP/80, 443]

|Script|Description|
|---|---|
|`http-enum`|Enumerates directories and files via HTTP|
|`http-headers`|Retrieves HTTP response headers|
|`http-title`|Shows the page title of the web root|
|`http-methods`|Enumerates allowed HTTP methods|
|`http-auth-finder`|Discovers HTTP authentication schemes|
|`http-brute`|Performs brute-force HTTP authentication|
|`http-wordpress-enum`|Enumerates WordPress themes, plugins, users|
|`http-shellshock`|Detects Shellshock vulnerability (CVE-2014-6271)|
|`http-vuln-cve2017-5638`|Checks Apache Struts RCE vulnerability|
|`ssl-cert`|Retrieves and displays the SSL certificate|
|`ssl-enum-ciphers`|Lists supported SSL/TLS cipher suites and strength rating|

**Examples:**

```go
nmap -p 80 --script=http-enum 192.168.1.1
nmap -p 80,443 --script=http-headers 192.168.1.1
nmap -p 80,443 --script=http-title 192.168.1.1
nmap -p 80 --script=http-methods --script-args http-methods.url-path='/api' 192.168.1.1
nmap -p 80,443 --script=http-auth-finder 192.168.1.1
nmap -p 80 --script=http-brute --script-args http-brute.path=/admin 192.168.1.1
nmap -p 80 --script=http-wordpress-enum 192.168.1.1
nmap -p 80 --script=http-shellshock --script-args uri=/cgi-bin/test.cgi 192.168.1.1
nmap -p 80 --script=http-vuln-cve2017-5638 192.168.1.1
nmap -p 443 --script=ssl-cert 192.168.1.1
nmap -p 443 --script=ssl-enum-ciphers 192.168.1.1
```

---

## ▶ DNS NSE [TCP/UDP/53]

|Script|Description|
|---|---|
|`dns-brute`|Brute-forces DNS hostnames and subdomains|
|`dns-zone-transfer`|Attempts a DNS zone transfer (AXFR)|
|`dns-srv-enum`|Enumerates SRV records for common services|
|`dns-cache-snoop`|Snoops on a DNS server's cache for queried domains|
|`dns-recursion`|Checks if the DNS server allows recursive queries|

**Examples:**

```go
nmap -p 53 --script=dns-brute --script-args dns-brute.domain=example.com 192.168.1.1
nmap -p 53 --script=dns-zone-transfer --script-args dns-zone-transfer.domain=example.com 192.168.1.1
nmap -p 53 --script=dns-srv-enum --script-args dns-srv-enum.domain=example.com 192.168.1.1
nmap -p 53 --script=dns-cache-snoop --script-args dns-cache-snoop.mode=timed 192.168.1.1
nmap -p 53 --script=dns-recursion 192.168.1.1
```

---

## ▶ SNMP NSE [UDP/161]

|Script|Description|
|---|---|
|`snmp-info`|Returns system description and uptime from SNMP|
|`snmp-interfaces`|Enumerates network interfaces via SNMP|
|`snmp-processes`|Enumerates running processes via SNMP|
|`snmp-sysdescr`|Retrieves SNMP sysDescr (OS and version info)|
|`snmp-brute`|Attempts to brute-force SNMP community strings|

**Examples:**

```go
nmap -sU -p 161 --script=snmp-info 192.168.1.1
nmap -sU -p 161 --script=snmp-interfaces 192.168.1.1
nmap -sU -p 161 --script=snmp-processes 192.168.1.1
nmap -sU -p 161 --script=snmp-sysdescr 192.168.1.1
nmap -sU -p 161 --script=snmp-brute --script-args passdb=communities.txt 192.168.1.1
```

---

## ▶ RDP NSE [TCP/3389]

|Script|Description|
|---|---|
|`rdp-enum-encryption`|Enumerates supported RDP encryption methods|
|`rdp-vuln-ms12-020`|Checks for MS12-020 DoS/RCE vulnerability|

**Examples:**

```go
nmap -p 3389 --script=rdp-enum-encryption 192.168.1.1
nmap -p 3389 --script=rdp-vuln-ms12-020 192.168.1.1
```

---

## ▶ MySQL NSE [TCP/3306]

|Script|Description|
|---|---|
|`mysql-info`|Connects and retrieves MySQL server banner info|
|`mysql-enum`|Enumerates MySQL users (with empty password)|
|`mysql-databases`|Lists accessible databases on the MySQL server|
|`mysql-brute`|Performs brute-force auth against MySQL|
|`mysql-empty-password`|Checks for MySQL accounts with empty passwords|

**Examples:**

```go
nmap -p 3306 --script=mysql-info 192.168.1.1
nmap -p 3306 --script=mysql-enum 192.168.1.1
nmap -p 3306 --script=mysql-databases --script-args mysqluser=root 192.168.1.1
nmap -p 3306 --script=mysql-brute --script-args userdb=u.txt,passdb=p.txt 192.168.1.1
nmap -p 3306 --script=mysql-empty-password 192.168.1.1
```

---

## ▶ MSSQL NSE [TCP/1433]

|Script|Description|
|---|---|
|`ms-sql-info`|Attempts to discover MSSQL server info and version|
|`ms-sql-enum`|Enumerates MSSQL logins and databases|
|`ms-sql-brute`|Performs brute-force auth against MSSQL|
|`ms-sql-xp-cmdshell`|Tests if xp_cmdshell is enabled for command execution|
|`ms-sql-empty-password`|Checks for MSSQL accounts with empty passwords|

**Examples:**

```go
nmap -p 1433 --script=ms-sql-info 192.168.1.1
nmap -p 1433 --script=ms-sql-enum 192.168.1.1
nmap -p 1433 --script=ms-sql-brute --script-args userdb=u.txt,passdb=p.txt 192.168.1.1
nmap -p 1433 --script=ms-sql-xp-cmdshell --script-args mssql.username=sa,mssql.password=sa 192.168.1.1
nmap -p 1433 --script=ms-sql-empty-password 192.168.1.1
```

---

## ▶ NFS / RPC NSE [TCP-UDP/111, 2049]

|Script|Description|
|---|---|
|`nfs-showmount`|Shows NFS exports (equivalent to showmount -e)|
|`nfs-ls`|Lists NFS export contents and permissions|
|`nfs-statfs`|Retrieves filesystem stats for an NFS share|
|`rpc-grind`|Finds RPC program numbers and versions|
|`rpcinfo`|Retrieves all registered RPC programs and port mappings|

**Examples:**

```go
nmap -p 111,2049 --script=nfs-showmount 192.168.1.1
nmap -p 111,2049 --script=nfs-ls 192.168.1.1
nmap -p 111,2049 --script=nfs-statfs 192.168.1.1
nmap -p 111 --script=rpc-grind 192.168.1.1
nmap -p 111 --script=rpcinfo 192.168.1.1
```

---

## ▶ LDAP NSE [TCP/389, 636]

|Script|Description|
|---|---|
|`ldap-rootdse`|Retrieves LDAP root DSE (naming contexts, schema, version)|
|`ldap-brute`|Performs brute-force auth against LDAP|
|`ldap-search`|Performs LDAP search query for user/group info|

**Examples:**

```go
nmap -p 389 --script=ldap-rootdse 192.168.1.1
nmap -p 389 --script=ldap-brute --script-args brute.firstonly=true 192.168.1.1
nmap -p 389 --script=ldap-search --script-args ldap.base='"dc=example,dc=com"' 192.168.1.1
```

---

## ▶ VNC NSE [TCP/5900]

|Script|Description|
|---|---|
|`vnc-info`|Retrieves VNC server info and authentication type|
|`vnc-brute`|Performs brute-force password auth against VNC|
|`realvnc-auth-bypass`|Checks for RealVNC authentication bypass (CVE-2006-2369)|

**Examples:**

```go
nmap -p 5900 --script=vnc-info 192.168.1.1
nmap -p 5900 --script=vnc-brute --script-args passdb=p.txt 192.168.1.1
nmap -p 5900 --script=realvnc-auth-bypass 192.168.1.1
```

---

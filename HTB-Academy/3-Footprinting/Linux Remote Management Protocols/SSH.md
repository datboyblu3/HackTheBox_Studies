
### Default Configuration
```
cat /etc/ssh/sshd_config  | grep -v "#" | sed -r '/^\s*$/d'
```

### Dangerous Settings

PasswordAuthentication yes............................	Allows password-based authentication
PermitEmptyPasswords yes.............................	Allows the use of empty passwords.
PermitRootLogin yes..........................................Allows to log in as the root user.
Protocol 1.............................................................Uses an outdated version of encryption.
X11Forwarding yes	.............................................Allows X11 forwarding for GUI applications.
AllowTcpForwarding yes....................................Allows forwarding of TCP ports.
PermitTunnel.......................................................Allows tunneling.
DebianBanner yes..............................................Displays a specific banner when logging in.

### Footprinting SSH

ssh-audit checks the client-side and server-side configuration and shows some general information and which encryption algorithms are still used by the client and server

```
git clone https://github.com/jtesta/ssh-audit.git && cd ssh-audit
```

```
./ssh-audit.py TARGET_IP
```

**Change Authentication Method**

For potential brute-force attacks, we can specify the authentication method with the SSH client option PreferredAuthentications.

```
ssh -v cry0l1t3@10.129.14.132 -o PreferredAuthentications=password
```

**Rsync**
- TCP/IP port 873
- can be used to copy files locally on a given machine and to/from remote hosts
- sends only the differences between the source files and the older version of the files that reside on the destination server
- It is often used for backups and mirroring
- It finds files that need to be transferred by looking at files that have changed in size or the last modified time

Check out the different ways Rsync can be taken advantage of: [Rsync Abuse](https://book.hacktricks.xyz/network-services-pentesting/873-pentesting-rsync)

**Scanning for Rsync**
```
sudo nmap -sV -p 873 127.0.0.1
```

**Probing for Accessible Shares**
```
nc -nv 127.0.0.1 873
```

**Enumerating an Open Share**: Assume the share found is called 'dev'
```
rsync -av --list-only rsync://127.0.0.1/dev
```

From the files that would result from the share above, we sync all them to our attacker machine
```
rsync -av rsync://127.0.0.1/dev
```

[How to Transfer Files with Rsync over SSH](https://phoenixnap.com/kb/how-to-rsync-over-ssh)

**R-Services**
- transmit information from client to server(and vice versa.) over the network in an unencrypted format, making it possible for attackers to intercept network traffic
- ports 512, 513, and 514 only accessible via r-commands
- most commonly used by commercial operating systems such as Solaris, HP-UX, and AIX

R-Commands are composed of the following programs:

rcp (remote copy)
rexec (remote execution)
rlogin (remote login)
rsh (remote shell)
rstat
ruptime
rwho (remote who)

Most Frequently Abused Programs
![[abused_rsync.png]]

**Trusted Hosts File**
The /etc/hosts.equiv file contains a list of trusted hosts and is used to grant access to other systems on the network. When users on one of these hosts attempt to access the system, they are automatically granted access without further authentication

```
cat /etc/hosts.equiv
```

**Scanning for R-Services**
```
sudo nmap -sV -p 512,513,514 10.0.17.2
```

**Access Control & Trusted Relationships**
- These services utilize Pluggable Authentication Modules (PAM) for user authentication onto a remote system; however, they also bypass this authentication through the use of the /etc/hosts.equiv and .rhosts
- hosts.equiv and .rhosts files contain a list of hosts (IPs or Hostnames) and users that are trusted by the local host when a connection attempt is made using r-commands

**Logging in with rlogin**. This login is successful due to the misconfiguration in the .rhosts file
```
rlogin 10.0.17.2 -l htb-student
```

Now list all interactive sessions on the local network with **rwho**
```
rwho
```

rusers will provide additional context by listing the authenticated users
```
rusers -al 10.0.17.5
```
who will list the following:
- what user is currently authenticated to what host
- 
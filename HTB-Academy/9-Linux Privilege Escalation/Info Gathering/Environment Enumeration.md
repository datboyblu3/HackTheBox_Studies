
**Find Writable Directories**

```
find / -path /proc -prune -o -type d -perm -o+w 2>/dev/null
```

**Find Writable Files**
```
find / -path /proc -prune -o -type f -perm -o+w 2>/dev/null
```

**PATH Variable**
```
echo $PATH
```

**ENV Variable**
```
env
```

**Determine Kernel Version: Two Ways**

uname -a
```
datboyblu3@htb[/htb]$ uname -a

Linux nixlpe02 5.4.0-122-generic #138-Ubuntu SMP Wed Jun 22 15:00:31 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux

```

/proc/version
```
cat /proc/version
```

**CPU type/version**
```
lscpu 
```

**Login Shells**
```
cat /etc/shells

# /etc/shells: valid login shells
/bin/sh
/bin/bash
/usr/bin/bash
/bin/rbash
/usr/bin/rbash
/bin/dash
/usr/bin/dash
/usr/bin/tmux
/usr/bin/screen
```

### Enumerating Drives

**lsblk**
```
lsblk
```

**fstab**
```
cat /etc/fstab
```

**lpstat** can be used to enumerate info about printers attached to the network

### Enumerate Routing Info

**route or netstat -rn**  
```
datboyblu3@htb[/htb]$ route

Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         _gateway        0.0.0.0         UG    0      0        0 ens192
10.129.0.0      0.0.0.0         255.255.0.0     U     0      0        0 ens192
```

**DNS**

Things to check:

- /etc/resolv.conf

- **arp -a**
```
arp -a
```

### Enumerating User Info

**/etc/passwd**

Format:

1. Username
2. Password
3. User ID (UID)
4. Group ID (GID)
5. User ID info
6. Home directory
7. Shell

**Environment Enumeration**
```
datboyblu3@htb[/htb]$ cat /etc/passwd | cut -f1 -d:

root
daemon
bin
sys

...SNIP...

mrb3n
lxd
bjones
administrator.ilfreight
backupsvc
cliff.moore
logger
shared
stacey.jenkins
htb-student
```

**Linux Hashing Algorithms**
```
    Algorithm 	Hash
	Salted MD5  $1$...
	SHA-256 	$5$...
	SHA-512 	$6$...
	BCrypt 	    $2a$...
	Scrypt 	    $7$...
	Argon2 	    $argon2i$...
```

**Verifying Login Shells**
```
grep "*sh$" /etc/passwd
```

**Existing Groups**
```
cat /etc/group
```

**List All Groups**
```
getent group sudo
```

**Mounted File Systems**
```
df -h
```

**Unmounted File Systems**
```
cat /etc/fstab | grep -v "#" | column -t
```

**Reveal All Hidden Files**
```
find / -type f -name ".*" -exec ls -l {} \; 2>/dev/null | grep htb-student
```

**Reveal All Hidden Directories**
```
find / -type d -name ".*" -ls 2>/dev/null
```

**Temporary Directories**

/tmp has a default retention time of 10 days. And all temp files stored here are deleted after restart.

/var/tmp has is 30 days. Files stored here are not deleted after reboot

```
ls -l /tmp /var/tmp /dev/shm
```


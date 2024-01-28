
Questions to ask when enumerating a system:

- What services and applications are installed?
- What services are running?
- What sockets are in use?
- What users, admins, and groups exist on the system?
- Who is current logged in? What users recently logged in?
- What password policies, if any, are enforced on the host?
- Is the host joined to an Active Directory domain?
- What types of interesting information can we find in history, log, and backup files
- Which files have been modified recently and how often? Are there any interesting patterns in file modification that could indicate a cron job in use that we may be able to hijack?
- Current IP addressing information
- Anything interesting in the `/etc/hosts` file?
- Are there any interesting network connections to other systems in the internal network or even outside the network?
- What tools are installed on the system that we may be able to take advantage of? (Netcat, Perl, Python, Ruby, Nmap, tcpdump, gcc, etc.)
- Can we access the `bash_history` file for any users and can we uncover any thing interesting from their recorded command line history such as passwords?
- Are any Cron jobs running on the system that we may be able to hijack?



### Internals

**Network Interfaces**
```
ip a
```

**Hosts**
```
cat /etc/hosts
```

**User's Last Login**
```
lastlog
```

**Currently Logged in Users**
```
w
```


**Special History Files**

Find history files created by scripts and/or programs
```shell-session
find / -type f \( -name *_hist -o -name *_history \) -exec ls -l {} \; 2>/dev/null
```

**Cron Jobs**

Daily Cron Jobs
```shell-session
find / -type f \( -name *_hist -o -name *_history \) -exec ls -l {} \; 2>/dev/null
```


**Proc**
```shell-session
find /proc -name cmdline -exec cat {} \; 2>/dev/null | tr " " "\n"
```


### Services

**Using a list of installed packages,  find vulnerabilities**
```shell-session
apt list --installed | tr "/" " " | cut -d" " -f1,3 | sed 's/[0-9]://g' | tee -a installed_pkgs.list
```

**List Binaries**
```shell-session
ls -l /bin /usr/bin/ /usr/sbin/
```


**Compare the existing binaries with the ones from GTFObins**
```shell-session
for i in $(curl -s https://gtfobins.github.io/ | html2text | cut -d" " -f1 | sed '/^[[:space:]]*$/d');do if grep -q "$i" installed_pkgs.list;then echo "Check GTFO for: $i";fi;done
```

**Find Configuration Files**
```shell-session
find / -type f \( -name *.conf -o -name *.config \) -exec ls -l {} \; 2>/dev/null
```

**Find Scripts**
```shell-session
find / -type f -name "*.sh" 2>/dev/null | grep -v "src\|snap\|share"
```

**Determine which processes are being run by Root**
```shell-session
ps aux | grep root
```




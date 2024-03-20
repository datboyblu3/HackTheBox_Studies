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


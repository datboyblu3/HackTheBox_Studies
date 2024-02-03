IP
```
10.129.205.109
```

USER
```
htb-user
```

PASSWORD
```
HTB_@cademy_us3r!
```
### RBASH - Restricted Bourne Shell
Limits the following:
- changing directories
- setting or modifying env variables
- executing commands in other directories

Verify if in rbash shell with the following commands

```
export -p # It spits out all the variables set  
env # It gives the $SHELL and $PATH variable  
echo $0 # It gives the $SHELL name  
echo $PATH # It gives the path variable
```


[**Escaping Restricted Shells Methods** ](https://systemweakness.com/how-to-breakout-of-rbash-restricted-bash-4e07f0fd95e)

### Echo Path
```
htb-user@ubuntu:~$ echo $PATH

/home/htb-user/bin
```

```
ssh htb-user@10.129.205.109:/bin/bash /home/htb-user/bin/bash
```

## What Worked

**Display all the content in the current directory**
```
htb-user@ubuntu:~$ echo *
bin flag.txt
htb-user@ubuntu:~$ 
htb-user@ubuntu:~$ 
htb-user@ubuntu:~$ echo "$(<flag.txt)"
HTB{35c4p3_7h3_r3stricted_5h311}
```


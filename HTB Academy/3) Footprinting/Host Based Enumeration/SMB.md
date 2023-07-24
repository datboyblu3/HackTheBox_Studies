l**List Available Shares on System**
```
smbclient -N -L //10.129.14.128
```

**Connect to a Share**
```
smbclient //10.129.14.128/notes
```

**rpcclient can be used to enumerate an SMB/SAMBA share**

```
rpcclient -U "" 10.129.14.128
```


**rpcclient queries**

| Syntax      | Description |
| ----------- | ----------- |
| srvinfo     | Server information       |
| enumdomains   | Enumerate all domains that are deployed in the network        |
| querydominfo      | Provides domain, server, and user information of deployed domains. |
| netshareenumall | Enumerates all available shares. |
| enumdomusers      | Enumerates all domain users.      |
| netsharegetinfo (share)  | Provides information about a specific share        |
| queryuser RID     | Provides information about a specific user. |

**Brute Forcing User RIDs**
```
for i in $(seq 500 1100);do rpcclient -N -U "" 10.129.14.128 -c "queryuser 0x$(printf '%x\n' $i)" | grep "User Name\|user_rid\|group_rid" && echo "";done
```


Other tools we can use to achieve the above, as well as further enumeration of SMB shares are:

**Impacket - Samrdump.py**
```
samrdump.py 10.129.14.128
```

**SMBmap**
```
smbmap -H 10.129.14.128
```

**CrackMapExec**
```
crackmapexec smb 10.129.14.128 --shares -u '' -p ''
```

**Enum4Linux**
```
./enum4linux-ng.py 10.129.14.128 -A
```








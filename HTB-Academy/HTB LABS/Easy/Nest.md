### IP
```
10.10.10.178
```

### NMAP
```
nmap -sV -Pn -sC -p- 10.10.10.178
```

### Smbclient
```
smbclient -N -L //10.10.10.178
```
```
smbclient -N -L //10.10.10.178

        Sharename       Type      Comment
        ---------       ----      -------
        ADMIN$          Disk      Remote Admin
        C$              Disk      Default share
        Data            Disk      
        IPC$            IPC       Remote IPC
        Secure$         Disk      
        Users           Disk      

```


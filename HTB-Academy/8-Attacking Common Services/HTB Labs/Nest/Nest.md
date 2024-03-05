### HTB Rating: Easy
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

Attempting to connect to the Users share and download all files we get a denied access message

```
$ smbclient //10.10.10.178/Users 
Password for [WORKGROUP\dan]:
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Sat Jan 25 18:04:21 2020
  ..                                  D        0  Sat Jan 25 18:04:21 2020
  Administrator                       D        0  Fri Aug  9 11:08:23 2019
  C.Smith                             D        0  Sun Jan 26 02:21:44 2020
  L.Frost                             D        0  Thu Aug  8 13:03:01 2019
  R.Thompson                          D        0  Thu Aug  8 13:02:50 2019
  TempUser                            D        0  Wed Aug  7 18:55:56 2019

                5242623 blocks of size 4096. 1839803 blocks available
smb: \> cd TempUser\
smb: \TempUser\> ls
NT_STATUS_ACCESS_DENIED listing \TempUser\*
smb: \TempUser\> get *
NT_STATUS_OBJECT_NAME_INVALID opening remote file \TempUser\*

```

Turns out it's blocking null sessions. So we have to specify a username and password:

### Specify random credentials

```
smbmap -H 10.10.10.178 -u 'dan' -p 'dan'            

    ________  ___      ___  _______   ___      ___       __         _______
   /"       )|"  \    /"  ||   _  "\ |"  \    /"  |     /""\       |   __ "\
  (:   \___/  \   \  //   |(. |_)  :) \   \  //   |    /    \      (. |__) :)
   \___  \    /\  \/.    ||:     \/   /\   \/.    |   /' /\  \     |:  ____/
    __/  \   |: \.        |(|  _  \  |: \.        |  //  __'  \    (|  /
   /" \   :) |.  \    /:  ||: |_)  :)|.  \    /:  | /   /  \   \  /|__/ \
  (_______/  |___|\__/|___|(_______/ |___|\__/|___|(___/    \___)(_______)
 -----------------------------------------------------------------------------
     SMBMap - Samba Share Enumerator | Shawn Evans - ShawnDEvans@gmail.com
                     https://github.com/ShawnDEvans/smbmap

[*] Detected 1 hosts serving SMB
[*] Established 1 SMB session(s)                                
                                                                                                    
[+] IP: 10.10.10.178:445        Name: 10.10.10.178              Status: Authenticated
        Disk                                                    Permissions     Comment
        ----                                                    -----------     -------
        ADMIN$                                                  NO ACCESS       Remote Admin
        C$                                                      NO ACCESS       Default share
        Data                                                    READ ONLY
        IPC$                                                    NO ACCESS       Remote IPC
        Secure$                                                 NO ACCESS
        Users                                                   READ ONLY
```

### Browse User share directories
```
smbmap -H 10.10.10.178 -u 'dan' -p 'dan' -r Users 
```


```       
    ________  ___      ___  _______   ___      ___       __         _______
   /"       )|"  \    /"  ||   _  "\ |"  \    /"  |     /""\       |   __ "\
  (:   \___/  \   \  //   |(. |_)  :) \   \  //   |    /    \      (. |__) :)
   \___  \    /\  \/.    ||:     \/   /\   \/.    |   /' /\  \     |:  ____/
    __/  \   |: \.        |(|  _  \  |: \.        |  //  __'  \    (|  /
   /" \   :) |.  \    /:  ||: |_)  :)|.  \    /:  | /   /  \   \  /|__/ \
  (_______/  |___|\__/|___|(_______/ |___|\__/|___|(___/    \___)(_______)
 -----------------------------------------------------------------------------
     SMBMap - Samba Share Enumerator | Shawn Evans - ShawnDEvans@gmail.com
                     https://github.com/ShawnDEvans/smbmap

[*] Detected 1 hosts serving SMB
[*] Established 1 SMB session(s)                                
                                                                                                    
[+] IP: 10.10.10.178:445        Name: 10.10.10.178              Status: Authenticated
        Disk                                                    Permissions     Comment
        ----                                                    -----------     -------
        ADMIN$                                                  NO ACCESS       Remote Admin
        C$                                                      NO ACCESS       Default share
        Data                                                    READ ONLY
        IPC$                                                    NO ACCESS       Remote IPC
        Secure$                                                 NO ACCESS
        Users                                                   READ ONLY
        ./Users
        dr--r--r--                0 Sat Jan 25 18:04:21 2020    .
        dr--r--r--                0 Sat Jan 25 18:04:21 2020    ..
        dr--r--r--                0 Wed Jul 21 14:47:04 2021    Administrator
        dr--r--r--                0 Wed Jul 21 14:47:04 2021    C.Smith
        dr--r--r--                0 Thu Aug  8 13:03:29 2019    L.Frost
        dr--r--r--                0 Thu Aug  8 13:02:56 2019    R.Thompson
        dr--r--r--                0 Wed Jul 21 14:47:15 2021    TempUser

```

We don't have access to the shares, but we can mount the shares to access the files

### Mount the Data share
```
sudo mount -t cifs //10.10.10.178/Data /mnt/data
```

Taking a look at email.txt 
![[Pasted image 20240305181401.png]]

### Credentials

**Username**
```
TempUser
```
```
welcome2019
```

Alerts.txt file message
```
There is currently no scheduled maintenance work
```

### Mount the Users share

```
sudo mount -t cifs //10.10.10.178/Users /mnt/users
```

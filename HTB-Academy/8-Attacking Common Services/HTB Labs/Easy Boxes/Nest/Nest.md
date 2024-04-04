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

Turns out it's blocking null sessions. So we have to specify ANY username and password:

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

Alerts.txt file message
```
There is currently no scheduled maintenance work
```

### Mount a Windows Share on Linux

Mount the Users shares with TempUser access

```
sudo mkdir /mnt/tempuser
```
```
sudo mount -t cifs -o 'username=TempUser,password=welcome2019' //10.10.10.178/Users /mnt/tempuser
```


Mounting with the credentials found, we can now access the directories in the Users share
![[Pasted image 20240305210134.png]]

But `cat` doesn't return anything from the New Text Document

Found more stuff in the /Data/IT/Configs directory

```
┌──(dan㉿ZeroSigma)-[/mnt/data/IT]
└─$ tre 
.
├── Archive
├── Configs
│   ├── Adobe
│   │   ├── editing.xml
│   │   ├── Options.txt
│   │   ├── projects.xml
│   │   └── settings.xml
│   ├── Atlas
│   │   └── Temp.XML
│   ├── DLink
│   ├── Microsoft
│   │   └── Options.xml
│   ├── NotepadPlusPlus
│   │   ├── config.xml
│   │   └── shortcuts.xml
│   ├── RU Scanner
│   │   └── RU_config.xml
│   └── Server Manager
├── Installs
├── Reports
└── Tools
                                                                                                                                          
┌──(dan㉿ZeroSigma)-[/mnt/data/IT]
└─$ 

```

In the Configs/NotepadPlusPlus/config.xml it tells us of a Temp.txt file in Secure$\\IT\Carl\Temp.txt

There's also a todo.txt file located on C.Smith's Desktop
![[Pasted image 20240305213810.png]]

Navigated to it but still don't have access. But the RU_config.xml contains a username and a base64 encoded field values.
```
└─$ cat RU_config.xml 
<?xml version="1.0"?>
<ConfigFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <Port>389</Port>
  <Username>c.smith</Username>
  <Password>fTEzAfYDoz1YzkqhQkH6GQFYKp1XY5hm7bjOP86yYxE=</Password>
</ConfigFile>                                                                                                                                                          
┌──(dan㉿ZeroSigma)-[/mnt/data/IT/Configs/RU Scanner]
└─$ 

```

Outputting it gives us garbage text so I need to put this in a windows editor.

Went back to `Secure$\IT\Carl` and tried to explore however I'm not able to see anything in the directory

![[Pasted image 20240306081000.png]]

Let's recursively view the sub-folders in the IT directory with smbmap:

![[Pasted image 20240306081329.png]]

The following folders are present: Docs, Reports and VB Projects. What can we see in VB Projects?

![[Pasted image 20240306081640.png]]

Let's mount to this directory and read the files:
```
sudo mount -t cifs -o 'username=TempUser,password=welcome2019' '//10.10.10.178/Secure$/IT/Carl/VB Projects/WIP/RU/RUScanner/' /mnt/ruscanner 
```

```
┌──(dan㉿ZeroSigma)-[/mnt/ruscanner]
└─$ ls -la
total 33
drwxr-xr-x 2 root root 4096 Aug  7  2019  .
drwxr-xr-x 8 root root 4096 Mar  6 08:26  ..
-rwxr-xr-x 1 root root  772 Aug  7  2019  ConfigFile.vb
-rwxr-xr-x 1 root root  279 Aug  7  2019  Module1.vb
drwxr-xr-x 2 root root    0 Aug  7  2019 'My Project'
-rwxr-xr-x 1 root root 4828 Aug  9  2019 'RU Scanner.vbproj'
-rwxr-xr-x 1 root root  143 Aug  6  2019 'RU Scanner.vbproj.user'
-rwxr-xr-x 1 root root  133 Aug  7  2019  SsoIntegration.vb
-rwxr-xr-x 1 root root 4888 Aug  7  2019  Utils.vb
drwxr-xr-x 2 root root    0 Aug  7  2019  bin
drwxr-xr-x 2 root root    0 Aug  7  2019  obj

```

In the Utils.vb file we have two functions: DecryptString and EncryptString. 
![[Pasted image 20240306181045.png]]

### Copy all Files to Nest Folder
```
┌──(dan㉿ZeroSigma)-[/mnt/…/VB Projects/WIP/RU/RUScanner]
└─$ sudo cp * "/home/dan/HackTheBox_Studies/HTB-Academy/8-Attacking Common Services/HTB Labs/Nest/"
cp: -r not specified; omitting directory 'My Project'
cp: -r not specified; omitting directory 'bin'
cp: -r not specified; omitting directory 'obj'

┌──(dan㉿ZeroSigma)-[/mnt/…/VB Projects/WIP/RU/RUScanner]
└─$ sudo cp -r * "/home/dan/HackTheBox_Studies/HTB-Academy/8-Attacking Common Services/HTB Labs/Nest/"

```

### Compile the Code

We have some key pieces of information:
1. The base64 encoded string found in the RU_config.xml file
2. The DecryptString function found in Utils.vb

What we're going to do is add a main() function to Utils.vb to run the DecryptString function 
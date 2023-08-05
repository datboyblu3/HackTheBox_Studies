- Microsoft's SQL-based relational database management system
- Is closed source and was initially written to run on Windows operating systems

### MSSQL Clients

- SQL Server Management Studio (SSMS) comes as a feature that can be installed with the MSSQL install package or can be downloaded & installed separately
- commonly installed on the server for initial configuration and long-term management of databases by admins
- since SSMS is a client-side application, it can be installed and used on any system

Other clients that can access a MSSQL database
- mssql-cli	
- SQL Server PowerShell	
- HediSQL	
- SQLPro	
- Impacket's mssqlclient.py

**Find if/where a client is located on your host**
```
locate mssqlclient
```

#### MSSQL Default Databases

| Syntax      | Description |
| ----------- | ----------- |
| master      | Tracks all system information for an SQL server instance       |
| model       | Template database that acts as a structure for every new database created. Any setting changed in the model database will be reflected in any new database created after changes to the model database        |
| msdb        | The SQL Server Agent uses this database to schedule jobs & alerts |
| tempdb      | Stores temporary objects |
| resource    | Read-only database containing system objects included with SQL server       |


### Default Configuration

- Initial install will show the SQL service running as NT SERVICE/MSSQLSERVER 
- Authentication being set to Windows Authentication means that the underlying Windows OS will process the login request and use either the local SAM database or the domain controller (hosting Active Directory) before allowing connectivity to the database management system

### Dangerous Settings

- MSSQL clients not using encryption to connect to the MSSQL server

- The use of self-signed certificates when encryption is being used. It is possible to spoof self-signed certificates

- The use of named pipes

- Weak & default sa credentials. Admins may forget to disable this account


### Footprinting the Service

**NMAP MSSQL Script Scan**
```
sudo nmap --script ms-sql-info,ms-sql-empty-password,ms-sql-xp-cmdshell,ms-sql-config,ms-sql-ntlm-info,ms-sql-tables,ms-sql-hasdbaccess,ms-sql-dac,ms-sql-dump-hashes --script-args mssql.instance-port=1433,mssql.username=sa,mssql.password=,mssql.instance-name=MSSQLSERVER -sV -p 1433 10.129.201.248
```


### MSSQL Ping in Metasploit

Use Metasploit to run an auxiliary scanner called mssql_ping that will scan the MSSQL service and provide helpful information in our footprinting process

```
msf6 auxiliary(scanner/mssql/mssql_ping) > set rhosts 10.129.201.248

rhosts => 10.129.201.248

msf6 auxiliary(scanner/mssql/mssql_ping) > run
```

### Connecting with Mssqlclient.py

```
python3 mssqlclient.py Administrator@10.129.201.248 -windows-auth
```


### Questions

**1) Enumerate the target using the concepts taught in this section. List the hostname of MSSQL server.**

```
ILF-SQL-01
```
![[mysql_server_hostname.png]]

**2) Connect to the MSSQL instance running on the target using the account (backdoor:Password1), then list the non-default database present on the server.**

```
Employees
```

```
python3 /usr/share/doc/python3-impacket/examples/mssqlclient.py backdoor@10.129.201.248 -windows-auth 
```

![[non_default_db.png]]

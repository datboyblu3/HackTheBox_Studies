
### Footprinting the Service

**Scanning MySQL Server**
```
sudo nmap 10.129.109.120 -sV -sC -p3306 --script mysql*
```

**Interacting with MySQL Server**
```
mysql -u root -pP4SSw0rd -h 10.129.109.120
```

**1) Enumerate the MySQL server and determine the version in use. (Format: MySQL X.X.XX)**

```
MySQL 8.0.27-0ubuntu0.20.04.1
```

```
sudo nmap 10.129.109.120 -sV -sC -p3306 --script mysql*
```

![[mysql_version.png]]

**2)  During our penetration test, we found weak credentials "robin:robin". We should try these against the MySQL server. What is the email address of the customer "Otto Lang"?**

```
mysql -u robin -probin -h 10.129.109.120
```

![[customer_table.png]]


**Use a SQL query to get the email from the user**
```
SELECT email FROM myTable WHERE name="Otto Lang";
```

**Users email is: ultrices@google.htb

![[mysql_user_email.png]]


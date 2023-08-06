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

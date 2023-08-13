
- created to monitor network devices. In addition
- can also be used to handle configuration tasks and change settings remotely. 
- SNMP-enabled hardware includes routers, switches, servers, IoT devices, and many other devices that can also be queried and controlled using this standard protocol
- UDP port 161, traps on UDP port 162

### MIB - Management Information Base

- Format for storing device info
- Is a text file in which all queryable SNMP objects of a device are listed in a standardized tree hierarchy
- Contains at least one Object Identifier (OID) that provides information about the type, access rights, and a description of the respective object
- does not contain data, but they explain where to find which information and what it looks like, which returns values for the specific OID, or which data type is used

### OID - Object Identifier

- represents a node in a hierarchical namespace
- sequence of numbers uniquely identifies each node
- Many nodes in the OID tree contain nothing except references to those below them 
- The OIDs consist of integers and are usually concatenated by dot notation

### SNMPv1

- Used for network management and monitoring
- supports the retrieval of information from network devices, allows for the configuration of devices, and provides traps, which are notifications of events.
- no built in authentication
- does not support encryption


### SNMPv2

- v2c, community based SNMP
- No encryption

### SNMPv3

- Encrypts credentials with a pre-shared key


### SNMP Daemon Config

```
cat /etc/snmp/snmpd.conf | grep -v "#" | sed -r '/^\s*$/d'
```

### Dangerous SNMP Settings

| Settings      | Description |
| ----------- | ----------- |
| rwuser noauth      | Provides access to the full OID tree without authentication.       |
| rwcommunity community string IPv4 address   | Provides access to the full OID tree regardless of where the requests were sent from.        |
| rwcommunity6 community string IPv6 address      | Same access as with rwcommunity with the difference of using IPv6 |


### Footprinting SNMP

Use tools like:
 - snmpwalk - used to query the OIDs with their information
 - onesixtyone - used to brute-force the names of the community strings
 - braa

**snmpwalk**
```
snmpwalk -v2c -c public 10.129.113.191
```


If community strings are unknown use the onesixtyone and SecLists wordlists to identify them


**onesixtyone**
```
onesixtyone -c /opt/useful/SecLists/Discovery/SNMP/snmp.txt 10.129.113.191
```

- When certain community strings are bound to specific IP addresses, they are named with the hostname of the host
- if we imagine an extensive network with over 100 different servers managed using SNMP, the labels, in that case, will have some pattern to them. Therefore, we can use different rules to guess them. We can use the tool crunch to create custom wordlists
- Once we know a community string, we can use it with braa to brute-force the individual OIDs and enumerate the information behind them.

**braa**
```
braa public@10.129.113.191:.1.3.6.*
```

### Questions

**1) Enumerate the SNMP service and obtain the email address of the admin:** 

 Answer: devadmin@inlanefreight.htb

```
snmpwalk -v2c -c public 10.129.113.191
```

 **2) What is the customized version of the SNMP server?:**  
 
 Answer: InFreight SNMP v0.91
```
 snmpwalk -v2c -c public 10.129.113.191
```

**3) Enumerate the custom script that is running on the system and submit its output as the answer:**  Answer: 

HTB{5nMp_fl4g_uidhfljnsldiuhbfsdij44738b2u763g}

```
 snmpwalk -v2c -c public 10.129.113.191
```


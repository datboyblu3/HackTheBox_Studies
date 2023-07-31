
### Types of DNS Servers

**DNS Root Server**
The root servers of the DNS are responsible for the top-level domains (TLD). As the last instance, they are only requested if the name server does not respond. Thus, a root server is a central interface between users and content on the Internet, as it links domain and IP address. The Internet Corporation for Assigned Names and Numbers (ICANN) coordinates the work of the root name servers. There are 13 such root servers around the globe.

**Authoritative Nameserver**
Authoritative name servers hold authority for a particular zone. They only answer queries from their area of responsibility, and their information is binding. If an authoritative name server cannot answer a client's query, the root name server takes over at that point.

**Non-authoritative Nameserver**
Non-authoritative name servers are not responsible for a particular DNS zone. Instead, they collect information on specific DNS zones themselves, which is done using recursive or iterative DNS querying.

**Caching DNS Server**
Caching DNS servers cache information from other name servers for a specified period. The authoritative name server determines the duration of this storage.

**Forwarding Server**
Forwarding servers perform only one function: they forward DNS queries to another DNS server.

**Resolver**
Resolvers are not authoritative DNS servers but perform name resolution locally in the computer or router.



### Points About DNS
- Mainly unencrypted
- Can be encrypted via TLS, DNS over TLS - DoT
- Or over HTTPS - DoH
- NSCrypt encrypts the traffic between the computer and the name server
- DNS stores other info about services other than hostnames and IP addresses

### DNS Records

- A	        - Returns an IPv4 address of the requested domain as a result.
- AAAA	- Returns an IPv6 address of the requested domain.
- MX	    - Returns the responsible mail servers as a result.
- NS	    - Returns the DNS servers (nameservers) of the domain
- TXT	    - This record can contain various information. The all-rounder can be used, e.g., to validate the Google Search Console or validate SSL certificates. In addition, SPF and DMARC entries are set to validate mail traffic and protect it from spam.

- CNAME	  - This record serves as an alias. If the domain www.hackthebox.eu should point to the same IP, and we create an A record for one and a CNAME record for the other
- PTR	- The PTR record works the other way around (reverse lookup). It converts IP addresses into valid domain names
- SOA	- Provides information about the corresponding DNS zone and email address of the administrative contact. It is located in a domain's zone file and specifies who is responsible for the operation of the domain and how DNS information for the domain is managed.

**dig**
```
dig soa www.inlanefreight.com
```

### Default Configuration

- Though they're many types of DNS configs, all DNS servers three distinct types:
	- Local DNS
	- Zone Files
	- Reverse Name Resolution Files
- The following discussion is based on the Bind9 DNS Server

#### Local DNS Configuration

- Located at : /etc/bind/named.conf.local
- We can define different zones in this file
- Zone File
	- text file that describes a DNS zone with the BIND file format
	- A zone file describes a zone completely. 
	- There must be precisely one SOA record and at least one NS record.
	- main goal of these global rules is to improve the readability of zone files
	- all forward records are entered according to the BIND format. 
	- This allows the DNS server to identify which domain, hostname, and role the IP addresses belong to
	- For the IP address to be resolved from the FQDN, the DNS server must have a reverse lookup file. 
	- In this file, the computer name FQDN is assigned to the last octet of an IP address, which corresponds to the respective host, using a PTR record. 
	- The PTR records are responsible for the reverse translation of IP addresses into names
	- Location of Reverse Name Resolution File: /etc/bind/db.IP-ADDRESS

### Dangerous Settings

- **allow-query** - Defines which hosts are allowed to send requests to the DNS server.
- **allow-recursion**	- Defines which hosts are allowed to send recursive requests to the DNS server.
- **allow-transfer** -	Defines which hosts are allowed to receive zone transfers from the DNS server.
- **zone-statistics** - Collects statistical data of zones


### Footprinting DNS

- DNS server can be queried as to which other name servers are known
- You do this using the NS record and the specification of the DNS server we want to query using the @ character.

**DIG - NS (Name Server) Query**
```
dig ns inlanefreight.htb @10.129.42.195
```

**DIG Version Query** - CHAOS TXT must be present on the DNS server for this to work
```
dig CH TXT version.bind 10.129.42.195
```

**DIG Any Query** - This displays all *AVAILABLE* records
```
dig any inlanefreight.htb @10.129.42.195
```

**Zone Transfers**
- Refers to the transfer of zones to another DNS server
- Known as Asynchronous Full Transfer Zone (AXFR)
- zone file is almost invariably kept identical on several name servers
- Synchronization between the servers involved is realized by zone transfer. 
- Using a secret key rndc-key, which we have seen initially in the default configuration, the servers make sure that they communicate with their own master or slave

**Primary  NS (Nameserver)**
- stores original data of a zone
- **Secondary NS's** increase reliability, utilized for load distribution, defend the primary from attacks
- DNS entries are generally created, modified, deleted on the primary
- Known as the master because it serves as a direct source for synchronizing a zone file
- While the secondary is known as the slave because it obtains zone data from a master
- However, a secondary can be both master and slave

The slave fetches the SOA record of the relevant zone from the master at certain intervals, the so-called refresh time, usually one hour, and compares the serial numbers. If the serial number of the SOA record of the master is greater than that of the slave, the data sets no longer match.

**DIG - AXFR Zone Transfer**
```
dig axfr inlanefreight.htb @10.129.42.195
```

**DIG - AXFR Zone Transfer - Internal**
```
dig axfr internal.inlanefreight.htb @10.129.42.195
```

**Subdomain Brute Forcing** - Using SecLists
```
for sub in $(cat SecLists/Discovery/DNS/subdomains-top1million-110000.txt);do dig $sub.inlanefreight.htb 10.129.113.191 | grep -v ';\|SOA' | sed -r '/^\s*$/d' | grep $sub | tee -a subdomains.txt;done
```

**Subdomain Brute Forcing** - Using DNSenum
```
dnsenum --dnsserver 10.129.42.195 --enum -p 0 -s 0 -o subdomains.txt -f /opt/useful/SecLists/Discovery/DNS/subdomains-top1million-110000.txt inlanefreight.htb
```


### Questions: 10.129.113.191

 Interact with the target DNS using its IP address and enumerate the FQDN of it for the "inlanefreight.htb" domain.
 **ANSWER:** ns.inlanefreight.htb
```
dig any inlanefreight.htb @10.129.113.191
```
![[fqdn.png]]

Identify if its possible to perform a zone transfer and submit the TXT record as the answer.
```
dig NS axfr internal.inlanefreight.htb
```

![[zone_transfer.png]]

What is the IPv4 address of the hostname DC1?
```
dig NS axfr internal.inlanefreight.htb
```
![[DC1_IP_ADDRESS.png]]

What is the FQDN of the host where the last octet ends with "x.x.x.203"? win2k.dev.inlanefreight.htb

First perform a zone transfer on inlanefreight.htb
```
dig axfr inlanefreight.htb @10.129.118.217
```

I did a zone transfer on all of the subdomains but only internal.inlanefreight.htb was successful
![[internal_zone_transfer.png]]

Initiate a zone transfer on the internal subdomain
```
dig axfr internal.inlanefreight.htb @10.129.118.217
```

![[internal_zone_transfer_2.png]]

Now I have to brute force the subdomain internal.inlanefreight.htb. Attempting with gobuster
```
sudo gobuster dns -d internal.inlanefreight.htb -r 10.129.42.195 -i -w SecLists/Discovery/DNS/fierce-hostlist.txt | tee subdomains.txt
```

In this learning module, two ways of brute forcing were described via a forloop and dnsenum. Here they are below. You should

Forloop
```
for sub in $(cat SecLists/Discovery/DNS/fierce-hostlist.txt);do dig $sub.inlanefreight.htb 10.129.113.191 | grep -v ';\|SOA' | sed -r '/^\s*$/d' | grep $sub | tee -a subdomains.txt;done
```

dnsenum
```
dnsenum --dnsserver 10.129.42.195 --enum -p 0 -s 0 -o subdomains.txt -f /opt/useful/SecLists/Discovery/DNS/fierce-hostlist.txt inlanefreight.htb
```



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

- CNAME	This record serves as an alias. If the domain www.hackthebox.eu should point to the same IP, and we create an A record for one and a CNAME record for the other.
- PTR	The PTR record works the other way around (reverse lookup). It converts IP addresses into valid domain names.
- SOA	Provides information about the corresponding DNS zone and email address of the administrative contact.

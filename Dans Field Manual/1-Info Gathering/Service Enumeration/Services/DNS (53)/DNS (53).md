### DNS Records

>[! A Records]
> Returns an IPv4 address of the requested domain as a result.

>[! AAAA Records]
> Returns an IPv6 address of the requested domain.

>[! MX ]
> Returns the responsible mail servers as a result.

> [! NS]
> Returns the DNS servers (nameservers) of the domain

> [! TXT]
> This record can contain various information. The all-rounder can be used, e.g., to validate the Google Search Console or validate SSL certificates. In addition, SPF and DMARC entries are set to validate mail traffic and protect it from spam.

>[! CNAME]
> This record serves as an alias. If the domain www.hackthebox.eu should point to the same IP, and we create an A record for one and a CNAME record for the other

>[!PTR]
> The PTR record works the other way around (reverse lookup). It converts IP addresses into valid domain names

>[!SOA]
> Provides information about the corresponding DNS zone and email address of the administrative contact. It is located in a domain's zone file and specifies who is responsible for the operation of the domain and how DNS information for the domain is managed.



# Common Commands

**NMAP DNS Enumeration**
```python
nmap -p53 -Pn -sV -sC 10.10.110.213
```
 
**dig**
```go
dig soa www.inlanefreight.com
```

**DIG - AXFR Zone Transfer**
```go
dig axfr inlanefreight.htb @10.129.42.195
```

**DIG - AXFR Zone Transfer - Internal**
```go
dig axfr internal.inlanefreight.htb @10.129.42.195
```

**Subdomain Brute Forcing** - Using SecLists
```go
for sub in $(cat SecLists/Discovery/DNS/subdomains-top1million-110000.txt);do dig $sub.inlanefreight.htb 10.129.113.191 | grep -v ';\|SOA' | sed -r '/^\s*$/d' | grep $sub | tee -a subdomains.txt;done
```

**Subdomain Brute Forcing** - Using DNSenum
```go
dnsenum --dnsserver 10.129.42.195 --enum -p 0 -s 0 -o subdomains.txt -f /opt/useful/SecLists/Discovery/DNS/subdomains-top1million-110000.txt inlanefreight.htb
```

## Footprinting DNS

**DIG - NS (Name Server) Query**
```go
dig ns inlanefreight.htb @10.129.42.195
```

**DIG Version Query** - CHAOS TXT must be present on the DNS server for this to work
```go
dig CH TXT version.bind 10.129.42.195
```

**DIG Any Query** - This displays all *AVAILABLE* records
```go
dig any inlanefreight.htb @10.129.42.195
```


**Subdomain Enumeration**
```python
./subfinder -d inlanefreight.com -v 
```

**Subbrute Enumeration** - use for hosts not connected to the internet

Store nameservers and other DNS records in your resolvers.txt file
```python
echo "ns1.inlanefreight.com" > ./resolvers.txt
```

Execute subbrute
```python
./subbrute TARGET_DOMAIN.com -s ./names.txt -r ./resolvers.txt
```

When subbrute finds more DNS records, use dig to perform the zone transfer
```python
dig axfr hr.inlanefreight.htb @10.129.203.6
```
### Default Configuration

- all DNS servers three distinct types:
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

>[!danger]
> DANGEROUS SETTINGS


- **allow-query** - Defines which hosts are allowed to send requests to the DNS server.
- **allow-recursion**	- Defines which hosts are allowed to send recursive requests to the DNS server.
- **allow-transfer** -	Defines which hosts are allowed to receive zone transfers from the DNS server.
- **zone-statistics** - Collects statistical data of zones


# Questions: 10.129.113.191

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


### DNSENum

[DNSEnum kali](https://chousensha.github.io/blog/2017/05/29/dnsenum-kali-linux-tools/)
[Subdomin Enumeration 0xffsec Handbook](https://0xffsec.com/handbook/information-gathering/subdomain-enumeration/#zone-transfer)
[DNS Bruteforcing](https://erev0s.com/blog/gobuster-directory-dns-and-virtual-hosts-bruteforcing/)
**Querying A Records**
```
export TARGET="facebook.com"
nslookup $TARGET
```
![[Pasted image 20230818232026.png]]

![[Pasted image 20230818232154.png]]

**Querying: A Records for a Subdomain** 
![[Pasted image 20230818232255.png]]

**Querying: PTR Records for an IP Address**
![[Pasted image 20230818232433.png]]

**Querying: ANY Existing Records**
![[Pasted image 20230818232522.png]]

![[Pasted image 20230818232556.png]]

**Querying TXT Records**
![[Pasted image 20230818233121.png]]

**Querying MX Records**
![[Pasted image 20230818233207.png]]

We can combine some of the results gathered via nslookup with the whois database to determine if our target organization uses hosting providers.

![[Pasted image 20230818233432.png]]

### Passive Subdomain Enumeration

Subdomain enumeration refers to mapping all available subdomains within a domain name

**Virus Total**
To receive information about a domain, type the domain name into the search bar and click on the "Relations" tab.
![[Pasted image 20230819000408.png]]

**Certificates**
Learn how to examine Certificate Transparency logs to discover additional domain names and subdomains for a target organization using two primary resources.

- https://censys.io
- https://crt.sh
![[Pasted image 20230819000610.png]]

We can further organize this data and combine it with other resources via the following commands in the Certificate Transparency section:

**Certificate Transparency** 
```
export TARGET="facebook.com"

curl -s "https://crt.sh/?q=${TARGET}&output=json" | jq -r '.[] | "\(.name_value)\n\(.common_name)"' | sort -u > "${TARGET}_crt.sh.txt"

head -n20 facebook.com_crt.sh.txt
```

![[Pasted image 20230819001036.png]]

This operation can also be done via openssl

**openssl**
```
export TARGET="facebook.com"

export PORT="443"

openssl s_client -ign_eof 2>/dev/null <<<$'HEAD / HTTP/1.0\r\n\r' -connect "${TARGET}:${PORT}" | openssl x509 -noout -text -in - | grep 'DNS' | sed -e 's|DNS:|\n|g' -e 's|^\*.*||g' | tr -d ',' | sort -u
```

![[Pasted image 20230819001314.png]]

### Automating Passive Subdomain Enumeration

**TheHarvester**

Can be used to gather information to help identify a company's attack surface. The tool collects emails, names, subdomains, IP addresses, and URLs from various public data sources for passive information gathering

Create a file with the names of The Harvester modules, in a text file called sources.txt

![[Pasted image 20230819001630.png]]

Now execute the following gather information from these sources
```
export TARGET="facebook.com"

cat sources.txt | while read source; do theHarvester -d "${TARGET}" -b $source -f "${source}_${TARGET}";done
```

When the process is finished, extract and sort all found subdomains
```
cat *.json | jq -r '.hosts[]' 2>/dev/null | cut -d':' -f 1 | sort -u > "${TARGET}_theHarvester.txt"
```

Merge all passive recon files
```
cat facebook.com_*.txt | sort -u > facebook.com_subdomains_passive.txt

cat facebook.com_*.txt | sort -u > facebook.com_subdomains_passive.txt
```


### Questions
1) Which IP address maps to inlanefreight.com?
```
export TARGET="www.inlanefreight.com"
nslookup $TARGET
```
![[Pasted image 20230818230826.png]]

2) Which subdomain is returned when querying the PTR record for 173.0.87.51?
```
nslookup -query=PTR 173.0.87.51
```
![[Pasted image 20230818230959.png]]

3) What is the first mailserver returned when querying the MX records for paypal.com?
```
export TARGET="paypal.com"
nslookup -query=MX $TARGET
```
![[Pasted image 20230818231242.png]]


### Passive Infrastructure Identification

- The Wayback Machine - http://web.archive.org/
- https://www.netcraft.com/

You can also use waybackurls to inspect URLs saved by Wayback Machine and look for specific keywords

```
go install github.com/tomnomnom/waybackurls@latest

waybackurls -dates https://facebook.com > waybackurls.txt

cat waybackurls.txt
```

### Active Information Gathering




### Active Infrastructure Identification

**Web Servers**
Identify webserver version. Pay attention to the X-Powered-By field, this will tell us what is powering the web server
```
curl -I "http://${TARGET}"
```

Other web analyzing tools....

**WhatWeb**
Recognizes web technologies, including content management systems (CMS), blogging platforms, statistic/analytics packages, JavaScript libraries, web servers, and embedded devices
```
whatweb -a3 https://www.facebook.com -v
```

**Wappalyzer**
A browser extension that does the same thing as WhatWeb

**WafW00f**
A web application firewall (WAF) fingerprinting tool that sends requests and analyses responses to determine if a security solution is in place
```
sudo apt install wafw00f -y
```

```
wafw00f -v https://www.tesla.comc
```

**Aquatone**

A tool for automatic and visual inspection of websites across many hosts and is convenient for quickly gaining an overview of HTTP-based attack surfaces by scanning a list of configurable ports, visiting the website with a headless Chrome browser, and taking a screenshot
```
sudo apt install golang chromium-driver

go get github.com/michenriksen/aquatone

export PATH="$PATH":"$HOME/go/bin"
```

Using a subdomain list as input to an Aquatone query
```
cat facebook_aquatone.txt | aquatone -out ./aquatone -screenshot-timeout 1000
```


**Questions**
1) What Apache version is running on app.inlanefreight.local? 2.4.41
```
export TARGET1="app.inlanefreight.local"
curl -I "http://${TARGET1}"
```

2) Which CMS is used on app.inlanefreight.local?: Joomla
```
export TARGET2="dev.inlanefreight.local"
curl -I "http://${TARGET2}"
```

### Active Subdomain Enumeration

**ZoneTransfers**

- A zone transfer is how a secondary DNS server receives information from the primary DNS server and updates it
- Below is the automatic approach to performing a zone transfer

![[Pasted image 20230820035232.png]]

And now the manual way....

1) **Identifying Nameservers** 
```
nslookup -type=NS zonetransfer.me
```

![[Pasted image 20230820035949.png]]

2) **Testing for ANY and AXFR Zone Transfer**
```
nslookup -type=any -query=AXFR zonetransfer.me nsztm1.digi.ninja
```
![[Pasted image 20230820040134.png]]

**GoBuster**

During the Passive Subdomain Enumeration portion we found a pattern lert-api-shv-{NUMBER}-sin6.facebook.com. We can use this pattern to discover additional subdomains. The first step will be to create a patterns.txt file with the patterns previously discovered
```
lert-api-shv-{GOBUSTER}-sin6
atlas-pp-shv-{GOBUSTER}-sin6
```

**GoBuster DNS**

```
export TARGET="facebook.com"
```

```
export NS="d.ns.facebook.com"
```

```
export WORDLIST="numbers.txt"
```

```
gobuster dns -q -r "${NS}" -d "${TARGET}" -w "${WORDLIST}" -p ./patterns.txt -o "gobuster_${TARGET}.txt"
```

### Questions

1) Submit the FQDN of the nameserver for the "inlanefreight.htb" domain as the answer: ns.inlanefreight.htb
```
dig axfr inlanefreight.htb  @10.129.5.1
```
![[Pasted image 20230820192055.png]]

2)  Identify how many zones exist on the target nameserver. Submit the number of found zones as the answer
```

```
[crt.sh](https://crt.sh/) , source [Certificate Transparency](https://en.wikipedia.org/wiki/Certificate_Transparency), a process that allows verification of issued digital certificates for encrypted internet connections


### Find Subdomain Info via a Certificate website
	-[crt](https://crt.sh)

**Output the results**
```
curl -s https://crt.sh/\?q\=inlanefreight.com\&output\=json | jq .
```

**Further filter by unique subdomains**

```shell-session
curl -s https://crt.sh/\?q\=inlanefreight.com\&output\=json | jq . | grep name | cut -d":" -f2 | grep -v "CN=" | cut -d'"' -f2 | awk '{gsub(/\\n/,"\n");}1;' | sort -u
```

Throw the subdomains into a list called *subdomainlist* 

**Identify hosts directly accessible from the internet and not hosted by third-party providers.**

```shell-session
for i in $(cat subdomainlist);do host $i | grep "has address" | grep inlanefreight.com | cut -d" " -f1,4;done
```

We can then generate a list of IPs and run them through Shodan to discover open TCP/IP ports

**Shodan - IP List**
```
for i in $(cat subdomainlist);do host $i | grep "has address" | grep inlanefreight.com | cut -d" " -f4 >> ip-addresses.txt;done
```

```
for i in $(cat ip-addresses.txt);do shodan host $i;done
```

Make note of IP 10.129.27.22 (matomo.inlanefreight.com)

**Display all available DNS records**
```
dig any inlanefreight.com
```



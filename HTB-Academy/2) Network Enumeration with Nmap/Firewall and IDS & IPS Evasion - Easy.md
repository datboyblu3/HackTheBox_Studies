
1) Identify the operating system on the machine. And submit the OS name
```
sudo nmap -F --max-retries=0 -T2 -sV 10.129.87.158 -D RND:5 --stats-every=5s
```

2) Find target's DNS server version.
```
sudo nmap -sSU -p 53 --script dns-nsid 10.129.65.37
```
	-dns-nsid : retries information from a DNS nameserver by requesting its nameserver ID and asking for its id.server and verion.bind values
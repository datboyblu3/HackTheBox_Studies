
#### NMAP Scan

**Scanning with version discovery, aggressive scan, no ping and default NSE scans**
```
sudo nmap 10.10.11.221 -sV -A -Pn -sC
```

![[Pasted image 20230901015823.png]]

- Services available SSH port 22, HTTP port 80
- There's 
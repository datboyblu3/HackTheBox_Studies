
Two types of virtual hosting:
- IP Based
- Named Based

**IP Based**
- can have multiple interfaces and IPs
- Server(s) can be bound to multiple IPs
- servers can be addressed under different IP addresses on a host

**Named Based**
- several domain names, such as admin.inlanefreight.htb and backup.inlanefreight.htb, can refer to the same IP. 
- Internally on the server, these are separated and distinguished using different folders. 
- Using this example, on a Linux server, the vHost admin.inlanefreight.htb could point to the folder /var/www/admin. 
- For backup.inlanefreight.htb the folder name would then be adapted and could look something like /var/www/backup


We can go about identifying virtual hosts with the combination of using cURL and the /usr/share/dnsrecon/namelist.txt file

We'll examine the Content-Length header to identify any differences

**vHost Fuzzing**
```
cat ./vhosts | while read vhost;do echo "\n********\nFUZZING: ${vhost}\n********";curl -s -I http://192.168.10.10 -H "HOST: ${vhost}.randomtarget.com" | grep "Content-Length: ";done
```

**dev-admin** is the vHost, now we'll use this in a cURL request

```
curl -s http://192.168.10.10 -H "Host: dev-admin.randomtarget.com"
```


### Automating Virtual Hosts Discovery

Use ffuf speed up the process and filter based on parameters in the response.

The web server responds with a default and static website every time we issue an invalid virtual host in the HOST header. We can use the filter by size -fs option to discard the default response as it will always have the same size.

```
ffuf -w ./vhosts -u http://192.168.10.10 -H "HOST: FUZZ.randomtarget.com" -fs 612
```

![[Pasted image 20230820235942.png]]

### Questions
1)  Enumerate the target and find a vHost that contains flag No. 1: HTB{h8973hrpiusnzjoie7zrou23i4zhmsxi8732zjso}
```
ffuf -w namelist.txt -u http://10.129.6.6 -H "HOST: FUZZ.inlanefreight.htb" -fs 10918
```

The FUZZ words that appear. Once you find these
	- ap
	- app
	- citrix
	- customers
	- dmz
	- www2

- When running ffuf you'll see a default size of 10918. Filter on this size
- Now perform a the cURL command again..
```
curl -s http://10.129.6.6 -H "Host: ap.inlanefreight.htb"
```
![[Pasted image 20230821191546.png]]




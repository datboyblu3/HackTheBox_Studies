
### xsstrike

Download from here:
```go
git clone https://github.com/s0md3v/XSStrike.git
```

```go
python xsstrike.py -u "http://SERVER_IP:PORT/index.php?task=test"
```

### Manual Discovery

Payload-Box
```go
https://github.com/payload-box/xss-payload-list
```

PayloadAllTheThings
```go
https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/XSS%20Injection/README.md
```

### Question 1: Utilize some of the techniques mentioned in this section to identify the vulnerable input parameter found in the above server. What is the name of the vulnerable parameter?

```go
python3 xsstrike.py -u "http://154.57.164.70:30722/?fullname=test&username=test&password=test&email=test%40gmail.com
```
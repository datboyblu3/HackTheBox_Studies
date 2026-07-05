
## Extension Fuzzing

```go
ffuf -w /usr/share/wordlists/wfuzz/extensions_common.txt:FUZZ -u http://SERVER_IP:PORT/blog/indexFUZZ
```

## Page Fuzzing
```go
ffuf -w /usr/share/wordlists/seclists/Discovery/Web-Content/combined_directories.txt:FUZZ -u http://154.57.164.79:31340/blog/FUZZ.php
```


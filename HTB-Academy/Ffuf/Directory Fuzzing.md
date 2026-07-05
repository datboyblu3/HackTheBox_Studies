
Directory Fuzzing typically looks like:
```go
ffuf -w /opt/useful/seclists/Discovery/Web-Content/directory-list-2.3-small.txt:FUZZ -u http://SERVER_IP:PORT/FUZZ
```

# Question

### In addition to the directory we found above, there is another directory that can be found. What is it?

```go
ffuf -w /usr/share/wordlists/wfuzz/general/common.txt:FUZZ -u http://154.57.164.79:31340/FUZZ
```

Answer:
```go
forum
```
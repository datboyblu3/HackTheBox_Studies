
- IMAP access emails from mail server
- IMAP allows online management of emails directly on the server and supports folder structures
- POP3 only provides listing, retrieving, and deleting emails as functions at the email server
- Both ports operate on TCP 143, 110,993 and 995
- 993 and 995 are used for encryption

### IMAP Commands

| Command      | Description |
| ----------- | ----------- |
| a LOGIN username password      | User's login       |
| a LIST "" *   | Lists all directories        |
| CREATE "INBOX"    | Creates a mailbox with a specified name |
| DELETE "INBOX" | Deletes a mailbox |
| RENAME "ToRead" "Important"      | Renames a mailbox       |
| LSUB "" *   | Returns a subset of names from the set of names that the User has declared as being active or subscribed.        |
| SELECT INBOX      | Selects a mailbox so that messages in the mailbox can be accessed |
| UNSELECT INBOX | Exits the selected mailbox |
| FETCH ID all      | Retrieves data associated with a message in the mailbox      |
| CLOSE   | Removes all messages with the Deleted flag set        |
| LOGOUT      | Closes the connection with the IMAP server |

### POP 3 Commands

| Syntax      | Description |
| ----------- | ----------- |
| Header      | Title       |
| Paragraph   | Text        |
| Syntax      | Description |
|             |             |
| Header      | Title       |
| Paragraph   | Text        |

### Dangerous Settings

### Footprinting

**nmap**
```
sudo nmap 10.129.42.195 -sV -p110,143,993,995 -sC
```

If credentials are found and we can log into the mail server, we can read and/or send emails. 

```
curl -k 'imaps://10.129.42.195' --user robin:robin -v
```


**ncat**
```
ncat --crlf --verbose 10.129.246.73 143
```

To interact with IMAP or POP3 over SSL, use **openssl** or **netcat**.


**OpenSSL - TLS Encrypted Interaction POP3**
```
openssl s_client -connect 10.129.42.195:pop3s
```


**OpenSSL - TLS Encrypted Interaction IMAP**
```
openssl s_client -connect 10.129.42.195:imaps
```


### Questions
**Target:** 10.129.42.195

**1) Figure out the exact organization name from the IMAP/POP3  service and submit it as the answer**
```
sudo nmap 10.129.42.195 -sV -p110,143,993,995 -sC
```

Or

```
openssl s_client -connect 10.129.42.195:pop3s
```

![[imap_org.png]]
 
**2) What is the FQDN that the IMAP and POP3 servers are assigned to?** 
```
dev.inlanefreight.htb
```

**3) Enumerate the IMAP service and submit the flag as the answer. (Format: HTB{...})**
```
HTB{roncfbw7iszerd7shni7jr2343zhrj}
```

**4) What is the customized version of the POP3 server?**

Start off with nmap scan using pop3 scripts from NSE
```
nmap --script "pop3-capabilities or pop3-ntlm-info" -sV -p 143,110,993,995 10.129.246.73
```

Doesn't reveal anything, but using the openssl command and scrolling to the bottom revealed the customized POP3 version

```
openssl s_client -connect 10.129.42.195:pop3s
```

	![[pop3_customized_version.png]]

**5) What is the admin email address?** 
```
devadmin@inlanefreight.htb
```

**6) Try to access the emails on the IMAP server and submit the flag as the answer. (Format: HTB{...})**

```
openssl s_client -crlf -connect 10.129.246.73:imaps
```

	Login in with creds
```
a login robin robin
```

	List all folders/mailboxes
```
a list "" "*"
```

	Select the mailbox
```
a SELECT DEV.DEPARTMENT.INT
```

	Check the mailbox status
```
a STATUS DEV.DEPARTMENT.INT (MESSAGES)
```

	Get the messages in the folder
```
1 FETCH 1 RFC822
```

	![[imap_messages.png]]
### Resources

[A Mutable Log](https://tewarid.github.io/2011/05/10/access-imap-server-from-the-command-line-using-openssl.html)
[IMAP Commands](https://www.atmail.com/blog/imap-commands/)
[IMAP Crib Sheet](https://donsutherland.org/crib/imap)
[Testing IMAP Commands](https://www.mailenable.com/kb/content/article.asp?ID=ME020711)
[RFC Commands](https://datatracker.ietf.org/doc/html/rfc2062)
[HackTheBox - Chaos](https://www.youtube.com/watch?v=no9UnySBQrU&t=770s&ab_channel=IppSec)
[IMAP Commands](https://www.atmail.com/blog/imap-101-manual-imap-sessions/)


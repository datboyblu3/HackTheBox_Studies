
- IMAP access emails from mail server
- IMAP allows online management of emails directly on the server and supports folder structures
- POP3 only provides listing, retrieving, and deleting emails as functions at the email server
- Both ports operate on TCP 143, 110,993 and 995
- 993 and 995 are used for encryption

### IMAP Commands

| Command      | Description |
| ----------- | ----------- |
| LOGIN username password      | User's login       |
| LIST "" **  | Lists all directories        |
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
sudo nmap 10.129.90.199 -sV -p110,143,993,995 -sC
```

If credentials are found and we can log into the mail server, we can read and/or send emails. 

```
curl -k 'imaps://10.129.90.199' --user cry0l1t3:1234 -v
```

To interact with IMAP or POP3 over SSL, use **openssl** or **netcat**.


**OpenSSL - TLS Encrypted Interaction POP3**
```
openssl s_client -connect 10.129.90.199:pop3s
```


**OpenSSL - TLS Encrypted Interaction IMAP**
```
openssl s_client -connect 10.129.90.199:imaps
```


### Questions
**Target:** 10.129.90.199

Figure out the exact organization name from the IMAP/POP3 service and submit it as the answer.
```
```

 What is the FQDN that the IMAP and POP3 servers are assigned to?
```
 
```

Enumerate the IMAP service and submit the flag as the answer. (Format: HTB{...})
```
```

What is the customized version of the POP3 server?
```
```

What is the admin email address?
```
```

Try to access the emails on the IMAP server and submit the flag as the answer. (Format: HTB{...})

```
```


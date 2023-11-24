
### cURL 

#### Commands to interact with IMAP/POP3

**1. Listing mailboxes (imap command `LIST "" "*"`)**
```
curl -k 'imaps://1.2.3.4/' --user user:pass
```

**2. Listing messages in a mailbox (imap command `SELECT INBOX` and then `SEARCH ALL`)**
```
curl -k 'imaps://1.2.3.4/INBOX?ALL' --user user:pass
```


The result of this search is a list of message indicies. Its also possible to provide more complex search terms. e.g. searching for drafts with password in mail body:

```
curl -k 'imaps://1.2.3.4/Drafts?TEXT password' --user user:pass
```

**3. Downloading a message (imap command `SELECT Drafts` and then `FETCH 1 BODY[]`)**
```
curl -k 'imaps://1.2.3.4/Drafts;MAILINDEX=1' --user user:pass
```

**Access messages with the UID (unique ID)**
```
curl -k 'imaps://1.2.3.4/INBOX' -X 'UID SEARCH ALL' --user user:pass
```
```
curl -k 'imaps://1.2.3.4/INBOX;UID=1' --user user:pass
```

**Download just parts of a message, e.g. subject and sender of first 5 messages (the `-v` is required to see the subject and sender)**
```
curl -k 'imaps://1.2.3.4/INBOX' -X 'FETCH 1:5 BODY[HEADER.FIELDS (SUBJECT FROM)]' --user user:pass -v 2>&1 | grep '^<'
```

Or write it as a for loop

```
for m in {1..5}; do
  echo $m
  curl "imap://1.2.3.4/INBOX;MAILINDEX=$m;SECTION=HEADER.FIELDS%20(SUBJECT%20FROM)" --user user:pass
done
```


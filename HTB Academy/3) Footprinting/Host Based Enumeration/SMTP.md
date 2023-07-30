Simple Mail Transfer Protocol
- A protocol for sending emails in an IP network
- Can be used between an email client and an outgoing mail server or between two SMTP servers. 
- SMTP is often combined with the IMAP or POP3 protocols, which can fetch emails and send emails
- Operates on ports TCP/IP 25 and 587
- Encrypted on TCP/IP port 465, Extended SMTP abbreviated as ESMTP
- Default configuration can be found at
	- cat /etc/postfix/main.cf | grep -v "#" | sed -r "/^\s*$/d"

### Essential Function

- After an email is sent, the SMTP client, the MUA (Mail User Agent) converts it into a header and a body and uploads both to the SMTP server
- The MTA (Mail Transfer Agent) checks the email for size and spam and then stores it
- The MSA/Relay Server (Mail Submission Agent) checks the validity/origin of the email
- On arrival at the SMTP server the data packets are reassembled to form a complete e-mail

Client (MTA) -> Submission Agent (MSA) -> Open Relay (MTA) -> Mail Delivery Agent (MDA) -> Mailbox (POP3/IMAP)

### Disadvantages of SMTP

1) sending an email using SMTP does not return a usable delivery confirmation
2) Users are not authenticated when a connection is established, and the sender of an email is therefore unreliable

### SMTP Commands

- AUTH PLAIN	AUTH is a service extension used to authenticate the client.

- HELO	The client logs in with its computer name and thus starts the session.

- MAIL FROM	The client names the email sender.

- RCPT TO	The client names the email recipient.

- DATA	The client initiates the transmission of the email

- RSET	The client aborts the initiated transmission but keeps the connection between client and server.

- VRFY	The client checks if a mailbox is available for message transfer.

- EXPN	The client also checks if a mailbox is available for messaging with this command.

- NOOP	The client requests a response from the server to prevent disconnection due to time-out.

- QUIT	The client terminates the session.


### Open Relay Configuration
```
mynetworks = 0.0.0.0/0
```
With this setting, this SMTP server can send fake emails and thus initialize communication between multiple parties. Another attack possibility would be to spoof the email and read it.

### Footprinting the Service

NMAP
```
sudo nmap 10.129.14.128 -sC -sV -p25
```

We can also use the smtp-open-relay NSE script to identify the target SMTP server as an open relay using 16 different tests

NMAP - Open Relay
```
sudo nmap 10.129.14.128 -p25 --script smtp-open-relay -v
```

### Questions

Enumerate the SMTP service and submit the banner, including its version as the answer.

```
telnet 10.129.41.187 25
```


Enumerate the SMTP service even further and find the username that exists on the system
```
smtp-user-enum -M VRFY -U /usr/share/wordlists/footprinting-wordlist.txt -t 10.129.113.191 -v -w 20

```

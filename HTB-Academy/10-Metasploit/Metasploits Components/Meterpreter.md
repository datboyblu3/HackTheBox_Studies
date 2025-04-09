>[! Tip ] To run Meterpreter, we only need to select any version of it from the `show payloads` output, taking into consideration the type of connection and OS we are attacking.
  When the exploit is completed, the following events occur:
>- The target executes the initial stager. This is usually a bind, reverse, findtag, passivex, etc.
> - The stager loads the DLL prefixed with Reflective. The Reflective stub handles the loading/injection of the DLL.
>- The Meterpreter core initializes, establishes an AES-encrypted link over the socket, and sends a GET. Metasploit receives this GET and configures the client.
>- Lastly, Meterpreter loads extensions. It will always load `stdapi` and load `priv` if the module gives administrative rights. All of these extensions are loaded over AES encryption.

### Questions

IP
```go
10.129.203.65
```

1) Find the existing exploit in MSF and use it to get a shell on the target. What is the username of the user you obtained a shell with?

*Executed Nmap scan inside msfdb*

NMAP Scan
```go
msf6 > db_nmap -sC 10.129.203.65
[*] Nmap: Starting Nmap 7.95 ( https://nmap.org ) at 2025-04-08 18:55 EDT
[*] Nmap: Nmap scan report for 10.129.203.65
[*] Nmap: Host is up (0.035s latency).
[*] Nmap: Not shown: 994 closed tcp ports (reset)
[*] Nmap: PORT     STATE SERVICE
[*] Nmap: 135/tcp  open  msrpc
[*] Nmap: 139/tcp  open  netbios-ssn
[*] Nmap: 445/tcp  open  microsoft-ds
[*] Nmap: 3389/tcp open  ms-wbt-server
[*] Nmap: | rdp-ntlm-info:
[*] Nmap: |   Target_Name: WIN-51BJ97BCIPV
[*] Nmap: |   NetBIOS_Domain_Name: WIN-51BJ97BCIPV
[*] Nmap: |   NetBIOS_Computer_Name: WIN-51BJ97BCIPV
[*] Nmap: |   DNS_Domain_Name: WIN-51BJ97BCIPV
[*] Nmap: |   DNS_Computer_Name: WIN-51BJ97BCIPV
[*] Nmap: |   Product_Version: 10.0.17763
[*] Nmap: |_  System_Time: 2025-04-08T22:55:07+00:00
[*] Nmap: |_ssl-date: 2025-04-08T22:55:07+00:00; 0s from scanner time.
[*] Nmap: | ssl-cert: Subject: commonName=WIN-51BJ97BCIPV
[*] Nmap: | Not valid before: 2025-04-07T21:46:10
[*] Nmap: |_Not valid after:  2025-10-07T21:46:10
[*] Nmap: 5000/tcp open  upnp
[*] Nmap: 5985/tcp open  wsman
[*] Nmap: Host script results:
[*] Nmap: | smb2-time:
[*] Nmap: |   date: 2025-04-08T22:55:10
[*] Nmap: |_  start_date: N/A
[*] Nmap: | smb2-security-mode:
[*] Nmap: |   3:1:1:
[*] Nmap: |_    Message signing enabled but not required
[*] Nmap: Nmap done: 1 IP address (1 host up) scanned in 17.19 seconds

```

FortiLogger Login
![[Pasted image 20250408185644.png]]

Searching for FortiLogger in Metasploit I see there's one exploit. I'll use this one and verify the options for this exploit
![[Pasted image 20250408185746.png]]

`show options` reveals the available payload applicable for this exploit, `Payload options (windows/meterpreter/reverse_tcp):`
![[Pasted image 20250408190129.png]]

A grep search shows this to be payload 76.
```go
grep meterpreter show payloads
```

![[Pasted image 20250408191046.png]]

Execute `show options` to set your options and run the exploit:
![[Pasted image 20250408191248.png]]

2) Retrieve the NTLM password hash for the "htb-student" user. Submit the hash as the answer.

Back out and run the exploit again. Issue `hashdump` to get a dump of the password hashes:
![[Pasted image 20250408191832.png]]



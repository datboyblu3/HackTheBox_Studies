**Querying A Records**
```
export TARGET="facebook.com"
nslookup $TARGET
```
![[Pasted image 20230818232026.png]]

![[Pasted image 20230818232154.png]]

**Querying: A Records for a Subdomain**
![[Pasted image 20230818232255.png]]

**Querying: PTR Records for an IP Address**
![[Pasted image 20230818232433.png]]

**Querying: ANY Existing Records**
![[Pasted image 20230818232522.png]]

![[Pasted image 20230818232556.png]]

**Querying TXT Records**
![[Pasted image 20230818233121.png]]

**Querying MX Records**
![[Pasted image 20230818233207.png]]

We can combine some of the results gathered via nslookup with the whois database to determine if our target organization uses hosting providers.

![[Pasted image 20230818233432.png]]


### Questions
1) Which IP address maps to inlanefreight.com?
```
export TARGET="www.inlanefreight.com"
nslookup $TARGET
```
![[Pasted image 20230818230826.png]]

2) Which subdomain is returned when querying the PTR record for 173.0.87.51?
```
nslookup -query=PTR 173.0.87.51
```
![[Pasted image 20230818230959.png]]

3) What is the first mailserver returned when querying the MX records for paypal.com?
```
export TARGET="paypal.com"
nslookup -query=MX $TARGET
```
![[Pasted image 20230818231242.png]]




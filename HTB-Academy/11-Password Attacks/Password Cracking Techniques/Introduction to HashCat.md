#### General Syntax

```go
hashcat -a 0 -m 0 <hashes> [wordlist, rule, mask, ...]
```

### Hash Types Hashcat Supports
```go
hashcat --help
```

```go
    # | Name                                                       | Category
  ======+============================================================+======================================
    900 | MD4                                                        | Raw Hash
      0 | MD5                                                        | Raw Hash
    100 | SHA1                                                       | Raw Hash
   1300 | SHA2-224                                                   | Raw Hash
   1400 | SHA2-256                                                   | Raw Hash
  10800 | SHA2-384                                                   | Raw Hash
   1700 | SHA2-512                                                   | Raw Hash
  17300 | SHA3-224                                                   | Raw Hash
  17400 | SHA3-256                                                   | Raw Hash
  17500 | SHA3-384                                                   | Raw Hash
  17600 | SHA3-512                                                   | Raw Hash
   6000 | RIPEMD-160                                                 | Raw Hash
    600 | BLAKE2b-512                                                | Raw Hash
  11700 | GOST R 34.11-2012 (Streebog) 256-bit, big-endian           | Raw Hash
  11800 | GOST R 34.11-2012 (Streebog) 512-bit, big-endian           | Raw Hash
   6900 | GOST R 34.11-94                                            | Raw Hash
  17010 | GPG (AES-128/AES-256 (SHA-1($pass)))                       | Raw Hash
   5100 | Half MD5                                                   | Raw Hash
  17700 | Keccak-224                                                 | Raw Hash
  17800 | Keccak-256                                                 | Raw Hash
  17900 | Keccak-384                                                 | Raw Hash
  18000 | Keccak-512                                                 | Raw Hash
   6100 | Whirlpool                                                  | Raw Hash
  10100 | SipHash                                                    | Raw Hash
     70 | md5(utf16le($pass))                                        | Raw Hash
    170 | sha1(utf16le($pass))                                       | Raw Hash
   1470 | sha256(utf16le($pass))                                     | Raw Hash
...SNIP...
```

**Determine the hash type via the hash ID**
```go
hashid -m '$1$FNr44XZC$wQxY6HHLrgrGX0e1195k.1'
```

### Hashcat Rules

```go
hashcat -a 0 -m 0 1b0556a75770563578569ae21392630c /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule
```

```go
ls -l /usr/share/hashcat/rules

total 2852
-rw-r--r-- 1 root root 309439 Apr 24  2024 Incisive-leetspeak.rule
-rw-r--r-- 1 root root  35802 Apr 24  2024 InsidePro-HashManager.rule
-rw-r--r-- 1 root root  20580 Apr 24  2024 InsidePro-PasswordsPro.rule
-rw-r--r-- 1 root root  64068 Apr 24  2024 T0XlC-insert_00-99_1950-2050_toprules_0_F.rule
-rw-r--r-- 1 root root   2027 Apr 24  2024 T0XlC-insert_space_and_special_0_F.rule
-rw-r--r-- 1 root root  34437 Apr 24  2024 T0XlC-insert_top_100_passwords_1_G.rule
-rw-r--r-- 1 root root  34813 Apr 24  2024 T0XlC.rule
-rw-r--r-- 1 root root   1289 Apr 24  2024 T0XlC_3_rule.rule
-rw-r--r-- 1 root root 168700 Apr 24  2024 T0XlC_insert_HTML_entities_0_Z.rule
-rw-r--r-- 1 root root 197418 Apr 24  2024 T0XlCv2.rule
-rw-r--r-- 1 root root    933 Apr 24  2024 best64.rule
-rw-r--r-- 1 root root    754 Apr 24  2024 combinator.rule
-rw-r--r-- 1 root root 200739 Apr 24  2024 d3ad0ne.rule
-rw-r--r-- 1 root root 788063 Apr 24  2024 dive.rule
-rw-r--r-- 1 root root  78068 Apr 24  2024 generated.rule
-rw-r--r-- 1 root root 483425 Apr 24  2024 generated2.rule
drwxr-xr-x 2 root root   4096 Oct 19 15:30 hybrid
-rw-r--r-- 1 root root    298 Apr 24  2024 leetspeak.rule
-rw-r--r-- 1 root root   1280 Apr 24  2024 oscommerce.rule
-rw-r--r-- 1 root root 301161 Apr 24  2024 rockyou-30000.rule
-rw-r--r-- 1 root root   1563 Apr 24  2024 specific.rule
-rw-r--r-- 1 root root     45 Apr 24  2024 toggles1.rule
-rw-r--r-- 1 root root    570 Apr 24  2024 toggles2.rule
-rw-r--r-- 1 root root   3755 Apr 24  2024 toggles3.rule
-rw-r--r-- 1 root root  16040 Apr 24  2024 toggles4.rule
-rw-r--r-- 1 root root  49073 Apr 24  2024 toggles5.rule
-rw-r--r-- 1 root root  55346 Apr 24  2024 unix-ninja-leetspeak.rule
```

## Attack Modes
>[! Note ] Hash cat has multiple attack modes such as:
> dictionary, mask, combinator, association and more.

#### Dictionary Attack
```go
hashcat -a 0 -m 0 e3e3ec5831ad5e7288241960e5d4fdb8 /usr/share/wordlists/rockyou.txt
```

#### Mask Attack

>[! Hint]
>  The Mask attack is a type of brute-force attack in which the keyspace is explicitly defined by the user. For example, if we know that a password is eight characters long, rather than attempting every possible combination, we might define a mask that tests combinations of six letters followed by two numbers.
>  
>  A mask is defined by combining a sequence of symbols, each representing a built-in or custom character set.
>  
>  Custom charsets can be defined with the `-1`, `-2`, `-3`, and `-4` arguments, then referred to with `?1`, `?2`, `?3`, and `?4`.

Mask Character Sets

| Symbol | Charset                             |
| ------ | ----------------------------------- |
| ?l     | abcdefghijklmnopqrstuvwxyz          |
| ?u     | ABCDEFGHIJKLMNOPQRSTUVWXYZ          |
| ?d     | 0123456789                          |
| ?h     | 0123456789abcdef                    |
| ?H     | 0123456789ABCDEF                    |
| ?s     | «space»!"#$%&'()*+,-./:;<=>?@[]^_`{ |
| ?a     | ?l?u?d?s                            |
| ?b     | 0x00 - 0xff                         |
Example:
Let's say that we specifically want to try passwords that start with an uppercase letter, continue with four lowercase letters, a digit, and then a symbol. The resulting hashcat mask would be `?u?l?l?l?l?d?s`.

```go
hashcat -a 3 -m 0 1e293d6912d074c0fd15844d803400dd '?u?l?l?l?l?d?s'
```

## Questions

1) Use a dictionary attack to crack the first password hash. (Hash: e3e3ec5831ad5e7288241960e5d4fdb8)

Hash
```go
e3e3ec5831ad5e7288241960e5d4fdb8
```

```go
hashcat -a 0 -m 0 e3e3ec5831ad5e7288241960e5d4fdb8 /usr/share/wordlists/rockyou.txt
```

2) Use a dictionary attack with rules to crack the second password hash. (Hash: 1b0556a75770563578569ae21392630c)

```go
1b0556a75770563578569ae21392630c
```

Determine the hash type:
```go
└─$ hashid -m '1b0556a75770563578569ae21392630c'                                       
Analyzing '1b0556a75770563578569ae21392630c'
[+] MD2 
[+] MD5 [Hashcat Mode: 0]
[+] MD4 [Hashcat Mode: 900]
[+] Double MD5 [Hashcat Mode: 2600]
[+] LM [Hashcat Mode: 3000]
[+] RIPEMD-128 
[+] Haval-128 
[+] Tiger-128 
[+] Skein-256(128) 
[+] Skein-512(128) 
[+] Lotus Notes/Domino 5 [Hashcat Mode: 8600]
[+] Skype [Hashcat Mode: 23]
[+] Snefru-128 
[+] NTLM [Hashcat Mode: 1000]
[+] Domain Cached Credentials [Hashcat Mode: 1100]
[+] Domain Cached Credentials 2 [Hashcat Mode: 2100]
[+] DNSSEC(NSEC3) [Hashcat Mode: 8300]
[+] RAdmin v2.x [Hashcat Mode: 9900]
```


```go
hashcat -a 0 -m 0 1b0556a75770563578569ae21392630c /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule
```



3) Use a mask attack to crack the third password hash. (Hash: 1e293d6912d074c0fd15844d803400dd)

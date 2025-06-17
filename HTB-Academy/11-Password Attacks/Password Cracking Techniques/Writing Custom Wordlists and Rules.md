[Hashcat Documentation](https://hashcat.net/wiki/doku.php?id=rule_based_attack)

|**Function**|**Description**|
|---|---|
|`:`|Do nothing|
|`l`|Lowercase all letters|
|`u`|Uppercase all letters|
|`c`|Capitalize the first letter and lowercase others|
|`sXY`|Replace all instances of X with Y|
|`$!`|Add the exclamation character at the end|

#### Custom Rule File

```go
cat << EOF > custom.rule
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
EOF
```

**use the following command to apply the rules in `custom.rule` to each word in `password.list` and store the mutated results in `mut_password.list`**

```go
hashcat --force password.list -r custom.rule --stdout | sort -u > mut_password.list
```

### Generating wordlists using CeWL

>[! Hint ]
> use a tool called [CeWL](https://github.com/digininja/CeWL) to scan potential words from a company's website and save them in a separate list. We can then combine this list with the desired rules to create a customized password list—one that has a higher probability of containing the correct password for an employee.

```go
cewl https://www.inlanefreight.com -d 4 -m 6 --lowercase -w inlane.wordlist
```

then...
```go
wc -l inlane.wordlist
```

## Exercise

Mark's hash
```go
97268a8ae45ac7d15c3cea4ce6ea550b
```

Create custom.list for Mark White
```go
August
1998
5
Nexura
Ltd
San Francisco, CA, USA
San Francisco
Francisco
CA
USA
Bella
Maria
Alex
baseball
```

Password Rules
- 12 characters
- One uppercase, one lowercase
- One symbol
- One number



### System Commands

**Find the mailbox of your user**
```
env | grep mail
```

**Find out the machine hardware name and submit it as the answer.**
```
uname -m
```

**Which shell is specified for the htb-student user?**
```
echo $SHELL
```


### Navigation

**What is the index number of the "sudoers" file in the "/etc" directory?**
```
ls -li
```

**Jump back to the last directory you visited**
```
cd -
```

### Files and Directories Commands

**which**
allows us to determine if specific programs, like cURL, netcat, wget, python, gcc, are available on the operating system
```
which python
```


**find**
```
find / -type f -name *.conf -user root -size +20k -newermt 2020-03-03 -exec ls -al {} \; 2>/dev/null
```
	-type f: 
	-name *.conf: indicate the name of the file we are looking for. The asterisk (*) stands for 'all' files with the '.conf' extension.
	-user root: filters all files whose owner is the root user.
	-	size +20k:  filter all the located files and specify that we only want to see the files that are larger than 20 KiB.
	- newermt 2020-03-03: Only files newer than the specified date will be presented.
	- exec ls -al {} \; This option executes the specified command, using the curly brackets as placeholders for each result. The backslash escapes the next character from being interpreted by the shell because otherwise, the semicolon would terminate the command and not reach the redirection.
	- 2>/dev/null : 2>/dev/null

What is the name of the config file that has been created after 2020-03-03 and is smaller than 28k but larger than 25k?
```
find / -type f -name *.conf -newermt 2020-03-03 -size +25k -size -28k -exec ls -al {} \; 2>/dev/null
```


**locate**: Different from find, in that it searches a local database for all files and folders
```
locate *.conf
```


How many files exist on the system that have the ".bak" extension?
```
find / -type f -name "*.bak" | wc -l
```


Submit the full path of the "xxd" binary.
```
find / -name "xxd" 2>/dev/null
```


### File Descriptors and Redirectors

Data Stream for Standard Input
	- STDIN - 0
	- STDOUT - 1
	- STDERR - 2

**Redirect standard resulting errors to the null device**
```
find /etc/ -name shadow 2>/dev/null
```

**Redirect STDOUT to file**
```
find /etc/ -name shadow 2>/dev/null > results.txt
```

**Redirect STDOUT and STDERR to Separate Files**
```
find /etc/ -name shadow 2> stderr.txt 1> stdout.txt
```


**Redirect STDIN**
The lower hand sign serves as STDIN
```
cat < stdout.txt
```

**Redirect STDOUT and Append to a File**
```
find /etc/ -name passwd >> stdout.txt 2>/dev/null
```

**Redirect STDIN Stream to a File**
```
cat << EOF > stream.txt
```


**Pipes**
Filters out the results and specify that only the lines containing the pattern "systemd" should be displayed
```
find /etc/ -name *.conf 2>/dev/null | grep systemd
```


Use the tool called wc, which should count the total number of obtained results
```
find /etc/ -name *.conf 2>/dev/null | grep systemd | wc -l
```

**Questions**
How many files exist on the system that have the ".log" file extension?: 32
```
find / -name *.log 2>/dev/null | wc -l
```

How many total packages are installed on the target system? 737
```
apt list --installed | grep -c "installed"
```

### Filter Contents

**more**
```
more /etc/passwd
```

**less**
```
less /etc/passwd
```

**head**
Prints out the first 10 lines
```
head /etc/passwd
```

**tail**
Prints out the last 10 lines
```
tail /etc/passwd
```

**sort**
Sort the results
```
cat /etc/passwd | sort
```

**grep**
Search for users who have the default shell "/bin/bash" set
```
cat /etc/passwd | grep "/bin/bash"
```

With the "-v" option we exclude all users who have disabled the standard shell with the name "/bin/false" or "/usr/bin/nologin"
```
cat /etc/passwd | grep -v "false\|nologin"
```

**cut**
- Handy to know how to remove specific delimiters and show the words on a line in a specified position.
- Use the option "-d" and set the delimiter to the colon character (:) and define with the option "-f" the position in the line we want to output
```
cat /etc/passwd | grep -v "false\|nologin" | cut -d":" -f1
```

**tr**
- Replaces characters in a line
- The first option, we define which character we want to replace, and as a second option, we define the character we want to replace it with
```
cat /etc/passwd | grep -v "false\|nologin" | tr ":" " "
```

**column**
the tool column is well suited to display such results in tabular form using the "-t."
```
cat /etc/passwd | grep -v "false\|nologin" | tr ":" " " | column -t
```

**awk**
The user "postgres" has one row too many. To keep it as simple as possible to sort out such results, the (g)awk programming is beneficial, which allows us to display the first ($1) and last ($NF) part of a line.
```
cat /etc/passwd | grep -v "false\|nologin" | tr ":" " " | awk '{print $1, $NF}'
```

**sed**
- Looks for patterns to replace/substitute text
- Here we are replacing "bin" with "HTB"
- "s" flag at the beginning stands for the substitute command
- specify the pattern we want to replace
- After the slash (/), we enter the pattern we want to use as a replacement in the third position. 
- Finally, we use the "g" flag, which stands for replacing all matches
```
cat /etc/passwd | grep -v "false\|nologin" | tr ":" " " | awk '{print $1, $NF}' | sed 's/bin/HTB/g'
```

**wc**
- It will often be useful to know how many successful matches we have
- The "l" option specify counting only the lines
```
cat /etc/passwd | grep -v "false\|nologin" | tr ":" " " | awk '{print $1, $NF}' | wc -l
```

### Questions

**How many services are listening on the target system on all interfaces? (Not on localhost and IPv4 only)**: 7
```
netstat -luntp | grep -v "127.0.0" | grep "LISTEN" | grep "0.0.0.0" | wc -l
```

**Determine what user the ProFTPd server is running under. Submit the username as the answer**: proftpd
```
ps aux | grep "proftpd"
```

**Use cURL from your Pwnbox (not the target machine) to obtain the source code of the "https://www.inlanefreight.com" website and filter all unique paths of that domain. Submit the number of these paths as the answer**: 34
```
curl https://www.inlanefreight.com inlane.txt | tr " " "\n" | grep -E "inlanefreight" | grep -E "src|href"| sort -u
```

### Filtering Practice
Use the /etc/passwd file for this exercise
1) A line with the username *cry0l1t3
```
cat /etc/passwd | grep "cry0l1t3"
```

2) The usernames
 ```
 cat /etc/passwd | grep -e "/bin/bash" | cut -d":" -f1
```

3) The username cry0l1t3 and his UID
```
cat /etc/passwd | grep -e "cry0l1t3" | cut -d":" -f1,3
```

4) The username cry0l1t3 and his UID separated by a comma (,)
```
cat /etc/passwd | grep -e "cry0l1t3" | cut -d":" -f1,3 | tr ":" ","
```

5) The username cry0l1t3, his UID, and the set shell separated by a comma (,)
```
cat /etc/passwd | grep -e "cry0l1t3" | cut -d":" -f1,3,7 | tr ":" ","
```

6) All usernames with their UID and set shells separated by a comma (,)
```
cat /etc/passwd | grep -e "/bin/bash" | cut -d":" -f1,7 | tr ":" ","
```

7) All usernames with their UID and set shells separated by a comma (,) and exclude the ones that contain nologin or false.
```
cat /etc/passwd | grep -e "/bin/bash" | cut -d":" -f1,3,7 | tr ":" "," | grep -v "nologin|false"
```

8) All usernames with their UID and set shells separated by a comma (,) and exclude the ones that contain nologin and count all lines of the filtered output: 4
```
cat /etc/passwd | grep -e "/bin/bash" | cut -d":" -f1,3,7 | tr ":" "," | grep -v "nologin" | wc -l
```

### Regular Expressions

- (a) - The round brackets are used to group parts of a regex. Within the brackets, you can define further patterns which should be processed together.

- [a-z] - The square brackets are used to define character classes. Inside the brackets, you can specify a list of characters to search for.

- {1,10} - The curly brackets are used to define quantifiers. Inside the brackets, you can specify a number or a range that indicates how often a previous pattern should be repeated.

- | - Also called the OR operator and shows results when one of the two expressions matches

- .* - Also called the AND operator and displayed results only if both expressions match

**OR Operator**
```
grep -E "(my|false)" /etc/passwd
```

**AND Operator**
```
grep -E "(my.*false)" /etc/passwd
```

This is searching for a line with both "my" AND "false". Without regex, this would be two grep statements
```
grep -E "my" /etc/passwd | grep -E "false"
```

### Regex Practice

Use the /etc/ssh/sshd_config on the target machine

1) Show all lines that do not contain the # character.
```
cat /etc/ssh/sshd_config | grep -v [#]
```

2) Search for all lines that contain a word that starts with Permit.
```
grep -E "^Permit" /etc/ssh/sshd_config
```

3) Search for all lines that contain a word ending with Authentication
```
grep -E "Authentication$" /etc/ssh/sshd_config
```

4) Search for all lines containing the word Key
```
grep -Ei "Key" /etc/ssh/sshd_config
```

5) Search for all lines beginning with Password and containing yes
```
grep -E "(Password.*yes)" /etc/ssh/sshd_config
```

6) Search for all lines that end with yes
```
grep -E "yes$" /etc/ssh/sshd_config
```
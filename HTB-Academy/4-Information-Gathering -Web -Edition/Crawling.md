- Ffuf can also be used to crawl websites, faster than zap discovering hidden folders/directories
- Ensure to check out the Attacking Web Applications with Ffuf module on HackTheBox

**Sensitive Information Disclosure**

A list of common extensions we can find in the raft-[ small | medium | large ]-extensions.txt files from SecLists

1) Create a file with the following items:
	- wp-admin
	- wp-content
	- wp-includes

2) Extract keywords with CeWL with a minimum length of 5 characters, converting them to lowercase and writing to a file
```
cewl -m5 --lowercase -w wordlist.txt http://192.168.10.10
```

3) The next step will be to combine everything in ffuf to see if we can find some juicy information. For this, we will use the following parameters in ffuf:

	-w: We separate the wordlists by coma and add an alias to them to inject them as fuzzing points later
	-u: Our target URL with the fuzzing points
```
ffuf -w ./folders.txt:FOLDERS,./wordlist.txt:WORDLIST,./extensions.txt:EXTENSIONS -u http://192.168.10.10/FOLDERS/WORDLISTEXTENSIONS
```

```
curl http://192.168.10.10/wp-content/secret~
```




Creds can be found in:

- .config
- .conf
- xml
- shell scripts
- .bak files
- databases
- .env
- .txt files

**Creds in PHP Files**
```shell-session
cat wp-config.php | grep 'DB_USER\|DB_PASSWORD'
```


```shell-session
find / ! -path "*/proc/*" -iname "*config*" -type f 2>/dev/null
```
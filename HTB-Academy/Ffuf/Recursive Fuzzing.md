>[!Note]
> Recursively scanning automatically starts another scan under any newly identified directories that may have on their pages until it has fuzzed the main website and all of its subdirectories.
>
>- Enabled via the `-recursion` flag
>- Specify the depth via `-recursion-depth`. The option `-recursion-depth 1` will only fuzz the main directories and their sub-directories, any additional sub-directories will not be fuzzed


```go
ffuf -w /usr/share/wordlists/seclists/Discovery/Web-Content/combined_directories.txt:FUZZ -u http://154.57.164.79:31340/FUZZ -recursion -recursion-depth 1 -e .php -v
```






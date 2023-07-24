
| Setting      | Description |
| ----------- | ----------- |
| dirmessage_enable=YES      | Show a message when they first enter a new directory?       |
| chown_uploads=YES   | Change ownership of anonymously uploaded files?        |
| chown_username=username            | User who is given ownership of anonymously uploaded files.            |
| local_enable=YES            | Enable local users to login?            |
| chroot_local_user=YES            | Use a list of local users that will be placed in their home directory?            |
| hide_ids=YES           | All user and group information in directory listings will be displayed as "ftp".            |
| ls_recurse_enable=YES            | Allows the use of recurse listings.            |


Simultaneously view all available content on an FTP server, perform a recursive listing
```
ls -R
```


Simultaneously download all available files
```
wget -m --no-passive ftp://anonymous:anonymous@10.129.14.136
```
	- This will create a directory with the name of the IP and store all file 

Find all NSE FTP scripts
```
find / -type f -name ftp* 2>/dev/null | grep scripts
```

Use openssl to communicate to the FTP server
```
openssl s_client -connect 10.129.14.136:21 -starttls ftp
```
>[! Hint ]
> A comprehensive list of archive file types can be found on [FileInfo](https://fileinfo.com/filetypes/compressed)


```go
curl -s https://fileinfo.com/filetypes/compressed | html2text | awk '{print tolower($1)}' | grep "\." | tee -a compressed_ext.txt
```

## Cracking Zip Files

```go
zip2john ZIP.zip > zip.hash
```

```go
john --wordlist=rockyou.txt zip.hash
```

```go
john zip.hash --show
```

## Cracking OpenSSL encrypted GZIP files

To determine the format of a file use the `file` command:
```go
file GZIP.gzip
```

The following one-liner may produce several GZIP-related error messages, which can be safely ignored. If the correct password list is used, as in this example, we will see another file successfully extracted from the archive. Check the current directory after the script completes.

```go
for i in $(cat rockyou.txt);do openssl enc -aes-256-cbc -d -in GZIP.gzip -k $i 2>/dev/null| tar xz;done
```

## Cracking BitLocker-encrypted drives

> [! Hint ]
> To crack a BitLocker encrypted drive, we can use a script called `bitlocker2john` to [four different hashes](https://openwall.info/wiki/john/OpenCL-BitLocker): the first two correspond to the BitLocker password, while the latter two represent the recovery key. Because the recovery key is very long and randomly generated, it is generally not practical to guess—unless partial knowledge is available

```go
bitlocker2john -i Backup.vhd > backup.hashes
```

```go
grep "bitlocker\$0" backup.hashes > backup.hash
```

```go
cat backup.hash
```

Now use JtR or hashcat to crack the hashes
```go
hashcat -a 0 -m 22100 '$bitlocker$0$16$02b329c0453b9273f2fc1b927443b5fe$1048576$12$00b0a67f961dd80103000000$60$d59f37e70696f7eab6b8f95ae93bd53f3f7067d5e33c0394b3d8e2d1fdb885cb86c1b978f6cc12ed26de0889cd2196b0510bbcd2a8c89187ba8ec54f' /usr/share/wordlists/rockyou.txt
```

#### Mounting BitLocker-encrypted drives in Linux (or macOS)

Install dislocker
```go
sudo apt-get install dislocker
```

Create two folders which we will use to mount the VHD
```go
sudo mkdir -p /media/bitlocker
```

```go
sudo mkdir -p /media/bitlockermount
```

Then use `losetup` to configure the VHD as [loop device](https://en.wikipedia.org/wiki/Loop_device), decrypt the drive using `dislocker`, and finally mount the decrypted volume

```go
sudo losetup -f -P Backup.vhd
```

```go
sudo dislocker /dev/loop0p2 -u1234qwer -- /media/bitlocker
```

```go
sudo mount -o loop /media/bitlocker/dislocker-file /media/bitlockermount
```

Now browse the file
```go
cd /media/bitlockermount/
```

## Questions

IP/Target
```go
94.237.51.163:58547
```

1) Run the above target then navigate to http://94.237.57.57:56778/download, then extract the downloaded file. Inside, you will find a password-protected VHD file. Crack the password for the VHD and submit the recovered password as your answer.

```go
francisco
```

2) Mount the BitLocker-encrypted VHD and enter the contents of flag.txt as your answer


Repeat all the steps for this mounting Bitlocker. At this step use the `francisco` password like so:
```
sudo dislocker /dev/loop0p2 -ufrancisco -- /media/bitlocker
```

Then...
```go
sudo mount -o loop /media/bitlocker/dislocker-file /media/bitlockermount
```

then...
```go
cd /media/bitlockermount/
```

```go
┌──(dan㉿kali)-[/media/bitlockermount]
└─$ cd /media/bitlockermount/                                               
                                                                                                                                       
┌──(dan㉿kali)-[/media/bitlockermount]
└─$ ls -la
total 17
drwxrwxrwx 1 root root 4096 Apr 20 02:10  .
drwxr-xr-x 5 root root 4096 Jun  9 12:23  ..
-rwxrwxrwx 1 root root   32 Apr 20 02:11  flag.txt
drwxrwxrwx 1 root root 8192 Apr 20 02:12 'System Volume Information'
                                                                                                                                       
┌──(dan㉿kali)-[/media/bitlockermount]
└─$ cat flag.txt             
43d95aeed3114a53ac66f01265f9b7af 
```


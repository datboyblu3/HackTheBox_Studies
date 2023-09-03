
#### NMAP Scan

**Scanning with version discovery, aggressive scan, no ping and default NSE scans**
```
sudo nmap 10.10.11.221 -sV -A -Pn -sC
```

![[Pasted image 20230901015823.png]]

- Here we see two services available: 22/TCP SSH and 80/TCP HTTP
- On port 80 we see "Did not follow redirect to http://2million.htb/"
- We're going to do two things now.
	1) To ensure we can get to this URL, we're going to make an entry in our /etc/hosts file
	2) Use feroxbuster to enumerate all directories in 2million.htb
``` bash
echo "10.10.11.221 2million.htb" | tee -a /etc/hosts
```

- Directory Brute Forcing
- We're going to enumerate all the directories we can access, hence the 200 HTTP Status Code
```bash
feroxbuster -u http://2million.htb -s 200
```
![[Pasted image 20230903010518.png]]

- Three pages to point out are *register*, *login*, *invite*
- Nothing interesting from the first two pages, unto the invite page
- Inspect the web page and select Debugger. Prettify the htb-frontend.min.js and inviteapi.min.js so you can make the code more readable
- In the inviteapi.min.js file, the return statement contains some interesting data
- There appears to be a few functions being called, verifyInviteCode and makeInviteCode
![[Pasted image 20230903011858.png]]
- How do I know these are functions? Well for one, the naming style. It's similar to camel case. Those two are also the only items that describe an action.
- Ok, now we need to find where else these functions are referenced or better yet, find the file that contains their code blocks.
- Copy and paste one of them in search bar in the left pane
![[Pasted image 20230903012104.png]]
- You will find the the function blocks!!
- Here we see that both are making POST requests to verify and generate the invite code
- What tool can we use to send a POST request and query the server? Curl!!
```
curl -sX POST http://2million.htb/api/v1/invite/verify
```
	-s mutes curl, does not show progress or error messages
	X is the request method
	POST this is the request method we're using, since we're sending data to the server

![[Pasted image 20230903013528.png]]
	NOTE: You can learn more about making curl post requests at [reqbin.com](https://reqbin.com/req/c-g5d14cew/curl-post-example)

First request doesn't yield anything, unto to the second

```
curl -sX POST http://2million.htb/api/v1/invite/how/to/generate
```
![[Pasted image 20230903013732.png]]
What does this message tell us?
- We have an encrypted message
- Encryption type is ROT13, given by "encytpe:ROT13"
- Hint - "Data is encrypted...We should probably check the encryption type in order to decrypt it.."



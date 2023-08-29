
We can use Nginx or Apache webservers to upload files

#### Nginx - Enabling PUT

**Create a Directory to Handle Uploaded Files**
```
Create a Directory to Handle Uploaded Files
```

**Change the Owner to www-data**
```
sudo chown -R www-data:www-data /var/www/uploads/SecretUploadDirectory
```

**Create Nginx Configuration File**

Create the Nginx configuration file by creating the file /etc/nginx/sites-available/upload.conf with the contents
```
server {
    listen 9001;
    
    location /SecretUploadDirectory/ {
        root    /var/www/uploads;
        dav_methods PUT;
    }
}
```

**Symlink our Site to the sites-enabled Directory**
```
sudo ln -s /etc/nginx/sites-available/upload.conf /etc/nginx/sites-enabled/
```

**Start Nginx**
```
sudo systemctl restart nginx.service
```
	NOTE: If you encounter any errors, check /var/log/nginx/error.log

**Verifying Errors**
```
tail -2 `/var/log/nginx/error.log`
```

```
ss -lnpt | grep `80`
```

```
ps -ef | grep `2811`
```
	NOTE: If there is already a module listening on port 80. To get around this, we can remove the default Nginx configuration, which binds on port 80

**Remove NginxDefault Configuration**
```
sudo rm /etc/nginx/sites-enabled/default
```

Test uploading by using cURL to send a PUT request

**Upload File Using cURL**
```
curl -T /etc/passwd http://localhost:9001/SecretUploadDirectory/users.txt
```

```
tail -1 /var/www/uploads/SecretUploadDirectory/users.txt
```


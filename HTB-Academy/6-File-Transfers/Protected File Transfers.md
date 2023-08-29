
**File Encryption on Windows**

- The PowerShell script, [Invoke-AESEncryption.ps1](https://www.powershellgallery.com/packages/DRTools/4.0.2.3/Content/Functions%5CInvoke-AESEncryption.ps1), provides encryption for files and strings

**Import Module Invoke-AESEncryption.ps1**
```
Import-Module .\Invoke-AESEncryption.ps1
```

**File Encryption Example**
```
Invoke-AESEncryption -Mode Encrypt -Key "p4ssw0rd" -Path .\scan-results.txt
```

**File Encryption on Linux**

**Encrypting /etc/passwd with openssl**
```
openssl enc -aes256 -iter 100000 -pbkdf2 -in /etc/passwd -out passwd.enc
```

**Decrypt passwd.enc with openssl**
```
openssl enc -d -aes256 -iter 100000 -pbkdf2 -in passwd.enc -out passwd
```



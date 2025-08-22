
## Wazuh Agent Not Registering after Installation

>[! Error] Agent not connecting to Server
> - Verify the log entry in `ossec.log`
> - This happens when the Wazuh server IP in the ossec.conf file is set to `0.0.0.0` and not the intended/appropriate address. 

### Linux Fix
>[! Success]
 Go to `/var/ossec/etc/ossec.conf` and replace the incorrect address with the correct address

![[Pasted image 20250705160208.png]]

### Windows Fix
>[! Success]
> Same thing for Windows, except the configuration file is found here `C:\Program Files (x86)\ossec-agent`

![[Pasted image 20250705160335.png]]

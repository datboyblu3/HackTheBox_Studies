
### Setting Capabilities

Done with the `setcap` command, `setcap` can be used to set capabilities for specific executables
```
sudo setcap cap_net_bind_service=+ep /usr/bin/vim.basic
```

### Values for the setcap command
![[setcap_values.png]]

### Capability Functions & Descriptions
![[cap.png]]
### Setcap Privilege Escalation
![[priv_esc.png]]

### Enumerating Capabilities
```
find /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin -type f -exec getcap {} \;
```

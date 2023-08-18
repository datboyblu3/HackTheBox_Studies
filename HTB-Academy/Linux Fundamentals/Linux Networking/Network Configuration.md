
**Activate Network Interface**
```
sudo ifconfig eth0 up     # OR
udo ip link set eth0 up
```

**Assign IP Address to an Interface**
```
sudo ifconfig eth0 192.168.1.2
```

**Assign a Netmask to an Interface**
```
sudo ifconfig eth0 netmask 255.255.255.0
```

**Assign the Route to an Interface**
```
sudo route add default gw 192.168.1.1 eth0
```

**Editing DNS Settings**
```
sudo vim /etc/resolv.conf
```

![[Pasted image 20230817091308.png]]

After making these edits in the /etc/resolv.conf file, make the changes in the /etc/network/interfaces file as well

**Editing Interfaces**
```
sudo vim /etc/network/interfaces
```

![[Pasted image 20230817091539.png]]


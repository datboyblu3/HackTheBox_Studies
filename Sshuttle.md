- Written in Python
- Removes the need to configure proxychains
- only works for pivoting over SSH
- does not provide other options for pivoting over TOR or HTTPS proxy servers
- useful for automating the execution of iptables and adding pivot rules for the remote host.
- We can configure the Ubuntu server as a pivot point and route all of Nmap's network traffic with sshuttle

### Installing sshuttle
```go
sudo apt-get install sshuttle
```

### Running sshuttle

sshuttle creates an entry in our `iptables` to redirect all traffic to the 172.16.5.0/23 network through the pivot host.
```go
sudo sshuttle -r ubuntu@10.129.202.64 172.16.5.0/23 -v
```
	 -r:connect to the remote machine with a username and password
	 172.16.5.0/23: the network or IP we want to route through the pivot host


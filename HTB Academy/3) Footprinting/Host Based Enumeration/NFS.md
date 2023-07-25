- Based on the Open Network Computing Remote Procedure Call on TCP/IP port 111 or TCP/UDP port 2049

### Dangerous Settings

rw                          - Read and write permissions
insecure	              - Ports above 1024 will be used
nohide	                  - If another file system was mounted below an exported directory, this directory is exported by its own exports entry.
no_root_squash	  - All files created by root are kept with the UID/GID 0

### Footprinting NFS

```
sudo nmap 10.129.14.128 -p111,2049 -sV -sC
```

- The rpcinfo NSE script retrieves a list of all currently running RPC services, their names and descriptions, and the ports they use.

```
sudo nmap --script nfs* 10.129.14.128 -sV -p111,2049
```

**Show All Shares**
```
showmount -e 10.129.14.128
```

**Mounting NFS Shares**
First, create your mount point
```
mkdir target-NFS
```

Then, mount your share. "nfs" is the share to be mounted
```
sudo mount -t nfs 10.129.14.128:/ ./target-NFS/ -o nolock
```

cd into the newly created mount point and take a look at the tree. The tree, you will see the paths to the mounted share
```
cd target-NFS
```
```
tree .
```


List Contents with GUIDs & UIDs 
```
ls -n mnt/nfs
```



NFS can also be used to further escalate privileges. If you have SSH access to a system and would like to read files from another folder that only a specific user can read, you would upload a shell to the NFS share that has the SUID of that specific user, then running the shell via the SSH user

**Unmounting**
```
cd ..
sudo umount ./target-NFS
```

### Questions

Target IP: 10.129.188.45

 Enumerate the NFS service and submit the contents of the flag.txt in the "nfs" share as the answer.

 Enumerate the NFS service and submit the contents of the flag.txt in the "nfsshare" share as the answer.
 
**nmap**
```
sudo nmap 10.129.188.45 -p111,2049 -sV --script nfs*
```
![[nfs.png]]

**showmount**
```
showmount -e 10.129.188.45
```
![[showmount.png]]

**Create mount point and mount it to the share**
```
mkdir target-NFS

sudo mount -t nfs 10.129.188.45:/ ./target-NFS/ -o nolock
```

![[shares.png]]

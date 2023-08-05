
- provides sysadmins with the ability to manage and monitor systems even if they are powered off or in an unresponsive state
- operates using a direct network connection to the system's hardware and does not require access to the operating system via a login shell
- can also be used for remote upgrades to systems without requiring physical access to the target host
- communicates over port 623 UDP


### Footprinting IPMI

Baseboard Management Controllers (BMCs) are typically implemented as embedded ARM systems running Linux, and connected directly to the host's motherboard. The most common BMCs we often see during internal penetration tests are HP iLO, Dell DRAC, and Supermicro IPMI. If we can access a BMC during an assessment, we would gain full access to the host motherboard and be able to monitor, reboot, power off, or even reinstall the host operating system. Gaining access to a BMC is nearly equivalent to physical access to a system. Many BMCs (including HP iLO, Dell DRAC, and Supermicro IPMI) expose a web-based management console.

**NMAP**
```
sudo nmap -sU --script ipmi-version -p 623 ilo.inlanfreight.local
```

**Metasploit Version Scan**
```

```

### Common BMC default credentials

For Dell iDRAC....root:calvin
For HP iLP...........Administrator:randomized 8-character string consisting of numbers and uppercase letters
Supermicro IPMO.......ADMIN:ADMIN

### Dangerous Settings

- During the authentication process, the server sends a salted SHA1 or MD5 hash of the user's password to the client before authentication takes place
- This can be leveraged to obtain the password hash for ANY valid user account on the BMC
- These password hashes can then be cracked offline using a dictionary attack using Hashcat mode 7300.
- In the event of an HP iLO using a factory default password, we can use the below Hashcat mask attack command:
```
hashcat -m 7300 ipmi.txt -a 3 ?1?1?1?1?1?1?1?1 -1 ?d?u
```

Use Metasploit's [ IPMI 2.0 RAKP Remote SHA1 Password Hash Retrieval](https://www.rapid7.com/db/modules/auxiliary/scanner/ipmi/ipmi_dumphashes/) to retrieve IPMI hashes

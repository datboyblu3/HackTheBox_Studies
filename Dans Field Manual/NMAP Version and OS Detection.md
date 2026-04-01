
**Detection Techniques Reference | Linux & Windows**

---

##  Service Version Detection [-sV]

|Flag / Option|Description|
|---|---|
|`-sV`|Enable service and version detection on open ports|
|`--version-intensity 0`|Lightest probing — fastest but least accurate|
|`--version-intensity 5`|Default intensity (balanced speed vs accuracy)|
|`--version-intensity 9`|Most aggressive probing — slowest but most accurate|
|`--version-light`|Alias for `--version-intensity 2`|
|`--version-all`|Alias for `--version-intensity 9`|
|`--version-trace`|Print detailed version scan activity for debugging|

**Examples:**
```go
nmap -sV 192.168.1.1
```

```go
nmap -sV --version-intensity 9 192.168.1.1
```

```go
nmap -sV --version-light 192.168.1.1
```

```go
nmap -sV --version-all 192.168.1.1
```

```go
nmap -sV --version-trace 192.168.1.1
```

```go
nmap -sV -p 22,80,443,3306 192.168.1.1
```

```go
nmap -sV --top-ports 100 192.168.1.1
```

---

##  OS Detection [-O]

|Flag / Option|Description|
|---|---|
|`-O`|Enable OS detection via TCP/IP fingerprinting|
|`--osscan-limit`|Only attempt OS detection on hosts with open+closed ports|
|`--osscan-guess`|Aggressively guess OS when no perfect match is found|
|`--max-os-tries 1`|Limit OS detection retries (default is 5)|
|`-O --fuzzy`|Alias for `--osscan-guess` — shows closest OS match|

**Examples:**

```go
nmap -O 192.168.1.1
```

```go
nmap -O --osscan-guess 192.168.1.1
```

```go
nmap -O --osscan-limit 192.168.1.0/24
```

```go
nmap -O --max-os-tries 1 192.168.1.1
```

```go
nmap -O --fuzzy 192.168.1.1
```

```go
nmap -O -p 22,80,443 192.168.1.1
```

---

##  Aggressive Detection [-A]

|Flag / Option|Description|
|---|---|
|`-A`|Enables OS detection, version detection, script scanning, and traceroute|
|`-A -T4`|Aggressive mode with faster timing (recommended for LANs)|
|`-A -T2`|Aggressive detection with slower, stealthier timing|
|`-A -p-`|Run aggressive detection across all 65535 ports|
|`-A --top-ports 1000`|Aggressive scan limited to top 1000 ports|

**Examples:**

```go
nmap -A 192.168.1.1
```

```go
nmap -A -T4 192.168.1.1
```

```go
nmap -A -T2 192.168.1.1
```

```go
nmap -A -p- 192.168.1.1
```

```go
nmap -A --top-ports 1000 192.168.1.0/24
```

```go
nmap -A -iL targets.txt
```

---

##  Combined Version + OS Detection

|Flag Combination|Description|
|---|---|
|`-sV -O`|Run both version and OS detection together|
|`-sV -O -sC`|Add default NSE scripts on top of version + OS|
|`-sV -O --osscan-guess`|Version detection with aggressive OS guessing|
|`-sV -O -p-`|Full port sweep with version and OS detection|
|`-sV -O -T4`|Faster combined scan suitable for local networks|
|`-sV -O -oA output`|Save results in all formats (XML, grepable, normal)|

**Examples:**

```go
nmap -sV -O 192.168.1.1
```

```go
nmap -sV -O -sC 192.168.1.1
```

```go
nmap -sV -O --osscan-guess 192.168.1.1
```

```go
nmap -sV -O -p- 192.168.1.1
```

```go
nmap -sV -O -T4 192.168.1.0/24
```

```go
nmap -sV -O -oA scan_results 192.168.1.1
```

---

##  TTL & TCP/IP Fingerprinting Concepts

| Indicator             | Typical OS              |
| --------------------- | ----------------------- |
| TTL ≈ 64              | Linux / Unix / macOS    |
| TTL ≈ 128             | Windows                 |
| TTL ≈ 255             | Cisco / Network devices |
| TCP Window Size 65535 | macOS / BSD             |
| TCP Window Size 8192  | Older Windows (XP/2003) |
| TCP Window Size 29200 | Linux kernel 3.x+       |
|                       |                         |

> Nmap correlates TTL, TCP window size, IP ID sequencing, and other stack behaviors against its `nmap-os-db` fingerprint database to determine OS.

**Examples:**

##### Manually observe TTL via ping to supplement nmap findings
```go

ping -c 1 192.168.1.1
```

##### Run OS detection and save to XML for TTL/fingerprint review
```go
nmap -O -oX os_scan.xml 192.168.1.1
```

##### Verbose OS detection to see fingerprint matching in real time
```go
nmap -O -v 192.168.1.1
```

##### Compare against specific nmap OS DB entry
```go
nmap -O --datadir /usr/share/nmap 192.168.1.1
```


---

##  Stealth & Timing Adjustments

|Flag|Description|
|---|---|
|`-T0` (Paranoid)|5 min delay between probes — IDS evasion|
|`-T1` (Sneaky)|15 sec delay between probes — slow and quiet|
|`-T2` (Polite)|0.4 sec delay — reduced bandwidth usage|
|`-T3` (Normal)|Default timing — no delay adjustments|
|`-T4` (Aggressive)|Faster — assumes reliable LAN connection|
|`-T5` (Insane)|Maximum speed — may miss results or crash targets|

**Examples:**

```go
nmap -sV -O -T1 192.168.1.1
```

```go
nmap -sV -O -T3 192.168.1.1
```

```go
nmap -sV -O -T4 192.168.1.1
```

```go
nmap -sV -T4 --min-rate 1000 192.168.1.1
```

```go
nmap -sV -T2 --max-retries 2 192.168.1.1
```

```go
nmap -sV --scan-delay 500ms 192.168.1.1
```
---

##  Output & Reporting

|Flag|Description|
|---|---|
|`-oN output.txt`|Normal human-readable output|
|`-oX output.xml`|XML output (importable into Metasploit, etc.)|
|`-oG output.gnmap`|Grepable output for quick parsing|
|`-oA output`|Save in all three formats simultaneously|
|`-v`|Verbose — show open ports as they are found|
|`-vv`|Extra verbose — show more detail during scan|
|`--reason`|Show the reason a port is in a given state|
|`--open`|Only show open ports in output|

**Examples:**

```go
nmap -sV -O -oN results.txt 192.168.1.1
```

```go
nmap -sV -O -oX results.xml 192.168.1.1
```

```go
nmap -sV -O -oA full_scan 192.168.1.1
```

```go
nmap -sV -O -v --reason 192.168.1.1
```

```go
nmap -sV -O --open 192.168.1.0/24
```

```go
nmap -sV -O -vv -oA network_audit 192.168.1.0/24
```


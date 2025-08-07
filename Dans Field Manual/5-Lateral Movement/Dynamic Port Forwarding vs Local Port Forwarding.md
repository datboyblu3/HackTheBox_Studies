
Both **Dynamic Port Forwarding (DPF)** and **Local Port Forwarding (LPF)** are used to route traffic through an SSH tunnel, but they serve different purposes.

|Feature|Dynamic Port Forwarding (DPF)|Local Port Forwarding (LPF)|
|---|---|---|
|**Function**|Acts as a SOCKS proxy to forward traffic dynamically to different destinations.|Forwards traffic from a local port to a specific remote server/port.|
|**Use Case**|Useful when you need to tunnel multiple types of traffic (e.g., web browsing, RDP, etc.) through an SSH connection.|Useful when you need to securely access a specific remote service (e.g., accessing an internal database).|
|**How It Works**|Creates a local SOCKS proxy server that routes traffic dynamically based on the destination.|Maps a single local port to a fixed remote destination (IP & port).|
|**Command Example**|`ssh -D 1080 user@remote-host`|`ssh -L 8080:remote-host:80 user@jump-server`|
|**Flexibility**|More flexible—applications can use the proxy to reach multiple destinations.|Less flexible—only one fixed destination is allowed per tunnel.|
|**Common Use Cases**|- Bypassing firewalls/censorship (e.g., tunneling browser traffic). - Penetration testing (SOCKS proxy for pivoting).|- Secure access to an internal web service or database. - Remote development on a protected server.|


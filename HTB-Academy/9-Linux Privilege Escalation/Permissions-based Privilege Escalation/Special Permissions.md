#### Set User ID upon Execution `setuid` 
- Allows a user to execute a program or script with the permissions of another user, typically with elevated privileges
- The `setuid` bit appears as an `s`

**List scripts with the `setuid` set**
```
find / -user root -perm -4000 -exec ls -ldb {} \; 2>/dev/null
```
```
-rwsr-xr-x 1 root root 18664 Nov 27 23:23 /usr/lib/polkit-1/polkit-agent-helper-1
-rwsr-xr-x 1 root root 118920 Oct 18 19:43 /usr/lib/snapd/snap-confine
-rwsr-xr-x 1 root root 555584 Jan 17 17:50 /usr/lib/openssh/ssh-keysign
-rwsr-sr-x 1 root root 14672 Dec 13 02:51 /usr/lib/xorg/Xorg.wrap
-rwsr-xr-- 1 root messagebus 51272 Jan  8 16:12 /usr/lib/dbus-1.0/dbus-daemon-launch-helper
-rwsr-xr-- 1 root kismet 154408 Dec 18 10:57 /usr/bin/kismet_cap_nrf_mousejack
-rwsr-xr-x 1 root root 62672 Jan  5 19:57 /usr/bin/chfn
-rwsr-xr-x 1 root root 14848 Dec  7 09:55 /usr/bin/vmware-user-suid-wrapper
-rwsr-xr-- 1 root kismet 228680 Dec 18 10:57 /usr/bin/kismet_cap_linux_wifi
-rwsr-xr-x 1 root root 35128 Jan  5 09:25 /usr/bin/umount
-rwsr-xr-x 1 root root 30872 Nov 27 23:23 /usr/bin/pkexec
-rwsr-xr-- 1 root kismet 150312 Dec 18 10:57 /usr/bin/kismet_cap_nrf_52840
-rwsr-xr-x 1 root root 162752 Mar 23  2023 /usr/bin/ntfs-3g
-rwsr-xr-- 1 root kismet 150312 Dec 18 10:57 /usr/bin/kismet_cap_ubertooth_one
-rwsr-xr-x 1 root root 88496 Jan  5 19:57 /usr/bin/gpasswd
-rwsr-xr-- 1 root kismet 154408 Dec 18 10:57 /usr/bin/kismet_cap_nxp_kw41z
-rwsr-xr-- 1 root kismet 154408 Dec 18 10:57 /usr/bin/kismet_cap_rz_killerbee
-rwsr-xr-x 1 root root 306488 Jan  3 15:40 /usr/bin/sudo
-rwsr-xr-x 1 root root 52880 Jan  5 19:57 /usr/bin/chsh
-rwsr-xr-x 1 root root 72344 Jan  5 19:57 /usr/bin/passwd
-rwsr-xr-- 1 root kismet 154408 Dec 18 10:57 /usr/bin/kismet_cap_ti_cc_2540
-rwsr-xr-x 1 root root 76096 Jan  5 09:25 /usr/bin/su
-rwsr-xr-- 1 root kismet 150312 Dec 18 10:57 /usr/bin/kismet_cap_nrf_51822
-rwsr-xr-x 1 root root 35128 Jan 12 10:46 /usr/bin/fusermount3
-rwsr-xr-- 1 root kismet 154408 Dec 18 10:57 /usr/bin/kismet_cap_ti_cc_2531
-rwsr-xr-x 1 root root 48896 Jan  5 19:57 /usr/bin/newgrp
-rwsr-xr-- 1 root kismet 158504 Dec 18 10:57 /usr/bin/kismet_cap_linux_bluetooth
-rwsr-xr-x 1 root root 63800 Jan  5 09:25 /usr/bin/mount
-rwsr-xr-- 1 root kismet 277288 Dec 18 10:57 /usr/bin/kismet_cap_hak5_wifi_coconut
-rwsr-xr-x 1 root root 146480 Dec  3 08:58 /usr/sbin/mount.nfs
-rwsr-xr-x 1 root root 48128 Aug 26  2022 /usr/sbin/mount.cifs
-rwsr-xr-- 1 root dip 403832 May 13  2022 /usr/sbin/pppd
-rwsr-xr-x 1 root root 54256 May 30  2023 /opt/Obsidian/chrome-sandbox

```



#### Set Group ID `setgid`
- A special permission that allows us to run binaries as if we were part of the group that created them

**List scripts with the `setgid` set**
```
find / -user root -perm -6000 -exec ls -ldb {} \; 2>/dev/null
```


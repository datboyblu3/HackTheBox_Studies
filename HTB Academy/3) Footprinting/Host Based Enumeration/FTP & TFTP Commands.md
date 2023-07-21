

### FTP Commands

| Command     | Description |
| ----------- | ----------- |
| !           | Runs the specified command on the local computer|
| ?           | Displays descriptions of FTP command 
| append      | Appends a local file to a file on the remote computer |
| ascii       | Sets the file transfer type to ASCII, the default            |
| bell        | Toggles a bell to ring after each file transfer command is completed (default = OFF)     |
| binary      | Sets the file transfer type to binary        |
| bye         | Ends the FTP session and exits ftp |
| cd          | Changes the working directory on the remote computer |
| close       | Ends the FTP session and returns to the command interpreter       |
| debug       | Toggles debugging (default = OFF)        |
| delete      | Deletes a single file on a remote computer |
| dir         | Displays a list of a remote directory’s files and subdirectories |
| disconnect  | Disconnects from the remote computer, retaining the ftp prompt       |
| get         | Copies a single remote file to the local computer        |
| glob        | Toggles filename globbing (wildcard characters) (default = ON)     |
| hash        | Toggles hash sign (#) printing for each data block transferred (default = OFF)    |
| help        | Displays descriptions for ftp commands       |
| lcd         | Changes the working directory on the local computer        |
| literal     | Sends arguments, verbatim, to the remote FTP server     |
| ls          | Displays an abbreviated list of a remote directory’s files and subdirectories     |
| mdelete     | Deletes one or more files on a remote computer       |
| mdir        | Displays a list of a remote directory’s files and subdirectories        |
| mget        | Copies one or more remote files to the local computer     |
| mkdir       | Creates a remote directory     |
| mls         | Displays an abbreviated list of a remote directory’s files and subdirectories       |
| mput        | Copies one or more local files to the remote computer        |
| open        | Connects to the specified FTP server     |
| prompt      | Toggles prompting (default = ON)         |
| put         | Copies a single local file to the remote computer |
| pwd         | Displays the current directory on the remote computer (literally, “print working directory”) |
| quit        | Ends the FTP session with the remote computer and exits ftp (same as “bye”       |
| quote       | Sends arguments, verbatim, to the remote FTP server (same as “literal”)        |
| recv        | Copies a remote file to the local computer |
| remotehelp  | Displays help for remote commands |
| rename      | Renames remote files       |
| rmdir       | Deletes a remote directory        |
| send        | Copies a local file to the remote computer (same as “put”) |
| status      | Displays the current status of FTP connections |
| trace       | Toggles packet tracing (default = OFF)       |
| type        | Sets or displays the file transfer type (default = ASCII)        |
| user        | Specifes a user to the remote computer |
| verbose     | Toggles verbose mode (default = ON)



TFTP Commands

connect	- Sets the remote host, and optionally the port, for file transfers.
get	        - Transfers a file or set of files from the remote host to the local host.
put	        - Transfers a file or set of files from the local host onto the remote host.
quit	        - Exits tftp.
status	    - Shows the current status of tftp, including the current transfer mode (ascii or binary), connection status, time-out value, and so on.
verbose	 - Turns verbose mode, which displays additional information during file transfer, on or off.
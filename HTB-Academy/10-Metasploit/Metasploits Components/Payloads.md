### Single
- contains the exploit and the entire shellcode for the selected task
- self-contained payloads, are the sole object sent and executed on the target system, getting us a result immediately after running. Example is adding a user to a system

### Stagers
- payloads work with Stage payloads to perform a specific task
- waits on the attacker machine, ready to establish a connection to the victim host once the stage completes its run on the remote host

### Stages
- payload components that are downloaded by stager's modules


### Searching for Specific Payloads
```go
grep meterpreter show payloads
```

```go
grep meterpreter grep reverse_tcp show payloads
```


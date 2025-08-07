>[! note] Pass the Ticket (PtT)
> Instead of an NTLM password hash, a stolen Kerberos ticket is used to move laterally within
> an Active Directory environment.
>> 
> To perform a PtT attack we need two things:
> 
> 	1) A TGS to allow access to a service
> 	2) TGT, used to request service tickets to access any service the user has privileges


## Kerberos Refresher

Kerberos stores all tickets locally and presents each service ticket for that specific service. The **Ticket Granting Ticket (TGT)** is the first ticket. It allows clients to get additional tickets aka the TGS. **The Ticket Granting Service** is requested by users who want to use a service. This ticket allows services to verify the user's identity.

When a user requests a TGT they authenticate to the DC by encrypting the current timestamp with their password hash. The DC will validate the users identity, then grants the user a TGT for future requests.

If the user wants to connect to MSSQL, the user request a TGS to the Key Distribution Center KDC. The user presents its TGT to the KCD, then will give the TGS to the MSSQL server for authentication.

**To perform PtT you will need a valid TGT and TGS**


## Harvesting Kerberos tickets from Windows

LSASS processes and stores the tickets, therefore you must communicate with LSASS to get them. As a local admin you can get all tickets.

Use the Mimikatz module **sekurlsa::tickets /export**. This will result in a list of files with the extension .kirbi. Discussed below

### Mimikatz - Exporting tickets

![[2025-08-07 07.49.54.gif]]

>[! Important] How to tell which is a ticket?
> Tickets ending with $ correspond to the computer account.
> User tickets have the user's name, followed by an @ that separates the service and the domain.
> Example: **[randomvalue]-username@service-domain.local.kirbi**

## Rebeus - Export Tickets

Rebeus can export tickets as well, via the dump option. The difference, it will print the ticket encoded in Base 64 format instead of giving us a file.




The settings in an ACL are called `Access Control Entries` (`ACEs`). Each ACE maps back to a user, group, or process (also known as security principals) and defines the rights granted to that principal. Every object has an ACL, but can have multiple ACEs because multiple security principals can access objects in AD
## Types of ACLS

### 1. Discretionary ACL
>[!INFO] DACL
> - Defines which security principals are granted or denied access to an object
> - Made up of ACEs that either allow or deny access
> - If a DACL does not exist for an object, all who attempt to access the object are granted full rights. 
> - If a DACL exists, but does not have any ACE entries specifying specific security settings, the system will deny access to all users, groups, or processes attempting to access it.

### 2. System ACL
>[!info] SACL
> Allow admins to log access attempts made to secure objects


##### forend's ACL and ACE's
![[Pasted image 20260421190253.png]]

| **ACE**              | **Description**                                                                                                                                                            |
| -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Access denied ACE`  | Used within a DACL to show that a user or group is explicitly denied access to an object                                                                                   |
| `Access allowed ACE` | Used within a DACL to show that a user or group is explicitly granted access to an object                                                                                  |
| `System audit ACE`   | Used within a SACL to generate audit logs when a user or group attempts to access an object. It records whether access was granted or not and what type of access occurred |
## Four specific ACEs to highlight the power of ACL attacks:

>[!tip] ForceChangePassword
> Gives us the right to reset a user's password without first knowing their password

>[!tip] GenericWrite
>Gives us the right to write to any non-protected attribute on an object. If we have this access over a user, we could assign them an SPN and perform a Kerberoasting attack (which relies on the target account having a weak password set). Over a group means we could add ourselves or another security principal to a given group.

>[!tip] AddSelf
> Shows security groups that a user can add themselves to

>[!tip] GenericAll
> Grants us full control over a target object. Depending on if this is granted over a user or group, we could modify group membership, force change a password, or perform a targeted Kerberoasting attack. If we have this access over a computer object and the [Local Administrator Password Solution (LAPS)](https://www.microsoft.com/en-us/download/details.aspx?id=46899) is in use in the environment, we can read the LAPS password and gain local admin access to the machine which may aid us in lateral movement or privilege escalation in the domain if we can obtain privileged controls or gain some sort of privileged access.


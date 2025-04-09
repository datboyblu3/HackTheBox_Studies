Install scrapy
```go
pip3 install scrapy --break-system-packages
```

Install ReconSpider
```go
wget -O ReconSpider.zip https://academy.hackthebox.com/storage/modules/144/ReconSpider.v1.2.zip
```
	NOTE: output will be saved in a JSON file called results.json

Execute ReconSpider against the target:
```go
python3 ReconSpider.py http://inlanefreight.com
```

Read the results file
```go
cat results.json | jq
```


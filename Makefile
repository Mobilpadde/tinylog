DATE=$(shell date +"%Y%m%d")
TS=$(shell date +%s)
STATUS=$(shell echo "lulz")
WD=$(shell pwd)

start:
	make statics
	make run

run:
	nim c -d:ssl -r src/tinylog.nim

statics:
	stylus --compress site/stylus -o site/static
	webpack --config site/scripts/webpack.config.dev.js

watch-styl:
	stylus --compress -w site/stylus -o site/static

watch-js:
	webpack --config site/scripts/webpack.config.dev.js -w

compile:
	nim c src/tinylog.nim

dump:
	firefox -p tinylog -screenshot site/dumps/$(DATE).png http://localhost:8080/log/$(DATE) --window-size=332,332

auth:
	twurl authorize --consumer-key ${CON_KEY} --consumer-secret ${CON_SECRET}

tweet:
	$(eval M_ID=$(shell twurl -H upload.twitter.com "/1.1/media/upload.json" -f "site/dumps/$(DATE).png" -F media -X POST | grep -Po '"media_id":\d+' | grep -Po '\d+'))
	twurl "/1.1/statuses/update.json" -d "media_ids=${M_ID}&status=$(STATUS)" 

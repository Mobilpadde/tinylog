DATE=$(shell date +"%Y%m%d")
TS=$(shell date +%s)
STATUS=$(shell echo "Whoop, I did this!")
WD=$(shell pwd)
PORT?=4000

deps:
	cd site && (yarn || npm i)

start:
	make deps
	make statics
	make run

run:
	nim c --threads:on -r src/tinylog.nim ${PORT}

compile:
	nim c --threads:on src/tinylog.nim

statics:
	cd site && (yarn css || npm run css)
	cd site && (yarn js || npm run js)

watch-css:
	cd site && (yarn css -w || npm run css -w)

watch-js:
	cd site && (yarn js -w || npm run js -w)

dump:
	firefox -p tinylog -screenshot site/dumps/$(DATE).png http://localhost:${PORT}/log/$(DATE) --window-size=332,346

auth:
	twurl authorize --consumer-key ${CON_KEY} --consumer-secret ${CON_SECRET}

tweet:
	$(eval M_ID=$(shell twurl -H upload.twitter.com "/1.1/media/upload.json" -f "site/dumps/$(DATE).png" -F media -X POST | grep -Po '"media_id":\d+' | grep -Po '\d+'))
	twurl "/1.1/statuses/update.json" -d "media_ids=${M_ID}&status=$(STATUS)" 

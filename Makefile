DATE=$(shell date +"%Y%m%d")
TS=$(shell date +%s)
STATUS=$(shell echo "Whoop, I did this!")
PORT?=4000

ifeq ($(WD),)
WD:=$(shell pwd)
endif

deps:
	cd site && (yarn || npm i)

start:
	make deps
	make statics
	make run

run:
	nim c --threads:on -r src/tinylog.nim -p:${PORT} -d:$(WD)

compile:
	nim c --threads:on src/tinylog.nim

make release:
	make compile
	
	mkdir -p release/site/data \
		release/site/dumps \
		release/site/static

	mv src/tinylog release/
	cp Makefile release/
	cp -r site/scripts release/site/
	cp -r site/stylus release/site/
	cp -r site/package.json release/site/

	tar -czf tinylog-$(NAME).tar.gz release/

statics:
	make deps
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

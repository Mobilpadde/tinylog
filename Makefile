deps:
	yarn global add stylus || npm i- g stylus

start:
	stylus --compress site/stylus -o site/static
	nim c -r src/tinylog.nim -s

watch-styl:
	stylus --compress -w site/stylus -o site/static

compile:
	nim c src/tinylog.nim

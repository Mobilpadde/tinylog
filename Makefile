deps:
	yarn global add stylus webpack webpack-cli || npm i- g stylus webpack webpack-cli

start:
	stylus --compress site/stylus -o site/static
	webpack --config site/scripts/webpack.config.dev.js
	nim c -r src/tinylog.nim -s

watch-styl:
	stylus --compress -w site/stylus -o site/static

watch-js:
	webpack --config site/scripts/webpack.config.dev.js -w

compile:
	nim c src/tinylog.nim

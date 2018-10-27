# tinylog

![OSS](images/20181027.png?raw=true)

## Requirements

 * [stylus](https://www.npmjs.com/package/stylus)
 * [webpack](https://www.npmjs.com/package/webpack)
 * [webpack-cli](https://www.npmjs.com/package/webpack-cli)
 * [twurl](https://github.com/twitter/twurl) ([guide](https://medium.com/@SamSchmir/a-guide-to-the-twitter-api-and-twurl-8711466a0635))
 * [Firefox](https://www.mozilla.org/en-US/firefox/new/) - for headless screenshots

### twitter

You'll then need to authorize twurl by

```shell
CON_KEY=TW_CONSUMER_KEY CON_SECRET=TW_CONSUMER_SECRET make auth
```

That's it!

You can now start enjoying tinylog :D

### hooks

You'd point your github/gitlab hooks to `http://changelog.MY-DOMAIN.TLD/githook` (You'd reverse proxy from localhost:4000)

## Start

Run on port `4000`:

```sh
    ./tinylog 4000
```

It'll handle everything for you 😍

## How it works

You commit as usual and it'll tweet your commits every day at 11pm, as an image. Easy as that!

## Paths

Tinylog exposes some url-paths from standard:

### GET

 * `/lazy` - for lazy-loading
 * `/all` - to check files exposed to the public
 * `/*` - to every file in the static folder

### POST
 * `/githook` - for when a new commit is pushed
 * `/newest` - ___[DEPRECATED]___ fetch the newest log-entry-name
 * `/prev` - ___[DEPRECATED]___ fetch the previous entry
    * body should be in the format of `yyyymmdd`
 * `/*` - a json msg

## API

To make a new entry in your logs simply in your git commit:

```md
\```
@fix
  Did __this__ thing, that fixed _that_ broken [thing](https://example.com)
\```
```

(Discard the `\`'s)

Or create/edit the files in `site/data` using the pattern `yyyymmdd.tl`, using that same structure, though, you should omit the back-ticks.

The `@fix` is probably the most importan thing, it's like tags for what you've done. Thus far you can use from:

 * fix
 * new
 * bug

Just remember to put the at-sign (`@`) in front of them.

Other than that, we've got a few goodies from `markdown`.

 * The `bold` => `__WORD__` || `**WORD**` => __WORD__
 * The `code` => single backtick in front and behind the code => `code`
 * The `emphasis` => `_WORD_` || `*WORD*` => *WORD*
 * The `link` => `[text](link)` => [text](link)
 * The `strike` => `~~WORD~~` => ~~WORD~~


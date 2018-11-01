# tinylog

[![Build Status](https://travis-ci.org/Mobilpadde/tinylog.svg?branch=master)](https://travis-ci.org/Mobilpadde/tinylog)

<p align="center">
<img src="images/light.png?raw=true" alt="Sample Light Image">
<img src="images/dark.png?raw=true" alt="Sample Dark Image">
</p>

<p align="center">
<img src="images/toggle.gif?raw=true" alt="Sample Animated Image">
</p>

## Requirements

 * Global deps:
    * [nim](https://nim-lang.org/) can also be installed using [choosenim](https://github.com/dom96/choosenim)
    * [twurl](https://github.com/twitter/twurl) ([guide](https://medium.com/@SamSchmir/a-guide-to-the-twitter-api-and-twurl-8711466a0635))
    * [Firefox](https://www.mozilla.org/en-US/firefox/new/) - for headless screenshots
 * Local packages can be installed by running `make deps` in your terminal.

### twitter

You'll then need to authorize twurl by in your terminal of your choice.

```sh
CON_KEY=TW_CONSUMER_KEY CON_SECRET=TW_CONSUMER_SECRET make auth
```

That's it!

### hooks

You'd point your github/gitlab hooks to `http://changelog.MY-DOMAIN.TLD/githook` (You'd reverse proxy from localhost:4000, this can be done using [nginx](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy))

## Start

Compile the tool by:

```sh
make compile
```

Run on port `4000` (also w/ a repo path, if you dare):

```sh
./tinylog -p:4000 -d:~/repos/tinylog -t:23
```

_OR_

Run `make run` to compile and run directly still on port `4000`.

---

If you run it with a path to any repo, it'll fetch all the commits since yesterday, put them in the `data`-folder and tweet it out at 11pm, as specified below. 

---

It'll handle everything for you 😍

You can now start enjoying tinylog 😇

## CLI Options

 * `p`, `port`: `int` - any port to start the server on.
    * std: `4000`
 * `d`, `dir`, `directory`: `path` - specify which repo-path to look at.
    * std: `""`
 * `t`, `time`: `int` - any number between `0` & `23`. Which will then correspond to what time to fetch data and tweet it.
    * std: `23`
    * Also, take a look at the [Post Scriptum](#post-scriptum).
 * `dump` - dump the image and quit
 * `tweet` - same as above, but tweet before quit

## How it works

You commit as usual and it'll tweet your commits every day at 11pm, as an image. Easy as that!

### Paths

Tinylog exposes some url-paths from standard:

#### GET

 * `/lazy` - for lazy-loading
 * `/all` - to check files exposed to the public
 * `/*` - to every file in the static folder

#### POST
 * `/githook` - for when a new commit is pushed
 * `/next` - fetch the next entry
    * body should be in the format of `yyyymmdd`
 * `/prev` - fetch the previous entry
    * body should be in the format of `yyyymmdd`
 * `/newest` - ___[REMOVED]___ fetch the newest log-entry-name
 * `/*` - a json msg

## API

To make a new entry in your logs simply in your git commit:

<pre>
```
@fix
  Did __this__ thing, that fixed _that_ broken [thing](https://example.com)
```
</pre>

Or create/edit the files in `site/data` using the pattern `yyyymmdd.tl`, using that same structure, though, you should omit the back-ticks.

The `@fix` is probably the most importan thing, it's like tags for what you've done. Thus far you can choose from:

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

## Post Scriptum

If you use the cli-opt `d`, `dir` or `directory`, you'd **not** connect your repo to the hook. This tool **will** handle that for you. By checking the local repo, and fetching the commits from that.

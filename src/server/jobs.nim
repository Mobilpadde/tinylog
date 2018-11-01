import json, strutils, os, osproc, times, threadpool, httpclient, json
{.experimental.}

const dirs = @[
    "site",
    "site/data",
    "site/dumps",
    "site/static"
]

const files = @[
    "lazy.js",
    "main.css",
]

const staticFile = "site/static/files.json"
const patternDir = "site/data/*.tl"

proc makeStructure*() =
    for d in dirs:
        if not dirExists(d):
            createDir(d)

proc makeFilesJson*() =
    var files = newSeq[string]()
    for f in walkPattern(patternDir):
        let name = f.extractFilename()
        files.add(name.substr(0, name.len() - 4))

    writeFile(staticFile, $ %* {
        "files": files,
    })

proc makeFiles*() =
    var shouldMake = false
    
    for f in files:
        shouldMake = not fileExists("$1/$2" % [dirs[3], f])

        if shouldMake:
            break

    if shouldMake:
        discard execCmd "make statics"

    makeFilesJson()

proc fetchCommits*(path, port: string) = 
    if dirExists(path):
        let (commits, _) = execCmdEx "cd $1; git --no-pager log --pretty=%b --since yesterday" % path
        let body = %* {
            "commits": [
                {
                    "message": %*commits
                }
            ]
        }

        let c = newHttpClient()
        c.headers = newHttpHeaders({ "Content-Type": "application/json" })

        let address = "http://localhost:$1/githook" % port
        let resp = c.request(address, httpMethod = HttpPost, body = $body)

        discard execCmd("PORT=$1 make dump" % port)

proc tweetDump*() =
    discard execCmd("make tweet")

proc sleeper(port, path: string, time: int) =
    let wait = convert(Hours, Milliseconds, 1)
    while true:
        sleep(wait)
        
        if now().hour == time:
            fetchCommits(path, port)
            tweetDump()

proc queueDumpAndTweet*(port, path: string, time: int = 23) =
    spawn sleeper(port, path, time)

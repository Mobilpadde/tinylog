import asynchttpserver, asyncdispatch, json, nre, os, strutils

import ../tinyparser/tiny

const dataDir = "site/data"
const staticDir = "site/static"

proc singleHandler(path: string): (HttpCode, string, HttpHeaders) {.gcsafe.} =
    var status = Http200
    let headers = newHttpHeaders([("Content-Type", "text/html")])
    
    var log = ""
    try:
        let f = readFile("$1/$2.tl" % [dataDir, path]).split(re"\n")
        log = tiny.parse(f)
    except:
        status = Http404

    return (status, log, headers)

proc staticHandler(path: string): (HttpCode, string, HttpHeaders) {.gcsafe.} =
    var status = Http200
    var headers = newHttpHeaders([("Content-Type", "text/css")])

    var file = ""
    try:
        file = readFile(staticDir & path)
    except:
        status = Http404

    return (status, file, headers)

proc mainHandler*(req: Request) {.async.} =
    let fileRe = re"^(?:\/log\/(\d+))\/?$"
    let file = req.url.path.replace(fileRe, "$1")

    if file.len() == 8:# and isAlphaNumeric(file):
        let (status, msg, headers) = singleHandler(file)
        await req.respond(status, msg, headers)
    else:
        var (status, txt, headers) = staticHandler(file)

        if status == Http404:
            let msg = %* {"error": "not found"}
            let headers = newHttpHeaders([("Content-Type", "application/json")])
            await req.respond(status, $msg, headers)
        else:
            await req.respond(status, txt, headers)

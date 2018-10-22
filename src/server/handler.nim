import asynchttpserver, asyncdispatch, json, nre, os, strutils

import ../tinyparser/tiny

const dataDir = "data"

proc singleHandler(file: string): (HttpCode, string, HttpHeaders) {.gcsafe.} =
    let status = Http200
    let headers = newHttpHeaders([("Content-Type", "text/html")])

    var f = readFile("$1/$2.tl" % [dataDir, file])
    let log = tiny.parse(f)

    return (status, log, headers)

proc mainHandler*(req: Request) {.async.} =
    let fileRe = re"^(?:\/log\/(\d+))\/?$"
    let file = req.url.path.replace(fileRe, "$1")

    if file.len() == 8:
        let (status, msg, headers) = singleHandler(file)
        await req.respond(status, msg, headers)
    else:
        let msg = %* {"error": "not found"}
        let headers = newHttpHeaders([("Content-Type", "application/json")])
        await req.respond(Http404, $msg, headers)

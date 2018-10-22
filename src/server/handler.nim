import asynchttpserver, asyncdispatch, json, nre

import ../tinyparser/tiny

proc singleHandler(file: string): (HttpCode, string, HttpHeaders) {.gcsafe.} = 
    let status = Http200
    let headers = newHttpHeaders([("Content-Type", "text/html")])

    let log = tiny.parse("""
    @fix
        Lulz - _this_ has been fixed.
    @anouncement
        We've got __this__ new thing!
    @improvement
        We've got [improved](https://tinylog.xyz).
    """)

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

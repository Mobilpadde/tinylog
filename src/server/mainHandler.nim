import asynchttpserver, asyncdispatch, json, nre, strutils

import
    handlers/singleHandler,
    handlers/staticHandler,
    handlers/jsonHandler,
    handlers/errorHandler

proc handler*(req: Request) {.async.} =
    let fileRe = re"^(?:\/log\/(\d+))\/?$"
    let file = req.url.path.replace(fileRe, "$1")

    if req.reqMethod == HttpGet:
        if file.len() == 8:# and isAlphaNumeric(file):
            let (status, msg, headers) = singleHandler(file)
            await req.respond(status, msg, headers)
        else:
            var (status, txt, headers) = staticHandler(file)

            if status == Http404:
                var (status, msg, headers) = errorHandler(file)
                await req.respond(status, msg, headers)
            else:
                await req.respond(status, txt, headers)
    elif req.reqMethod == HttpPost:
        var (status, body, headers) = jsonHandler(file)
        await req.respond(status, body, headers)

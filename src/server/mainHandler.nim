import asynchttpserver, asyncdispatch, json, nre, strutils

import ../tinyparser/tiny

import
    handlers/singleHandler,
    handlers/staticHandler,
    handlers/commitHandler,
    handlers/errorHandler,
    handlers/filesHandler,
    handlers/jsonHandler,
    handlers/lazyHandler

proc handler*(req: Request) {.async.} =
    let fileRe = re"^(?:\/log\/(\d+))\/?$"
    let file = req.url.path.replace(fileRe, "$1")

    if req.reqMethod == HttpGet:
        if file.len() == 8 and isDigit(file):
            let (status, msg, headers) = singleHandler(file)
            await req.respond(status, msg, headers)
        else:
            case req.url.path:
                of "/lazy":
                    let (status, msg, headers) = lazyHandler(file)
                    await req.respond(status, msg, headers)
                of "/all":
                    let (status, msg, headers) = filesHandler(fileType.all)
                    await req.respond(status, msg, headers)
                else:
                    let (status, txt, headers) = staticHandler(file)

                    if status == Http404:
                        var (status, msg, headers) = errorHandler(file)
                        await req.respond(status, msg, headers)
                    else:
                        await req.respond(status, txt, headers)
    elif req.reqMethod == HttpPost:
        case req.url.path:
            of "/githook":
                let (status, data, headers) = commitHandler(req.body)
                await req.respond(status, data, headers)
            of "/next":
                let (status, msg, headers) = filesHandler(fileType.next, req.body)
                await req.respond(status, msg, headers)
            of "/prev":
                let (status, msg, headers) = filesHandler(fileType.previous, req.body)
                await req.respond(status, msg, headers)
            else:
                var (status, body, headers) = jsonHandler(file)
                await req.respond(status, body, headers)

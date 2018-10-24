import asynchttpserver

const staticDir = "site/static"

proc staticHandler*(path: string): (HttpCode, string, HttpHeaders) {.gcsafe.} =
    var status = Http200
    var headers = newHttpHeaders([("Content-Type", "text/css")])

    var file = ""
    try:
        file = readFile(staticDir & path)
    except:
        status = Http404

    return (status, file, headers)

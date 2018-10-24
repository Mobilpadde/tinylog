import asynchttpserver, strutils

const staticDir = "site/static"

proc determType(path: string): string =
    let exts = path.split('.')

    case exts[exts.len() - 1]:
        of "js":
            return "application/javascript"
        of "css":
            return "text/css"
        else:
            return "text/plain"

proc staticHandler*(path: string): (HttpCode, string, HttpHeaders) {.gcsafe.} =
    var status = Http200
    var headers = newHttpHeaders([("Content-Type", determType(path))])
    echo path
    echo headers

    var file = ""
    try:
        file = readFile(staticDir & path)
    except:
        status = Http404

    return (status, file, headers)

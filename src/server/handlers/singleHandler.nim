import asynchttpserver, nre, strutils

import ../../tinyparser/tiny

const dataDir = "site/data"

proc singleHandler*(path: string): (HttpCode, string, HttpHeaders) {.gcsafe.} =
    var status = Http200
    let headers = newHttpHeaders([("Content-Type", "text/html")])
    
    var log = ""
    try:
        let f = readFile("$1/$2.tl" % [dataDir, path]).split(re"\n")
        let date = path.replace(re"(?:(\d{4})(\d{2})(\d{2}))", "$2/$3/$1")
        log = tiny.parse(f, date)
    except:
        status = Http404

    return (status, log, headers)

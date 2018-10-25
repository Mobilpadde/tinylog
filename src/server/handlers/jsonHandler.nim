import asynchttpserver, json

proc jsonHandler*(body: string): (HttpCode, string, HttpHeaders) {.gcsafe.} =
    let headers = newHttpHeaders([("Content-Type", "application/json")])
    let d = %* {"msg": body}

    return (Http200, $d, headers)

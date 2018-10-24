import asynchttpserver, json

proc errorHandler*(body: string): (HttpCode, string, HttpHeaders) {.gcsafe.} =
    let msg = %* {"error": "not found"}
    let headers = newHttpHeaders([("Content-Type", "application/json")])

    return (Http404, $msg, headers)

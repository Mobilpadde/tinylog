import asynchttpserver, nre, strutils

import ../../tinyparser/tiny

proc lazyHandler*(path: string): (HttpCode, string, HttpHeaders) {.gcsafe.} =
    var status = Http200
    let headers = newHttpHeaders([("Content-Type", "text/html")])

    return (status, tiny.html(@[
        "",
        "",
        "<script src=\"/lazy.js\"></script>",
    ]), headers)

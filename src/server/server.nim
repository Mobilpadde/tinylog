import asynchttpserver, asyncdispatch

import mainHandler

let server = newAsyncHttpServer()

proc start*(portInt: uint16) {.gcsafe.} =
    let port = Port(portInt)
    waitFor server.serve(port, mainHandler.handler)

proc stop*() =
    server.close()

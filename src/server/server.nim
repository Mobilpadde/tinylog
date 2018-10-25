import asynchttpserver, asyncdispatch

import mainHandler, makeFiles

let server = newAsyncHttpServer()

proc start*(portInt: uint16) {.gcsafe.} =
    makeFilesJson()
    
    let port = Port(portInt)
    waitFor server.serve(port, mainHandler.handler)

proc stop*() =
    server.close()

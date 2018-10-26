import asynchttpserver, asyncdispatch

import mainHandler, makes

let server = newAsyncHttpServer()

proc start*(portInt: uint16) {.gcsafe.} =
    makeStructure()
    makeFiles()
    
    let port = Port(portInt)
    waitFor server.serve(port, mainHandler.handler)

proc stop*() =
    server.close()

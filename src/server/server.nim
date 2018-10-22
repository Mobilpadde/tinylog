import asynchttpserver, asyncdispatch

import  handler

proc start*(portInt: uint16) =
    let port = Port(portInt)
    
    let server = newAsyncHttpServer()
    waitFor server.serve(port, handler.mainHandler)

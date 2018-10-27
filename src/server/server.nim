import asynchttpserver, asyncdispatch, strscans

import mainHandler, jobs

let server = newAsyncHttpServer()

proc start*(portStr: string) {.gcsafe.} =
    makeStructure()
    makeFiles()

    queueDumpAndTweet()

    var portInt: int
    discard scanf(portStr, "$i", portInt)

    let port = Port(portInt)
    let server = newAsyncHttpServer()

    waitFor server.serve(port, mainHandler.handler)

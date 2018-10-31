import asynchttpserver, asyncdispatch, strscans, threadpool

import mainHandler, jobs

let server = newAsyncHttpServer()

proc start*(portStr, repoPath: string = "") {.gcsafe.} =
    makeStructure()
    makeFiles()

    queueDumpAndTweet(portStr, repoPath)

    var portInt: int
    discard scanf(portStr, "$i", portInt)

    let port = Port(portInt)
    let server = newAsyncHttpServer()

    waitFor server.serve(port, mainHandler.handler)

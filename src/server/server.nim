import asynchttpserver, asyncdispatch, strscans, threadpool

import mainHandler, jobs

let server = newAsyncHttpServer()

proc start*(portStr, repoPath, timeStr: string = "") {.gcsafe.} =
    makeStructure()
    makeFiles()

    var timeInt: int = 23
    discard scanf(timeStr, "$i", timeInt)

    queueDumpAndTweet(portStr, repoPath, timeInt)

    var portInt: int
    discard scanf(portStr, "$i", portInt)

    let port = Port(portInt)
    let server = newAsyncHttpServer()

    waitFor server.serve(port, mainHandler.handler)

import asynchttpserver, asyncdispatch, strscans, threadpool, os, times

import mainHandler, jobs

let server = newAsyncHttpServer()

proc dumpTweet(dump, tweet: bool = false, repoPath, portStr: string) =
    sleep convert(Seconds, Milliseconds, 2)

    if dump:
        fetchCommits(repoPath, portStr)
    if tweet:
        tweetDump()
    
    if dump or tweet:
        quit(0)

proc start*(
    portStr,
    repoPath,
    timeStr: string = "",
    dump,
    tweet: bool = false
) {.gcsafe.} =
    makeStructure()
    makeFiles()

    var timeInt: int = 23
    discard scanf(timeStr, "$i", timeInt)

    queueDumpAndTweet(portStr, repoPath, timeInt)

    var portInt: int = 4000
    discard scanf(portStr, "$i", portInt)

    let port = Port(portInt)
    let server = newAsyncHttpServer()

    spawn dumpTweet(dump, tweet, repoPath, portStr)
    waitFor server.serve(port, mainHandler.handler)
    runForever()

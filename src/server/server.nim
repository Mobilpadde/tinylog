import asynchttpserver, asyncdispatch, json, os

import mainHandler

const staticFile = "site/static/files.json"
const patternDir = "site/data/*.tl"

let server = newAsyncHttpServer()

proc start*(portInt: uint16) {.gcsafe.} =
    var files = newSeq[string]()
    for f in walkPattern(patternDir):
        let name = f.extractFilename()
        files.add(name.substr(0, name.len() - 4))

    writeFile(staticFile, $ %* {
        "files": files,
    })
    
    let port = Port(portInt)
    waitFor server.serve(port, mainHandler.handler)

proc stop*() =
    server.close()

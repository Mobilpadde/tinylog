import os, httpclient, json

import server/server

server.start(8080)

setControlCHook(proc() {.noconv.} =
    server.stop()
)

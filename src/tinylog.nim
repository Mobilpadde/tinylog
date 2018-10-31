import os, httpclient, json, asyncdispatch, parseopt

import server/server

var port, path = ""

var p = initOptParser()
for kind, key, val in p.getopt():
    if kind == cmdLongOption or kind == cmdShortOption:
        case key:
            of "port", "p":
                port = val
            of "directory", "dir", "d":
                path = val

server.start(port, path)
runForever()

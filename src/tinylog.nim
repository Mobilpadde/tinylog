import os, asyncdispatch, parseopt

import server/server

var port, path, time = ""
var dump, tweet = false

var p = initOptParser()
for kind, key, val in p.getopt():
    if kind == cmdLongOption or kind == cmdShortOption:
        case key:
            of "port", "p":
                port = val
            of "directory", "dir", "d":
                path = val
            of "time", "t":
                time = val
            of "dump":
                dump = true
            of "tweet":
                tweet = true

server.start(port, path, time, dump, tweet)

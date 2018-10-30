import os, httpclient, json, asyncdispatch

import server/server

server.start(paramStr(1))

runForever()

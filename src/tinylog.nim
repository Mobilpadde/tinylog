import os, httpclient, json, asyncdispatch

import server/server

server.start(paramStr(1), if paramCount() > 1: paramStr(2) else: "")

runForever()

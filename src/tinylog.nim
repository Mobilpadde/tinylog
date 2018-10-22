import os

import server/server

if paramStr(1) == "-s":
    server.start(8080)
elif paramStr(1) == "-a":
    echo paramStr(1)

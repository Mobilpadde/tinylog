import asynchttpserver, json, os, strutils, nre, sequtils, times

import ../makes

const dataDir = "site/data"

proc gitCommit(body: string): (HttpCode, string) =
    try:
        let node = parseJson(body)
        return (Http200, $node["commits"][0]["message"])
    except:
        return (Http500, "👎")

proc commitHandler*(body: string): (HttpCode, string, HttpHeaders) {.gcsafe.} =
    let headers = newHttpHeaders([("Content-Type", "text/plain")])
    var (status, data) = gitCommit(body)

    if status == Http500:
        return (status, data, headers)

    data = data.replace(re"[@\w\s\t\n\\n]*```[(?:\\n)\n]*([@\w\s\t\n\\n]*)[\\n\n]*```[@\w\s\t\n\\n]*", "$1")

    if data.substr(0, 1) == "\\n":
        data = data.substr(1)

    let
        name = "$1/$2.$3" % [dataDir, format(now(), "yyyyMMdd"), "tl"]
        newLines = data.unescape().split("\\n")

    try:
        let
            f = open(name, fmAppend)
        for l in newLines:
            f.writeLine(l)
        f.close()
    except:
        writeFile(name, "")
        let f = open(name, fmWrite)
        for l in newLines:
            f.writeLine(l)
        f.close()

    makeFilesJson()

    return (status, "👍", headers)

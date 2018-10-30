import asynchttpserver, json, strscans, strutils, algorithm, sequtils

import jsonHandler

const staticFile = "site/static/files.json"

type fileType* = enum
    next, previous, all

proc filesHandler*(fType: fileType, curr: string = ""): (HttpCode, string, HttpHeaders) {.gcsafe.} =
    var status = Http200
    var data = ""

    try:
        let x = readFile(staticFile)

        case fType:
            of fileType.all:
                let len = parseJson(x)["files"].len()
                let dArr = parseJson(x)["files"].toSeq()
                let rev = dArr.toOpenArray(0, len - 1).reversed()
                data = $ %* rev
            of fileType.next:
                let dat = parseJson(x)["files"]
                var next = $dat[0]

                var currInt: int
                discard scanf(curr, "$i", currInt)

                var dInt: int
                for idx in 0..<dat.len():
                    discard scanf(unescape($dat[idx]), "$i", dInt)
                    if currInt < dInt:
                        next = $dat[idx]
                        break
                data = next

                if currInt >= dInt:
                    status = Http404
                    data = "-1"

            of fileType.previous:
                let dat = parseJson(x)["files"].toSeq().reversed()
                var prev = $dat[0]

                var currInt: int
                discard scanf(curr, "$i", currInt)

                var dInt: int
                for idx in 0..<dat.len():
                    discard scanf(unescape($dat[idx]), "$i", dInt)
                    if currInt > dInt:
                        prev = $dat[idx]
                        break
                data = prev

                if currInt <= dInt:
                    status = Http404
                    data = "-1"
            else:
                status = Http404
                data = "-1"
    except:
        status = Http500
        data = "-1"

    let headers = newHttpHeaders([("Content-Type", "application/json")])
    return (status, data, headers)
    
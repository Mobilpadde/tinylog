import json, os

const staticFile = "site/static/files.json"
const patternDir = "site/data/*.tl"

proc makeFilesJson*() =
    var files = newSeq[string]()
    for f in walkPattern(patternDir):
        let name = f.extractFilename()
        files.add(name.substr(0, name.len() - 4))

    writeFile(staticFile, $ %* {
        "files": files,
    })

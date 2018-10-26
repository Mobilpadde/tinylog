import json, strutils, os, osproc

const dirs = @[
    "site",
    "site/data",
    "site/dumps",
    "site/static"
]

const files = @[
    "lazy.js",
    "main.css",
]

const staticFile = "site/static/files.json"
const patternDir = "site/data/*.tl"

proc makeStructure*() =
    for d in dirs:
        if not dirExists(d):
            createDir(d)

proc makeFilesJson*() =
    var files = newSeq[string]()
    for f in walkPattern(patternDir):
        let name = f.extractFilename()
        files.add(name.substr(0, name.len() - 4))

    writeFile(staticFile, $ %* {
        "files": files,
    })

proc makeFiles*() =
    var shouldMake = false
    
    for f in files:
        shouldMake = not fileExists("$1/$2" % [dirs[3], f])

        if shouldMake:
            break

    if shouldMake:
        discard execCmd "make statics"

    makeFilesJson()

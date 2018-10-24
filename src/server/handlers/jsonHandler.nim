import asynchttpserver, json

proc gitCommit(body: string): JsonNode =
    let node = parseJson(body)
    return node["commits"]

proc jsonHandler*(body: string): (HttpCode, string, HttpHeaders) {.gcsafe.} =
    let headers = newHttpHeaders([("Content-Type", "application/json")])
    let data = $gitCommit(body)

    return (Http200, data, headers)

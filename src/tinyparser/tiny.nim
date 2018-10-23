import sequtils, nre, strutils

import types

proc parse*(lines: seq[string]): string {.gcsafe.} =
    return """
        <html>
            <head>$2</head>
            <body><h1>Latest Changes</h1><ul>$1</ul></body>
        </html>
    """ % [
        types.parse(lines),
        "<link rel=\"stylesheet\" href=\"/main.css\">",
    ]

import sequtils, nre, strutils

import types

proc parse*(lines: seq[string]): string {.gcsafe.} =
    return """
        <html>
            <head>
                <meta charset="utf-8">
                <title>tinylog</title>
                <link rel="stylesheet" href="/main.css">
            </head>
            <body>
                <div id="tinylog">
                    <b class="changes">Changes</b>
                    <ul>$1</ul>
                    <a class="log" href="$2" target="_blank">Changelog</a>
                </div>
            </body>
        </html>
    """ % [
        types.parse(lines),
        "https://changes.tinylog.xyz"
    ]

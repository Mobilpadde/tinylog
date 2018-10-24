import sequtils, nre, strutils

import types

proc html*(replacers: seq[string]): string {.gcsafe.} =
    return """
        <html>
            <head>
                <meta charset="utf-8">
                <title>tinylog</title>
                <link rel="stylesheet" href="/main.css">
            </head>
            <body>
                <div id="tinylog">
                    <b id="changes">Changes</b>
                    <ul id="list">$1</ul>
                    <a id="log" href="$2" target="_blank">Changelog</a>
                </div>
                $3
            </body>
        </html>
    """ % replacers

proc parse*(lines: seq[string]): string {.gcsafe.} =
    html(@[
        types.parse(lines),
        "https://changes.tinylog.xyz",
        ""
    ])

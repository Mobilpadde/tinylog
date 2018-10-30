import sequtils, nre, strutils
from htmlgen import nil

import types

proc layout(hc, bc, bclass: string = ""): string =
    let meta8 = htmlgen.meta(charset="utf-8")
    let title = htmlgen.title("tinylog")
    let css = htmlgen.link(rel="stylesheet", href="/main.css")

    let head = htmlgen.head(meta8, title, css, hc)
    let body = htmlgen.body(class=bclass, bc)

    htmlgen.html(head, body)

proc single*(lines: seq[string], dates: seq[string], fin: string, colorMode: string = "light"): string {.gcsafe.} =
    let holder = htmlgen.`div`(id="tinylog",
        htmlgen.b(id="changes", "Changes"), 
        "<ul id=\"list\">$1$2$3</ul>" % [
            "<a href=\"/log/$1\" data-date=\"$1\" class=\"date\">$2</a>" % dates,
            types.parse(lines),
            "<span class=\"date\">$1</span>" % [fin],
        ],
        htmlgen.span(id="log",
            htmlgen.a(id="prev", "&laquo;"),
            htmlgen.a(href="/lazy", target="_blank", "Changelog"),
            htmlgen.a(id="next", "&raquo;"),
        ),
        htmlgen.script(src="/single.js")
    )

    return layout("", holder, colorMode)

proc lazy*(colorMode: string = "light"): string {.gcsafe.} =
    let holder = htmlgen.`div`(id="tinylog",
        htmlgen.b(id="changes", "Changes"), 
        "<ul id=\"list\"></ul>",
        htmlgen.a(id="log", href="/lazy", target="_blank", "Changelog"),
        htmlgen.script(src="/lazy.js")
    )

    return layout("", holder, colorMode)

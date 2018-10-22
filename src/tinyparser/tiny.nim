import sequtils, nre, strutils

import types

proc parse*(text: string): string {.gcsafe.} =
    return "<ul>$1</ul>" % [types.parse(text)]

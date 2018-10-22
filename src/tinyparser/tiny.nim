import sequtils, nre, strutils

import types

let matchers = @[types.matcher]
let replacers = @[types.replacer] 

let zipped = sequtils.zip(matchers, replacers)

proc parse*(text: string): string =
    result = text
    for processor in zipped:
        let (matcher, replacer) = processor
        result = nre.replace(result, matcher, replacer)

    return "<ul>$1</ul>" % [result]

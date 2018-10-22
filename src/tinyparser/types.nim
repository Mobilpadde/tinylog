import nre, strutils, sequtils

import emphasis

let matcher = re"(?:(?:\@(\w+))(?:\s+(.+)))"

proc replacer(m: RegexMatch): string =
    let thing = toUpperAscii(m.captures[0])
    result = m.captures[1]
    for processor in zip(emphasis.matchers, emphasis.replacers):
        let (matcher, replacer) = processor
        result = nre.replace(result, matcher, replacer)

    return "<li><span>$1</span><p>$2</p></li>" % [thing, result]

proc parse*(text: string): string =
    nre.replace(text, matcher, replacer)

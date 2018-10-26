import nre, strutils, sequtils

import emphasis

type
    Log = object
        thing, text: string

let thingMatcher = re"@(\w+)"
let wholeThingMatcher = re"@(\w+)"

proc parse*(lines: seq[string]): string =
    var logs = @[
        Log(thing: "bug"),
        Log(thing: "fix"),
        Log(thing: "new"),
    ]

    var current = 0
    for line in lines:
        let ln = line.replace("\n", "")
        if ln.find(thingMatcher).isSome():
            let thing = ln
                .replace(re".*(?=@)", "")
                .replace(thingMatcher, "$1")
                .toLowerAscii()

            case thing:
                of "bug":
                    current = 0
                of "fix":
                    current = 1
                of "new":
                    current = 2
        else:
            var res = ln.replace(re"([\\\n]\s?)+", "")
            for processor in zip(emphasis.matchers, emphasis.replacers):
                let (matcher, replacer) = processor
                res = nre.replace(res, matcher, replacer)
            logs[current].text &= res & "<br/>"

    result = ""
    for l in logs:
        if l.text.len() > 0:
            result &= "<li class=\"$1\"><span class=\"$1\">$1</span><p>$2</p></li>" % [
                l.thing,
                l.text,
            ]

    return result

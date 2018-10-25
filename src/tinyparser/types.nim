import nre, strutils, sequtils

import emphasis

type
    Log = object
        thing, text: string

let thingMatcher = re"@(\w+)"
let wholeThingMatcher = re"@(\w+)"

proc parse*(lines: seq[string]): string =
    var logs = newSeq[Log]()
    for line in lines:
        let ln = line.replace("\n", "")
        if ln.find(thingMatcher).isSome():
            var l = Log(
                thing: ln
                    .replace(re".*(?=@)", "")
                    .replace(thingMatcher, "$1")
                )

            logs.add(l)
        else:
            var res = ln.replace(re"([(\\)\n]\s?)+", "")
            for processor in zip(emphasis.matchers, emphasis.replacers):
                let (matcher, replacer) = processor
                res = nre.replace(res, matcher, replacer)
            logs[logs.len() - 1].text &= res & "<br/>"

    result = ""
    for l in logs:
        result &= "<li class=\"$1\"><span class=\"$1\">$1</span><p>$2</p></li>" % [
            l.thing,
            l.text,
        ]

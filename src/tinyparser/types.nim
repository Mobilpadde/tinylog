import nre, strutils, sequtils

import emphasis

type
    Log = object
        thing, text: string

let thingMatcher = re"@\w+"

proc parse*(lines: seq[string]): string =
    var logs = newSeq[Log]()
    for line in lines:
        if line.match(thingMatcher).isSome():
            let l = Log(thing: line.replace("@", ""))
            logs.add(l)
        else:
            var res = line
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

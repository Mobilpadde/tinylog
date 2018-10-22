import nre, strutils

let matcher* = re"(?:(?:\@(\w+))(?:\s+(.+)))"

proc replacer*(m: RegexMatch): string =
    return "<li><span>$1</span><p>$2</p></li>" % [m.captures[0], m.captures[1]]

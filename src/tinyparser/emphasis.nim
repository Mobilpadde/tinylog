import nre, strutils

let boldMatcher     = re"(\*\*|__)(.*?)\1"
let codeMatcher     = re"`(.*?)`"
let emphasisMatcher = re"(\*|_)(.*?)\1"
let linkMatcher     = re"\[([^\[]+)\]\(([^\)]+)\)"
let strikeMatcher   = re"\~\~(.*?)\~\~"

proc boldReplacer(m: RegexMatch): string = 
    "<strong>$1</strong>" % [m.captures[1]]

proc emphasisReplacer(m: RegexMatch): string = 
    "<em>$1</em>" % [m.captures[1]]

proc strikeReplacer(m: RegexMatch): string = 
    "<del>$1</del>" % [m.captures[0]]

proc codeReplacer(m: RegexMatch): string = 
    "<code>$1</code>" % [m.captures[0]]

proc linkReplacer(m: RegexMatch): string = 
    "<a href=\"$2\" target=\"_blank\">$1</a>" % [m.captures[0], m.captures[1]]

proc getMatchers*(): seq[Regex] =
    @[
        re"(\*\*|__)(.*?)\1",
        re"`(.*?)`",
        re"(\*|_)(.*?)\1",
        re"\[([^\[]+)\]\(([^\)]+)\)",
        re"\~\~(.*?)\~\~",
    ]

let replacers* = [
    boldReplacer,
    codeReplacer,
    emphasisReplacer,
    linkReplacer,
    strikeReplacer,
]

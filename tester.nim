import src/tinyparser/tiny

#@fix
#    Lulz - this has been fixed.
#
#@anouncement
#	We've got this new thing!
#
#@improvement
#	We've got improved.

echo tiny.parse("""
@fix
    Lulz - _this_ has been fixed.
@anouncement
    We've got __this__ new thing!
@improvement
	We've got [improved](https://tinylog.xyz).
""")

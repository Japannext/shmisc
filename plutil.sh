plist_get() {
	python << __EOF__
import plistlib, sys
data = plistlib.readPlist("$1")
key = "$2".lstrip("/").split("/")
while key:
	part = key.pop(0)
	if isinstance(data, list):
		part = int(part)
	data = data[part]
if isinstance(data, list) or isinstance(data, dict):
	sys.exit(1)
print data
__EOF__
}

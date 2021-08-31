# Copyright 2021 Japannext Co., Ltd. <https://www.japannext.co.jp/>
# SPDX-License-Identifier: Apache-2.0

plist_get() {
	python2 << __EOF__
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

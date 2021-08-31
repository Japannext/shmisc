#!/usr/bin/env python
#
# Copyright 2021 Japannext Co., Ltd. <https://www.japannext.co.jp/>
# SPDX-License-Identifier: Apache-2.0

from __future__ import print_function
import errno
import getopt
import os
import re
import sys

shcode = re.compile("%%(.*)%%")
include_paths = []
macro_vars = {}


def print_usage():
	print("shproc [-Idir...] [-Dmacro=defn...] file")

def print_msg(fmt, *args):
	print("shproc: " + fmt % args, file=sys.stderr)

def do_expand(s):
	try:
		return macro_vars[s]
	except KeyError:
		raise Exception("%s: Undefined macro" % (s,))

def do_include(s):
	for path in include_paths:
		try:
			return file(os.path.join(path, s)).read()
		except IOError as e:
			if e.errno == errno.ENOENT:
				continue
			raise
	raise Exception("%s: No such file found" % (s,))

ops = {':': do_expand, '<': do_include }


try:
	opts, args =  getopt.getopt(sys.argv[1:], "I:D:")
except getopt.GetoptError as e:
	print_msg("%s", e)
	print_usage()
	sys.exit(1)

for o,a in opts:
	if o == "-I":
		include_paths.append(a)
	elif o == "-D":
		var, value = a.split('=',1)
		macro_vars[var] = value

try:
	outfile_name = None
	nargs = len(args)
	if nargs == 0:
		print_usage()
		sys.exit()
	elif nargs == 1:
		infile = file(args[0], 'r')
		outfile = sys.stdout
	elif nargs == 2:
		infile = file(args[0], 'r')
		outfile_name = args[1]
		outfile = file(outfile_name, 'w')
	else:
		raise Exception("Too many input files")

	for lineno, line in enumerate(infile):
		m = shcode.search(line)
		if m:
			shargs = m.group(1)
			try:
				line = line[:m.start()] + ops[shargs[0]](shargs[1:]) + line[m.end():]
			except KeyError:
				raise Exception("line %d: Invalid preprocessing opcode" % (lineno,))
			except Exception as e:
				raise Exception("line %d: %s" % (lineno, e))
		print(line, file=outfile, end='')
	sys.exit()
except IOError as e:
	print_msg("%s: %s" % (e.filename, e.strerror))
except Exception as e:
	print_msg("%s", e)

if outfile_name:
	os.remove(outfile_name)
sys.exit(1)

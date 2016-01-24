#!/usr/bin/python3

import sys, subprocess, re, os

CLASS_RE = re.compile('\\.[A-Z][a-zA-Z0-9_]+')

def dumpJAR(path):
	proc = subprocess.Popen(['jar', 'tf', path], stdout = subprocess.PIPE)
	while True:
		line = proc.stdout.readline().decode('utf-8')
		if not len(line):
			break
		line = line.rstrip('\r\n')
		dumpType(line)
	status = proc.wait()
	if status:
		sys.exit(status)

def dumpType(qname):
	if not qname.endswith('.class'):
		return
	qname = qname[:-6].replace('/', '.')
	m = CLASS_RE.search(qname)
	if m and m.end() == len(qname):
		print(qname)

if len(sys.argv) < 2:
	sys.stderr.write('Usage: ' + os.path.basename(sys.argv[0]) + ' jarfile...\n')
	sys.exit(1)
for f in sys.argv[1:]:
	dumpJAR(f)

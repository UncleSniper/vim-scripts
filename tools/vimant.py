#!/usr/bin/python3

import re, sys, subprocess, os

TARGET_RE = re.compile('^([a-zA-Z0-9_-]+):$')
ERRMSG_RE = re.compile('^    \\[javac\\] (.*\\.java):([0-9]+): ([^ ].*)$')
ERRLINE_RE = re.compile('^    \\[javac\\] (.*)$')
ERRCOL_RE = re.compile('^    \\[javac\\] ([ \\t]*)\\^$')

class OutputReader(object):
	ST_NONE = 0
	ST_ERRMSG = 1
	ST_ERRLINE = 2
	def __init__(self):
		self.state = OutputReader.ST_NONE
		self.errpath = self.errline = self.errmsg = self.errcol = ''
	def procLine(self, line):
		if self.state == OutputReader.ST_NONE:
			tm = TARGET_RE.match(line)
			mm = ERRMSG_RE.match(line)
			if tm:
				print(tm.group(1))
			elif mm:
				self.errpath = os.path.relpath(mm.group(1))
				self.errline = mm.group(2)
				self.errmsg = mm.group(3)
				self.errcol = ''
				self.state = OutputReader.ST_ERRMSG
		elif self.state == OutputReader.ST_ERRMSG:
			lm = ERRLINE_RE.match(line)
			cm = ERRCOL_RE.match(line)
			if lm:
				self.state = OutputReader.ST_ERRLINE
			elif cm:
				self.errcol = str(len(cm.group(1)) + 1)
				self.dumpError()
				self.state = OutputReader.ST_NONE
			else:
				self.dumpError()
				self.state = OutputReader.ST_NONE
				self.procLine(line)
		else:
			cm = ERRCOL_RE.match(line)
			if cm:
				self.errcol = str(len(cm.group(1)) + 1)
				self.dumpError()
				self.state = OutputReader.ST_NONE
			else:
				self.dumpError()
				self.state = OutputReader.ST_NONE
				self.procLine(line)
	def dumpError(self):
		msg = '    ' + self.errpath + ':' + self.errline
		if len(self.errcol):
			msg += ':' + self.errcol
		msg += ': ' + self.errmsg
		print(msg)

proc = subprocess.Popen(['ant'], stdout = subprocess.PIPE, stderr = subprocess.STDOUT)
reader = OutputReader()
while True:
	line = proc.stdout.readline().decode('utf-8')
	if not len(line):
		break
	line = line.rstrip('\r\n')
	reader.procLine(line)
status = proc.wait()
sys.exit(status)

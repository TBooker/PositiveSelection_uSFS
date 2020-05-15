## some of the runs timed out on Cedar, so I need to get a count of how many files of each type are in each directory

def file_lengthy(fname):
	with open(fname) as f:
		for i, l in enumerate(f):
			pass
		return i + 1

import glob, sys

for j in glob.glob('Nes*/'): 
	print(j)
	nDiv_full = [file_lengthy(i) for i in glob.glob(j + '/*.nDiv.Be.output')]
	nDiv_full_complete = [i for i in nDiv_full if i > 100]
	print('nDiv_full', len(nDiv_full) ,len(nDiv_full_complete))

	nDiv_dDFE = [file_lengthy(i) for i in glob.glob(j + '/*.nDiv.dDFE.B.output')]
	nDiv_dDFE_complete = [i for i in nDiv_dDFE if i > 100]
	print('nDiv_dDFE', len(nDiv_dDFE) ,len(nDiv_dDFE_complete))

	wDiv_full = [file_lengthy(i) for i in glob.glob(j + '/*.wDiv.Be.output')]
	wDiv_full_complete = [i for i in wDiv_full if i > 100]
	print('wDiv_full', len(wDiv_full) ,len(wDiv_full_complete))

	wDiv_dDFE = [file_lengthy(i) for i in glob.glob(j + '/*.wDiv.dDFE.B.output')]
	wDiv_dDFE_complete = [i for i in wDiv_dDFE if i > 100]
	print('wDiv_dDFE', len(wDiv_dDFE) ,len(wDiv_dDFE_complete))

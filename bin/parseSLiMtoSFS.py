### Let's make a file of Site Frequency Spectra for each "gene" that we simulated 

import glob
import gzip
import argparse
import random
import pandas as pd
import numpy as np
import cPickle as pkl


def SFS_from_all_frequencies(frequencies,N):
	SFS = [0]*(N+1)
	length = len(frequencies)
	for i in frequencies:
		if i > N:
			print "SFS_from_frequencies: Error in your frequencies vector: One of the values is greater than the number of individuals\nThe offending value is: " + str(i) +" and the sample is "+str(N)
			return
		if i > 0 and i <= N:
			SFS[i] += 1
			
	SFS[0] = length - sum(SFS)
	if sum(SFS) < length:
		print"SFS_from_frequencies: Error in your frequencies vector: Fewer items in the SFS than the length of the region"
		return
	if sum(SFS) > length:
		print"SFS_from_frequencies: Error in your frequencies vector: More items in the SFS than the length of the region"
		return
	return SFS

def parseSubstitutions(dataFile):
	df = pd.DataFrame([i.strip().split(' ') for i in gzip.open(dataFile) if not i.startswith('M') and not i.startswith('#')] , columns = ['index','mutID','mutType','pos','s','h','pop','born','fixed'])
	df = df.astype( {'index': 'int64','mutID': 'int64','mutType':'string','pos': 'int64','s': 'float64','h': 'float64','pop':'string','born': 'int64','fixed': 'int64'} )
	return df
	
def parseVCF(dataFile, sample = None):

	flatten = lambda l: [item for sublist in l for item in sublist]
	data = []
	
	for i in gzip.open(dataFile):
		if i.startswith('#'): continue
		line = i.strip().split()
		pos = line[1]
		info = line[7].split(';')
		selCoef = float(info[1].split('=')[1])
		mutType = info[5].split('=')[1]
		
		if not sample:
			alleleFreqs = flatten( [k.split('|') for k in line[9:]] )
		else:
			genotypes = line[9:]
			random.shuffle(genotypes)
			alleleFreqs = flatten( [k.split('|') for k in genotypes[:sample]] )

		data.append( [int(pos), float(selCoef), mutType, alleleFreqs] )

	return pd.DataFrame(data, columns = ['pos', 's', 'mutType','alleleFreqs']), len(alleleFreqs)


## The floowing function assumes that there is a single class of advantageous mutational effects
def summariseSubsOneClass(subsDF):

#	subsDF['gamma'] = subsDF['s'] * 2500 * 2 # Assuming N = 2500

	syn = sum(subsDF['mutType'] == 'm1')

	nonsyn_del = sum(subsDF['mutType'] == 'm2')

	nonsyn_adv = sum(subsDF['mutType'] == 'm3')

	return syn, nonsyn_del, nonsyn_adv 

def getSFS(variants, sampleSize, downsample = None):
	freqs = []
	for v in list(variants.alleleFreqs):
		if downsample == None:
			vx = map(int, v)
		else:
			vx = map(int, np.random.choice(v, downsample, replace=False))
		
		alleleFreq = sum(vx)

		if alleleFreq > len(vx): 
			print 'Something really fucked up'
			return
		freqs.append( alleleFreq )

	return SFS_from_all_frequencies(freqs, sampleSize)

	
def summariseVariantsOneClass(variants, sampleSize, downsample = None):

	synVars = variants[variants['mutType'] == '1'].copy()

	nonSynDelVars = variants[variants['mutType'] == '2'].copy()

	nonSynAdvVars = variants[variants['mutType'] == '3'].copy()
	
	synSFS = getSFS(synVars, sampleSize)
	nonSynDelSFS = getSFS(nonSynDelVars, sampleSize)
	nonSynAdvSFS = getSFS(nonSynAdvVars, sampleSize)
	return synSFS, nonSynDelSFS, nonSynAdvSFS 

#	return [ syn, nonsyn_del, nonsyn_adv ]


def main():
	parser = argparse.ArgumentParser(description="Generate a simulation config file for SLiM")
	parser.add_argument("-i", 
			required = True,
			dest = "input",
			type =str, 
			help = "name the input directory")
	parser.add_argument("-o", 
			required = True,
			dest = "output",
			type =str, 
			help = "name the output file")
	parser.add_argument("--downSample", 
			required = False,
			dest = "downSample",
			type =int, 
			help = "how many diploids to sample from the VCFs?")
	
	args = parser.parse_args()

	dataFiles = []

## Gene length = 1899
	geneLocations = [1000, 11000, 21000, 31000, 41000, 51000, 61000]

	count = 0
	for i in glob.glob(args.input + '/*vcf.gz'):
		count += 1
		if 'T1' in i: continue
		vcf = i
		fixed = i.split('vcf')[0]+'fixed.txt.gz'
		dataFiles.append( [vcf, fixed] )

	data = []
	for rep in dataFiles:
		fixedMuts = parseSubstitutions(rep[1])
		if args.downSample:
			VCF,sampleSize = parseVCF(rep[0], sample = args.downSample)
		else:
			VCF,sampleSize = parseVCF(rep[0])

		repNumber = rep[0].split('_')[3]

		for g in range(len(geneLocations)):
			geneNumber = g + 1
			start = geneLocations[g]
			end = geneLocations[g] + 1899

			subs_T1 = fixedMuts[(fixedMuts['pos'] <= end) & (fixedMuts['pos'] >= start) & (fixedMuts['fixed'] >= 85000 ) ]
			subs_T2 = fixedMuts[(fixedMuts['pos'] <= end) & (fixedMuts['pos'] >= start) & (fixedMuts['fixed'] >= 35000  ) ]
			variants = VCF[(VCF['pos'] >= start) & (VCF['pos'] <= end) ]
			T1_syn, T1_nonsyn_del, T1_nonsyn_adv = summariseSubsOneClass( subs_T1 )

			T2_syn, T2_nonsyn_del, T2_nonsyn_adv = summariseSubsOneClass( subs_T2 )

			synSFS, nonSynDelSFS, nonSynAdvSFS = summariseVariantsOneClass(variants, sampleSize)

			outDict = {'repNumber':repNumber,
					'geneNumber':geneNumber,
					'T1_syn':T1_syn, 
					'T1_nonsyn_del':T1_nonsyn_del, 
					'T1_nonsyn_adv':T1_nonsyn_adv, 
					'T2_syn':T2_syn, 
					'T2_nonsyn_del':T2_nonsyn_del, 
					'T2_nonsyn_adv':T2_nonsyn_adv, 
					'synSFS':synSFS, 
					'nonSynDelSFS':nonSynDelSFS, 
					'nonSynAdvSFS':nonSynAdvSFS}

#			outline = [repNumber, geneNumber, T1_syn, T1_nonsyn_del, T1_nonsyn_adv, T2_syn, T2_nonsyn_del, T2_nonsyn_adv, synSFS, nonSynDelSFS, nonSynAdvSFS]
			data.append(outDict)
			

	pkl.dump( data, open( args.output + ".p", "wb" ) )	

main()

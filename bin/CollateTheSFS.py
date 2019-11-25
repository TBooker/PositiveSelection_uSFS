## Now let's open up the pickle jar and collate the SFS - will make polyDFE files and get summary stats

import glob, gzip, argparse, os, random
import pandas as pd
import numpy as np
import cPickle as pkl

def polyDFEconfig(sel,neu):
	outString = '1\t1\t'+str(len(sel)-1)+'\n' 
	outString += '\t'.join(map(str, neu[1:-1] + [sum(neu) , neu[-1], sum(neu) ])) + '\n'
	outString += '\t'.join(map(str, sel[1:-1] + [sum(sel) , sel[-1], sum(sel) ]))
	return outString

def pi(SFS,per_site = True):
	if sum(SFS) ==0: 
		return -99
	N = len(SFS)-1
	binom = (N * (N -1))/2
	pi = sum([(1.0*i*(N-i)*(SFS[i]))/(binom) for i in xrange(N) if i != 0])
	if per_site == True:
		return pi/sum(SFS)
	else:
		return pi

def combineGenes(genes, path, label, polyDFE = True, SFS = False):
	numberOfGenes = len(genes)
	print(numberOfGenes)	
	numberOfSynSites = numberOfGenes * 500
	numberOfNonsynSites = numberOfGenes * 1000
	
	T1_syn = genes[0]['T1_syn'] 
	T1_nonsyn_del = genes[0]['T1_nonsyn_del']
	T1_nonsyn_adv = genes[0]['T1_nonsyn_adv'] 
	T2_syn = genes[0]['T2_syn']
	T2_nonsyn_del = genes[0]['T2_nonsyn_del']
	T2_nonsyn_adv = genes[0]['T2_nonsyn_adv']
	synSFS = np.array(genes[0]['synSFS'])
	nonSynDelSFS = np.array(genes[0]['nonSynDelSFS'])
	nonSynAdvSFS = np.array(genes[0]['nonSynAdvSFS'])

	for g in range(len(genes) - 1):
		T1_syn += genes[g+1]['T1_syn'] 
		T1_nonsyn_del += genes[g+1]['T1_nonsyn_del']
		T1_nonsyn_adv += genes[g+1]['T1_nonsyn_adv'] 
		T2_syn += genes[g+1]['T2_syn']
		T2_nonsyn_del += genes[g+1]['T2_nonsyn_del']
		T2_nonsyn_adv += genes[g+1]['T2_nonsyn_adv']
		synSFS += np.array(genes[g+1]['synSFS'])
		nonSynDelSFS += np.array(genes[g+1]['nonSynDelSFS'])
		nonSynAdvSFS += np.array(genes[g+1]['nonSynAdvSFS'])
	dN_T1 = float(T1_nonsyn_del + T1_nonsyn_adv)/ numberOfNonsynSites
	dNa_T1 = float(T1_nonsyn_adv)/ numberOfNonsynSites
	dS_T1 = float(T1_syn)/ numberOfSynSites

	dN_T2 = float(T2_nonsyn_del + T2_nonsyn_adv)/ numberOfNonsynSites
	dNa_T2 = float(T2_nonsyn_adv)/ numberOfNonsynSites
	dS_T2 = float(T2_syn )/ numberOfSynSites
	
	alpha_T1 = float(T1_nonsyn_adv)/ (T1_nonsyn_del + T1_nonsyn_adv)
	alpha_T2 = float(T2_nonsyn_adv)/ (T2_nonsyn_del + T2_nonsyn_adv)
	
#	print dN_T1, dS_T1, dN_T1/dS_T1, float(T1_nonsyn_adv)/ (T1_nonsyn_del + T1_nonsyn_adv) 
#	print dN_T2, dS_T2, dN_T2/dS_T2, float(T2_nonsyn_adv)/ (T2_nonsyn_del + T2_nonsyn_adv)
	
	nonSynSFS_T1 = nonSynDelSFS + nonSynAdvSFS
	nonSynSFS_T1[0] = numberOfNonsynSites - sum(nonSynSFS_T1) - (T1_nonsyn_del + T1_nonsyn_adv)
	nonSynSFS_T1[-1] = T1_nonsyn_del + T1_nonsyn_adv

	synSFS_T1 = synSFS.copy()
	synSFS_T1[0] = numberOfSynSites - sum(synSFS) - T1_syn
	synSFS_T1[-1] = T1_syn 

	nonSynSFS_T2 = nonSynDelSFS + nonSynAdvSFS
	nonSynSFS_T2[0] = numberOfNonsynSites - sum(nonSynSFS_T2) - (T2_nonsyn_del + T2_nonsyn_adv)
	nonSynSFS_T2[-1] = T2_nonsyn_del + T2_nonsyn_adv

	synSFS_T2 = synSFS.copy()
	synSFS_T2[0] = numberOfSynSites - sum(synSFS) - T2_syn
	synSFS_T2[-1] = T2_syn 

	pi_syn = pi(synSFS_T2)
	pi_nonsyn = pi(nonSynSFS_T2)

	segSites_nonsyn = sum(nonSynSFS_T2[1:-1])
	segSites_syn = sum(synSFS_T2[1:-1])

	segSites_nonsyn_adv = sum(nonSynAdvSFS[1:-1])

	statsVector_T1 = [label, 'T1', numberOfGenes, dS_T1, dN_T1, dNa_T1, alpha_T1, pi_syn, pi_nonsyn, segSites_nonsyn, segSites_nonsyn_adv, segSites_syn]
	statsVector_T2 = [label, 'T2', numberOfGenes, dS_T2, dN_T2, dNa_T2, alpha_T2, pi_syn, pi_nonsyn, segSites_nonsyn, segSites_nonsyn_adv, segSites_syn]

	if SFS:
		
		del_bit = [[i,nonSynDelSFS[i],'deleterious','nonsyn'] for i in range(len(nonSynDelSFS) ) if i != 0 and i != len(nonSynDelSFS)-1]
		
		adv_bit = [[i,nonSynAdvSFS[i],'advantageus','nonsyn'] for i in range(len(nonSynAdvSFS) ) if i != 0 and i != len(nonSynAdvSFS)-1]
		
		syn_bit = [[i,synSFS[i],'neutral','syn'] for i in range(len(synSFS)) if i != 0 and i != len(nonSynDelSFS)-1]
		SFS_csv = pd.DataFrame(syn_bit + del_bit + adv_bit, columns = ['alleles','count', 'class', 'site'] )
		SFS_csv.to_csv( path + '/' + label +'.SFS.csv', index = False)
	if polyDFE:
		polyDFE_T1 = polyDFEconfig(list(nonSynSFS_T1), list(synSFS_T1))
		poly_1 = open(path + '/' + label +'.polyDFE_T1.config', 'w')
		poly_1.write(polyDFE_T1)
		poly_1.close()
		polyDFE_T2 = polyDFEconfig(list(nonSynSFS_T2), list(synSFS_T2))
		poly_2 = open(path + '/' + label +'.polyDFE_T2.config', 'w')
		poly_2.write(polyDFE_T2)
		poly_2.close()

	pd.DataFrame([ statsVector_T1, statsVector_T2 ], columns = ['label', 'Time', 'numberOfGenes', 'dS', 'dN', 'dNa', 'alpha', 'pi_syn', 'pi_nonsyn', 'segSites_nonsyn', 'segSites_nonsyn_adv', 'segSites_syn']).to_csv( path + '/' + label +'.summary.csv', index = False)


def main():
	parser = argparse.ArgumentParser(description="Make collated site frequency spectra from the picke jar ")
	parser.add_argument("-i", 
			required = True,
			dest = "input",
			type =str, 
			help = "name the pickle you want to open")
	parser.add_argument("-o", 
			required = True,
			dest = "output",
			type =str, 
			help = "give the name of an output drectory. A bunch of files will be written to this directory")
	parser.add_argument("--polyDFE", 
			dest = "polyDFE",
			action = 'store_true', 
			help = "Give this flag if you want to write polyDFE configs")
	parser.add_argument("--SFS", 
			dest = "SFS",
			action = 'store_true', 
			help = "Give this flag if you want to write the SFS")
	parser.add_argument("--reps", "-r", 
			required = True,
			dest = "reps",
			type = int, 
			default = 0,
			help = "How many replicates do you want to generate?")
	parser.add_argument("--mkdir","-m", 
			dest = "mkdir",
			action = 'store_true', 
			help = "Give this flag if you want to make a directory with the name given as input")
	parser.add_argument("--vanilla","-v", 
			dest = "vanilla",
			action = 'store_true', 
			help = "Give this flag if you want to include the vanilla dataset")
	parser.add_argument("--reduce", 
			dest = "reduce",
			type = float, 
			help = "Give the fraction of the dataset that you want to analyse",
			default = 1)
	args = parser.parse_args()

## Read in the pickled list of data. Each gene is represented once
	dataList = pkl.load( gzip.open( args.input , "rb" ) )	

## Make a dir to dump the files into
	if args.mkdir:
		os.system('mkdir ' + args.output)
## Make a dir to dump the files into
	if args.reduce > 1:
		print "you can't reduce the dataset with that number, use a value < 1"
		return
	elif args.reduce > 0 and args.reduce < 1: 
		reducedSetSize = int( len(dataList) * args.reduce )
	elif args.reduce ==1: 
		reducedSetSize = len(dataList)

## Do it for the vanilla list
	print 'compile the SFS'

	if args.vanilla:
		combineGenes(dataList, args.output, 'vanilla', polyDFE = args.polyDFE, SFS = args.SFS)

	for i in range(args.reps):
		rep_number= i + 1
		rep_list = list(np.random.choice(dataList, reducedSetSize ))

		combineGenes(rep_list, args.output, str(rep_number), polyDFE = args.polyDFE, SFS = args.SFS)
main()

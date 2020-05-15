import pandas as pd, argparse, glob
from scipy.stats import chi2
from tom import brace
import numpy as np 
from collections import OrderedDict

def parsepolyDFE(input):

	data = [i.strip() for i in open(input).readlines()]
	# print input, len(data)
	if len(data) < 100:	return
	lnL = [i for i in data if i.startswith('---- Best joint')][0].split(' ')[5]
	results = data[data.index('--  Model: B')+1 : data.index('--  Model: B')+5]
	retDict = {}
	retDict['lnL'] = float(lnL)
 	for i,j in zip(results[2].split(), results[3].split()):
 		if i == '--': continue
 
 		if i == 'p_b':
 			retDict['pa_est'] = [float(j)]
 		elif i == 'S_b':		
 			retDict['Sb_est'] = [float(j)]
 		else:
# 		
 			retDict[i] = [float(j)]
 	retDict['alpha_div'] = [float([i for i in data if i.startswith('---- alpha_div')][0].split(' ')[-1])]
	retDict['alpha_dfe'] = [float([i for i in data if i.startswith('---- alpha_dfe')][0].split(' ')[-1])]

	retDict['product'] =  [retDict['pa_est'][0] * retDict['Sb_est'][0]]

	return retDict
		
		
#def getBootRanges(df, vanilla, taxa):
def getBootRanges(df, taxa):
	
	dfs = []
	new = []
	for i in ['Sb_est','pa_est','b','S_d','alpha_dfe','alpha_div', 'product']:
		temp = OrderedDict() 

		temp['taxa'] = taxa
		temp['stat'] = i
		temp['lower'] = np.percentile(df[i], 2.5)
		temp['median'] = np.median(df[i],)
		temp['upper'] = np.percentile(df[i], 97.5)
		new.append( temp )
	if 'LRT' in list(df): 
		for i in ['LRT']:
			prop_sig = float(sum(df[i] < 0.05))/ len(df[i])
		
			temp['taxa'] = taxa
			temp['stat'] = 'propSig'
			temp['lower'] = prop_sig
			temp['median'] = prop_sig
			temp['upper'] = prop_sig
		
	new_df = pd.DataFrame(new)

	return new_df


def main():
	parser = argparse.ArgumentParser(description="This script makes a CSV File with the results of polyDFE in a nice table")

	parser.add_argument("-i","--input", 
		required = True,
		dest = "input",
		type =str, 
		help = "Give the name of a directory contatining the multiple directories whose names end with '_boots'")
		
	parser.add_argument("-o","--output", 
		required = True,
		dest = "output",
		type =str, 
		help = "The name of the Dataframe you'll write")

	parser.add_argument("--NoAdv", 
		dest = "NoAdv",
		action = 'store_true', 
		help = "Give this flag if you want to analyse the runs that didn't model positive selection")
			
	args = parser.parse_args()

	searchString_wDiv = args.input+'/*.output'



	allBoots_with = []

	for i in glob.glob(searchString_wDiv):
			name = 'adv'
			rep = i.split('/')[-1].split('.')[2]
			temp = parsepolyDFE(i)
			if not temp: continue
			temp['name'] = name
			ID = i.split('/')[-1].split('.')[0]
			temp['ID'] = 'with_div'	
			allBoots_with.append( pd.DataFrame.from_dict(temp) )

	DFE_with = pd.concat(allBoots_with).sort_values('ID', ascending=1)

	

	listy =  args.input.split('_')
	Nes = listy[0].split('s')[1]
	pA = listy[1].split('A')[1]
	n = listy[2][1:]
	

	output = pd.concat([DFE_with])
	output['Nes'] = Nes
	output['pA'] = pA
	output['n'] = n

	output['delt_lnL'] = output['lnL'].max() - output['lnL']
	if not args.NoAdv:
		output['name'] = 'dDFE'
	else:
		output['name'] = 'full_DFE'
	output.to_csv( args.output , index = False)
	
	
if '__name__':
	main()

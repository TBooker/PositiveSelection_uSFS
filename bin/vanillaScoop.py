

import glob
import pandas as pd

all_dfs = []

for i in glob.glob('Nes*vanilla/vanilla.summary.csv'):
	dfe = i.split('/')[0]
	Nes = float(dfe.split('_')[0].split('s')[1])
	pA = float(dfe.split('_')[1].split('A')[1])
	
	df = pd.read_csv(i)
	df['Nes'] = Nes
	df['pA'] = pA
	all_dfs.append(df)

pd.concat(all_dfs).to_csv('all.vanilla.summary.csv', index = False)

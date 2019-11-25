import pandas as pd
import glob, sys

all = []
for i in glob.glob('*csv'):
	all.append( pd.read_csv(i) )

pd.concat(all).to_csv(sys.argv[1], index = False)

# Estimating the strength of positive selection from the unfolded site frequency spectrum (uSFS)

This repository contains the scripts, SLiM configuration files and processed data from a small study I did on estimating the parameters of positive selection from the unfolded site frequency spectrum. This work has been published in G3 (https://doi.org/10.1534/g3.120.401052)

I based the simulations on those performed by Campos and Charlesworth (2019 - Genetics), where they simulated positive and negatively selected mutations occurring in the exons of protein-coding genes. The SLiM configuration file that performs the simulation is [configs/single_class.slim](here)

I ran a large number of replicate simulations on a cluster that uses the SLURM scheculing system. I wrote an array-job submission script that looked like this:

```
#!/bin/bash
#SBATCH --array=1-2000 # 2000 Jobs
#SBATCH --job-name=TomSlim
#SBATCH --time=00:40:00
#SBATCH --mem=3000
#SBATCH --output=TomSlim.uSFS.%A%a.out
#SBATCH --error=TomSlim.uSFS.%A%a.err


~/bin/build/slim -d selStrength=1000 -d pA=0.01  -d REP=$SLURM_ARRAY_TASK_ID ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim
~/bin/build/slim -d selStrength=1000 -d pA=0.001  -d REP=$SLURM_ARRAY_TASK_ID ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim
~/bin/build/slim -d selStrength=1000 -d pA=0.0001  -d REP=$SLURM_ARRAY_TASK_ID ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim
```
I specify the variable parameters for SLiM at the command line (i.e. selStrength and pA), and run 2000 replicates for each parameter set. There are seven simulated genes in each dataset, representing a genome with 14,000 protein-coding genes. The method I used to analsyse the uSFS (```polyDFE```), and other methods such as ```DFE-alpha``` assume that sites are independant. We know that that is biologically incorrect, selection at linked sites is probably ubiquitous and affects the SFS for all sites in the genome. However, to my knowledge, there is currently no likelihood function for the expected SFS under the combined effects of direct selection, selection at linked sites, historical population size variation and polarization error that could be used to analyse  

With the resulting datafiles, I collated the substitutions and variable sites into a uSFS for simulated synonymous and nonsynonymous sites. I then collated the resulting uSFS data and bootstrapped using the following command:

```
##	Go from SLiM output to analysed files:
##
#This assumes that all the SLiM output is organised into files named like this, Nes1000_pA0.01, Nes500_pA0.001 etc. 

# Gzip all the VCFs, save a little space
gzip Nes*/*vcf 
# Gzip all the files of substitutions
gzip Nes*/*.fixed.txt 

# parse all the SLiM output and store in a pickle jar
parallel "python ../bin/parseSLiMtoSFS.py -i Nes{1}_pA{2}/ -o Nes{1}_pA{2}.pkl" ::: 1000 500 100 50 10 ::: 0.01 0.001 0.0001

# downsample to 20 diploids for all the SLiM output and store in a pickle jar
parallel "python ../bin/parseSLiMtoSFS.py -i Nes{1}_pA{2}/ -o Nes{1}_pA{2}_n20.pkl --downSample 20" ::: 1000 500 100 50 10 ::: 0.01 0.001 0.0001

# gzip the pickle jars
gzip *.pkl.p

# let's now get a summary file for each pickle jar, getting stats like alpha, pi/pi0 and the number of segregating sites. I call the basic dataset the vanilla dataset.
parallel "python ../bin/CollateTheSFS.py -i Nes{1}_pA{2}.pkl.p.gz -o Nes{1}_pA{2}_vanilla --SFS --mkdir --vanilla --reps 0" ::: 1000 500 100 50 10 ::: 0.01 0.001 0.0001

# I make a summary file for each data set using:
python ../bin/vanillaScoop.py

# Now let's make 100 polyDFE input files for each dataset:
parallel "python ../bin/CollateTheSFS.py -i Nes{1}_pA{2}_n20.pkl.p.gz -o Nes{1}_pA{2}_n20_polyDFE --mkdir --polyDFE --reps 100 " ::: 1000 500 100 50 10 ::: 0.01 0.001 0.0001

```


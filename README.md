# Estimating the strength of positive selection from the unfolded site frequency spectrum (uSFS)

This repository contains the scripts, SLiM configuration files and processed data from a small study I did on estimating the parameters of positive selection from the unfolded site frequency spectrum. This work has been published in G3 (https://doi.org/10.1534/g3.120.401052)

I based the simulations on those performed by Campos and Charlesworth (2019 - Genetics), where they simulated positive and negatively selected mutations occurring in the exons of protein-coding genes. The SLiM configuration file that performs the simulation is [configs/single_class.slim](here). It is a pretty straightforward SLiM-ulation of a Wright-Fisher population. My aim was to model a population that closely matches the assumptions that are made by the DFE inference packages - i.e. constant population size, an invariant distribution of mutational effects and random mating. The big exception is that SLiM models linkage and I modelled a gene-like structure in the simulations. Each simulation had 7 of these genes. The method I used to analsyse the uSFS (```polyDFE```), and other methods such as ```DFE-alpha``` assume that sites are independant. We know that that is biologically incorrect, selection at linked sites is probably ubiquitous and affects the SFS for sites across the genome. However, to my knowledge, there is currently no likelihood function for the expected SFS under the combined effects of direct selection, selection at linked sites, historical population size variation and polarization error that could be used to analyse empirical data.

In this GitHub repository, you'll find all the code you need to run the simulations and analysis that I did for the G3 paper. I also include the scripts I used for plotting the figures.

See the [configs/](configs directory) for more info about the simulation structure.

## Running the simulations

I ran a large number of replicate simulations (2,000 per parameter combination) on a cluster that uses the SLURM scheduling system. I wrote an array-job submission script that looked like this for three particular parameter combinations:

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
I specify the variable parameters for SLiM at the command line (i.e. selStrength and pA), and run 2000 replicates for each parameter set. There are seven "genes"" in each simulation, so 2,000 replicates represents a genome with 14,000 protein-coding genes. So I ended up with the uSFS data for a little shy of a **Drosophila** genome's worth of data.

Of course, there are lots of other ways that one could go about running the simulations, I just happened to have access to a server that runs SLURM. 

## Running the simulations

With the resulting datafiles, I collated the substitutions and variable sites into a uSFS for simulated synonymous and nonsynonymous sites. I simulated populations of 10,000 individuals, calculated summary stats and then sampled 20 diploids from each. 

Here's an example of how that might look using the GNU parallel tool:

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

# The vanilla scoop makes a summary file for each dataset that contains summ

# Now let's make 100 polyDFE input files for each dataset:
parallel "python ../bin/CollateTheSFS.py -i Nes{1}_pA{2}_n20.pkl.p.gz -o Nes{1}_pA{2}_n20_polyDFE --mkdir --polyDFE --reps 100 " ::: 1000 500 100 50 10 ::: 0.01 0.001 0.0001

```

Using the above code, we'll get a bunch of output files that are useful for plotting and downstream analysis. The ```CollateTheSFS.py``` Python script generates the file of summary stats that I used to make Figure 1. 


## The expected and observed uSFS

Figure 3 from the paper shows the expected and observed uSFS from the simulated populations. Tataru et al (2016) give all the formulae to calculate the expected uSFS derived using the Poisson Random Field branch of theory. That paper is great!

Last year I started using Mathematica and used that to calculate the analytical expectations shown in Figure 2 and Figure S4. The code for calculating those is in "" 



## Running polyDFE

PolyDFE is a great program and really easy to use. I

To examine the likelihood surfaces (Figure 4 in the paper), I fixed the values of the positive selection parameters and performed the likelihood maximisation on the data. That part of the analysis pipeline uses a file of initialisation values that store each of the parameter combinations. Check the [surface/](surface/) directory for the code that I used to do that.




#!/bin/bash
#SBATCH --array=1-100
#SBATCH --job-name=TomSlim
#SBATCH --time=01:30:00
#SBATCH --mem=1000
#SBATCH --output=TomSlim.polyDFE.%A%a.out
#SBATCH --error=TomSlim.polyDFE.%A%a.err


/home/booker/bin/polyDFE-master/polyDFE-2.0-linux-64-bit -d polyDFE_runs_n20/Nes10_pA0.01_n20_polyDFE/XX.polyDFE_T1.config -w >polyDFE_runs_n20/Nes10_pA0.01_n20_polyDFE/XX.polyDFE_T1.nDiv.output
/home/booker/bin/polyDFE-master/polyDFE-2.0-linux-64-bit -d polyDFE_runs_n20/Nes10_pA0.01_n20_polyDFE/XX.polyDFE_T1.config -w >polyDFE_runs_n20/Nes10_pA0.01_n20_polyDFE/XX.polyDFE_T1.nDiv.output

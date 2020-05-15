#!/bin/bash
#SBATCH --array=1-100
#SBATCH --job-name=TomSlim
#SBATCH --time=06:00:00
#SBATCH --mem=1000
#SBATCH --output=TomSlim.polyDFE.%A%a.out
#SBATCH --error=TomSlim.polyDFE.%A%a.err


#~/bin/polyDFE-master/polyDFE-2.0-linux-64-bit -d ~/projects/def-whitlock/booker/uSFS_positiveSelection/polyDFE_fixedEffect/polyDFE_runs_n20/Nes500_pA0.01_n20_polyDFE/$SLURM_ARRAY_TASK_ID.polyDFE_T1.config  -i ~/bin/polyDFE-master/input/init_model_BandC.txt 2 -m B > ~/projects/def-whitlock/booker/uSFS_positiveSelection/polyDFE_fixedEffect/polyDFE_runs_n20/Nes500_pA0.01_n20_polyDFE/$SLURM_ARRAY_TASK_ID.polyDFE_T1.wDiv.dDFE.B.output
~/bin/polyDFE-master/polyDFE-2.0-linux-64-bit -d ~/projects/def-whitlock/booker/uSFS_positiveSelection/polyDFE_fixedEffect/polyDFE_runs_n20/Nes500_pA0.01_n20_polyDFE/$SLURM_ARRAY_TASK_ID.polyDFE_T1.config -i ~/bin/polyDFE-master/input/init_model_BandC.txt 2 -m B -w > ~/projects/def-whitlock/booker/uSFS_positiveSelection/polyDFE_fixedEffect/polyDFE_runs_n20/Nes500_pA0.01_n20_polyDFE/$SLURM_ARRAY_TASK_ID.polyDFE_T1.nDiv.dDFE.B.output

#!/bin/bash
#SBATCH --array=1-100
#SBATCH --job-name=TomSlim
#SBATCH --time=10:00:00
#SBATCH --mem=1000
#SBATCH --output=TomSlim.polyDFE.%A%a.out
#SBATCH --error=TomSlim.polyDFE.%A%a.err


~/bin/polyDFE-master/polyDFE-2.0-linux-64-bit -d ~/projects/def-whitlock/booker/uSFS_positiveSelection/polyDFE_fixedEffect/polyDFE_runs_n40/Nes10_pA0.01_n40_polyDFE/$SLURM_ARRAY_TASK_ID.polyDFE_T1.config  -m B -e  > ~/projects/def-whitlock/booker/uSFS_positiveSelection/polyDFE_fixedEffect/polyDFE_runs_n40/Nes10_pA0.01_n40_polyDFE/$SLURM_ARRAY_TASK_ID.polyDFE_T1.wDiv.Be.output

~/bin/polyDFE-master/polyDFE-2.0-linux-64-bit -d ~/projects/def-whitlock/booker/uSFS_positiveSelection/polyDFE_fixedEffect/polyDFE_runs_n40/Nes10_pA0.01_n40_polyDFE/$SLURM_ARRAY_TASK_ID.polyDFE_T1.config -w -m B -e  > ~/projects/def-whitlock/booker/uSFS_positiveSelection/polyDFE_fixedEffect/polyDFE_runs_n40/Nes10_pA0.01_n40_polyDFE/$SLURM_ARRAY_TASK_ID.polyDFE_T1.nDiv.Be.output

#~/bin/polyDFE-master/polyDFE-2.0-linux-64-bit -d ~/projects/def-whitlock/booker/uSFS_positiveSelection/polyDFE_fixedEffect/polyDFE_runs_n20/Nes1000_pA0.0001_n20_polyDFE/$SLURM_ARRAY_TASK_ID.polyDFE_T1.config -r /home/booker/projects/def-whitlock/booker/uSFS_positiveSelection/configs/range_model_BandC.txt 2 -m B  > ~/projects/def-whitlock/booker/uSFS_positiveSelection/polyDFE_fixedEffect/polyDFE_runs_n20/Nes1000_pA0.0001_n20_polyDFE/$SLURM_ARRAY_TASK_ID.polyDFE_T1.wDiv.B.output
#~/bin/polyDFE-master/polyDFE-2.0-linux-64-bit -d ~/projects/def-whitlock/booker/uSFS_positiveSelection/polyDFE_fixedEffect/polyDFE_runs_n20/Nes1000_pA0.0001_n20_polyDFE/$SLURM_ARRAY_TASK_ID.polyDFE_T1.config -r /home/booker/projects/def-whitlock/booker/uSFS_positiveSelection/configs/range_model_BandC.txt 2 -m B -w > ~/projects/def-whitlock/booker/uSFS_positiveSelection/polyDFE_fixedEffect/polyDFE_runs_n20/Nes1000_pA0.0001_n20_polyDFE/$SLURM_ARRAY_TASK_ID.polyDFE_T1.nDiv.B.output

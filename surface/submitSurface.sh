#!/bin/bash
#SBATCH --array=1-2500
#SBATCH --job-name=TomSlim
#SBATCH --time=05:0:00
#SBATCH --mem=1000
#SBATCH --output=TomSlim.polyDFE.%A%a.out
#SBATCH --error=TomSlim.polyDFE.%A%a.err


~/bin/polyDFE-master/polyDFE-2.0-linux-64-bit -i /home/booker/projects/def-whitlock/booker/uSFS_positiveSelection/surface/init_surface.txt $SLURM_ARRAY_TASK_ID -d /home/booker/projects/def-whitlock/booker/uSFS_positiveSelection/surface/Nes100_pA0.001_n20_polyDFE_surface/99.polyDFE_T1.config -w > /home/booker/projects/def-whitlock/booker/uSFS_positiveSelection/surface/Nes100_pA0.001_n20_polyDFE_surface/99.polyDFE_T1.$SLURM_ARRAY_TASK_ID.nDiv.output

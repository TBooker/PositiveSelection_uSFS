#!/bin/bash
#SBATCH --array=1-2500
#SBATCH --job-name=TomSlim
#SBATCH --time=05:00:00
#SBATCH --mem=1000
#SBATCH --output=TomSlim.polyDFE.%A%a.out
#SBATCH --error=TomSlim.polyDFE.%A%a.err

~/bin/polyDFE-master/polyDFE-2.0-linux-64-bit -i /home/booker/projects/def-whitlock/booker/uSFS_positiveSelection/surface/init_files/init_Nes1000.txt $SLURM_ARRAY_TASK_ID -d /home/booker/projects/def-whitlock/booker/uSFS_positiveSelection/surface/Nes1000_pA0.0001_n20_polyDFE_surface/Nes1000_pA0.0001_n20_polyDFE.config -m B > /home/booker/projects/def-whitlock/booker/uSFS_positiveSelection/surface/Nes1000_pA0.0001_n20_polyDFE_surface/Nes1000_pA0.0001_99.T1.$SLURM_ARRAY_TASK_ID.wDiv.B.output

~/bin/polyDFE-master/polyDFE-2.0-linux-64-bit -i /home/booker/projects/def-whitlock/booker/uSFS_positiveSelection/surface/init_files/init_Nes1000.txt $SLURM_ARRAY_TASK_ID -d /home/booker/projects/def-whitlock/booker/uSFS_positiveSelection/surface/Nes1000_pA0.0001_n20_polyDFE_surface/Nes1000_pA0.0001_n20_polyDFE.config -m B -w > /home/booker/projects/def-whitlock/booker/uSFS_positiveSelection/surface/Nes1000_pA0.0001_n20_polyDFE_surface/Nes1000_pA0.0001_99.T1.$SLURM_ARRAY_TASK_ID.nDiv.B.output

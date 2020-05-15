#!/bin/bash
#SBATCH --array=1-2000
#SBATCH --job-name=TomSlim
#SBATCH --time=00:45:00
#SBATCH --mem=3000
#SBATCH --output=TomSlim.uSFS.%A%a.out
#SBATCH --error=TomSlim.uSFS.%A%a.err



~/bin/build/slim -d selStrength=1000 -d pA=0.0001  -d REP=$SLURM_ARRAY_TASK_ID.1 ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim

~/bin/build/slim -d selStrength=1000 -d pA=0.0001  -d REP=$SLURM_ARRAY_TASK_ID.2 ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim

~/bin/build/slim -d selStrength=1000 -d pA=0.0001  -d REP=$SLURM_ARRAY_TASK_ID.3 ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim

~/bin/build/slim -d selStrength=1000 -d pA=0.0001  -d REP=$SLURM_ARRAY_TASK_ID.4 ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim

~/bin/build/slim -d selStrength=1000 -d pA=0.0001  -d REP=$SLURM_ARRAY_TASK_ID.5 ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim

~/bin/build/slim -d selStrength=1000 -d pA=0.0001  -d REP=$SLURM_ARRAY_TASK_ID.6 ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim

~/bin/build/slim -d selStrength=1000 -d pA=0.0001  -d REP=$SLURM_ARRAY_TASK_ID.7 ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim

~/bin/build/slim -d selStrength=1000 -d pA=0.0001  -d REP=$SLURM_ARRAY_TASK_ID.8 ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim

~/bin/build/slim -d selStrength=1000 -d pA=0.0001  -d REP=$SLURM_ARRAY_TASK_ID.9 ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim

~/bin/build/slim -d selStrength=1000 -d pA=0.0001  -d REP=$SLURM_ARRAY_TASK_ID.0 ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim



#!/bin/bash
#SBATCH --array=1-2000 # 2000 Jobs
#SBATCH --job-name=TomSlim
#SBATCH --time=01:20:00
#SBATCH --mem=3000
#SBATCH --output=TomSlim.uSFS.%A%a.out
#SBATCH --error=TomSlim.uSFS.%A%a.err

~/bin/build/slim -d selStrength=0.01 -d pA=0.0  -d REP=$SLURM_ARRAY_TASK_ID ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim                                                 

##~/bin/build/slim -d selStrength=1000 -d pA=0.01  -d REP=$SLURM_ARRAY_TASK_ID ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim
##~/bin/build/slim -d selStrength=1000 -d pA=0.001  -d REP=$SLURM_ARRAY_TASK_ID ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim
##~/bin/build/slim -d selStrength=1000 -d pA=0.0001  -d REP=$SLURM_ARRAY_TASK_ID ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim

##~/bin/build/slim -d selStrength=500 -d pA=0.01  -d REP=$SLURM_ARRAY_TASK_ID ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim
##~/bin/build/slim -d selStrength=500 -d pA=0.001  -d REP=$SLURM_ARRAY_TASK_ID ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim
##~/bin/build/slim -d selStrength=500 -d pA=0.0001  -d REP=$SLURM_ARRAY_TASK_ID ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim

##~/bin/build/slim -d selStrength=100 -d pA=0.01  -d REP=$SLURM_ARRAY_TASK_ID ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim
##~/bin/build/slim -d selStrength=100 -d pA=0.001  -d REP=$SLURM_ARRAY_TASK_ID ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim
##~/bin/build/slim -d selStrength=100 -d pA=0.0001  -d REP=$SLURM_ARRAY_TASK_ID ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim

##~/bin/build/slim -d selStrength=50 -d pA=0.01  -d REP=$SLURM_ARRAY_TASK_ID ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim
##~/bin/build/slim -d selStrength=50 -d pA=0.001  -d REP=$SLURM_ARRAY_TASK_ID ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim
##~/bin/build/slim -d selStrength=50 -d pA=0.0001  -d REP=$SLURM_ARRAY_TASK_ID ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim

##~/bin/build/slim -d selStrength=10 -d pA=0.01  -d REP=$SLURM_ARRAY_TASK_ID ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim
##~/bin/build/slim -d selStrength=10 -d pA=0.001  -d REP=$SLURM_ARRAY_TASK_ID ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim
##~/bin/build/slim -d selStrength=10 -d pA=0.0001  -d REP=$SLURM_ARRAY_TASK_ID ~/projects/def-whitlock/booker/uSFS_positiveSelection/configs/single_class.slim

#!/bin/bash

#SBATCH --mem=60GB
#SBATCH -p ml
#SBATCH --gres=gpu:1
#SBATCH --time=107:59:59
#SBATCH --nodes=1
#SBATCH -c 7


/projects/zihforschung/lazariv/start_RStudio_Server.sh


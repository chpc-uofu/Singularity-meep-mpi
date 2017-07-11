#!/bin/bash
#SBATCH --job-name=polarizer
#SBATCH --time=2:00:00
#SBATCH --ntasks=168

#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=m.cuma@utah.edu

#SBATCH --output=polarizer_%A.out
#SBATCH --error=polarizer_%A.err

#SBATCH --account=owner-guest
#SBATCH --partition=kingspeak-guest
#SBATCH -C c28


# Job Info
export INP=polarizer.ctl
export WORKDIR=$SLURM_SUBMIT_DIR
export GUILE_WARN_DEPRECATED="no"
export MEEP_CONTAINER=/uufs/chpc.utah.edu/common/home/u0101881/containers/singularity/containers/chpc/Singularity-meep-mpi/ubuntu_meep_good.img
export MEEP_SCRIPT=meep-mpich2

# Load MPICH
module load gcc/4.8.5
module load mpich/3.2.g

# Job properly
echo " ********************************* "
echo " Job $SLURM_JOBID started at `date`"
echo " Nodes:$SLURM_NODELIST" 

cd $WORKDIR
# Run with Ethernet (Updated 07/10/2017)
mpirun -np $SLURM_NPROCS  singularity exec $MEEP_CONTAINER $MEEP_SCRIPT $INP > $SLURM_JOBID.out

echo " Job $SLURM_JOBID ended at `date`"
echo " ********************************* "

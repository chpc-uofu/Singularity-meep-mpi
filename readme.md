Ubuntu container MEEP-MPI

Includes InfiniBand stack for IB support

MEEP-MPI is built with MPICH, so, can use MPICH ABI compatible MPI distros

IMPI does not work since meep-mpi complains that IMPI lacks BLCR kernel module

MVAPICH2, on the other hand, works OK.

To test:
```
cd examples
ml gcc mvapich2 singularity/2.3
mpirun -np 2 singularity exec /uufs/chpc.utah.edu/common/home/u0101881/containers/singularity/containers/chpc/Singularity-meep-mpi/ubuntu_meep.img meep-mpich2 holey-wvg-bands.ctl
```

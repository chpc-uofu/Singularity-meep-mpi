# Ubuntu container MEEP-MPI

Includes InfiniBand stack for IB support

MEEP-MPI is built with MPICH, so, can use MPICH ABI compatible MPI distros

IMPI does not work since meep-mpi complains that IMPI lacks BLCR kernel module

MVAPICH2, on the other hand, works OK.

## To test:
```
cd examples
ml gcc mvapich2 singularity/2.3.1
mpirun -np 2 singularity exec /uufs/chpc.utah.edu/common/home/u0101881/containers/singularity/containers/chpc/Singularity-meep-mpi/ubuntu_meep.img meep-mpich2 holey-wvg-bands.ctl
```

## Performance problem
- mpich 3.2 packaged with Ubuntu 16.10 is only built with TCP. As the executable is using dynamic libraries from the container, it by default uses libmpich.so from `/usr/lib/x86_64-linux-gnu`, and thus does not run over the IB.
- we need to overload this `libmpich.so` with that from the CHPC - in `/uufs/chpc.utah.edu/sys/installdir/mpich/3.2-c7/lib` - also had to `ln -s libmpi.so.12.1.0 libmpich.so.12` as `libmpich.so.12` link is not made in the build from the source.
- so, run through a script like:
```
#!/bin/bash
export LD_LIBRARY_PATH="/uufs/chpc.utah.edu/sys/installdir/mpich/3.2-c7/lib:$LD_LIBRARY_PATH"
meep-mpich2 $@

```
- however, this crashes due to buggy MXM. So, better to use MVAPICH2:
```
#!/bin/bash
export LD_LIBRARY_PATH="/uufs/chpc.utah.edu/sys/installdir/mvapich2/2.2-c7/lib:$LD_LIBRARY_PATH"
meep-mpich2 $@

```
and, on the host
```
mpirun -np 2 singularity exec /uufs/chpc.utah.edu/common/home/u0101881/containers/singularity/containers/chpc/Singularity-meep-mpi/ubuntu_meep.img /uufs/chpc.utah.edu/common/home/u0101881/containers/singularity/containers/chpc/Singularity-meep-mpi/examples/run_meep_mvapich.sh holey-wvg-bands.ctl
```

## Performance

Container performance not as good as the `meep-mpich2` is built with gcc and underlying open source stack (OpenBLAS,...)

For example, on the holey-wvg-bands.ctl example, 2procs (over IB)

 run type              | runtime (s)
 ---                   | ---
 MVAPICH2 host         | 36.3216 
 IMPI host             | 21.1274 
 MVAPICH2 container    | 55.0033 
 MPICH2 container      | 63.9363 
 MPICH2 container TCP  | 270.671 

Another example, polarizer.ctl, 6x28 core nodes

 run type             | runtime (s)
 ---                  | ---
 MPICH TCP, host      | 499.017 
 MPICH IB, host       | segfault
 MPICH container IB   | 275.962 
 MPICH container TCP  | 687.565 
       

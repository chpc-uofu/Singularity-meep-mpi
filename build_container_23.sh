imgname=meep
osname=ubuntu
rm -f ${osname}_${imgname}.img
sudo /uufs/chpc.utah.edu/sys/installdir/singularity/2.3/bin/singularity create --size 4096 ${osname}_${imgname}.img
sudo /uufs/chpc.utah.edu/sys/installdir/singularity/2.3/bin/singularity bootstrap ${osname}_${imgname}.img Singularity



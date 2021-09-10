#!/bin/bash
#############################################################################
# Run regression tests for the hydrognate program against all mmCIF files
# in the PDB to catch any failures.
#
# Must be run in an environment where "phenix.suitename" points at the
# new CCTBX version of SuiteName and where the monomer libraries can be
# found so that the mp_geo program works.
#
# This presumes that you are running in an environment where you have
# mmtbx.hydrogenate on your path and have access to the rsync command as well.
#
# The program first uses rsync to pull all of the CIF files into the
# mmCIF directory (if this has been done before, only changes will be pulled).
#
# WARNING: This program deletes each file that it was able to run on
# successfully, so that repeated runs will not retry the same file over
# and over.
#
#############################################################################

######################
# Parse the command line
# The first argument, if present, specifies the modulo of 8 to use when
# deciding whether the script should run a file.
VERBOSE=1
mkdir -p ./outputs

export LIBTBX_DISABLE_TRACEBACKLIMIT=1


MODULO=""
if [ "$1" != "" ] ; then MODULO="$1" ; fi

######################
# Pull the mMCIF files
#./get_mmCIF.sh

######################
# For each mMCIF file, see if we can run.  If not, save the error output.

count=0
failed=0
names=`cat matrix_errors.txt`
files=""
for n in $names; do
  dir=`echo $n | cut -c2-3`
  files="$files ./$dir/$n.cif.gz"
done

for f in $files; do

  ##############################################
  # We found a file.
  let "total++"
  mod=`echo "$total % 1000" | bc`
  if [ "$mod" -eq 0 ] ; then
    echo "Checked $total files..."
  fi

  ##############################################
  # We found a file to check.
  let "count++"

  ##############################################
  # See if our modulo parameter tells us to skip it.
  if [ "$MODULO" != "" ] ; then
    mod=$(("$count" % 8))
    if [ "$mod" -ne "$MODULO" ] ; then
      echo "Skipping $f, modulo = $mod"
      continue
    fi
  fi

  ##############################################
  # Now run on on the input file and store its output if we fail.

  # Get the full mmCIF file name
  d2=`echo $f | cut -d/ -f 2`
  d3=`echo $f | cut -d/ -f 3`
  base=`echo $d3 | cut -d. -f1`
  name=$base
  cname=mmCIF/$d2/$name.cif.gz
  if [ -n "$VERBOSE" ] ; then echo "Testing $cname" ; fi

  # Decompress the file after making sure the file exists.
  if [ ! -f $cname ] ; then continue ; fi
  ciffile="./${name}.cif"
  outfile="./${name}_out.txt"
  errorfile="./${name}_error.txt"
  gunzip < $cname > $ciffile

  # Run on the CIF file.
  mmtbx.hydrogenate $ciffile 2> $errorfile > $outfile
  if [ $? -ne 0 ]
  then
    let "failed++"
    echo "Error running on $name ($failed failures out of $count)"
    cp $errorfile $outfile outputs
  fi

  rm -f $ciffile $outfile $errorfile ${name}_hydrogenate.pdb

done

if [ $failed -ne 0 ]
then
  echo "$failed files failed out of $count"
  let "ret+=$failed"
fi

if [ $ret -eq 0 ]
then
  echo "Success!"
fi
exit $ret


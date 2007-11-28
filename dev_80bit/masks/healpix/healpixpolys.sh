#! /bin/bash
# USAGE: healpixpolys.scr <Nside> <scheme> <p> <r> <polygon_outfile>

mangledir=../../bin/

if [ "$1" != 0 ]; then
 for ((  I = 1 ;  I < 8192 ;  I = `expr 2 \* $I`  ))
 do
  if [ "$1" = "$I" ]; then
   FLAG=1
  fi
 done

 if [ "$FLAG" != 1 ]; then
  echo "USAGE: healpixpolys.scr <Nside> <scheme> <p> <r> <polygon_outfile>"
  echo "<Nside> must be a power of 2."
  echo "<scheme> is the pixelization scheme to use; <p> is the number of polygons allowed in each pixel; <r> is the maximum pixelization resolution."
  exit 1
 fi
fi

if [ "$1" = 0 ]; then
 POLYS=1
else
 POLYS=`expr 12 \* $1 \* $1`
fi

echo healpix_weight $POLYS >> jhw
for ((  I = 0 ;  I < POLYS;  I++  ))
do
  echo 0 >> jhw
done

${mangledir}poly2poly jhw jp
rm jhw
#note that -vo switch is needed in order to keep the correct id numbers (the HEALPix NESTED pixel numbers)

${mangledir}pixelize -P$2$3,$4 -vo jp jpx
rm jp

${mangledir}snap -vo jpx $5
rm jpx

echo "HEALPix pixels at Nside=$1 written to $5"
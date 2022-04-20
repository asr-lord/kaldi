#!/usr/bin/env bash

# Copyright  2014  University of Edinburgh (Author: Pawel Swietojanski, Jonathan Kilgour)
#            2015  Brno University of Technology (Author: Karel Vesely)
#            2016  Johns Hopkins University (Author: Daniel Povey)
#


. utils/parse_options.sh

if [ $# -ne 2 ]; then
  echo "Usage: $0 <mic> <ami-dir>"
  echo " where <mic> is either ihm, sdm1 or mdm8, and <ami-dir> is download space."
  echo "e.g.: $0 sdm1 /foo/bar/AMI"
  echo "Note: this script won't actually re-download things if called twice,"
  echo "because we use the --continue flag to 'wget'."
  exit 1;
fi
mic=$1
adir=$2

amiurl=http://groups.inf.ed.ac.uk/ami
#annotver=ami_public_manual_1.6.1
wdir=data/local/downloads

case $mic in
  ihm)
  ;;
  mdm8) mics="1 2 3 4 5 6 7 8"
  ;;
  sdm1) mics="1"
  ;;
  mix)  mics="1"
  ;;
  *) echo "Wrong 'mic' option $mic" && exit 1
  ;;
esac
echo "mics set to '$mics'"

mkdir -p $adir
mkdir -p $wdir/log

#download annotations
#
#annot="$adir/$annotver"
#if [[ ! -d $adir/annotations || ! -f "$annot" ]]; then
#  echo "Downloading annotiations..."
#  wget -nv -O $annot.zip $amiurl/AMICorpusAnnotations/$annotver.zip &> $wdir/log/download_ami_annot.log
#  mkdir -p $adir/annotations
#  unzip -o -d $adir/annotations $annot.zip &> /dev/null
#fi
#[ ! -f "$adir/annotations/AMI-metadata.xml" ] && echo "$0: File AMI-Metadata.xml not found under $adir/annotations." && exit 1;

#download waves

cat local/split_train.orig local/split_eval.orig local/split_dev.orig > $wdir/ami_meet_ids.flist

wgetfile=$wdir/wget_$mic.sh

# TODO fix this with Pawel, files don't exist anymore,
manifest="wget --continue -O $adir/MANIFEST.TXT http://groups.inf.ed.ac.uk/ami/download/temp/amiBuild-04237-Sun-Jun-15-2014.manifest.txt"
license="wget --continue -O $adir/LICENCE.TXT http://groups.inf.ed.ac.uk/ami/download/temp/Creative-Commons-Attribution-NonCommercial-ShareAlike-2.5.txt"

echo "#!/usr/bin/env bash" > $wgetfile
echo $manifest >> $wgetfile
echo $license >> $wgetfile

if [ "$mic" == "ihm" ]; then
  extra_headset= #some meetings have 5 sepakers (headsets)
  for line in EN2001a EN2001b EN2001d EN2001e EN2002a EN2002b EN2002c EN2002d EN2003a EN2004a EN2005a EN2006a EN2006b EN2009b EN2009c EN2009d ES2002a ES2002b ES2002c ES2002d ES2003a ES2003b ES2003c ES2003d ES2004a ES2004b ES2004c ES2004d ES2005a ES2005b ES2005c ES2005d ES2006a ES2006b ES2006c \
    ES2006d ES2007a ES2007b ES2007c ES2007d ES2008a ES2008b ES2008c ES2008d ES2009a ES2009b ES2009c ES2009d ES2010a ES2010b ES2010c ES2010d ES2011a ES2011b ES2011c ES2011d ES2012a ES2012b ES2012c ES2012d ES2013a ES2013b ES2013c ES2013d ES2014a ES2014b ES2014c ES2014d ES2015a ES2015b ES2015c \
    ES2015d ES2016a ES2016b ES2016c ES2016d IB4001 IB4002 IB4003 IB4004 IB4005 IB4010 IB4011 IN1001 IN1002 IN1005 IN1007 IN1008 IN1009 IN1012 IN1013 IN1014 IN1016 IS1000a IS1000b IS1000c IS1000d IS1001a IS1001b IS1001c IS1001d IS1002b IS1002c IS1002d IS1003a IS1003b IS1003c IS1003d IS1004a \
    IS1004b IS1004c IS1004d IS1005a IS1005b IS1005c IS1006a IS1006b IS1006c IS1006d IS1007a IS1007b IS1007c IS1007d IS1008a IS1008b IS1008c IS1008d IS1009a IS1009b IS1009c IS1009d TS3003a TS3003b TS3003c TS3003d TS3004a TS3004b TS3004c TS3004d TS3005a TS3005b TS3005c TS3005d TS3006a TS3006b \
    TS3006c TS3006d TS3007a TS3007b TS3007c TS3007d TS3008a TS3008b TS3008c TS3008d TS3009a TS3009b TS3009c TS3009d TS3010a TS3010b TS3010c TS3010d TS3011a TS3011b TS3011c TS3011d TS3012a TS3012b TS3012c TS3012d; do
    for m in 0 1 2 3 4 5; do
      # Hint: avoiding re-download by '--continue',
      echo "wget -nv --continue -P $adir/$line/audio $amiurl/AMICorpusMirror/amicorpus/$line/audio/$line.Headset-$m.wav" >> $wgetfile
     done
  done
elif [ "$mic" == "mix" ]; then
  for line in EN2001a EN2001b EN2001d EN2001e EN2002a EN2002b EN2002c EN2002d EN2003a EN2004a EN2005a EN2006a EN2006b EN2009b EN2009c EN2009d ES2002a ES2002b ES2002c ES2002d ES2003a ES2003b ES2003c ES2003d ES2004a ES2004b ES2004c ES2004d ES2005a ES2005b ES2005c ES2005d ES2006a ES2006b ES2006c \
      ES2006d ES2007a ES2007b ES2007c ES2007d ES2008a ES2008b ES2008c ES2008d ES2009a ES2009b ES2009c ES2009d ES2010a ES2010b ES2010c ES2010d ES2011a ES2011b ES2011c ES2011d ES2012a ES2012b ES2012c ES2012d ES2013a ES2013b ES2013c ES2013d ES2014a ES2014b ES2014c ES2014d ES2015a ES2015b ES2015c \
      ES2015d ES2016a ES2016b ES2016c ES2016d IB4001 IB4002 IB4003 IB4004 IB4005 IB4010 IB4011 IN1001 IN1002 IN1005 IN1007 IN1008 IN1009 IN1012 IN1013 IN1014 IN1016 IS1000a IS1000b IS1000c IS1000d IS1001a IS1001b IS1001c IS1001d IS1002b IS1002c IS1002d IS1003a IS1003b IS1003c IS1003d IS1004a \
      IS1004b IS1004c IS1004d IS1005a IS1005b IS1005c IS1006a IS1006b IS1006c IS1006d IS1007a IS1007b IS1007c IS1007d IS1008a IS1008b IS1008c IS1008d IS1009a IS1009b IS1009c IS1009d TS3003a TS3003b TS3003c TS3003d TS3004a TS3004b TS3004c TS3004d TS3005a TS3005b TS3005c TS3005d TS3006a TS3006b \
      TS3006c TS3006d TS3007a TS3007b TS3007c TS3007d TS3008a TS3008b TS3008c TS3008d TS3009a TS3009b TS3009c TS3009d TS3010a TS3010b TS3010c TS3010d TS3011a TS3011b TS3011c TS3011d TS3012a TS3012b TS3012c TS3012d; do
      # Hint: avoiding re-download by '--continue',
      echo "wget -nv --continue -P $adir/$line/audio $amiurl/AMICorpusMirror/amicorpus/$line/audio/$line.Mix-Headset.wav" >> $wgetfile
  done
else
  for m in $mics; do
    # Hint: avoiding re-download by '--continue',
    echo "wget -nv --continue -P $adir/$line/audio $amiurl/AMICorpusMirror/amicorpus/$line/audio/$line.Array1-0$m.wav" >> $wgetfile
  done
fi
# done < $wdir/ami_meet_ids.flist

chmod +x $wgetfile
echo "Downloading audio files for $mic scenario."
echo "Look at $wdir/log/download_ami_$mic.log for progress"
$wgetfile &> $wdir/log/download_ami_$mic.log

# Do rough check if #wavs is as expected, it will fail anyway in data prep stage if it isn't,
if [ "$mic" == "ihm" ]; then
  num_files=$(find $adir -iname *Headset* | wc -l)
  if [ $num_files -ne 687 ]; then
    echo "Warning: Found $num_files headset wavs but expected 687. Check $wdir/log/download_ami_$mic.log for details."
    exit 1;
  fi
else
  num_files=$(find $adir -iname *Array1* | wc -l)
  if [[ $num_files -lt 1352 && "$mic" == "mdm" ]]; then
    echo "Warning: Found $num_files distant Array1 waves but expected 1352 for mdm. Check $wdir/log/download_ami_$mic.log for details."
    # exit 1;
  elif [[ $num_files -lt 169 && "$mic" == "sdm" ]]; then
    echo "Warning: Found $num_files distant Array1 waves but expected 169 for sdm. Check $wdir/log/download_ami_$mic.log for details."
    # exit 1;
  fi
fi

echo "Downloads of AMI corpus completed succesfully. License can be found under $adir/LICENCE.TXT"
exit 0;

#!/bin/sh
CPUFILE=/proc/cpuinfo
test -f $CPUFILE || exit 1
NUMPHY=`grep "physical id" $CPUFILE | sort -u | wc -l`
NUMLOG=`grep "processor" $CPUFILE | wc -l`
echo This system has $NUMPHY physical CPUs and $NUMLOG logical CPUs.
NUMCORE=`grep "core id" $CPUFILE | sort -u | wc -l`
echo For every physical CPU there are $NUMCORE cores.
echo -n The CPU is a `grep "model name" $CPUFILE | sort -u | cut -d : -f 2-`
echo " with`grep "cache size" $CPUFILE | sort -u | cut -d : -f 2-` cache"

## CPUID=$(echo `cat /usr/bin/cpuid`)
/usr/bin/cpuid > id.txt
CPUID=id.txt
a=$(echo `cat $CPUID | grep -m1 'extended model' | sed 's/0x//' | awk ' { print $4 } '`)
a+=$(echo `cat $CPUID | grep -m1 'extended family' | sed 's/0x//' | awk ' { print $4 } '`)
a+=$(echo `cat $CPUID | grep -m1 'AMD' | sed 's/(//' | sed 's/)//' | awk ' { print $13 } '`)
a+=$(echo `cat $CPUID | grep -m1 'model' | sed 's/0x//' | awk ' { print $3 } '`)
a+=$(echo `cat $CPUID | grep -m1 'stepping id' | sed 's/0x//' | awk ' { print $4 } '`)
a+=' '
a+=$(echo `cat $CPUID | grep -m1 'processor serial number:' | awk ' { print $4 } '`)
echo CPUID=0x$a

##
## printf '%s%s\n' "$(grep -Pom1 'extended model.*\(\K\d+' <(cpuid))" "$(grep -Pom1 'extended family.*\(\K\d+' <(cpuid))"
## <== derived from http://askubuntu.com/questions/833416/bash-scripting-how-to-concatenate-the-following-strings
## echo "$(grep -Pom1 'extended model.*\(\K\d+' <(cpuid))" <== following command derived from here!
a=$(grep -Pom1 'extended model.*\(\K\d+' < $CPUID)
a+=$(grep -Pom1 'extended family.*\(\K\d+' < $CPUID)
a+=$(grep -Pom1 'AMD.*\(\K\d+' < $CPUID)
a+=$(grep -Pom1 'model.*\(\K\d+' < $CPUID)
a+=$(grep -Pom1 'stepping id.*\(\K\d+' < $CPUID)
a+=' '
## a+=$(grep -Pom1 'processor serial number.*\: \K\d+' < $CPUID)
## a+=$(grep -Pom1 'processor serial number:' < $CPUID)
## echo `grep "processor serial number:" $CPUID` | awk ' { print $4 } ' > cpu.txt
echo $a
rm $CPUID

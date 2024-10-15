#!/bin/bash

if [ ! -r $1 ]
then
	echo "Usage: $0 <dlx_assembly_file>.asm"
	exit 1
fi

asmfile=`echo $1 | sed s/[.].*//g`
perl ./assembler.bin/dlxasm.pl -o $asmfile.bin -list $asmfile.list $1
rm $asmfile.bin.hdr
cat $asmfile.bin | hexdump -v -e '/1 "%02X" /1 "%02X" /1 "%02X" /1 "%02X\n"' 


cp $asmfile.bin .
cp $asmfile.list .
od --width=4 -t xC "$(basename "$1" .asm).bin" | awk '{print $2$3$4$5}' > test.mem

sed -i '/^[[:space:]]*$/d' test.mem

cd ..
setmentor
#source /eda/scripts/init_questa_core_prime 
vsim -do SCRIPTS/a-Toplevel_script.txt 
cd scripts/

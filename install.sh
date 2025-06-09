#!/bin/bash



echo -ne "This script asumes that you have alredy partitioned and mounted your disk/partitions, if not please abort and do that first\nDo you want to continue (Y/n): " 

read acepto

if [[ "$acepto" == "y" || "$acepto" == "Y" ]];then
	echo "Flama maquinola"
	./archinstall.sh
elif [[ "$acepto" == "n" || "$acepto" == "N" ]];then
	echo "Te espero ;D"
fi

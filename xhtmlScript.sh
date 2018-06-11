#!/bin/bash

command="latexml";
destinationDIR="";
destinatioEXT="xhtml";
sourceDIR="./";
sourceEXT="tex";

declare -i count=0;

function list_files()
{
    if !(test -d "$1") 
    then
        #echo $1;
        return;
    fi

    cd "$1";

    for i in *
    do	
        if test -d "$i" #if directory
        then 
			if [ "$i" != "tex" ] && [ "$i" != "texError" ]
			then
            	list_files "$i"; #recursively list files
	    		cd "..";
			fi
        else
            if [ "${i##*.}" = "$sourceEXT" ]
            then
                count=$((count+1));
		$(latexml --xml --destination=$destinationDIR${i%.*}.xml ${i%.*}.$sourceEXT);
       	$(latexmlpost --cmml --nocrossref ${i%.*}.xml --destination=$destinationDIR${i%.*}.$destinatioEXT);
            fi
        fi
    done
}

list_files "$(pwd)"; 

printf "\n------------------------------------------------------------------\n";
printf " -- Total Files Proccess Found: %s" "$count";
printf "\n------------------------------------------------------------------\n";
echo "Done";

#!/bin/bash

command="latexml";
destinationDIR="";
destinatioEXT="xhtml";
sourceDIR="./";
sourceEXT="tex";

declare -i counts=0;

function delete_files()
{
    if !(test -d "$1") 
    then
        return;
    fi

    cd "$1"

    for i in *
    do
        if test -d "$i" #if directory
        then 
	    if [ "$i" != "tex" ] && [ "$i" != "texError" ]
	    then 
            	delete_files "$i" #recursively list files
            	cd "..";
	    fi
        else
            if [ "${i##*.}" = "xml" ]
            then
		$(rm ${i%.*}.xml);
            fi
	    if [ "${i##*.}" = "tex" ]
	    then
		    if [ -f ${i%.*}.xhtml ]
		    then
			if [ ! -d "tex" ]
			then
				echo $(pwd)/tex;
				$(mkdir $(pwd)/tex);
				$(chmod 755 $(pwd)/tex);
			fi
			$(mv ${i%.*}.tex tex/) && counts=$((counts+1));
		    else
			if [ ! -d "texError" ]
			then
				echo $(pwd)/texError;
				$(mkdir $(pwd)/texError);
				$(chmod 755 $(pwd)/texError);
			fi
			$(mv ${i%.*}.tex texError/);
		    fi
	    fi
        fi
    done
}

delete_files "$sourceDIR";

printf "\n------------------------------------------------------------------\n";
printf " -- Total xhtml Files Found: %s" "$counts";
printf "\n------------------------------------------------------------------\n";
echo "Done";

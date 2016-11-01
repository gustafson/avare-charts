for a in `ls *.zip|grep -v webp`; do
#for a in `ls databases.zip|grep -v webp`; do
#for a in `ls ELEV*NEW*.zip REL*zip|grep -v webp`; do
    b=`basename $a .zip`
    ## TMP1=$(tempfile -p tmpf-)
    ## TMP2=$(tempfile -p tmpf-)
    TMP1=$(mktemp)
    TMP2=$(mktemp)
    if [[ ! -f ${b}.webp.zip ]]; then
    
    	if [[ `unzip -l ${a}  *jpg|tail -n1|awk '{print $1}'` -gt 0 ]]; then
    	    echo Starting $a
    	    
    	    mkdir $b 2> /dev/null
    	    pushd $b > /dev/null
    	    unzip -u ../$a > /dev/null
    	    
    	    find {afd,area,minimums,plates,tiles} -type f  2> /dev/null | grep -e jpg -e png |
    		while read FILE; do
    		    if [[ `echo "${FILE##*.}"` == "jpg" ]]; then
    			NEWFILE=`dirname $FILE`/`basename $FILE .jpg`
    			echo "../../${NEWFILE}.png -unsharp 1x1 -background white -alpha remove ${NEWFILE}.png" >> ${TMP1}
    			echo "-quiet -q 75 -m 6 ${NEWFILE}.png -o ${NEWFILE}.webp" >> ${TMP2}
    		    elif [[ `echo "${FILE##*.}"` == "png" ]]; then
    			## Update all but the elevation tiles
    			if [[ ! `echo ${FILE} |grep tiles/6` ]]; then
    			    NEWFILE=`dirname $FILE`/`basename $FILE .png`
    			    echo "-quiet -quiet -lossless -m 6 ${FILE} -o ${NEWFILE}.webp" >> ${TMP2}
    			fi
    		    fi
    		done 
    
    	    cat ${TMP1} | xargs -n8 -P8 convert && rm ${TMP1}
    	    cat ${TMP2} | xargs -n8 -P8 cwebp   && rm ${TMP2}
    
    	    ## Replace all except the elevation tiles
    	    sed -i -e '/tiles\/6/!s/png/webp/' -e 's/jpg/webp/' $b
    
    	    zip -9 ../${b}.webp.zip $b `cat $b |grep -v ^1`
    	    popd > /dev/null
    	    rm -fr $b
    
    	    N1=`unzip -l $a |tail -n1 |tr -s ' '|cut -f3 -d" "`
    	    N2=`unzip -l ${b}.webp.zip |tail -n1 |tr -s ' '|cut -f3 -d" "`
    	    if [[ ! $N1 -eq $N2 ]]; then
    		echo $a $N1 $b $N2 > ${a}.error.txt
    	    fi
    	fi
    fi
    echo Done $a
done

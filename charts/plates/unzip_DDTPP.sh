[[ -d ${1} ]] || mkdir ${1}
pushd ${1}

for zip in ../*zip; do
    echo ${zip}
    RETURN=0;
    ## Deal with differing file extensions that have occasionally occurred
    for TYPE in pdf PDF; do
	if [[ `unzip -qql ${zip} "*${TYPE}"` ]]; then
	    [[ `unzip -qqo ${zip} "*${TYPE}"; echo $?` -eq 0 ]] || RETURN=1
	fi
    done
done

[[ -f ${1}/*pdf ]] && rename pdf PDF ${1}/*pdf

unzip -qq ../DDTPPE*.zip d-TPP_Metafile.xml || RETURN=1

echo $RETURN

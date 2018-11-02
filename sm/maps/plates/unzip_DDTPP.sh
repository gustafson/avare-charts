[[ -d $1 ]] || mkdir $1
pushd $1

for zip in ../*zip; do
    echo ${zip}
    RETURN=0;
    [[ `unzip -qqo ${zip} "*PDF"; echo $?` -eq 0 ]] || RETURN=1
done

unzip ../DDTPPE*.zip d-TPP_Metafile.xml || RETURN 1

echo $RETURN

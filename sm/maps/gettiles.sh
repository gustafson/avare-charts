function mygroup(){
    ./gettiles.py $(extract_corners.sh $1) $(cyclenumber.sh) $1 $2
}

export -f mygroup

for img in charts/sec/*SEC*.tif; do
    BASE=final/`echo $img | cut -d\/ -f3 | sed 's/.\{9\}$//'`-new.zip
    rm -f $BASE
    zip -9 $BASE `mygroup ${img} jpg`
done

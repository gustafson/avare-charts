
CURRENT=`./cyclenumber.sh`
let PAST=$CURRENT-1;
echo $CURRENT $PAST

[[ -d tiles/$CURRENT ]] || mkdir tiles/$CURRENT

for a in ifa ifh ifr; do 
    [[ -d tiles/$PAST/$a ]] && mv tiles/$PAST/$a tiles/$CURRENT/$a
done

for a in maps.e[ahl].*db; do
    sqlite3 $a .dump |sed "s/tiles\/$PAST/tiles\/$CURRENT/" > tmp.txt
    sqlite3 $a.new < tmp.txt
    mv $a.new $a
    echo Updated $a
done

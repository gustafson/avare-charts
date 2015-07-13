CURRENT=`./cyclenumber.sh`
let PAST=$CURRENT-1;
echo $CURRENT $PAST

[[ -d tiles/$CURRENT ]] || mkdir tiles/$CURRENT

for a in 3 4 5; do 
    [[ -d tiles/$PAST/$a ]] && mv tiles/$PAST/$a tiles/$CURRENT/$a
done

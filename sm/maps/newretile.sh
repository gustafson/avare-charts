for a in 50 60 70 75 80 85 90; do 
    find . -name "*\.${a}.jpg" -print0 |du -shc --files0-from=-|grep -v jpg
done

find -name "*.png" -size -855c


#  rename .jpg .70.jpg `find . -name "*jpg"|grep -v "\.[56789]0\.jpg"`


### NOTE
function rmme(){
    echo $0
    [[ `convert $0 -format '%@' info: 2> /dev/null|cut -c 1-3` == "0x0" ]] && rm $0
}
export -f rmme
find . -name "*png" | xargs -n1 -P64 bash -c rmme

find . -name "*png" | xargs -n1 -P64 optipng
find . -name "*png" | xargs -n1 -P64 mogrify -format jpg -quality 85


zip -R -9 sec "tiles/1505a/sec/all/*/*/*.jpg"
zip -R -9 tac "tiles/1505a/tac/all/*/*/*.jpg"


find tiles/$(./cyclenumber.sh)/*/all -name "*png"|xargs -n 1 -P 16 optipng -preserve -quiet

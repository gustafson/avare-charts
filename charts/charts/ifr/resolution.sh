## Base level 0 is two tiles (one per hemisphere). Compute the estimated required resolution.

if [[ `echo $1 |grep -e ENR_AKH` ]]; then
    TR=`echo |awk '{printf("%.20f", (20026376.39)/512/(2**8));}'`
elif [[ `echo $1 |grep -e ENR_H` ]]; then
    TR=`echo |awk '{printf("%.20f", (20026376.39)/512/(2**9));}'`
else
    TR=`echo |awk '{printf("%.20f", (20026376.39)/512/(2**10));}'`
fi

echo ${TR} ${TR}

CMP=~/avare/compare
rm -fr ${CMP}
[[ -d ${CMP} ]] || mkdir -p ${CMP}

for DIR in final ~/avare/1811; do
    for ZIP in ${DIR}/*zip; do
	unzip -l ${ZIP} |
	    awk '{print $4}'
    done |sort -u > allfiles_`basename ${DIR}`.txt
done

OLDTILES=`diff -y --suppress-common-lines allfiles_1811.txt allfiles_final.txt | cut -f1 -d"<" | cut -f1 -d">"|cut -f1 -d"|"`
NEWTILES=`diff -y --suppress-common-lines allfiles_1811.txt allfiles_final.txt | cut -f2 -d"<" | cut -f2 -d">"|cut -f2 -d"|"`

for DIR in final ~/avare/1811; do
    pushd ${DIR}
    for ZIP in *zip; do
	unzip -qq -d ${CMP}/OLD -o ${ZIP} ${OLDTILES}
	unzip -qq -d ${CMP}/NEW -o ${ZIP} ${NEWTILES}
    done
    popd
done

pushd ${CMP}
for DIR in OLD NEW; do
    pushd ${DIR}
    for file in `find . -type f`; do
	mv $file `echo $file | sed s./.-.g | sed s/.-//`;
    done
    popd
done
find . -type d|sort -r|xargs -n1 rmdir

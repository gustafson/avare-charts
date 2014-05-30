#/bin/bash

echo `gdalinfo $1|grep "Upper Left\|Lower Right"|cut -f2 -d\(|cut -f1 -d\)|sed s/,//`

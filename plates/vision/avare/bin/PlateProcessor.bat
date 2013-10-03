
REM Fix detector mode
PlateProcessor.exe E:\Dropbox\work\avare\data\RNAV-GPS--A.jpg -tpl E:\Dropbox\work\avare\data\ref.png -thresh 127 -negate -threshcost 0.07 -savefiximages -txtout

REM This will output cropped OCR candidates from original image.
PlateProcessor.exe E:\Dropbox\work\avare\data\RNAV-GPS--A.jpg_fix_0.png -tpl E:\Dropbox\work\avare\data\ref_FAF2.png -thresh 127 -negate -maxmatches 3 -threshcost 0.07 -outnum 1 -savefiximages
PlateProcessor.exe E:\Dropbox\work\avare\data\RNAV-GPS--A.jpg_fix_0.png -tpl E:\Dropbox\work\avare\data\ref_IAF2.png -thresh 127 -negate -maxmatches 3 -threshcost 0.07 -outnum 2 -savefiximages

PlateProcessor.exe E:\Dropbox\work\avare\data\RNAV-GPS--A.jpg_fix_1.png -tpl E:\Dropbox\work\avare\data\ref_FAF2.png -thresh 127 -negate -maxmatches 3 -threshcost 0.07 -outnum 1 -savefiximages
PlateProcessor.exe E:\Dropbox\work\avare\data\RNAV-GPS--A.jpg_fix_1.png -tpl E:\Dropbox\work\avare\data\ref_IAF2.png -thresh 127 -negate -maxmatches 3 -threshcost 0.07 -outnum 2 -savefiximages

PlateProcessor.exe E:\Dropbox\work\avare\data\RNAV-GPS--A.jpg_fix_2.png -tpl E:\Dropbox\work\avare\data\ref_FAF2.png -thresh 127 -negate -maxmatches 3 -threshcost 0.07 -outnum 1 -savefiximages
PlateProcessor.exe E:\Dropbox\work\avare\data\RNAV-GPS--A.jpg_fix_2.png -tpl E:\Dropbox\work\avare\data\ref_IAF2.png -thresh 127 -negate -maxmatches 3 -threshcost 0.07 -outnum 2 -savefiximages

PlateProcessor.exe E:\Dropbox\work\avare\data\RNAV-GPS--A.jpg_fix_3.png -tpl E:\Dropbox\work\avare\data\ref_FAF2.png -thresh 127 -negate -maxmatches 3 -threshcost 0.07 -outnum 1 -savefiximages
PlateProcessor.exe E:\Dropbox\work\avare\data\RNAV-GPS--A.jpg_fix_3.png -tpl E:\Dropbox\work\avare\data\ref_IAF2.png -thresh 127 -negate -maxmatches 3 -threshcost 0.07 -outnum 2 -savefiximages

REM Text detection mode
PlateProcessor.exe E:\Dropbox\work\avare\data\RNAV-GPS--A.jpg -mode 2 -dark 1 -imgout

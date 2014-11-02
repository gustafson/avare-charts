#!/bin/bash

## Run on eagle first, then on thor

## Note to extract to svg without inkscape, pstoedit seems to be the best at preserving text rather than glyph.  But it looks pretty ugly and it gets both the glyph (as polygon outline) and the text.  Grep to get rid of the polygon.

##
[[ $# -ne 1 ]] && NP=32

function doit(){
    
    proc=$0
    pdf=`echo $proc |sed s/.png/.pdf/`
    pdf=`ls plates*/$pdf`
    png=`echo $pdf |sed s/.pdf/.png/`

    pngf=$(echo $png |cut -f2-3 -d"/")
    pngf=plates/$pngf
    pdff=$(echo $pdf |cut -f3 -d"/")
    svg=`echo $png |sed s/.png/.geotags.svg/`

    ## echo proc $proc
    echo pdf $pdf $pdff
    ## echo png $png $pngf  
    ## echo svg $svg

    unset SVGTEXT

    if [[ -f $pdf ]]; then
	
	## Gather the array of constants
	## 806x1238
	
 	minmax=($(\
 	sqlite3 geoplates.db "select proc,lon,dx,lat,dy,dx,dy from geoplates where proc=='$proc';" | head -n1 |
 		awk 'BEGIN {FS="|" } ;{printf ("%g %g %g %g %g %g", $2, $2+806.0/$3, $4, $4+1238.0/$5, $6, $7)}'
 		))
	## Check if the domain is reasonable for a plate
	TOOLARGE=`echo ${minmax[0]} ${minmax[1]} ${minmax[2]} ${minmax[3]} | 
	awk 'function abs(x){return ((x < 0.0) ? -x : x)} { if ((abs($1-$2)>3) || (abs($3-$4)>3)) {print 1} else {print 0} }'`
	if [[ $TOOLARGE -eq 1 ]]; then 
	    echo WARNING: $proc is bad
	fi
	## echo ${minmax[*]} 
	
 	AIRPORT=`echo $proc |cut -f1 -d/`;
	APPTYPE=`echo $proc |cut -c 5-7`;
	RUNWAY=`echo $proc |cut -c 8-|grep -o '[0-9][0-9]'`
	
	## sqlite3 main.db .schema
	
 	CIR=($(sqlite3 main.db "select LocationID,ARPLongitude,ARPLatitude from airports where LocationID =='$AIRPORT';"|tr "|" " "))
 	
 	X=`echo ${CIR[1]} ${minmax[0]} ${minmax[4]}|awk '{print ($1-$2)*$3}'`
 	Y=`echo ${CIR[2]} ${minmax[2]} ${minmax[5]}|awk '{print ($1-$2)*$3}'`

	
	if [[ -f $pdf ]]; then
	    COL="255,0,0";
	    
	    SVGTEXT=$(cat << EOF
<svg height="1238" width="806" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" onload="Init(evt)">
<defs>
<style type="text/css"><![CDATA[ 
	    circle.airport {
		stroke: #f00;
		stroke-width: 1.5;
		stroke-opacity:.4;
		fill: #f00;
		fill-opacity:.2;
	    }
	    circle.navaid {
		stroke: #0f0;
		stroke-width: 1.5;
		stroke-opacity:.4;
		fill: #0f0;
		fill-opacity:.2;
	    }
	    circle.fix {
		stroke: #00f;
		stroke-width: 1.5;
		stroke-opacity:.4;
		fill: #00f;
		fill-opacity:.2;
	    }
	    text.airport {
		stroke: #f00;
		fill: #f00;
		text-anchor:"middle";
	    }
	    text.navaid {
		stroke: #0f0;
		fill: #0f0;
		text-anchor:"middle";
	    }
	    text.fix {
		stroke: #00f;
		fill: #00f;
		text-anchor:"middle";
	    }
	    ]]></style>
</defs>
<script type='text/ecmascript'><![CDATA[
	var SVGDocument = null;
	var SVGRoot = null;

	function Init(evt)
	{
	    SVGDocument = evt.target.ownerDocument;
	    SVGRoot = SVGDocument.documentElement;
	}

	function ToggleOpacity(evt, targetId)
	{
	    var newTarget = evt.target;
	    if (targetId)
		{
		    newTarget = SVGDocument.getElementById(targetId);
		}
		var newValue = newTarget.getAttributeNS(null, 'opacity')

		if ('0.05' != newValue)
		    {
			newValue = '0.05';
		    }
		else
		    {
			newValue = '1';
		    }
		    newTarget.setAttributeNS(null, 'opacity', newValue);

		    if (targetId)
			{
			    SVGDocument.getElementById(targetId + 'Exception').setAttributeNS(null, 'opacity', '1');
			}
	}
	]]></script>
EOF
	    )
	    
	    ## Embedd a file or a link to a file
	    ## SVGTEXT+="<image xlink:href=\"$pngf\" x=\"0\" y=\"0\" height=\"1238px\" width=\"806px\"/>"
	    ## SVGTEXT+="<image xlink:href=\"$pdff\" x=\"0\" y=\"0\" height=\"1238px\" width=\"806px\"/>"
	    
	    SVGTEXT+="<image xlink:href=\"data:image/png;base64,"
	    SVGTEXT+=`convert $png png:fd:1|base64`
	    SVGTEXT+="\" x=\"0\" y=\"0\" height=\"1238px\" width=\"806px\"/>"
	    
	    SVGTEXT+="<g id=\"all\">"
	    SVGTEXT+="<rect width=\"806\" height=\"1238\" style=\"fill:rgba(0,0,0,0); stroke-width:3; stroke:rgba(0,0,0,0)\" onclick='ToggleOpacity(evt, \"all\")'/>"
	    SVGTEXT+="<g id=\"airports\" onclick='ToggleOpacity(evt, \"airports\")'>"
	    SVGTEXT+="<circle class=\"airport\" cx=\"${X}\" cy=\"${Y}\" r=\"7.5\"/>"
	    SVGTEXT+="<text class=\"airport\" x=\"${X}\" y=\"${Y}\">${CIR[0]}</text>"
	    SVGTEXT+="</g>"
	    
	    X=$(printf "%.0f\n" $X)
	    Y=$(printf "%.0f\n" $Y)
	    
	    CMD="convert -stroke \"rgba(${COL},0.60)\" -fill \"rgba(${COL},0.40)\" -strokewidth 2"
	    CMD+=" -draw \"translate ${X},${Y} circle 0,0 10,0\""
	    CMD+=" -fill \"rgba(${COL},1)\" -pointsize 15 -annotate +${X}+${Y} ${CIR[0]}"
	    
	    PDFTEXT=`pdftotext $pdf -`;
	    if [[ `echo "$PDFTEXT"|wc -l` -gt 5 ]]; then USEPDF=1; else USEPDF=0; fi

	    if [[ $TOOLARGE -eq 0 ]]; then
		if [[ $USEPDF -eq 1 ]]; then 
		    nav=`sqlite3 main.db "select LocationID from nav where ARPLongitude>${minmax[0]} and ARPLongitude<${minmax[1]} and ARPLatitude<${minmax[2]} and ARPLatitude>${minmax[3]};"`
		    nav2=`pdftotext $pdf -| grep -o -F "$nav" |sort |uniq`
		else
		    nav=`sqlite3 procedures.db "select InitialCourse, FinalCourse, MissedCourse from procedures where Airport like '%$AIRPORT' and AppType like '%$APPTYPE%' and Runway like '%$RUNWAY%';"`
		    nav2=`echo $nav |sed -e "s/,/\n/g" -e "s/|/\n/g" -e "s/ //g" | sed -e "/^$/d" | sort | uniq`
		fi
	    fi

	    FORCE=0;

	    ##[[ "plates/GYY/ILS-OR-LOC-RWY-30.png" == $pngf ]]     && nav2=`printf "CGT"` && FORCE=1;

	    ## GREPSTR="\"`echo $nav| sed s/" "/"\\\\\|"/g;`\""
	    
	    SVGTEXT+="<g id=\"navaids\" onclick='ToggleOpacity(evt, \"navaids\")'>"

	    for nav in $nav2; do

	 	nav=`sqlite3 main.db "select LocationID,ARPLongitude,ARPLatitude from nav where LocationID='$nav';"`
		
	  	COL="0,255,0"
	  	CIR=(`echo $nav|tr "|" " "`)
	  	DX=`echo ${CIR[1]} ${minmax[0]} ${minmax[4]}|awk '{print ($1-$2)*$3}'`
	  	DY=`echo ${CIR[2]} ${minmax[2]} ${minmax[5]}|awk '{print ($1-$2)*$3}'`
	 	
	 	if [[ `pdftotext $pdf - |grep -c ${CIR[0]}` > 0 || $FORCE -eq 1 ]]; then
	 	    SVGTEXT+="<circle class=\"navaid\" cx=\"${DX}\" cy=\"${DY}\" r=\"7.5\"/>"
	 	    SVGTEXT+="<text class=\"navaid\" x=\"${DX}\" y=\"${DY}\">${CIR[0]}</text>"
	 	fi
		
	  	DX=$(printf "%.0f\n" $DX)
	  	DY=$(printf "%.0f\n" $DY)
		
	 	if [[ `pdftotext $pdf - |grep -c ${CIR[0]}` > 0 || $FORCE -eq 1 ]]; then
	 	    CMD+=" -stroke \"rgba(${COL},0.60)\" -fill \"rgba(${COL},0.40)\" -strokewidth 2 -draw 'translate ${DX},${DY} circle 0,0 10,0'";
	 	    CMD+=" -fill \"rgba(${COL},1)\" -annotate +${DX}+${DY} ${CIR[0]}";
	 	fi
	    done

	    SVGTEXT+="</g>"


	    if [[ $TOOLARGE -eq 0 ]]; then 
		if [[ $USEPDF -eq 1 ]]; then 
		    fix=`sqlite3 main.db "select LocationID from fix where ARPLongitude>${minmax[0]} and ARPLongitude<${minmax[1]} and ARPLatitude<${minmax[2]} and ARPLatitude>${minmax[3]};"`
		    fix2=`pdftotext $pdf -| grep -o -F "$fix" |sort |uniq`
		else
		    fix=`sqlite3 procedures.db "select InitialCourse, FinalCourse, MissedCourse from procedures where Airport like '%$AIRPORT' and AppType like '%$APPTYPE%' and Runway like '%$RUNWAY%';"`
		    fix2=`echo $nav |sed -e "s/,/\n/g" -e "s/|/\n/g" -e "s/ //g" | sed -e "/^$/d" | sort | uniq`
		fi
	    fi

	    ## GREPSTR="\"`echo $fix| sed s/" "/"\\\\\|"/g;`\""

	    ## Special... identify fixes on older plates without pdf text.
	    FORCE=0;
	    [[ "plates/MTC/ILS-OR-LOC-DME-RWY-01.png" == $pngf ]] && fix2=`printf "ASAKE\nCERUS\nLAJOY\nCASKO"` && FORCE=1;
	    [[ "plates/MTC/ILS-OR-LOC-DME-RWY-19.png" == $pngf ]] && fix2=`printf "SQYRS\nFINEX\nMASEY"` && FORCE=1;
	    [[ "plates/MTC/TACAN-RWY-01.png" == $pngf ]]          && fix2=`printf "ASAKE\nFASLA\nJAXUP"` && FORCE=1;
	    [[ "plates/MTC/TACAN-RWY-19.png" == $pngf ]]          && fix2=`printf "BKKUS\nTOPAE\nSQYRS"` && FORCE=1;
	    [[ "plates/GUS/ILS-OR-LOC-RWY-23.png" == $pngf ]]     && fix2=`printf "CANDO\nOLCER\nGOETH"` && FORCE=1;
	    [[ "plates/GUS/ILS-OR-LOC-RWY-05.png" == $pngf ]]     && fix2=`printf "AVCOB\nBEUKE\nCANDO\nRICHE"` && FORCE=1;
	    [[ "plates/GUS/RNAV-GPS-RWY-05.png" == $pngf ]]       && fix2=`printf "GILDY\nHUMVI\nJOVON\nNAVOJ"` && FORCE=1;
	    [[ "plates/GUS/RNAV-GPS-RWY-23.png" == $pngf ]]       && fix2=`printf "PUDLE\nNIROE\nRILOE\nRURIE"` && FORCE=1;
	    #[[ "plates/GYY/ILS-OR-LOC-RWY-30.png" == $pngf ]]     && fix2=`printf "GARIE\nKIKVE"` && FORCE=1;

	    ## Fixes
	    SVGTEXT+="<g id=\"fixes\" onclick='ToggleOpacity(evt, \"fixes\")'>"
	    #`pdftotext $pdf - |grep -o $GREPSTR |uniq`
	    for fix in $fix2; do
		if [[ $TOOLARGE -eq 0 ]]; then 
		## echo $fix $pdff
	 	    fix=`sqlite3 main.db "select LocationID,ARPLongitude,ARPLatitude from fix where LocationID='$fix';"`
		    
	  	    COL="0,0,255"
	  	    CIR=(`echo $fix|tr "|" " "`)
	  	    
	  	    DX=`echo ${CIR[1]} ${minmax[0]} ${minmax[4]}|awk '{print ($1-$2)*$3}'`
	  	    DY=`echo ${CIR[2]} ${minmax[2]} ${minmax[5]}|awk '{print ($1-$2)*$3}'`
	 	    
	 	    if [[ `pdftotext $pdf - |grep -c ${CIR[0]}` > 0 || $FORCE -eq 1 ]]; then
	 		SVGTEXT+="<circle class=\"fix\" cx=\"${DX}\" cy=\"${DY}\" r=\"7.5\"/>"
	 		SVGTEXT+="<text class=\"fix\" x=\"${DX}\" y=\"${DY}\">${CIR[0]}</text>"
	 	    fi
		    
	  	    DX=$(printf "%.0f\n" $DX)
	  	    DY=$(printf "%.0f\n" $DY)
	  	    
	 	    if [[ `pdftotext $pdf - |grep -c ${CIR[0]}` > 0 || $FORCE -eq 1 ]]; then
	 		CMD+=" -stroke \"rgba(${COL},0.60)\" -fill \"rgba(${COL},0.40)\" -strokewidth 2 -draw 'translate ${DX},${DY} circle 0,0 10,0'";
	 		CMD+=" -fill \"rgba(${COL},1)\" -annotate +${DX}+${DY} ${CIR[0]}";
	 	    fi
		fi
	    done
	    SVGTEXT+="</g>"
	    SVGTEXT+="</g>"

	    if [[ $TOOLARGE -eq 1 ]]; then
		SVGTEXT+="<text class=\"navaid\" x=\"5.0\" y=\"30.0\">THIS PLATE LIKELY HAS ERRANT GEOTAGS</text>"
	    fi
	    
	    CMD1=$CMD
	    CMD1+=" $png ${png}.geotags.png"
	    
	    ## CMD+=" -antialias -depth 8 -quality 00 -colors 31 -size 806x1238 xc:transparent -alpha Background ${proc}.alpha.png"
	    CMD+=" -size 806x1238 xc:transparent -colors 256 png8:${png}.alpha.png"
	    
	    ## For PNG files
	    ## eval $CMD
	    ## eval $CMD1
	    
	    SVGTEXT+="</svg>"
	    echo "$SVGTEXT" > $svg
	    
	else
	    echo missing $png
	fi
    fi
}

export -f doit




CYCLE=`./cyclenumber.sh`

SCOUROPTS="--enable-comment-stripping --enable-id-stripping --indent=none --remove-metadata --set-precision=4 --shorten-ids --strip-xml-prolog --quiet "

function doall (){
    out=$(echo $0 |sed s/.pdf/.svgz/)

    inkscape $0 --vacuum-defs --export-plain-svg=/dev/stdout | 
    python scour/scour.py ${SCOUROPTS} |
    python scour/scour.py ${SCOUROPTS} |
    gzip -9 > ${out}
    echo $out
}


function inkit (){
    out=$(echo $0 |sed s/.pdf/.svg.gz/)
    [[ -f ${out} ]] || inkscape $0 --vacuum-defs --export-plain-svg=/dev/stdout | 
    rsvg-convert -w 806 -h 1238 -f svg |
    sed -e 's/806pt/806/' -e 's/1238pt/1238/' -e 's/<svg/<svg id="plate"/' |
    gzip -9 > ${out}

    echo $out
}

function scourit (){
    echo out
    out=$(echo $0 |sed s/.pdf/.plate.svgz/)
    in=$(echo $0 |sed s/.pdf/.svg.gz/)
    if [[ -f $in ]]; then
	gunzip ${in} -c |
	python scour/scour.py ${SCOUROPTS} | 
	python scour/scour.py ${SCOUROPTS} | 
	## sed "s/<svg/<svg id=\"geotag\"/" |
	gzip -9 > ${out}
	rm ${in}
	## echo $out
    else
	echo file $in non-existant
    fi
}

export -f doall
export -f inkit
export -f scourit




function assembleit (){
GEOTAG="$0";
#for GEOTAG in plates_*/*/*.geotags.svg; do
#    TMP=$(mktemp --suffix=.svg)

    DIR=`dirname $GEOTAG`
    SVG=`basename $GEOTAG .geotags.svg`

    ## echo ${GEOTAG} ${SVG} ${GEOTAG} ${TMP}

    SVGTEXT=$(cat << EOF
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
<defs>
EOF
)

    SVGTEXT+=$(echo)
    SVGTEXT+=`cat ${DIR}/${SVG}.plate.svgz |gunzip -c -|tail -n +2`
    SVGTEXT+=$(echo)
    SVGTEXT+=`cat ${GEOTAG} | sed s/"<svg"/"<svg id=\"geotag\""/`

SVGTEXT+=$(cat << EOF

</defs>

<use xlink:href="#plate"/>
<use xlink:href="#geotag"/>
</svg>
EOF
)

echo "$SVGTEXT" | gzip -9 -c > ${DIR}/${SVG}.svgz
#rm ${TMP}

#done
}


export -f assembleit







## VECTOR SVGS FROM PDF ## if [[ $(hostname) == eagle ]]; then
## VECTOR SVGS FROM PDF ## 
## VECTOR SVGS FROM PDF ##     NP=16
## VECTOR SVGS FROM PDF ##     echo converting plates to svg
## VECTOR SVGS FROM PDF ##     find plates_[A-Z][A-Z] -name "*.pdf" | 
## VECTOR SVGS FROM PDF ##     xargs -P ${NP} -n 1 bash -c inkit 
## VECTOR SVGS FROM PDF ## 
## VECTOR SVGS FROM PDF ## else
## VECTOR SVGS FROM PDF ## 
## VECTOR SVGS FROM PDF ##     NP=32
## VECTOR SVGS FROM PDF ##     echo Creating geotags
## VECTOR SVGS FROM PDF ##     sqlite3 geoplates.db "select proc from geoplates;"| 
## VECTOR SVGS FROM PDF ##     xargs -P${NP} -n1 bash -c doit
## VECTOR SVGS FROM PDF ## 
## VECTOR SVGS FROM PDF ##     echo scouring plates for file size
## VECTOR SVGS FROM PDF ##     find plates_[A-Z][A-Z] -name "*.pdf" | 
## VECTOR SVGS FROM PDF ##     xargs -P ${NP} -n 1 bash -c scourit
## VECTOR SVGS FROM PDF ## 
## VECTOR SVGS FROM PDF ##     #./nextgenplate.sh
## VECTOR SVGS FROM PDF ## 
## VECTOR SVGS FROM PDF ##     ls plates_*/*/*.geotags.svg|
## VECTOR SVGS FROM PDF ##     xargs -P ${NP} -n 1 bash -c assembleit
## VECTOR SVGS FROM PDF ## 
## VECTOR SVGS FROM PDF ## fi


echo Creating geotags
sqlite3 -init init.sql geoplates.db "select proc from geoplates;"| grep AZO|
xargs -P${NP} -n1 bash -c doit
wait

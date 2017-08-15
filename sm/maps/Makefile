# Copyright (c) 2012, Zubair Khan (governer@gmail.com)
# Copyright (c) 2013-2015, Peter A. Gustafson (peter.gustafson@wmich.edu)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in
#   the documentation and/or other materials provided with the
#   distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
# OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
# AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
# WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

## ToDo for "normal" machines.
## 1) Update NP variable in scripts

CYCLE=$(shell ./cyclenumber.sh)
CYCLEDATE28BASE=$(shell ./cycledates.sh 28 base)
CYCLEDATE56BASE=$(shell ./cycledates.sh 56 base)
CYCLEDATE28=$(shell ./cycledates.sh 28)
CYCLEDATE56=$(shell ./cycledates.sh 56)
GDALVERSION=$(shell gdal-config --version)
NP=$(shell grep proc /proc/cpuinfo|wc -l)

all:
	@echo
	@echo
	@echo "Build instructions for Avare charts"
	@echo "  Minimum gdal version is 2.0"
	@echo "  -- Current gdal version is $(GDALVERSION)"
	@echo "  Machine has $(NP) processors, assuming all may be used."
	@echo
	@echo "Pull the latest code"
	@echo "  git pull"
	@echo
	@echo 'execute "make clean" to clean out temp files'
	@echo
	@echo 'execute "make update" to update a prior build (saving download time)'
	@echo 'execute "make scratch" to start from scratch'
	@echo
	@echo "Due to FAA posting sequence, this may be the preferred order for this cycle (all included in above)."
ifeq ($(CYCLEDATE28), $(CYCLEDATE56))
	@echo "  make download-ifr #$(CYCLEDATE56)"
endif
	@echo "  make update-vfr #$(CYCLEDATE28)"
ifeq ($(CYCLEDATE28), $(CYCLEDATE56))
	@echo "  make rename"
	@echo "  make stage-all #$(CYCLEDATE56)"
else
	@echo "  make stage-vfr #$(CYCLEDATE28)"
endif
	@echo
	@echo "  make download-cifp #$(CYCLE)"
	@echo "  make procedures.db #$(CYCLEDATE28)"
	@echo
	@echo "  make download-plates #$(CYCLE)"
	@echo "  make plates-png #$(CYCLEDATE28)"
	@echo "  make mins-data #$(CYCLEDATE28)"
ifeq ($(CYCLEDATE28), $(CYCLEDATE56))
	@echo
	@echo "  make download-afd #$(CYCLEDATE56)"
	@echo "  make afd-data #$(CYCLEDATE56)"
endif
	@echo
	@echo "  make download-base-data #$(CYCLEDATE56BASE) $$(./cycledates.sh 28 dof)"
	@echo "  make process-data #$(CYCLEDATE56BASE)"
	@echo
	@echo "  make geolist #$(CYCLEDATE28)"
	@echo "  make canada"
	@echo "  make ziptiles"
	@echo "  make zipdatabase"
	@echo "  make qualitycontrol"

scratch: download-ifr download-vfr rename stage-all plates download-base-data process-data zipdatabase
update: download-ifr update-vfr rename stage-all plates download-base-data process-data zipdatabase

clean:
	find final -type f|grep -v "CAN_\|REL_\|ELEV_"| xargs rm # \|ELUS_\|EHUS\|AFD_
	rm -rf merge ads.txt
	rm -f sepsec septac stage-vfr-sec stage-ifr-low stage-ifr-area stage-ifr-high stage-vfr-tac *.tif *.jpg *.xml
	rm -f files*.csv logfile.txt *.log
	rm -f ifr-gps-currency*{kmz,json,txt}

download-base-data:
	$$(rm -f APT.txt AWOS.txt FIX.txt TWR.txt DOF.DAT NAV.txt AWY.txt aixm5.0.zip DAILY_DOF.ZIP)
	## obstacles file.  Get this first as it is usually last posted... will thus not download the rest unless successful.
	## https://nfdc.faa.gov/tod/public/TOD_DOF.html
	## wget -N --no-check-certificate https://nfdc.faa.gov/tod/public/DOFS/DOF_$$(./cycledates.sh 56 dof).zip && unzip DOF*.zip DOF.DAT && rm DOF*.zip
	echo "USING Daily DOF file rather than 56 day cycle.  This is, on average, more current than the 56 day cycle."
	wget -N --no-check-certificate https://nfdc.faa.gov/tod/DAILY_DOF.ZIP && unzip DAILY_DOF.ZIP DOF.DAT && rm -f DAILY_DOF.ZIP
	# https://nfdc.faa.gov/fadds/subscriptionDownload.do?productId=548752
	## https://nfdc.faa.gov/webContent/28DaySub/2017-04-27/APT.zip
	wget -N --no-check-certificate https://nfdc.faa.gov/webContent/28DaySub/$(CYCLEDATE28BASE)/APT.zip && unzip APT.zip && rm -f APT.zip
	wget -N --no-check-certificate https://nfdc.faa.gov/webContent/28DaySub/$(CYCLEDATE28BASE)/AWOS.zip && unzip AWOS.zip && rm -f AWOS.zip
	wget -N --no-check-certificate https://nfdc.faa.gov/webContent/28DaySub/$(CYCLEDATE28BASE)/TWR.zip && unzip TWR.zip && rm -f TWR.zip
	wget -N --no-check-certificate https://nfdc.faa.gov/webContent/28DaySub/$(CYCLEDATE28BASE)/FIX.zip && unzip FIX.zip && rm -f FIX.zip
	wget -N --no-check-certificate https://nfdc.faa.gov/webContent/28DaySub/$(CYCLEDATE28BASE)/NAV.zip && unzip NAV.zip && rm -f NAV.zip
	wget -N --no-check-certificate https://nfdc.faa.gov/webContent/28DaySub/$(CYCLEDATE28BASE)/AWY.zip && unzip AWY.zip && rm -f AWY.zip
	./saa.sh							     $(CYCLEDATE28BASE)
	wget -N --no-check-certificate https://www.outerworldapps.com/WairToNowWork/avare_aptdiags.php && mv avare_aptdiags.php airdiags/aptdiags.csv

process-data:
	./saa.pl > saa.csv
	./airport.pl > airport.csv
	./runway.pl > runway.csv
	./freq.pl > freq.csv
	./fix.pl > fix.csv
	./nav.pl > nav.csv
	./dof.pl > dof.csv
	./awos.pl > awos.csv
	./aw.pl > aw.csv

plates-png: 
	[[ -f d-TPP_Metafile.xml.zip.$(CYCLE) ]] && unzip -o d-TPP_Metafile.xml.zip.$(CYCLE)
	./plates_png.sh

download-plates: 
	@echo This is currently done on eagle:
	@echo "  wget -c -b http://www.aeronav.faa.gov/upload_313-d/terminal/DDTPPA_20$(CYCLE).zip"
	@echo "  wget -c -b http://www.aeronav.faa.gov/upload_313-d/terminal/DDTPPB_20$(CYCLE).zip"
	@echo "  wget -c -b http://www.aeronav.faa.gov/upload_313-d/terminal/DDTPPC_20$(CYCLE).zip"
	@echo "  wget -c -b http://www.aeronav.faa.gov/upload_313-d/terminal/DDTPPD_20$(CYCLE).zip"
	@echo "  wget -c -b http://www.aeronav.faa.gov/upload_313-d/terminal/DDTPPE_20$(CYCLE).zip"
	@echo "  wait"

download-cifp: 
	@echo on thor:
	@echo "  pushd ~/CIFP"
	@echo "  wget -c http://www.aeronav.faa.gov/Upload_313-d/cifp/cifp_20$(CYCLE).zip"
	@echo "and complete the processing:"
	@echo "  popd"

download-afd:
	@echo This is currently done on eagle:
	@echo "  wget -c http://www.aeronav.faa.gov/upload_313-d/supplements/DCS_$(shell ./cycledates.sh 56 afd).zip"

afd-data:
	echo http://www.aeronav.faa.gov/upload_313-d/supplements/DCS_20160526.zip
	rm -f afd.csv
	./afd.sh

mins-data:
	./domins.sh $(CYCLE)

download-vfr:
	echo Downloading vfr for cycle $(CYCLE)
	mkdir merge
	mkdir -p charts/wac  
	mkdir -p charts/sec 
	mkdir -p charts/tac
	mkdir -p charts/oth
	cd charts/sec && \
	perl ../../reapfiles.pl -f zip http://www.faa.gov/air_traffic/flight_info/aeronav/digital_products/vfr/
	rm -f *_P.zip *NFN.zip
	mv *TAC*zip ../tac
	mv C[CDEFGHJ]* ../wac
	mv *Heli.zip ../oth

update-vfr:
	./update_vfr_charts.sh ## New process gets only updates

download-ifr:
	echo Downloading ifr for cycle $(CYCLE)
	#if [[ -d charts/ifr ]]; then rm -fr charts/ifr; fi
	## if [[ -d charts/ifh ]]; then rm -fr charts/ifh; fi
	## if [[ -d charts/ifal ]]; then rm -fr charts/ifal; fi
	## if [[ -d charts/ifa ]]; then rm -fr charts/ifa; fi
	## if [[ -d charts/ifah ]]; then rm -fr charts/ifah; fi
	#mkdir -p charts/ifr
	## mkdir -p charts/ifh
	## mkdir -p charts/ifa
	## mkdir -p charts/ifal
	## mkdir -p charts/ifah
	cd charts/ifr && wget -N http://aeronav.faa.gov/enroute/$$(../../cycledates.sh 56 ifr)/DDECUS.zip
	./dlifr.sh $$(./cycledates.sh 56 ifr)
	## cd charts/ifr && rm -f *pdf*zip *tif
	cd charts/ifr && unzip -f -o -j DDECUS.zip
	cd charts/ifr && ls *zip | grep -v -e DDECUS.zip -e delcb | xargs -n1 -P$(NP) unzip -f -o -j  ## Don't use carribean which isn't geotagged
	@echo Done downloading and unziping ifr charts

rename:
	## rm -f charts/*/*tif
	## cd charts/tac  && ls *zip | awk '{printf "%s *tif\n", $$1}' | xargs -n2 -P$(NP) unzip -j
	## cd charts/wac  && ls *zip | awk '{printf "%s *tif\n", $$1}' | xargs -n2 -P$(NP) unzip -j
	## cd charts/sec  && ls *zip | awk '{printf "%s *tif\n", $$1}' | xargs -n2 -P$(NP) unzip -j
	## cd charts/hel && ls *zip | awk '{printf "%s *tif\n", $$1}' | xargs -n2 -P$(NP) unzip -j
	## cd charts/ifh  && ls *zip | awk '{printf "%s *tif\n", $$1}' | xargs -n2 -P$(NP) unzip -j
	## cd charts/ifa  && ls *zip | awk '{printf "%s *tif\n", $$1}' | xargs -n2 -P$(NP) unzip -j
	## cd charts/ifr  && ls *zip | awk '{printf "%s *tif\n", $$1}' | xargs -n2 -P$(NP) unzip -j
	## cd charts/ifah && ls *zip | awk '{printf "%s *tif\n", $$1}' | xargs -n2 -P$(NP) unzip -j
	##cd charts/ifal && ls *zip | awk '{printf "%s *tif\n", $$1}' | xargs -n2 -P$(NP) unzip -j
	#
	@echo Reminder: unzip is done by the download code
	rm -f charts/tac/*Planning*tif
	rename " " "" charts/*/*tif
	rename " " "" charts/*/*tif
	rename " " "" charts/*/*tif
	rename " " "" charts/*/*tif
	rename U.S. US charts/*/*tif


stage-all: stage-vfr-sec stage-ifr-low
	## NOTE current limit is disk IO and open files, it is inadvisable to do all at the same time
	cat generate-tiles.pbs| qsub -t 0,1,3,4,5%2 #| sed s/ppn=16/ppn=$(NP)/

stage-ifr: stage-ifr-low
	cat generate-tiles.pbs| qsub -t 3-5%2 #| sed s/ppn=16/ppn=$(NP)/

stage-vfr: stage-vfr-sec
	cat generate-tiles.pbs| qsub -t 0-1%2 #| sed s/ppn=16/ppn=$(NP)/	

stage-ifr-low: charts/ifr/*zip  # charts/ifa/*zip charts/ifh/*zip
	if [[ ! -d merge ]]; then mkdir merge; fi
	gcc -march=native -O3 -Wall stage-ifr-low.c -o stage-ifr-low
	gcc -march=native -O3 -Wall stage-ifr-high.c -o stage-ifr-high
	gcc -march=native -O3 -Wall stage-ifr-area.c -o stage-ifr-area
	./stage-ifr-low
	./stage-ifr-high
	./stage-ifr-area

stage-vfr-sec: charts/sec/*tif charts/wac/*tif charts/tac/*tif
	if [[ ! -d merge ]]; then mkdir merge; fi
	## gcc -march=native -O3 -Wall stagefly.c -o stagefly
	gcc -march=native -O3 -Wall stage-vfr-heli.c -o stage-vfr-heli
	gcc -march=native -O3 -Wall stage-vfr-sec.c -o stage-vfr-sec
	gcc -march=native -O3 -Wall stage-vfr-tac.c -o stage-vfr-tac
	./stage-vfr-heli
	./stage-vfr-sec
	./stage-vfr-tac

ziptiles:
	## ./ziptiles.sh
ifeq ($(CYCLEDATE28), $(CYCLEDATE56))
	qsub -t 0,1,3,4,5 ziptiles512.pbs
else
	qsub -t 0,1 ziptiles512.pbs
endif
	qsub -t 98 ziptiles512.pbs

zipdatabase:
	echo "Zipping cycle " $(CYCLE)
	rm -f main.db
	rm -f final/databases.zip
	sqlite3 main.db < importother.sql
	sqlite3 main.db "VACUUM;"
	sqlite3 tiles.db "VACUUM;"
	cp ~/CIFP/procedures.db .
	sqlite3 procedures.db "VACUUM;"
	rm obs.db; sqlite3 main.db ".dump obs" | sqlite3 obs.db
	sqlite3 main.db "drop table obs; vacuum;"
	sqlite3 obs.db "vacuum;"
	zip -9 -r final/databases.zip procedures.db main.db obs.db
	zip -9 final/databases.zip `find tiles/0/6 -name "*jpg"`
	zip -9 final/databases.zip `find tiles/1/7 -name "*jpg"`
	zip -9 final/databases.zip `find tiles/2/5 -name "*jpg"`
ifeq ($(CYCLEDATE28), $(CYCLEDATE56))
	find tiles/3/6 -name "*png" |xargs -n8 optipng
	find tiles/4/5 -name "*png" |xargs -n8 optipng
	find tiles/5/7 -name "*png" |xargs -n8 optipng
endif
	find tiles/6/6 -name "*png" |xargs -n8 optipng
	zip -9 final/databases.zip `find tiles/3/6 -name "*png"`
	zip -9 final/databases.zip `find tiles/4/5 -name "*png"`
	zip -9 final/databases.zip `find tiles/5/7 -name "*png"`
	zip -9 final/databases.zip `find tiles/6/6 -name "*png"`
	zip -9 final/databases.zip `find tiles/7/5 -name "*jpg"`
	## zip -9 final/databases.zip `find tiles/8/7 -name "*jpg"` ## Canada large and not wanted in US
	## zip -9 final/databases.zip `find tiles/9/8 -name "*png"` ## Heli very large with gulf coast
	pushd final; ../zip.py databases $(CYCLE); popd

zipdatabase256:
	echo "Zipping cycle " $(CYCLE)
	rm -f main.db
	rm -f final/256/databases.zip
	sqlite3 main.db < importother.sql
	sqlite3 main.db "VACUUM;"
	sqlite3 tiles.db "VACUUM;"
	cp ~/CIFP/procedures.db .
	sqlite3 procedures.db "VACUUM;"
	zip -9 -r final/256/databases.zip procedures.db main.db tiles.db
	zip -9 final/256/databases.zip `find tiles/0/7 -name "*jpg"`
	zip -9 final/256/databases.zip `find tiles/1/8 -name "*jpg"`
	zip -9 final/256/databases.zip `find tiles/2/6 -name "*jpg"`
	zip -9 final/256/databases.zip `find tiles/3/7 -name "*png"`
	zip -9 final/256/databases.zip `find tiles/4/6 -name "*png"`
	zip -9 final/256/databases.zip `find tiles/5/8 -name "*png"`
	## zip -9 final/256/databases.zip `find tiles/6/6 -name "*png"` ## New elevation model would be too big to include
	zip -9 final/256/databases.zip `find tiles/7/6 -name "*jpg"`
	## zip -9 final/256/databases.zip `find tiles/8/8 -name "*jpg"` ## Canada large and not wanted in US
	## zip -9 final/256/databases.zip `find tiles/9/9 -name "*png"` ## Heli very large with gulf coast
	pushd final/256/; ../../zip.py databases $(CYCLE); popd

geolist:
	./plates_list.sh
	perl plate_list.pl > list_plates.txt
	mv list_plates.txt final/.

chartpoly.txt:

procedures.db:
	echo This is currently done outside of the avare working directory

canada:
	./ourairports.sh
	./canada_ad.sh

qualitycontrol:
	./qualitycontrol.sh

clean:
	rm -f time.*txt *tif*sql

.PHONY: retile

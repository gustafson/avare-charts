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
CYCLEDATE56BASE=$(shell ./cycledates.sh 56 base)
CYCLEDATE28=$(shell ./cycledates.sh 28)
CYCLEDATE56=$(shell ./cycledates.sh 56)

all:
	@echo
	@echo
	@echo "Build instructions for Avare charts"
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
	@echo "  make unzip"
ifeq ($(CYCLEDATE28), $(CYCLEDATE56))
	@echo "  make stage-all #$(CYCLEDATE56)"
else
	@echo "  make stage-vfr #$(CYCLEDATE28)"
endif
	@echo "  make plates-png #$(CYCLEDATE28)"
	@echo "  make mins-data #$(CYCLEDATE28)"
ifeq ($(CYCLEDATE28), $(CYCLEDATE56))
	@echo "  make afd-data #$(CYCLEDATE56)"
endif
	@echo "  make download-base-data #$(CYCLEDATE56BASE) $$(./cycledates.sh 56 dof)"
	@echo "  make process-data #$(CYCLEDATE56BASE)"
	@echo "  make procedures.db #$(CYCLEDATE28)"
	@echo "  make geolist #$(CYCLEDATE28)"
	@echo "  make canada"
	@echo "  make ziptiles"
	@echo "  make zipit"
	@echo "  make qualitycontrol"

scratch: download-ifr download-vfr unzip stage-all plates download-base-data process-data zipit
update: download-ifr update-vfr unzip stage-all plates download-base-data process-data zipit

clean:
	find final -type f|grep -v "CAN_\|REL_\|ELEV_"| xargs rm # \|ELUS_\|EHUS\|AFD_
	rm -rf merge ads.txt
	rm sepsec septac stage-vfr-sec stage-ifr-low stage-ifr-area stage-ifr-high stage-vfr-tac *.tif *.jpg *.xml
	rm files*.csv logfile.txt *.log
	rm ifr-gps-currency*{kmz,json,txt}

download-base-data:
	$$(rm -f APT.txt AWOS.txt FIX.txt TWR.txt DOF.DAT NAV.txt aixm5.0.zip DAILY_DOF.ZIP)
	## obstacles file.  Get this first as it is usually last posted... will thus not download the rest unless successful.
	## https://nfdc.faa.gov/tod/public/TOD_DOF.html
	## wget --no-check-certificate https://nfdc.faa.gov/tod/public/DOFS/DOF_$$(./cycledates.sh 56 dof).zip && unzip DOF*.zip DOF.DAT && rm DOF*.zip
	echo "USING Daily DOF file rather than 56 day cycle.  This is, on average, more current than the 56 day cycle."
	wget --no-check-certificate https://nfdc.faa.gov/tod/DAILY_DOF.ZIP && unzip DAILY_DOF.ZIP DOF.DAT && rm DAILY_DOF.ZIP
	# https://nfdc.faa.gov/fadds/subscriptionDownload.do?productId=548752
	wget --no-check-certificate https://nfdc.faa.gov/webContent/56DaySub/$(CYCLEDATE56BASE)/APT.zip && unzip APT.zip && rm APT.zip
	wget --no-check-certificate https://nfdc.faa.gov/webContent/56DaySub/$(CYCLEDATE56BASE)/AWOS.zip && unzip AWOS.zip && rm AWOS.zip
	wget --no-check-certificate https://nfdc.faa.gov/webContent/56DaySub/$(CYCLEDATE56BASE)/TWR.zip && unzip TWR.zip && rm TWR.zip
	wget --no-check-certificate https://nfdc.faa.gov/webContent/56DaySub/$(CYCLEDATE56BASE)/FIX.zip && unzip FIX.zip && rm FIX.zip
	wget --no-check-certificate https://nfdc.faa.gov/webContent/56DaySub/$(CYCLEDATE56BASE)/NAV.zip && unzip NAV.zip && rm NAV.zip
	wget --no-check-certificate https://nfdc.faa.gov/webContent/56DaySub/$(CYCLEDATE56BASE)/AWY.zip && unzip AWY.zip && rm AWY.zip
	./saa.sh							     $(CYCLEDATE56BASE)

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
	# wget -N http://aeronav.faa.gov/d-tpp/$(CYCLE)/xml_data/d-TPP_Metafile.xml
	### Currently buying plate xml file so this isn't needed.
	## [[ -f d-TPP_Metafile.xml ]] && rm d-TPP_Metafile.xml || echo
	[[ -f d-TPP_Metafile.xml.zip.$(CYCLE) ]] && unzip -o d-TPP_Metafile.xml.zip.$(CYCLE)
	./plates_png.sh

afd-data:
	[[ -f afd.csv ]] && rm afd.csv
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
	rm *_P.zip *NFN.zip
	mv *TAC*zip ../tac
	mv C[CDEFGHJ]* ../wac
	mv *Heli.zip ../oth

update-vfr:
	./update_vfr_charts.sh ## New process gets only updates

download-ifr:
	echo Downloading ifr for cycle $(CYCLE)
	if [[ -d charts/iff ]]; then rm -fr charts/iff; fi
	if [[ -d charts/ifh ]]; then rm -fr charts/ifh; fi
	if [[ -d charts/ifal ]]; then rm -fr charts/ifal; fi
	if [[ -d charts/ifa ]]; then rm -fr charts/ifa; fi
	mkdir -p charts/iff
	mkdir -p charts/ifh
	mkdir -p charts/ifa
	mkdir -p charts/ifal
	mkdir -p charts/ifah
	./dlifr.sh $$(./cycledates.sh 56 ifr)

unzip:
	rm charts/*/*tif
	cd charts/tac  && ls *zip | awk '{printf "%s *tif\n", $$1}' | xargs -n2 -P16 unzip -j
	cd charts/wac  && ls *zip | awk '{printf "%s *tif\n", $$1}' | xargs -n2 -P16 unzip -j
	cd charts/sec  && ls *zip | awk '{printf "%s *tif\n", $$1}' | xargs -n2 -P16 unzip -j
	cd charts/heli && ls *zip | awk '{printf "%s *tif\n", $$1}' | xargs -n2 -P16 unzip -j
	cd charts/ifh  && ls *zip | awk '{printf "%s *tif\n", $$1}' | xargs -n2 -P16 unzip -j
	cd charts/ifa  && ls *zip | awk '{printf "%s *tif\n", $$1}' | xargs -n2 -P16 unzip -j
	cd charts/iff  && ls *zip | awk '{printf "%s *tif\n", $$1}' | xargs -n2 -P16 unzip -j
	cd charts/ifah && ls *zip | awk '{printf "%s *tif\n", $$1}' | xargs -n2 -P16 unzip -j
	cd charts/ifal && ls *zip | awk '{printf "%s *tif\n", $$1}' | xargs -n2 -P16 unzip -j
	# cd charts/heli && ls *zip | awk '{printf "%s *tif\n", $$1}' | xargs -n2 -P16 unzip -j
	#
	rm charts/tac/*Planning*tif
	rename " " "" charts/*/*tif
	rename " " "" charts/*/*tif
	rename " " "" charts/*/*tif
	rename " " "" charts/*/*tif


stage-all: stage-vfr stage-ifr

stage-ifr:
	if [[ ! -d merge ]]; then mkdir merge; fi
	gcc -march=native -O3 -Wall stage-ifr-low.c -o stage-ifr-low
	gcc -march=native -O3 -Wall stage-ifr-high.c -o stage-ifr-high
	gcc -march=native -O3 -Wall stage-ifr-area.c -o stage-ifr-area
	./stage-ifr-low
	./stage-ifr-high
	./stage-ifr-area
	## NOTE current rate limit is disk IO and open files, do one at a time
	qsub -t 1-3%1 generate-tiles.pbs

stage-vfr:
	./update_ifr_tiles.sh
	if [[ ! -d merge ]]; then mkdir merge; fi
	## gcc -march=native -O3 -Wall stagefly.c -o stagefly
	gcc -march=native -O3 -Wall stage-vfr-heli.c -o stage-vfr-heli
	gcc -march=native -O3 -Wall stage-vfr-sec.c -o stage-vfr-sec
	gcc -march=native -O3 -Wall stage-vfr-tac.c -o stage-vfr-tac
	./stage-vfr-heli
	./stage-vfr-sec
	./stage-vfr-tac
	## NOTE current rate limit is disk IO and open files, do one at a time
	qsub -t 4-6%1 generate-tiles.pbs

ziptiles:
	./ziptiles.sh

zipit:
	echo "Zipping cycle " $(CYCLE)
	if [ -a main.db ]; then rm main.db; fi;
	if [ -a final/databases.zip ]; then rm final/databases.zip; fi;
	sqlite3 main.db < importother.sql
	sqlite3 main.db "VACUUM;"
	sqlite3 tiles.db "VACUUM;"
	cp ~/CIFP/procedures.db .
	sqlite3 procedures.db "VACUUM;"
	zip -9 -r final/databases.zip procedures.db main.db tiles.db
	zip -9 final/databases.zip `find tiles/0/6 -name "*jpg"`
	zip -9 final/databases.zip `find tiles/1/7 -name "*jpg"`
	zip -9 final/databases.zip `find tiles/2/5 -name "*jpg"`
	zip -9 final/databases.zip `find tiles/3/6 -name "*png"`
	zip -9 final/databases.zip `find tiles/4/5 -name "*png"`
	zip -9 final/databases.zip `find tiles/5/7 -name "*png"`
	zip -9 final/databases.zip `find tiles/6/5 -name "*png"`
	zip -9 final/databases.zip `find tiles/7/5 -name "*jpg"`
	## zip -9 final/databases.zip `find tiles/8/7 -name "*jpg"` ## Canada large and not wanted in US
	zip -9 final/databases.zip `find tiles/9/8 -name "*png"`
	pushd final; ../zip.py databases $(CYCLE); popd

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
	rm time.*txt *tif*sql

.PHONY: retile

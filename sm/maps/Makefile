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
CYCLECIFP=$(shell ./cycledates.sh 28 vfrdl)
CYCLEPLATES=$(shell ./cycledates.sh 28 plates)
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
	@echo "  Minimum gdal version is 2.4"
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
	@echo "  make procedures.db #$(CYCLEDATE28)"
	@echo
	@echo "  make download-plates #$(CYCLE)"
	@echo "  make plates-png #$(CYCLEDATE28)"
	@echo "  make mins-data #$(CYCLEDATE28)"
ifeq ($(CYCLEDATE28), $(CYCLEDATE56))
	@echo
	@echo "  make afd.csv #$(CYCLEDATE56)"
endif
	@echo "  make download-and-process-base-data #$(CYCLEDATE56BASE) $$(./cycledates.sh 28 dof)"
	@echo
	@echo "  make geolist #$(CYCLEDATE28)"
	@echo "  make ziptiles"
	@echo "  make canada"
	@echo "  make zipdatabase"
	@echo "  make qualitycontrol"

scratch: download-ifr download-vfr rename stage-all plates download-and-process-base-data zipdatabase
update: download-ifr update-vfr rename stage-all plates download-and-process-base-data zipdatabase

clean:
	find final -type f|grep -v "CAN_\|REL_\|ELEV_"| xargs rm # \|ELUS_\|EHUS\|AFD_
	rm -rf merge ads.txt
	rm -f sepsec septac stage-vfr stage-ifr stage-ifr-area stage-ifr-high stage-vfr-tac *.tif *.jpg *.xml
	rm -f files*.csv logfile.txt *.log
	rm -f ifr-gps-currency*{kmz,json,txt}

download-and-process-base-data:
	$$(rm -f APT.txt AWOS.txt FIX.txt TWR.txt DOF.DAT NAV.txt AWY.txt aixm5.0.zip DAILY_DOF.ZIP)
	## obstacles file.  Get this first as it is usually last posted... will thus not download the rest unless successful.
	## https://nfdc.faa.gov/tod/public/TOD_DOF.html
	## wget -N --no-check-certificate https://nfdc.faa.gov/tod/public/DOFS/DOF_$$(./cycledates.sh 56 dof).zip && unzip DOF*.zip DOF.DAT && rm DOF*.zip
	echo "USING Daily DOF file rather than 56 day cycle.  This is, on average, more current than the 56 day cycle."
	wget -N http://aeronav.faa.gov/Obst_Data/DAILY_DOF_DAT.ZIP && unzip DAILY_DOF_DAT.ZIP DOF.DAT && rm -f DAILY_DOF_DAT.ZIP
	# https://nfdc.faa.gov/fadds/subscriptionDownload.do?productId=548752
	## https://nfdc.faa.gov/webContent/28DaySub/2017-04-27/APT.zip
	wget -N https://nfdc.faa.gov/webContent/28DaySub/$(CYCLEDATE28BASE)/APT.zip && unzip APT.zip && rm -f APT.zip
	wget -N https://nfdc.faa.gov/webContent/28DaySub/$(CYCLEDATE28BASE)/AWOS.zip && unzip AWOS.zip && rm -f AWOS.zip
	wget -N https://nfdc.faa.gov/webContent/28DaySub/$(CYCLEDATE28BASE)/TWR.zip && unzip TWR.zip && rm -f TWR.zip
	wget -N https://nfdc.faa.gov/webContent/28DaySub/$(CYCLEDATE28BASE)/FIX.zip && unzip FIX.zip && rm -f FIX.zip
	wget -N https://nfdc.faa.gov/webContent/28DaySub/$(CYCLEDATE28BASE)/NAV.zip && unzip NAV.zip && rm -f NAV.zip
	wget -N https://nfdc.faa.gov/webContent/28DaySub/$(CYCLEDATE28BASE)/AWY.zip && unzip AWY.zip && rm -f AWY.zip
	./saa.sh							     $(CYCLEDATE28BASE)
	wget -N https://www.outerworldapps.com/WairToNowWork/avare_aptdiags.php && mv avare_aptdiags.php airdiags/aptdiags.csv
	./saa.pl > saa.csv
	./airport.pl > airport.csv
	./runway.pl > runway.csv
	./freq.pl > freq.csv
	./fix.pl > fix.csv
	./nav.pl > nav.csv
	./dof.pl > dof.csv  ## New file format 3/2018
	./dof.sh > dof.csv
	./awos.pl > awos.csv
	./aw.pl > aw.csv

plates-png: 
	# cd plates/DDTPP && unzip DDTPPE*zip d-TPP_Metafile.xml
	cd plates && sbatch plates.pbs

download-plates:
	[[ -d plates/DDTPP ]] || mkdir -p plates/DDTPP
	cd plates/DDTPP && wget -c http://aeronav.faa.gov/upload_313-d/terminal/DDTPPA_$(CYCLEPLATES).zip
	cd plates/DDTPP && wget -c http://aeronav.faa.gov/upload_313-d/terminal/DDTPPB_$(CYCLEPLATES).zip
	cd plates/DDTPP && wget -c http://aeronav.faa.gov/upload_313-d/terminal/DDTPPC_$(CYCLEPLATES).zip
	cd plates/DDTPP && wget -c http://aeronav.faa.gov/upload_313-d/terminal/DDTPPD_$(CYCLEPLATES).zip
	cd plates/DDTPP && wget -c http://aeronav.faa.gov/upload_313-d/terminal/DDTPPE_$(CYCLEPLATES).zip
	cd plates/DDTPP && ../unzip_DDTPP.sh $(CYCLE)

procedures.db: 
	pushd CIFP && wget -c http://aeronav.faa.gov/Upload_313-d/cifp/cifp_$(CYCLECIFP).zip
	pushd CIFP && unzip cifp_$(CYCLECIFP).zip && rm -f procedures.db
	pushd CIFP && make procedures.db && mv procedures.db ..

afd.csv:
	rm -f afd.csv
	sbatch -n 40 afd.sh

mins-data:
	sbatch domins.pbs

download-vfr:
	echo Downloading vfr for cycle $(CYCLE)
	echo This code is old and not recently tested
	mkdir merge
	## mkdir -p charts/wac  
	mkdir -p charts/sec 
	mkdir -p charts/tac
	mkdir -p charts/oth
	mkdir -p charts/fly
	cd charts/sec && \
	perl ../../reapfiles.pl -f zip http://www.faa.gov/air_traffic/flight_info/aeronav/digital_products/vfr/
	rm -f *_P.zip *NFN.zip
	mv *TAC*zip ../tac
	## mv C[CDEFGHJ]* ../wac
	mv *Heli.zip ../oth

update-vfr:
	./update_vfr_charts.sh ## Get updates, clean out old files for any updates

download-ifr:
	## echo Downloading ifr for cycle $(CYCLE)
	rm -f charts/ifr/*tif charts/ifr/*pdf charts/ifr/*zip
	cd charts/ifr && wget -N http://aeronav.faa.gov/enroute/$$(../../cycledates.sh 56 ifr)/DDECUS.zip
	## ./dlifr.sh $$(./cycledates.sh 56 ifr)  ## Currently this only gets the carribean
	cd charts/ifr && unzip -o -j DDECUS.zip
	## 
	## ## Chart L06 requires special treatment... it is tagged for north but contains north and south
	## ## Further, Alaska doesn't have pdf
	cd charts/ifr && ls *zip | grep -e DE[HL] | xargs -n1 -P$(NP) -I {} unzip -o -j {} "*pdf" ## Don't use carribean which isn't geotagged
	cd charts/ifr && mv ENR_L06.pdf ENR_L06N.pdf
	cd charts/ifr && ls *zip | grep -e L06 -e AKL -e ENR_ | xargs -n1 -P$(NP) -I {} unzip -o -j {} "*tif"
	rm charts/ifr/*zip
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
	@rm -f charts/tac/*Planning*tif
	@echo -n $(rename " " "" charts/*/*tif)
	@echo -n $(rename " " "" charts/*/*tif)
	@echo -n $(rename " " "" charts/*/*tif)
	@echo -n $(rename " " "" charts/*/*tif)
	@echo -n $(rename U.S. US charts/*/*tif)
	@echo Files are renamed


stage-all: stage-vfr stage-ifr

stage-ifr: charts/ifr/*zip
	if [[ ! -d merge ]]; then mkdir merge; fi
	gcc -march=native -O3 -Wall stage-ifr-low.c -o stage-ifr-low
	gcc -march=native -O3 -Wall stage-ifr-area.c -o stage-ifr-area
	## ./stage-ifr-low
	./stage-ifr-area
	./ifr-slurm.sh ## This generates ifr low tiles (submitting to generate-tiles.pbs)
	sbatch --array=4-5 generate-tiles.pbs

stage-vfr: charts/sec/*tif charts/tac/*tif #charts/wac/*tif 
	if [[ ! -d merge ]]; then mkdir merge; fi
	sbatch --array=0,1,9 generate-tiles.pbs

ziptiles:
	## ./ziptiles.sh
ifeq ($(CYCLEDATE28), $(CYCLEDATE56))
	sbatch --array=0,1,3,4,5,9 ziptiles512.pbs
else
	sbatch --array=0,1,9 ziptiles512.pbs
endif

temp:
	@for chart in 3; do \
	DEP=`qsub -t $$chart generate-tiles.pbs`; \
	qsub -t $$chart -W depend=afterany:$$DEP ziptiles512.pbs; \
	done

zipdatabase:
	echo "Zipping cycle " $(CYCLE)
	rm -f main.db
	sqlite3 main.db < importother.sql
	sqlite3 main.db "VACUUM;"
	sqlite3 procedures.db "VACUUM;"
	rm obs.db; sqlite3 main.db ".dump obs" | sqlite3 obs.db
	sqlite3 main.db "drop table obs; vacuum;"
	sqlite3 obs.db "vacuum;"
	rm -f final/databases.zip
	## 
	zip -9 final/databases.zip procedures.db main.db obs.db
	zip -9 final/databases.zip `find tiles/[0123457]/[0-5] -name "*webp"` 
	zip -9 final/databases.zip `find tiles/[03]/6 -name "*webp"`
	zip -9 final/databases.zip `find tiles/[15]/[67] -name "*webp"`
	zip -9 final/databases.zip `find tiles/13/[0-7] -name "*webp"` ## Flyway
	zip -9 final/databases.zip `find tiles/6/6 -name "*png"` ## Elevation tiles have not been updated to include lower layers
	## Canada (7) and Heli (8) large and not for general distribution
	pushd final; ../zip.py databases $(CYCLE); popd

zipdatabase256:
	echo "Zipping cycle " $(CYCLE)
	rm -f main.db
	rm -f final/256/databases.zip
	sqlite3 main.db < importother.sql
	sqlite3 main.db "VACUUM;"
	cp ~/CIFP/procedures.db .
	sqlite3 procedures.db "VACUUM;"
	zip -9 -r final/256/databases.zip procedures.db main.db
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

canada:
	wget -N http://ourairports.com/data/airports.csv && ./ourairports.pl > ourairports.csv
	# ./ourairports.sh
	./canada_ad.sh

qualitycontrol:
	./qualitycontrol.sh

clean:
	rm -f time.*txt *tif*sql

.PHONY: retile

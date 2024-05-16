# Copyright (c) 2012, Zubair Khan (governer@gmail.com)
# Copyright (c) 2013-2021, Peter A. Gustafson (peter.gustafson@wmich.edu)
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

CYCLE=$(shell ./cyclenumber.py)
CYCLECIFP=$(shell ./cycledates.sh 28 plates)
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
ifeq ($(CYCLEDATE28), $(CYCLEDATE56))
	@echo "Do 56 Day Cycle"
	@echo "  make download-ifr #$(CYCLEDATE56)"
	@echo "  make download-vfr #$(CYCLEDATE28)"
	@echo "  make rename"
	@echo "  make stage-all #$(CYCLEDATE56) ## Generates all new tiles in tmp space then only overwrites different tiles for 0,1,9,13,3,4,5"
	@echo "  make afd.csv #$(CYCLEDATE56)"
	@echo
endif
	@echo "Do Every Cycle"
	@echo "  make procedures.db #$(CYCLEDATE28)"
	@echo "  make download-plates #$(CYCLE)"
	@echo "  make canada #(available 10 days prior to $(CYCLEDATE56BASE))"
	@echo "  make plates-png #$(CYCLEDATE28)"
	@echo "  make mins-data #$(CYCLEDATE28)"
	@echo "  make download-and-process-base-data #$(CYCLEDATE56BASE) $$(./cycledates.sh 28 dof)"
	@echo
	@echo "Finalize"
	@echo "  make ziptiles"
	@echo "  make zipafd"
	@echo "  make zipdatabase"
	@echo "  make qualitycontrol"
	@echo "  make upload"
	@echo
	@echo "Notes:"
	@echo "* As of 1909 all VFR/IFR tiles are webp lossy.  Some other tiles are still png lossless"
	@echo "* Plates are still png because in-app doesn't look for webp and webp exiftag hasn't been tested"
	@echo "* AFD and canada are png because in-app doesn't look for webp of these"


update: download-ifr download-vfr rename stage-all plates download-and-process-base-data zipdatabase

clean-28:
	rm -f final/CAN_ADS.zip final/*PLATES*
	rm -f time.*txt

download-and-process-base-data:
	$$(rm -f APT.txt AWOS.txt FIX.txt TWR.txt DOF.DAT NAV.txt AWY.txt aixm5.0.zip DAILY_DOF.ZIP)
	echo "USING Daily DOF file rather than 56 day cycle.  This is, on average, more current than the 56 day cycle."
	wget -N http://aeronav.faa.gov/Obst_Data/DAILY_DOF_DAT.ZIP && unzip DAILY_DOF_DAT.ZIP DOF.DAT && rm -f DAILY_DOF_DAT.ZIP
	wget -N https://nfdc.faa.gov/webContent/28DaySub/$(CYCLEDATE28BASE)/APT.zip && unzip APT.zip && rm -f APT.zip
	wget -N https://nfdc.faa.gov/webContent/28DaySub/$(CYCLEDATE28BASE)/AWOS.zip && unzip AWOS.zip && rm -f AWOS.zip
	wget -N https://nfdc.faa.gov/webContent/28DaySub/$(CYCLEDATE28BASE)/TWR.zip && unzip TWR.zip && rm -f TWR.zip
	wget -N https://nfdc.faa.gov/webContent/28DaySub/$(CYCLEDATE28BASE)/FIX.zip && unzip FIX.zip && rm -f FIX.zip
	wget -N https://nfdc.faa.gov/webContent/28DaySub/$(CYCLEDATE28BASE)/NAV.zip && unzip NAV.zip && rm -f NAV.zip
	wget -N https://nfdc.faa.gov/webContent/28DaySub/$(CYCLEDATE28BASE)/AWY.zip && unzip AWY.zip && rm -f AWY.zip
	./saa.sh					 $(CYCLEDATE28BASE)
	wget -N https://www.outerworldapps.com/WairToNowWork/avare_aptdiags.php && mv avare_aptdiags.php airdiags/aptdiags.csv
	./saa.pl > saa.csv
	./airport.pl > airport.csv
	./runway.pl > runway.csv
	./airport.py ## Does both airports and runways
	./freq.pl | iconv -f ISO-8859-1 -t UTF-8 > freq.csv
	./fix.pl > fix.csv
	./nav.pl > nav.csv
	./dof.pl > dof.csv
	./awos.pl > awos.csv
	./aw.pl > aw.csv

plates-png: 
	cd plates && sbatch plates.pbs

download-plates:
	rm -fr plates/DDTPP/*zip && mkdir -p plates/DDTPP
	cd plates/DDTPP && wget -c http://aeronav.faa.gov/upload_313-d/terminal/DDTPPA_$(CYCLEPLATES).zip
	cd plates/DDTPP && wget -c http://aeronav.faa.gov/upload_313-d/terminal/DDTPPB_$(CYCLEPLATES).zip
	cd plates/DDTPP && wget -c http://aeronav.faa.gov/upload_313-d/terminal/DDTPPC_$(CYCLEPLATES).zip
	cd plates/DDTPP && wget -c http://aeronav.faa.gov/upload_313-d/terminal/DDTPPD_$(CYCLEPLATES).zip
	cd plates/DDTPP && wget -c http://aeronav.faa.gov/upload_313-d/terminal/DDTPPE_$(CYCLEPLATES).zip
	cd plates/DDTPP && ../unzip_DDTPP.sh $(CYCLE)

procedures.db: 
	pushd CIFP && wget -c http://aeronav.faa.gov/Upload_313-d/cifp/cifp_$(CYCLECIFP).zip
	pushd CIFP && rm -fr $(CYCLECIFP) && mkdir $(CYCLECIFP)
	pushd CIFP/$(CYCLECIFP) && unzip ../cifp_$(CYCLECIFP).zip
	pushd CIFP && rm -f procedures.db
	pushd CIFP && make procedures.db && mv procedures.db ..
        ### The following is required because osprey (the database prep host) is somehow on the faa blacklist
	ssh pilot.ceas.wmich.edu 'cd /dev/shm/; wget https://www.fly.faa.gov/rmt/data_file/prefroutes_db.csv ; cat prefroutes_db.csv' > prefroutes_db.csv
	sqlite3 procedures.db < importpreferredroutes.txt

afd.csv:
	rm -f afd.csv
	sbatch --nice=10 -w osprey -n 20 afd.sh
	#@echo sbatch -w --dependency=afterok:$(PID) afdzip.pbs

mins-data:
	sbatch domins.pbs

download-vfr:
	./update_vfr_charts.sh ## Get updates, clean out old files for any updates

download-ifr:
	## echo Downloading ifr for cycle $(CYCLE)
	rm -f charts/ifr/*tif charts/ifr/*pdf charts/ifr/*zip
	cd charts/ifr && wget -N http://aeronav.faa.gov/enroute/$$(../../cycledates.sh 56 ifr)/DDECUS.zip
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
	@echo Reminder: unzip is done by the download code
	@rm -f charts/tac/*Planning*tif
	@echo -n $(rename " " "" charts/*/*tif)
	@echo -n $(rename " " "" charts/*/*tif)
	@echo -n $(rename " " "" charts/*/*tif)
	@echo -n $(rename " " "" charts/*/*tif)
	@echo -n $(rename U.S. US charts/*/*tif)
	@echo Files are renamed


stage-all: stage-vfr stage-ifr

stage-ifr: charts/ifr/*tif
	if [[ ! -d merge ]]; then mkdir merge; fi
	sbatch --array=3-5 generate-tiles.pbs

stage-vfr: charts/sec/*tif charts/tac/*tif charts/fly/*tif #charts/wac/*tif 
	if [[ ! -d merge ]]; then mkdir merge; fi
	sbatch --array=0,1,9,13 generate-tiles.pbs

ziptiles:
	sbatch --array=0,1,3,4,5,9,13 ziptiles512.pbs

zipafd:
	sbatch afdzip.pbs

temp:
	@for chart in 3; do \
	DEP=`qsub -t $$chart generate-tiles.pbs`; \
	qsub -t $$chart -W depend=afterany:$$DEP ziptiles512.pbs; \
	done

zipdatabase:
	echo "Zipping cycle " $(CYCLE)
	rm -f main.db mainx.db
	./airport-fix-ids.py
	sqlite3 main.db < importother.sql
	sqlite3 mainx.db < importother-v2.sql
	sqlite3 main.db "VACUUM;"
	sqlite3 mainx.db "VACUUM;"
	sqlite3 procedures.db "VACUUM;"
	rm obs.db; sqlite3 main.db ".dump obs" | sqlite3 obs.db
	sqlite3 main.db "drop table obs; vacuum;"
	sqlite3 mainx.db "drop table obs; vacuum;"
	sqlite3 obs.db "vacuum;"
	rm -f final/databases.zip
	## 
	zip -9 final/databases.zip procedures.db main.db mainx.db obs.db
	zip -9 final/databases.zip `find tiles/[0123457]/[0-5] -name "*webp"` 
	zip -9 final/databases.zip `find tiles/[03]/6 -name "*webp"`
	zip -9 final/databases.zip `find tiles/[15]/[67] -name "*webp"`
	zip -9 final/databases.zip `find tiles/13/[0-7] -name "*webp"` ## Flyway
	zip -9 final/databases.zip `find tiles/6/6 -name "*png"` ## Elevation tiles have not been updated to include lower layers
	## Canada (7) and Heli (8) large and not for general distribution
	#pushd final; ../zip.py databases $(CYCLE); popd

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

updatemanifest:
	## Only these require manifest updates (Includes IFR older than the last cycle conclusion)
	## for a in ENRA_* ELUS_* EHUS_* alternates.zip; do #
	pushd final && for a in `ls *zip`; do \
	    echo Updating $$a; \
	    b=`basename $$a .zip`; \
	    zip -d $$a $$b > /dev/null ; \
	    echo $$b `unzip -l $$a |tail -n1` > $$a.count \
	    @echo ../zip.py `basename $$a .zip` $(CYCLE); \
	    ../zip.py `basename $$a .zip` $(CYCLE); \
	done

canada:
	@echo https://www.navcanada.ca/en/aeronautical-information/operational-guides.aspx
	@echo Canada charts supposed to be release 10 days prior to effective date
	wget -N http://ourairports.com/data/airports.csv && ./ourairports.py > ourairports.csv
	# ./ourairports.sh
	./canada_ad.sh

openflightmaps:
	./openflightmaps.py

qualitycontrol:
	./qualitycontrol.sh

.PHONY: retile

upload:
	rsync -avP final/ apps4av@mamba:/home/apps4av/mamba.dreamhosters.com/new/$(CYCLE)/ --del
	rsync -avP final/ peter@avare.bubble.org:public_html/$(CYCLE)/ --del
	rsync -avP final/ osprey.ceas.wmich.edu:/var/www/osprey.ceas.wmich.edu/htdocs/avare/$(CYCLE)/ --del

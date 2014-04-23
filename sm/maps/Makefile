# Copyright (c) 2012, Zubair Khan (governer@gmail.com)
# Copyright (c) 2013, Peter A. Gustafson (peter.gustafson@wmich.edu)
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

#export LD_LIBRARY_PATH=/usr/local/lib
# Copy APT.txt TWR.txt, FIX.txt, NAV.txt, DOF.DAT
# Set dates in afd.sh get_ads.sh


## ToDo for "normal" machines.
## 1) Update NP variable in scripts

all:
	@echo
	@echo
	@echo "Build instructions for Avare charts"
	@echo
	@echo "Pull the latest code"
	@echo "  git pull"
	@echo
	@echo 'execute "make fresh" to clean out temp files'
	@echo
	@echo "  Change the dates in the download-base-data target of Makefile as applicable"
	@echo "  Change the dates in the download-ifr target of the Makefile as applicable"
	@echo "  Change the date in dlafd.pl if applicable (afd_$$(./cycledates.sh 56).xml on 56 Day cycle)"
	@echo
	@echo 'execute "make update" to update a prior build (saving download time)'
	@echo 'execute "make scratch" to start from scratch'
	@echo
	@echo "Due to FAA posting sequence, this may be the preferred order (all included in above)."
	@echo "  make download-ifr #$$(./cycledates.sh 56)"
	@echo "  make update-vfr #$$(./cycledates.sh 28)"
	@echo "  make unzip"
	@echo "  make stageall"
	@echo "  make plates #$$(./cycledates.sh 28)"
	@echo "  make download-base-data #$$(./cycledates.sh 56)"
	@echo "  make process-data #$$(./cycledates.sh 56)"
	@echo "  make zipit"
	@echo "  make qualitycontrol"

CYCLE=$$(./cyclenumber.sh)

scratch: download-ifr download-vfr unzip stageall plates download-base-data process-data zipit
update: download-ifr update-vfr unzip stageall plates download-base-data process-data zipit

fresh:
	rm -rf plates plates_[A-Z][A-Z]
	rm -rf afd
	rm -rf final
	rm -rf merge
	rm ads.txt APT.txt AWOS.txt FIX.txt TWR.txt
	rm maps.el.db maps.eh.db maps.oth.db maps.sec.db maps.tac.db maps.wac.db
	rm afd.csv airport.csv awos.csv dof.csv files.csv fix.csv freq.csv nav.csv runway.csv ## FIXME Canadian stuff left... update after any refresh
	rm sepsec septac stagesec stageifr stageifa stageifh stagetac *.tif *.jpg *.xml
	mkdir final

download-base-data:
	# https://nfdc.faa.gov/fadds/subscriptionDownload.do?productId=548752
	wget --no-check-certificate https://nfdc.faa.gov/webContent/56DaySub/$$(./cycledates.sh 56 base)/APT.zip && unzip APT.zip && rm APT.zip
	wget --no-check-certificate https://nfdc.faa.gov/webContent/56DaySub/$$(./cycledates.sh 56 base)/AWOS.zip && unzip AWOS.zip && rm AWOS.zip
	wget --no-check-certificate https://nfdc.faa.gov/webContent/56DaySub/$$(./cycledates.sh 56 base)/TWR.zip && unzip TWR.zip && rm TWR.zip
	wget --no-check-certificate https://nfdc.faa.gov/webContent/56DaySub/$$(./cycledates.sh 56 base)/FIX.zip && unzip FIX.zip && rm FIX.zip
	wget --no-check-certificate https://nfdc.faa.gov/webContent/56DaySub/$$(./cycledates.sh 56 base)/NAV.zip && unzip NAV.zip && rm NAV.zip
	./saa.sh							     $$(./cycledates.sh 56 base)
	## obstacles file
	## https://nfdc.faa.gov/tod/public/TOD_DOF.html
	wget --no-check-certificate https://nfdc.faa.gov/tod/public/DOFS/DOF_140302.zip && unzip DOF*.zip DOF.DAT && rm DOF*.zip
	## wget https://nfdc.faa.gov/tod/DAILY_DOF.ZIP && unzip DAILY_DOF.ZIP DOF.DAT && rm DAILY_DOF.ZIP

process-data:
	./saa.pl > saa.csv
	./airport.pl > airport.csv
	./runway.pl > runway.csv
	./freq.pl > freq.csv
	./fix.pl > fix.csv
	./nav.pl > nav.csv
	./dof.pl > dof.csv
	./awos.pl > awos.csv

plates: 
	mkdir plates
	wget -N http://155.178.201.160/d-tpp/$(CYCLE)/xml_data/d-TPP_Metafile.xml
	# wget -N http://www.faa.gov/air_traffic/flight_info/aeronav/digital_products/dtpp && mv index.html d-tpp-index.html
	#./get_ads.sh $(CYCLE) # change cycle here  ## Don't need. They are in the plates already
	## wget -N https://nfdc.faa.gov/webContent/dtpp/current.xml && mv current.xml d-TPP_Metafile.xml
	./plates_png.sh
	./afd.sh 
	./domins.sh $(CYCLE) # change cycle here

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
	mv C[CDEFGH]* ../wac
	mv *Heli.zip ../oth

update-vfr:
	./update_vfr_charts.sh ## New process gets only updates

download-ifr:
	echo Downloading ifr for cycle $(CYCLE)
	if [[ -d charts/iff ]]; then rm -fr charts/iff; fi
	if [[ -d charts/ifh ]]; then rm -fr charts/ifh; fi
	if [[ -d charts/ifal ]]; then rm -fr charts/ifal; fi
	if [[ -d charts/ifah ]]; then rm -fr charts/ifah; fi
	mkdir -p charts/iff
	mkdir -p charts/ifh
	mkdir -p charts/ifal
	mkdir -p charts/ifah
	./dlifr.sh $$(./cycledates.sh 56 ifr) #change date  #IFR low
	./dlifh.sh $$(./cycledates.sh 56 ifr) #change date  #IFH high
	./dlifa.sh $$(./cycledates.sh 56 ifr) #change date  #Alaska high and low

unzip:
	cd charts/tac && rm -rf *.tif && unzip -j \*.zip \*.tif && \
	for file in *\ *; do \
	  mv "$$file" `echo $$file | sed 's/ //g'`;\
	done && \
	rm -f NewYorkTACVFRPlanningCharts*.tif
	cd charts/wac && rm -f *.tif && unzip -j \*.zip \*.tif && \
	for file in *\ *; do \
	  mv "$$file" `echo $$file | sed 's/ //g'`;\
	done
	cd charts/sec && rm -f *.tif && unzip -j \*.zip \*.tif && \
	for file in *\ *; do \
	  mv "$$file" `echo $$file | sed 's/ //g'`;\
	done
	cd charts/oth && rm -f *.tif && unzip -j \*.zip \*.tif && \
	for file in *\ *; do \
	  mv "$$file" `echo $$file | sed 's/ //g'`;\
	done
	cd charts/ifh  && rm -f *.tif && unzip -j \*.zip \*.tif
	cd charts/iff  && rm -f *.tif && unzip -j \*.zip \*.tif
	cd charts/ifah && rm -f *.tif && unzip -j \*.zip \*.tif
	cd charts/ifal && rm -f *.tif && unzip -j \*.zip \*.tif
	cd charts/oth && rm -f *.tif && unzip -j \*.zip \*.tif && \
	for file in *\ *; do \
	  mv "$$file" `echo $$file | sed 's/ //g'`;\
	done


stageall:
	if [[ ! -d merge ]]; then mkdir merge; fi
	gcc -march=native -O3 -Wall stagesec.c -o stagesec -fopenmp
	gcc -march=native -O3 -Wall stageifr.c -o stageifr -fopenmp
	gcc -march=native -O3 -Wall stageifh.c -o stageifh -fopenmp
	gcc -march=native -O3 -Wall stageifal.c -o stageifal -fopenmp
	gcc -march=native -O3 -Wall stageifah.c -o stageifah -fopenmp
	gcc -march=native -O3 -Wall stagetac.c -o stagetac -fopenmp
	## gcc -march=native -O3 -Wall stageheli.c -o stageheli -fopenmp
	## each pbs script could be run as a shell script but is 
	## run through pbs for efficient resource management.
	./stageall.sh $(CYCLE)


zipit:
	## FIXME must find out how to updated canap.csv canfreq.csv canrun.csv
	echo "Zipping cycle " $(CYCLE)
	if [ -a main.db ]; then rm main.db; fi;
	if [ -a final/databases.zip ]; then rm final/databases.zip; fi;
	sqlite3 main.db < importother.sql
	gcc -march=native -O3 -Wall sepsec.c -o sepsec
	gcc -march=native -O3 -Wall septac.c -o septac
	./sepsec $(CYCLE)
	./septac $(CYCLE)
	./sepelus.sh $(CYCLE)
	./sepehus.sh $(CYCLE)
	./sepelev.sh ## FIXME Images and correct db file currently added to the tiles and current directory manually
	./seprel.sh ## FIXME Images and correct db file currently added to the tiles and current directory manually
	./sephelo.sh ## FIXME Images and correct db file currently added to the tiles and current directory manually
	##./septopo.sh copy charts zips on servers as no expires
	##./sepgc.sh copy charts zips on servers as no expires
	sqlite3 maps.eh.db "VACUUM;"
	sqlite3 maps.el.db "VACUUM;"
	sqlite3 maps.sec.db "VACUUM;"
	sqlite3 maps.tac.db "VACUUM;"
	sqlite3 maps.wac.db "VACUUM;"
	sqlite3 maps.oth.db "VACUUM;"
	sqlite3 main.db "VACUUM;"
	# STATIC sqlite3 maps.elv.db "VACUUM;"
	# STATIC sqlite3 maps.rel.db "VACUUM;"
	# STATIC sqlite3 maps.topo.db "VACUUM;"
	## FIXME must add maps.topo.db 
	zip -9 -r final/databases.zip maps.*.db main.db `find tiles/*/*/*/4 -type f|grep -v tif|grep -v topo`

qualitycontrol:
	./qualitycontrol.sh

# Use gdalinfo -approx_stats to check tif files for success.

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
	@echo 'execute \"make fresh\" to clean out temp files'
	@echo
	@echo "  Change the dates in the download-base-data target of Makefile as applicable"
	@echo "  Change the date in dlafd.pl if applicable (afd_12DEC2013.xml)"
	@echo "  Change the dates in the download-ifr target of the Makefile as applicable"
	@echo
	@echo 'execute "make update" to update a prior build (saving download time)'
	@echo 'execute "make scratch" to start from scratch'
	@echo
	@echo "Due to FAA posting sequence, this may be the preferred order (all included in above)."
	@echo "  make download-ifr"
	@echo "  make update-vfr"
	@echo "  make unzip"
	@echo "  make stageall"
	@echo "  make plates"
	@echo "  make download-base-data"
	@echo "  make process-data"
	@echo "  make zipit"

scratch: download-ifr download-vfr unzip stageall plates download-base-data process-data zipit
update: download-ifr update-vfr unzip stageall plates download-base-data process-data zipit

fresh:
	rm -rf plates
	rm -rf afd 
	rm -rf final
	rm -rf merge
	rm -fr tiles/{ifh,ifr,sec,tac,wac}
	rm ads.txt APT.txt AWOS.txt FIX.txt TWR.txt
	rm maps.el.db maps.eh.db maps.oth.db maps.sec.db maps.tac.db maps.wac.db
	rm afd.csv airport.csv awos.csv dof.csv files.csv fix.csv freq.csv nav.csv runway.csv ## FIXME Canadian stuff left... update after any refresh
	rm sepsec septac stagesec stageifr stageifa stageifh stagetac *.tif *.jpeg *.xml

download-base-data:
	# https://nfdc.faa.gov/fadds/subscriptionDownload.do?productId=548752
	wget https://nfdc.faa.gov/webContent/56DaySub/2013-12-12/APT.zip && unzip APT.zip && rm APT.zip
	wget https://nfdc.faa.gov/webContent/56DaySub/2013-12-12/AWOS.zip && unzip AWOS.zip && rm AWOS.zip
	wget https://nfdc.faa.gov/webContent/56DaySub/2013-12-12/TWR.zip && unzip TWR.zip && rm TWR.zip
	wget https://nfdc.faa.gov/webContent/56DaySub/2013-12-12/FIX.zip && unzip FIX.zip && rm FIX.zip
	wget https://nfdc.faa.gov/webContent/56DaySub/2013-12-12/NAV.zip && unzip NAV.zip && rm NAV.zip
	## obstacles file
	wget https://nfdc.faa.gov/tod/public/DOFS/DOF_131110.zip && unzip DOF*.zip DOF.DAT && rm DOF*.zip
	# https://nfdc.faa.gov/webContent/dtpp/current.xml

process-data:
	./saa.sh 2013-12-12
	./airport.pl > airport.csv
	./runway.pl > runway.csv
	./freq.pl > freq.csv
	./fix.pl > fix.csv
	./nav.pl > nav.csv
	./dof.pl > dof.csv
	./awos.pl > awos.csv

plates:
	mkdir plates
	mkdir final
	#./get_ads.sh 1313 # change cycle here  ## Don't need. They are in the plates already
	./plates_png.sh  ## FIXME MANUAL INTERVENTION: the DownloadPlates.pl attempts to redownload the base xml file with every state.  This is error prone due to FAA server timeouts
	./afd.sh # change date here by fixing the date in dlafd.pl (afd_12DEC2013.xml)
	./domins.sh 1313 # change cycle here

download-vfr:
	mkdir merge
	mkdir -p charts/wac  
	mkdir -p charts/sec 
	mkdir -p charts/tac
	cd charts/sec && \
	perl ../../reapfiles.pl -f zip http://aeronav.faa.gov/index.asp?xml=aeronav/applications/VFR/chartlist_sect
	cd charts/tac && \
	perl ../../reapfiles.pl -f zip http://aeronav.faa.gov/index.asp?xml=aeronav/applications/VFR/chartlist_tac
	cd charts/wac && \
	perl ../../reapfiles.pl -f zip http://aeronav.faa.gov/index.asp?xml=aeronav/applications/VFR/chartlist_wac

update-vfr:
	./update_vfr_charts.sh ## New process gets only updates

download-ifr:
	if [[ -d charts/iff ]]; then rm -fr charts/iff; fi
	if [[ -d charts/ifh ]]; then rm -fr charts/ifh; fi
	if [[ -d charts/ifal ]]; then rm -fr charts/ifal; fi
	if [[ -d charts/ifah ]]; then rm -fr charts/ifah; fi
	mkdir -p charts/iff
	mkdir -p charts/ifh
	mkdir -p charts/ifal
	mkdir -p charts/ifah
	./dlifr.sh 12-12-2013 #change date  #IFR low
	./dlifh.sh 12-12-2013 #change date  #IFH high
	./dlifa.sh 12-12-2013 #change date  #Alaska high and low

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
	cd charts/ifh  && rm -f *.tif && unzip -j \*.zip \*.tif
	cd charts/iff  && rm -f *.tif && unzip -j \*.zip \*.tif
	cd charts/ifah && rm -f *.tif && unzip -j \*.zip \*.tif
	cd charts/ifal && rm -f *.tif && unzip -j \*.zip \*.tif

stageall:
	if [[ ! -d merge ]]; then mkdir merge; fi
	gcc -march=native -O3 -Wall stagesec.c -o stagesec -fopenmp
	gcc -march=native -O3 -Wall stageifr.c -o stageifr -fopenmp
	gcc -march=native -O3 -Wall stageifh.c -o stageifh -fopenmp
	gcc -march=native -O3 -Wall stageifal.c -o stageifal -fopenmp
	gcc -march=native -O3 -Wall stageifah.c -o stageifah -fopenmp
	gcc -march=native -O3 -Wall stagetac.c -o stagetac -fopenmp
	## each pbs script could be run as a shell script but is 
	## run through pbs for efficient resource management.
	./stageall.sh

HIGHLEVEL=`sqlite3 maps.eh.db  "select name from files where (level = ' 4');"` \
	`sqlite3 maps.el.db  "select name from files where (level = ' 4');"` \
	`sqlite3 maps.elv.db "select name from files where (level = ' 4');"` \
	`sqlite3 maps.rel.db "select name from files where (level = ' 4');"` \
	`sqlite3 maps.sec.db "select name from files where (level = ' 4');"` \
	`sqlite3 maps.tac.db "select name from files where (level = ' 4');"` \
	`sqlite3 maps.wac.db "select name from files where (level = ' 4');"` \
	`sqlite3 maps.oth.db "select name from files where (level = ' 4');"` 
#	`sqlite3 maps.topo.db "select name from files where (level = ' 4');"` \


zipit:
	## FIXME must find out how to updated canap.csv canfreq.csv canrun.csv
	if [ -a main.db ]; then rm main.db; fi;
	sqlite3 main.db < importother.sql
	gcc -march=native -O3 -Wall sepsec.c -o sepsec
	gcc -march=native -O3 -Wall septac.c -o septac
	./sepsec
	./septac
	./sepelus.sh
	./sepehus.sh
	./sepelev.sh ## FIXME Images and correct db file currently added to the tiles and current directory manually
	./seprel.sh ## FIXME Images and correct db file currently added to the tiles and current directory manually
	./sephelo.sh ## FIXME Images and correct db file currently added to the tiles and current directory manually
	##./septopo.sh copy charts zips on servers as no expires
	##./sepgc.sh copy charts zips on servers as no expires
	sqlite3 maps.eh.db "VACUUM;"
	sqlite3 maps.el.db "VACUUM;"
	sqlite3 maps.elv.db "VACUUM;"
	sqlite3 maps.rel.db "VACUUM;"
	sqlite3 maps.topo.db "VACUUM;"
	sqlite3 maps.sec.db "VACUUM;"
	sqlite3 maps.tac.db "VACUUM;"
	sqlite3 maps.wac.db "VACUUM;"
	sqlite3 maps.oth.db "VACUUM;"
	sqlite3 main.db "VACUUM;"
	## FIXME must add maps.topo.db 
	zip -9 -r final/databases.zip maps.*.db main.db $(HIGHLEVEL)

qualitycontrol:
	./qualitycontrol.sh

# Use gdalinfo -approx_stats to check tif files for success.

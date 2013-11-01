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

all:
	@echo execute \"make update\" or \"make scratch\"

scratch: base download-vfr unzip stageall zipit
update: base update-vfr unzip stageall zipit
base: fresh download-base-data process-data download-ifr 

fresh:
	rm -rf plates
	rm -rf afd 
	rm -rf final
	rm -rf merge
	rm -f maps.eh.db maps.el.db maps.oth.db maps.sec.db maps.tac.db maps.wac.db
	rm -f afd.csv airport.csv awos.csv dof.csv files.csv fix.csv freq.csv nav.csv runway.csv ## FIXME Canadian stuff left... update after any refresh
	rm -f sepsec septac stagesec stageifr stageifh stagetac *.tif *.jpeg *.xml

download-base-data:
	wget https://nfdc.faa.gov/webContent/56DaySub/2013-10-17/APT.zip && unzip APT.zip && rm APT.zip
	wget https://nfdc.faa.gov/webContent/56DaySub/2013-10-17/AWOS.zip && unzip AWOS.zip && rm AWOS.zip
	wget https://nfdc.faa.gov/webContent/56DaySub/2013-10-17/TWR.zip && unzip TWR.zip && rm TWR.zip
	wget https://nfdc.faa.gov/webContent/56DaySub/2013-10-17/FIX.zip && unzip FIX.zip && rm FIX.zip
	wget https://nfdc.faa.gov/webContent/56DaySub/2013-10-17/NAV.zip && unzip NAV.zip && rm NAV.zip
	## obstacles file
	wget https://nfdc.faa.gov/tod/public/DOFS/DOF_1300915.zip && unzip DOF*.zip DOF.DAT && rm DOF*.zip
	# https://nfdc.faa.gov/webContent/dtpp/current.xml

process-data:
	mkdir plates
	mkdir final
	./airport.pl > airport.csv
	./runway.pl > runway.csv
	./freq.pl > freq.csv
	./fix.pl > fix.csv
	./nav.pl > nav.csv
	./dof.pl > dof.csv
	./awos.pl > awos.csv
	#./get_ads.sh 1311 # change cycle here  ## Don't need. Zubair says they are in the plates already
	./plates_png.sh
	./afd.sh # change date here  
	./domins.sh 1311 # change cycle here

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
	if [[ -d charts/ifa ]]; then rm -fr charts/ifa; fi
	mkdir -p charts/iff
	mkdir -p charts/ifh
	mkdir -p charts/ifa
	cd charts/iff && ../../dlifr.sh 10-17-2013 #change date
	cd charts/ifh && ../../dlifh.sh 10-17-2013 #change date
	cd charts/ifa && ../../dlifa.sh 10-17-2013 #change date

unzip:
	cd charts/tac && \
	rm -rf *.tif && \
	unzip -j \*.zip \*.tif && \
	for file in *\ *; do \
		mv "$$file" `echo $$file | sed 's/ //g'`;\
	done && \
	rm -f NewYorkTACVFRPlanningCharts*.tif
	cd charts/wac && \
	rm -f *.tif && \
	unzip -j \*.zip \*.tif && \
	for file in *\ *; do \
		mv "$$file" `echo $$file | sed 's/ //g'`;\
	done
	cd charts/sec && \
	rm -f *.tif && \
	unzip -j \*.zip \*.tif && \
	for file in *\ *; do \
		mv "$$file" `echo $$file | sed 's/ //g'`;\
	done
	cd charts/ifh && \
	rm -f *.tif && \
	unzip -j \*.zip \*.tif
	cd charts/iff && \
	rm -f *.tif && \
	unzip -j \*.zip \*.tif

stageall:
	if [[ ! -d merge ]]; then mkdir merge; fi
	gcc -march=native -O3 -Wall stagesec.c -o stagesec -fopenmp
	gcc -march=native -O3 -Wall stageifr.c -o stageifr -fopenmp
	gcc -march=native -O3 -Wall stageifh.c -o stageifh -fopenmp
	gcc -march=native -O3 -Wall stagetac.c -o stagetac -fopenmp
	## each pbs script could be run as a shell script but is 
	## run through pbs for efficient resource management.
	./stageall.sh

## 	This allows high level tiles to be included in databases.zip.
HIGHLEVELS=`sqlite3 maps.eh.db  "select name from files where (level = ' 3') or (level = ' 4');"` \
	`sqlite3 maps.el.db  "select name from files where (level = ' 3') or (level = ' 4');"` \
	`sqlite3 maps.elv.db "select name from files where (level = ' 3') or (level = ' 4');"` \
	`sqlite3 maps.rel.db "select name from files where (level = ' 3') or (level = ' 4');"` \
	`sqlite3 maps.sec.db "select name from files where (level = ' 3') or (level = ' 4');"` \
	`sqlite3 maps.tac.db "select name from files where (level = ' 3') or (level = ' 4');"` \
	`sqlite3 maps.wac.db "select name from files where (level = ' 3') or (level = ' 4');"` \
	`sqlite3 maps.oth.db "select name from files where (level = ' 3') or (level = ' 4');"` 

HIGHLEVEL=`sqlite3 maps.eh.db  "select name from files where (level = ' 4');"` \
	`sqlite3 maps.el.db  "select name from files where (level = ' 4');"` \
	`sqlite3 maps.elv.db "select name from files where (level = ' 4');"` \
	`sqlite3 maps.rel.db "select name from files where (level = ' 4');"` \
	`sqlite3 maps.sec.db "select name from files where (level = ' 4');"` \
	`sqlite3 maps.tac.db "select name from files where (level = ' 4');"` \
	`sqlite3 maps.wac.db "select name from files where (level = ' 4');"` \
	`sqlite3 maps.oth.db "select name from files where (level = ' 4');"` 

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
	sqlite3 maps.sec.db "VACUUM;"
	sqlite3 maps.tac.db "VACUUM;"
	sqlite3 maps.wac.db "VACUUM;"
	sqlite3 maps.oth.db "VACUUM;"
	sqlite3 main.db "VACUUM;"
	## FIXME must add maps.topo.db 
	zip -9 -r final/databases.zip maps.*.db main.db $(HIGHLEVEL)

# Use gdalinfo -approx_stats to check tif files for success.

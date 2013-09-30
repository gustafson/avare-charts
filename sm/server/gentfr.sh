CURDIR=`pwd`
cd /home/apps4av && \
	perl tfr.pl && \
	zip TFRs.zip tfr.txt && \
	cp TFRs.zip mamba.dreamhosters.com/ && \
	rm TFRs.zip tfr.txt && \
	date -u > mamba.dreamhosters.com/TFRs_update.txt

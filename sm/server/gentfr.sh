CURDIR=`pwd`
cd /home/apps4av && \
	perl tfr.pl && \
	zip TFRs.zip tfr.txt && \
	cp TFRs.zip mamba.dreamhosters.com/new && \
	rm TFRs.zip tfr.txt 

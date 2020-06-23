#!/bin/bash
#Copyright (c) 2012, Zubair Khan (governer@gmail.com) 
#All rights reserved.
#
#Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
#    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#
#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

export airports=`cat airport.csv | cut -d, -f1,1`
export today=09-20-2012

for airport in ${airports}
do
	export url="http://aeronav.faa.gov/digital_tpp_search.asp?ver=1210&eff=$today&end=10-18-2012&fldIdent=$airport&fld_ident_type=FAA&st=&fldAPName=&fldVol=&fldShowADOnly=Y&submit1=Search"
	echo ${url}
	wget ${url} -q -O tmp
	export fname=`cat tmp | grep AD.PDF | sed 's/.*href\s*=\s*"//' | cut -d/ -f3 | cut -d\" -f1`
	export file=http://aeronav.faa.gov/d-tpp/1210/$fname
	echo ${file}
	wget -q ${file}
	mv -f ${fname} ${airport}.pdf
done

#!/home/pete/avare.charts.git/charts/airportdata-python/bin/python3.11

## Copyright (c) 2024, Peter A. Gustafson
## All rights reserved.
## 
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions
## are met:
## 
##     * Redistributions of source code must retain the above copyright
##     * notice, this list of conditions and the following disclaimer.
##
##     * Redistributions in binary form must reproduce the above
##     * copyright notice, this list of conditions and the following
##     * disclaimer in the documentation and/or other materials
##     * provided with the distribution.
## 
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
## "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
## LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
## FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
## COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
## INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
## BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
## LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
## CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
## LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
## ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
## POSSIBILITY OF SUCH DAMAGE.

######################################################################
## Code for including ICAO airport code types in avare databases It ##
## requires airportdata-python, which was installed from pip as it  ##
## wasn't in the system repo                                        ##
######################################################################

import airportsdata
LID = airportsdata.load('LID')  # key is the FAA LID
ICAO = airportsdata.load('ICAO')  # key is the ICAO
IATA = airportsdata.load('IATA')  # key is the IATA


def fixfile(csv):
    ## threeunique = 0
    outfile = csv.replace('.csv','-ICAO.csv')
    print(f'Converting {csv} to {outfile}')

    with open (csv, 'r') as f:
        data = f.readlines()
        data = [d.replace('\n','').split(',') for d in data]

    with open (outfile, 'w') as f:
        for d in data:
            airport = None
            try:
                ## If id is already ICAO, simply skip it
                airport = ICAO[d[0]]
            except:
                try:
                    airport = LID[d[0]]
                    d[0] = airport['icao']
                    # if len(airport['icao'])==4:
                    #     print('debug icao', airport['icao'], '!')
                except:
                    try:
                        airport = IATA[d[0]]
                        d[0] = airport['iata']
                        # if len(airport['iata'])==3:
                        #     print('debug iata', airport['iata'], '!')
                    except:
                        pass

            f.write(','.join(d) + '\n')                

fixfile('airport-tmp.csv') ## This is mostly ICAO already coming from airport.py
fixfile('runway-tmp.csv') ## This is mostly ICAO already coming from airport.py
fixfile('freq.csv')
fixfile('airdiags/aptdiags.csv')
fixfile('afd.csv')
fixfile('mins/to.csv')
fixfile('mins/alt.csv')
fixfile('awos.csv')
## fixfile('ourairports.csv') ## Already done in direct conversion script

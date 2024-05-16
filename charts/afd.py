#!/usr/bin/env python

#Copyright (c) 2023, Peter A. Gustafson (peter.gustafson@wmich.edu)
#All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#    * Redistributions of source code must retain the above copyright
#    * notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above
#    * copyright notice, this list of conditions and the following
#    * disclaimer in the documentation and/or other materials provided
#    * with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

import glob
import sys
import xml.etree.ElementTree as ET
import pypdf
import multiprocessing as mp
import argparse
import os

# Find the path to your XML file
xml_file = glob.glob('*xml')[-1]
cyclestr = xml_file[3:].replace('.xml','')

# Parse the XML file, get the root element
tree = ET.parse(xml_file)
root = tree.getroot()

# Find all "airport" elements
airport_elements = root.findall(".//airport")


def worker(airport):
    aptid = airport.find('aptid').text
    navid = airport.find('navidname').text
    pages = airport.find('pages')
    pdfs = pages.findall('pdf')

    # if not aptid in ['MMU','AZO', 'LHD']: return

    for pdf in pdfs:
        
        base = pdf.text[::-1].split('_')[1:]
        base = '_'.join(base)[::-1]

        fn = f'{base}.pdf'

        npages = len(pypdf.PdfReader(fn).pages)
        if npages == 1:
            pngs = [f'{base}.png']
        else:
            pngs = [f'{base}-{i}.png' for i in range(npages)]
        #pngs = glob.glob(f'{base}*png')

        MOGRIFY=False
        for png in pngs:
            if not os.path.exists(png):
                MOGRIFY=True
                ## DPI=240.9  #Android limited plates size 2400x
                ## DPI=225
        if MOGRIFY:
            cmd = f'mogrify -trim +repage -dither none -antialias -density 225 -depth 8 -background white  -alpha remove -alpha off -colors 15 -format png -quality 100 {fn}'
            os.system(cmd)

            ## Optimize.  Pretty good optimization is done above
            ## os.system(f'optipng -quiet {png}')
        else:
            print(f'Existing pngs {pngs}, skipped.', file=sys.stderr)

        if navid:
            name = navid
        if aptid:
            name = aptid

        # pngs = glob.glob(f'{base}*png')
        for png in pngs:
            out = f'{name},{png.split(".")[0]}'
            #f.write(out)
            print(out)

parser = argparse.ArgumentParser(description="Process AFD images and database info")
parser.add_argument('--cpus', type=int, default=os.cpu_count(), help="CPUS to use in processing")
parser.add_argument('--nnodes', type=int, default=1, help="Number of nodes in use (division of labor)")
parser.add_argument('--node',   type=int, default=0, help="Current node number in use (division of labor)")

# Parse arguments from command line
args = parser.parse_args()
cpus = args.cpus
node = args.node
nnodes = args.nnodes

airport_elements = [airport for i,airport in enumerate(airport_elements) if (i % nnodes) == node]

## ## There are no repeated names (i.e., navid and airport the same)
## for airport in airport_elements:
##     if (airport.find('aptid').text) and (airport.find('navidname').text):
##         print ('yes')

count = []
total = len(airport_elements)

print(f'Total airports = {len(airport_elements)}', file=sys.stderr)

with mp.Pool(processes=cpus) as pool:
    # pool.map(worker, records)
    for instance in pool.imap_unordered(worker, airport_elements):
        count.append(instance)
        if (len(count)%10==0):
            print ("Approximately %2.2f%% complete" % (100*len(count)/total), file=sys.stderr)
print('Complete', file=sys.stderr)

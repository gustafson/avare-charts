#!/usr/bin/python2.7

import glob
xmlfile = glob.glob('./DDTPP/*/d-TPP_Metafile.xml')

import xml.etree.ElementTree as ET
tree = ET.parse(xmlfile[-1])
root = tree.getroot()
## import PythonMagick
import os

from shutil import copyfile

def switch(record):
    x = record.find("chart_code").text
    return {
            'APD': 1,
            'DAU': 1,
            'DP': 1,
            'HOT': 1,
            'IAP': 1,
            'LAH': 1,
            ## 'MIN': 1,
            'ODP': 1,
            'STAR': 1,
    }.get(x, 0)    # 0 is default if x not found

def copy_files_to_state(state, cycle):
    ## Copy files from the download location to a local directory organized by airport

    pdfimages = []
    pngimages = []
    ## print state.tag, state.attrib
    for city in state:
        ## print city.tag, city.attrib
        for airport in city:
            ## print airport.tag, airport.attrib
            for record in airport._children:
                if (switch(record)):
                    cn = record.find("chart_name").text.replace(" ","-")
                    cn = cn.replace("(","").replace(")","").replace("/","-")
                    cn = cn.replace("---","-").replace(",","")
                    pdf = record.find("pdf_name").text
                    
                    if not (pdf == "DELETED_JOB.PDF"):
                        ## if (True):
                        pdf = "./DDTPP/" + cycle +"/" + pdf
                        mydir = "/dev/shm/plates/" + airport.attrib['apt_ident']
                        fn = mydir + "/" + cn + ".pdf"
                        png = mydir + "/" + cn + ".png"
                        
                        if not os.path.exists(mydir):
                            os.makedirs (mydir)
                        ## Copy the file if it exists
                        if not os.path.isfile(fn):
                            if (os.path.isfile(pdf)):
                                copyfile(pdf, fn);
                            else:
                                print ("missing:" + fn + " source: " + pdf)
                                    
                        pdfimages.append(fn)
                        pngimages.append(png)
                                    
    print ("#state has %s files" % (len(pdfimages)));
    return pdfimages, pngimages

#PWD=os.system('pwd')
PWD=os.getcwd()
nstates = root._children.__len__();
cycle=root.attrib['cycle']
cpus = 16

## A worker function which can be called in parallel
def worker(pdf):
    str = ("0 %s %s %s" % (cycle, state, pdf))
    syscommand = ("./plates.sh %s" % (str))
    ## print (syscommand)
    os.system (syscommand)

## Note we can eventually use pbs with environment variables
## print os.environ['HOME']

## This is where the action really happens
import multiprocessing as mp
statecount=0;
for state in root:
    ## If you want just one state for debugging, uncomment the next line
    ## if (state.attrib['ID']=="AS"): # or state.attrib['ID']=="MI"
        print ("#" + state.attrib['ID'])
        statecount += 1;
        pdfimages, pngimages = copy_files_to_state(state, cycle)

        state = state.attrib['ID']
        ## Create a pool of jobs to run in parallel
        pool = mp.Pool(processes=cpus) #processes=4

        ## Do all the pdf images in the state
        pool.map(worker, pdfimages)
        
        ## Do only one
        ## pool.map(worker, [pdfimages[0]])

## Create zip files
os.system ("./plates.sh 1 %s" % cycle)
## Extract database info
os.system ("./plates.sh 2 %s" % cycle)

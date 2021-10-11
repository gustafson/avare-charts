#!/usr/bin/python

# Copyright (c) 2021, Peter A. Gustafson, peter.gustafson@wmich.edu
# All rights reserved.
#
#    Redistribution and use in source and binary forms, with or without
#    modification, are permitted provided that the following conditions
#    are met:
#
#    * Redistributions of source code must retain the above copyright notice,
#      this list of conditions and the following disclaimer.

#    * Redistributions in binary form must reproduce the above copyright notice,
#      this list of conditions and the following disclaimer in the documentation
#      and/or other materials provided with the distribution.
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
#

# author Peter A. Gustafson


import requests
from bs4 import BeautifulSoup as bs
base = "https://www.navcanada.ca"
url = base + "/en/aeronautical-information/operational-guides.aspx"

print ("Url request: {}".format(url))

response = requests.get(url)
soup = bs(response.text, features="lxml")

## Find the next pdf link
urls = soup.find_all("a", {"class": "info"})
 #and "next" in t.text
urls = [t for t in urls if "cac" in t["href"] and "pdf" in t["href"]]
url = [t["href"] for t in urls if "upcoming" in t.text]
urls = [t["href"] for t in urls]


if (len(url)==0):
    print("Next issuance has not been posted")
    print("Current link(s) is/are: {}".format(", ".join(urls)))
    exit()

print ("Url request: {}".format(url))
url = base + url[0]

print ("Url request: {}".format(url))
## contents = requests.get(url)
## 
## with open('cac_next.pdf', 'wb') as f:
##     f.write(response.content)

import os
os.system ("wget -O cac_next.pdf " + url)

print("Downloaded ", url, "as cac_next.pdf")

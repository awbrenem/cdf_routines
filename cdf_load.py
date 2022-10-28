import datetime as dt  # Python standard library datetime  module
from datetime import datetime
import numpy as np
import matplotlib.pyplot as plt
import os
os.environ["CDF_LIB"] = "~/CDF/lib"
import scipy.io as sio
import xarray as xr
#import pandas as pdhttps://github.com/MAVENSDC/cdflib/blob/da4084b9c85a2ea4f47f76437e85f052863a9180/cdflib/epochs.py#L1512
#from spacepy import pycdf
import cdflib

# cdffile = pycdf.CDF('FU3_context_20150201_v01.cdf')
# epoch = cdffile['Epoch']

cdf_file = cdflib.CDF('FU3_context_20150201_v01.cdf')
cdf_file1=cdflib.CDF('rbspa_efw-l3_20150101_v04.cdf')
# cdf_file1.cdf_info()
# cdf_file1.cdf_info()['zVariables']
mlt = cdf_file.varget("MLT")
L=cdf_file.varget("McIlwainL")
lat = cdf_file.varget("Lat")
lon = cdf_file.varget("Lon")
alt = cdf_file.varget("Alt")
ep = cdf_file.varget("epoch")
epochtime = cdflib.cdfepoch.to_datetime(ep)

# data = cdflib.cdf_to_xarray('FU3_context_20150201_v01.cdf')
# cdflib.cdfepoch.to_datetime(data['epoch'].values)

# cdflib.cdfepoch.encode_epoch(ep[0])
# cdflib.cdfepoch.breakdown_epoch(ep[0])

mlt_rb=cdf_file1.varget('mlt')
lshell=cdf_file1.varget('lshell')
ep_rb = cdf_file1.varget("epoch")
epochtime_rb = cdflib.cdfepoch.to_datetime(ep_rb)

fig=plt.figure()
ax=fig.add_subplot(211)
plt.scatter(mlt,L)
plt.title('Firebird') # +str(hr)+ ':' +str(mint))
plt.ylabel(' L')
plt.xlabel('MLT')
plt.ylim([0,50])
plt.grid(True)
plt.legend()    
ax=fig.add_subplot(212)
plt.hist2d(mlt,L, bins=10, cmap='Blues')
plt.ylim([0,50])
plt.colorbar()

fig=plt.figure()
ax=fig.add_subplot(211)
plt.scatter(mlt_rb,lshell)
plt.title('RBSP') # +str(hr)+ ':' +str(mint))
plt.ylabel(' L')
plt.xlabel('MLT')
plt.ylim([0,50])
plt.grid(True)
plt.legend()    
ax=fig.add_subplot(212)
plt.hist2d(mlt_rb,lshell, bins=10, cmap='Blues')
plt.ylim([0,50])
plt.colorbar()

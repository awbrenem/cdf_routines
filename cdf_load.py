"""
Example of how to load a CDF file in Python
"""

import cdflib


cdf_file = cdflib.CDF('/Users/abrenema/data/firebird/FU3/2016/FU3_context_20161222_v01.cdf')
cdf_file.cdf_info()['zVariables']

mlt = cdf_file.varget("MLT")
L=cdf_file.varget("McIlwainL")
lat = cdf_file.varget("Lat")
lon = cdf_file.varget("Lon")
alt = cdf_file.varget("Alt")
ep = cdf_file.varget("epoch")
epochtime = cdflib.cdfepoch.to_datetime(ep)


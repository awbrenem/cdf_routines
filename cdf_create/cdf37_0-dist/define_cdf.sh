###########################################
#  CDF environment variables declaration
###########################################
source /Applications/cdf/cdf37_0-dist/bin/definitions.C
setenv CLASSPATH .:${CDF_BASE}/cdfjava/classes/cdfjava.jar:${CDF_BASE}/cdfjava/cdftools/CDFToolsDriver.jar:${CDF_BASE}/cdfjava/cdfml/cdfml.jar
setenv DYLD_LIBRARY_PATH .:${CDF_BASE}/cdfjava/lib:${CDF_LIB}

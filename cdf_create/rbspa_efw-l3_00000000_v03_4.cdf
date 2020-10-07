
pro create_rbsp_l3_cdf

;Create the skeleton table
/Applications/cdf/cdf37_0-dist/bin/skeletontable -skeleton-path /Users/aaronbreneman/Desktop/skeletonout /Users/aaronbreneman/Desktop/aaa_rbspa_efw-l3_00000000_v02

;Create the CDF file from the skeleton table
/Applications/cdf/cdf37_0-dist/bin/skeletoncdf -cdf-path /Users/aaronbreneman/Desktop/cdfout /Users/aaronbreneman/Desktop/skeletonout

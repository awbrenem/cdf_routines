;Use READ_MYCDF to easily read multiple CDF files and specific or all variables
;within them.
;See https://spdf.gsfc.nasa.gov/CDAWlib.html for documentation of the CDAWlib
;package

;Options for Unix times or TT2000 times, depending on time format of input CDF

;**Crib sheet designed to be run by copy/paste


rbsp_efw_init

;Must include this to use the CDFWlib data package
@compile_cdaweb

;path = '/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/cdf_programs/'
;cdfnames = path + ['rbspa_efw-l3_20140106_v02.cdf','rbspa_efw-l3_20170716_v02.cdf']

;Select all files you'd like to plot
;Change directory search path for convenience
cdfnames = dialog_pickfile(/multiple_files,path='~/Desktop/Research/other/Stuff_for_other_people/Wygant_John/')
r = read_mycdf(['np_fit','vp_fit_RTN','sc_pos_HCI','sc_vel_HCI'],cdfnames)



;Load example RBSP L3 file
path = '/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/cdf_programs/'
fn = 'rbspa_efw-l3_20140106_v02.cdf'
cdfnames = path+fn

tstart = '2014/01/06 01:00:00'
tstop = '2014/01/06 03:00:00'

r = read_mycdf(['density'],cdfnames,tstart=tstart,tstop=tstop)



;Load example RBSP burst 2 file (large)
;----Doesn't take less time to load if you choose a small time slice.
;----Apparently still has to load entire file...

path = '/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/cdf_programs/'
fn = 'rbspa_l1_mscb1_20190801_v02.cdf'
cdfnames = path+fn

tstart = '2019/08/01 04:00:00'
tstop = '2019/08/01 04:01:10'


r = read_mycdf(['mscb1'],cdfnames,tstart=tstart,tstop=tstop)
t = r.epoch.dat
tunix = time_double(t,/epoch)

r = read_mycdf(['mscb1'],cdfnames)
t = r.epoch.dat
tunix = time_double(t,/epoch)




;**Read in all variables...can take a while
;r = read_mycdf('',/all,cdfnames)
;**Read in only select variables



;	TSTART = epoch starting value - YYYYMMDD etc. string.
;	TSTOP = epoch ending value - YYYYMMDD etc. string.



;See contents of structure you've just read in
help,r,/st


;get the times
t = r.epoch.dat



;**************************************************************
;;Use this for standard CDF epoch times
tunix = time_double(t,/epoch)





;**************************************************************
;;Use this if  CDF epoch times are milliseconds since 1-Jan-0000
;;(like the EFW CDFs)
;t = real_part(t)
;cdf_epoch,1000d*t,yr, mo, dy, hr, mn, sc, milli, /BREAK
;tunix = strarr(n_elements(yr))
;for i=0L,n_elements(tunix)-1 do tunix[i] = strtrim(yr[i],2)+'-'+strtrim(mo[i],2)+'-'+$
;strtrim(dy[i],2)+'/'+strtrim(hr[i],2)+':'+strtrim(mn[i],2)+':'+$
;strtrim(sc[i],2)+'.'+strtrim(milli[i],2)
;tunix = time_double(tunix)

;**************************************************************
;Use this if CDF times are in TT2000 times
;(like Justin Kasper's PSP CDFs)
t = long64(t)
CDF_TT2000, t, yr, mo, dy, hr, mn, sc, milli, /BREAK
tunix = strarr(n_elements(yr))
yr = strtrim(floor(yr),2) & mo = strtrim(floor(mo),2) & dy = strtrim(floor(dy),2) & hr = strtrim(floor(hr),2) & mn = strtrim(floor(mn),2) & sc = strtrim(floor(sc),2) & milli = strtrim(floor(milli),2)

;Pad with zeros
goo = where(mo lt 10) & if goo[0] ne -1 then mo[goo] = '0'+mo[goo]
goo = where(dy lt 10) & if goo[0] ne -1 then dy[goo] = '0'+dy[goo]
goo = where(hr lt 10) & if goo[0] ne -1 then hr[goo] = '0'+hr[goo]
goo = where(mn lt 10) & if goo[0] ne -1 then mn[goo] = '0'+mn[goo]
goo = where(sc lt 10) & if goo[0] ne -1 then sc[goo] = '0'+sc[goo]
goo = where(milli lt 10) & if goo[0] ne -1 then milli[goo] = '00'+milli[goo]
goo = where((milli ge 10) and (milli lt 100)) & if goo[0] ne -1 then milli[goo] = '0'+milli[goo]

tunix = yr+'-'+mo+'-'+$
dy+'/'+hr+':'+mn+':'+$
sc+'.'+milli
tunix = time_double(tunix)
;***************************************************


;now grab various quantities and store as tplot variables

store_data,'density',tunix,r.np_fit.dat
ylim,'density',1,10000,1

vp_rtn = r.vp_fit_RTN.dat
store_data,'vp_rtn',tunix,transpose(vp_rtn)
store_data,'vmag',tunix,reform(sqrt(vp_rtn[0,*]^2 + vp_rtn[1,*]^2 + vp_rtn[2,*]^2))
ylim,'vp_rtn',-1000,1000
ylim,'vmag',0,10000

pos = r.sc_pos_HCI.dat
vel = r.sc_vel_HCI.dat
store_data,'pos_hci',tunix,transpose(pos)
store_data,'vel_hci',tunix,transpose(vel)
store_data,'vsc_mag',tunix,reform(sqrt(vel[0,*]^2 + vel[1,*]^2 + vel[2,*]^2))


tplot,['density','vp_rtn','vmag','pos_hci','vel_hci','vsc_mag']



end

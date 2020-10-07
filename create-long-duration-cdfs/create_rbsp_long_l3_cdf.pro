
;Use READ_MYCDF to easily read multiple CDF files and specific or all variables
;within them.
;See https://spdf.gsfc.nasa.gov/CDAWlib.html for documentation of the CDAWlib
;package

;This version's set up to load multiple EFW L3 files

;**Crib sheet designed to be run by copy/paste


;*************************************
;*************************************
;*************************************
;Must include this to use the CDFWlib data package
;@compile_cdaweb
stop
;*************************************
;*************************************
;*************************************



rbsp_efw_init


sc = 'b'
year = '2016'

rbx = 'rbsp'+sc

fileoutput = '~/Desktop/'+rbx+'_l3_'+year


;Load L3 files
;path = '/Users/aaronbreneman/Desktop/rbsp.space.umn.edu/data/rbsp/'+rbx+'/l3/'+year+'/'
path = '/Users/aaronbreneman/Desktop/code/Aaron/RBSP/TDAS_trunk_svn/general/missions/rbsp/efw/cdf_file_production/'
cdfnames = dialog_pickfile(/multiple_files,path=path)

;**Read in all variables...can take a while
r = read_mycdf('',/all,cdfnames)
;**Read in only select variables
;r = read_mycdf(['np_fit','vp_fit_RTN','sc_pos_HCI','sc_vel_HCI'],cdfnames)


;See contents of structure you've just read in
;help,r,/st


;Get the names of all the variables within the structure
varnames = tag_names(r)
varnames = varnames[where(varnames ne 'EPOCH')]


;get the times
t = r.epoch.dat
thsk = r.epoch_hsk.dat





;**************************************************************
;;Use this if  CDF epoch times are milliseconds since 1-Jan-0000
;;(like the EFW CDFs)
t = real_part(t)
cdf_epoch,1000d*t,yr, mo, dy, hr, mn, sc, milli, /BREAK
tunix = strarr(n_elements(yr))
;for i=0L,n_elements(tunix)-1 do tunix[i] = time_string(strtrim(yr[i],2)+'-'+strtrim(mo[i],2)+'-'+$
;strtrim(dy[i],2)+'/'+strtrim(hr[i],2)+':'+strtrim(mn[i],2)+':'+$
;strtrim(sc[i],2)+'.'+strtrim(milli[i],2))
tunix = strarr(n_elements(yr))
for i=0L,n_elements(tunix)-1 do tunix[i] = strtrim(yr[i],2)+'-'+strtrim(mo[i],2)+'-'+$
strtrim(dy[i],2)+'/'+strtrim(hr[i],2)+':'+strtrim(mn[i],2)+':'+$
strtrim(sc[i],2)+'.'+strtrim(milli[i],2)
tunix = time_double(tunix)
epoch = tplot_time_to_epoch(tunix,/epoch16)



;**************************************************************
;;Use this if CDF times are in TT2000 times
;;(like Justin Kasper's PSP CDFs)
;t = long64(t)
;CDF_TT2000, t, yr, mo, dy, hr, mn, sc, milli, /BREAK
;tunix = strarr(n_elements(yr))
;yr = strtrim(floor(yr),2) & mo = strtrim(floor(mo),2) & dy = strtrim(floor(dy),2) & hr = strtrim(floor(hr),2) & mn = strtrim(floor(mn),2) & sc = strtrim(floor(sc),2) & milli = strtrim(floor(milli),2)
;
;;Pad with zeros
;goo = where(mo lt 10) & if goo[0] ne -1 then mo[goo] = '0'+mo[goo]
;goo = where(dy lt 10) & if goo[0] ne -1 then dy[goo] = '0'+dy[goo]
;goo = where(hr lt 10) & if goo[0] ne -1 then hr[goo] = '0'+hr[goo]
;goo = where(mn lt 10) & if goo[0] ne -1 then mn[goo] = '0'+mn[goo]
;goo = where(sc lt 10) & if goo[0] ne -1 then sc[goo] = '0'+sc[goo]
;goo = where(milli lt 10) & if goo[0] ne -1 then milli[goo] = '00'+milli[goo]
;goo = where((milli ge 10) and (milli lt 100)) & if goo[0] ne -1 then milli[goo] = '0'+milli[goo]
;
;tunix = yr+'-'+mo+'-'+$
;dy+'/'+hr+':'+mn+':'+$
;sc+'.'+milli
;tunix = time_double(tunix)
;;***************************************************


;now grab each quantity and store as tplot variable.
;This loop checks to see if the "data" is actually timeseries data
;by comparing the size of the data array to the time array
for j=0,n_elements(varnames)-1 do begin $
  strtmp = 'dat = r.'+varnames[j] + '.dat' & $
  void = execute(strtmp) & $
  sizetmp = size(dat) & $
  if sizetmp[0] eq 1 then sz = sizetmp[1] else sz = sizetmp[2] & $
  sizetst = n_elements(tunix) eq sz & $
  if sizetst then store_data,varnames[j],tunix,reform(transpose(dat))
endfor





;;remove  -1.00000e+31 values
;for i=0,n_elements(vars)-1 do begin $
;  get_data,vars[i],data=dd,dlim=dlim,lim=lim  & $
;  goo = where(dd.y lt -1.00000e+30)  & $
;  if goo[0] ne -1 then dd.y[goo] = !values.f_nan & $
;  store_data,vars[i],data=dd,dlim=dlim,lim=lim
;endfor




;Same but for HSK cadence data 

varnames = tag_names(r)
varnames = varnames[where(varnames ne 'EPOCH_HSK')]

varnames = 'bias_current'
thsk = real_part(thsk)
cdf_epoch,1000d*thsk,yr, mo, dy, hr, mn, sc, milli, /BREAK
tunix = strarr(n_elements(yr))
for i=0L,n_elements(tunix)-1 do tunix[i] = strtrim(yr[i],2)+'-'+strtrim(mo[i],2)+'-'+$
strtrim(dy[i],2)+'/'+strtrim(hr[i],2)+':'+strtrim(mn[i],2)+':'+$
strtrim(sc[i],2)+'.'+strtrim(milli[i],2)
tunix = time_double(tunix)
epochhsk = tplot_time_to_epoch(tunix,/epoch16)

for j=0,n_elements(varnames)-1 do begin $
  strtmp = 'dat = r.'+varnames[j] + '.dat' & $
  void = execute(strtmp) & $
  sizetmp = size(dat) & $
  if sizetmp[0] eq 1 then sz = sizetmp[1] else sz = sizetmp[2] & $
  sizetst = n_elements(tunix) eq sz & $
  if sizetst then store_data,varnames[j],tunix,reform(transpose(dat))
endfor



vars = tnames()


;remove  -1.00000e+31 values
for i=0,n_elements(vars)-1 do begin $
  get_data,vars[i],data=dd,dlim=dlim,lim=lim  & $
  goo = where(dd.y lt -1.00000e+30)  & $
  if goo[0] ne -1 then dd.y[goo] = !values.f_nan & $
  store_data,vars[i],data=dd,dlim=dlim,lim=lim
endfor





;tplot,vars
;tplot_save,vars,filename=fileoutput


;------------------------------------------------
;Make plots


;tplot_restore,filename=fileoutput+'.tplot'




  if n_elements(version) eq 0 then version = 2
  vstr = string(version, format='(I02)')



;------------ Set up paths. BEGIN. ----------------------------




  ;Grab the skeleton file.
  skfile = rbx+'_efw-lX_00000000_vXX.cdf'


    path = '~/Desktop/code/Aaron/RBSP/TDAS_trunk_svn/general/missions/rbsp/efw/cdf_file_production/'
    skeleton = path + skfile


  ;make sure we have the skeleton CDF
  found = 1
  skeletonFile=file_search(skeleton,count=found)
  skeletonFile = skeletonFile[0]



;------------ Set up paths. END. ----------------------------


;  year = strmid(date,0,4) & mm = strmid(date,5,2) & dd = strmid(date,8,2)


path2 = '~/Desktop/code/Aaron/github.umn.edu/create-long-duration-cdfs/'


  datafile = path2+rbx+'_efw-l3_'+year+'_fullyear_v'+vstr+'.cdf'
;  datafile = path+rbx+'efw-l3_'+year+mm+dd+'_v'+vstr+'.cdf'

  file_copy, skeletonFile, datafile, /overwrite ; Force to replace old file.


  cdfid = cdf_open(datafile)



;Grab all data here



bp = '12'


  ;Rename the appropriate variables to more generic names. The rest will get deleted.
;  cdf_varrename,cdfid,'efield_spinfit_mgse_'+bp,'efield_spinfit_mgse'
  cdf_varrename,cdfid,'efield_inertial_spinfit_mgse_'+bp,'efield_in_inertial_frame_spinfit_mgse'
  cdf_varrename,cdfid,'efield_corotation_spinfit_mgse_'+bp,'efield_in_corotation_frame_spinfit_mgse'
  cdf_varrename,cdfid,'efield_inertial_spinfit_edotb_mgse_'+bp,'efield_in_inertial_frame_spinfit_edotb_mgse'
  cdf_varrename,cdfid,'efield_corotation_spinfit_edotb_mgse_'+bp,'efield_in_corotation_frame_spinfit_edotb_mgse'
  cdf_varrename,cdfid,'density_'+bp,'density'
  cdf_varrename,cdfid,'corotation_efield_mgse','VxB_efield_of_earth_mgse'
  cdf_varrename,cdfid,'VxB_mgse','VscxB_motional_efield_mgse'
  cdf_varrename,cdfid,'vsvy_vavg_combo_'+bp,'spacecraft_potential'


;**********TEMPORARY FOR WYGANT
;cdf_varrename,cdfid,'efield_spinfit_mgse_23','efield_moving_with_sc_mgse_Wygant'

;****************************
;****************************
;****************************
;****************************
;****************************


  ;Final list of variables to NOT delete
  varsave_general = ['epoch','epoch_hsk',$
;  'diagBratio',$
    'efield_in_inertial_frame_spinfit_mgse',$
    'efield_in_corotation_frame_spinfit_mgse',$
;    'efield_in_inertial_frame_spinfit_edotb_mgse',$
;    'efield_in_corotation_frame_spinfit_edotb_mgse',$
    'VxB_efield_of_earth_mgse',$
    'VscxB_motional_efield_mgse',$
    'spacecraft_potential',$
    'density',$
    'velocity_gse','position_gse',$
    'angle_spinplane_Bo',$
    'mlt','mlat','lshell',$
    'spinaxis_gse',$
    'flags_all','flags_charging_bias_eclipse',$
    'global_flag',$
;    'burst1_avail',$
;    'burst2_avail',$
    'bias_current',$
    'bfield_gse','bfield_mgse']
;    'efield_moving_with_sc_mgse_Wygant']







  ;Now that we have renamed some of the variables to our liking,
  ;get list of all the variable names in the CDF file.
  inq = cdf_inquire(cdfid)
  CDFvarnames = ''
  for varNum = 0, inq.nzvars-1 do begin $
    stmp = cdf_varinq(cdfid,varnum,/zvariable) & $
    if stmp.recvar eq 'VARY' then CDFvarnames = [CDFvarnames,stmp.name]
  endfor
  CDFvarnames = CDFvarnames[1:n_elements(CDFvarnames)-1]



  ;Delete all variables we don't want to save.
  for qq=0,n_elements(CDFvarnames)-1 do begin $
    tstt = array_contains(varsave_general,CDFvarnames[qq]) & $
    if not tstt then print,'Deleting var:  ', CDFvarnames[qq] & $
    if not tstt then cdf_vardelete,cdfid,CDFvarnames[qq]
  endfor




  ;--------------------------------------------------
  ;Populate the remaining variables
  ;--------------------------------------------------


  get_data,'FLAGS_ALL',data=flag_arr
  get_data,'burst1_avail',data=b1_flag
  get_data,'burst2_avail',data=b2_flag
  get_data,'DENSITY',data=density
  get_data,'POSITION_GSE',data=pos_gse
  get_data,'VELOCITY_GSE',data=vel_gse
  get_data,'EFIELD_IN_INERTIAL_FRAME_SPINFIT_MGSE',data=efield_inertial_spinfit_mgse
  get_data,'EFIELD_IN_COROTATION_FRAME_SPINFIT_MGSE',data=efield_corotation_spinfit_mgse
  get_data,'VXB_EFIELD_OF_EARTH_MGSE',data=corotation_efield_mgse
  get_data,'VSCXB_MOTIONAL_EFIELD_MGSE',data=vxb
  get_data,'SPINAXIS_GSE',data=sa
  get_data,'ANGLE_SPINPLANE_BO',data=angles
  get_data,'SPACECRAFT_POTENTIAL',data=vsvy_vavg
  get_data,'bias_current',data=ibias
  get_data,'BFIELD_MGSE',data=mag_mgse
  get_data,'BFIELD_GSE',data=mag_gse
  get_data,'GLOBAL_FLAG',data=globalflag
  get_data,'FLAGS_CHARGING_BIAS_ECLIPSE',data=flags
  get_data,'MLT',data=mlt 
  get_data,'LSHELL',data=lshell
  get_data,'MLAT',data=mlat 
;  mlt = dat.y[*,0]
;  lshell = dat.y[*,1]
;  mlat = dat.y[*,2]



  cdf_varput,cdfid,'epoch',epoch
  cdf_varput,cdfid,'flags_charging_bias_eclipse',transpose(flags.y)
  cdf_varput,cdfid,'flags_all',transpose(flag_arr.y)
  cdf_varput,cdfid,'global_flag',reform(globalflag.y)
;  cdf_varput,cdfid,'burst1_avail',b1_flag.y
;  cdf_varput,cdfid,'burst2_avail',b2_flag.y

  cdf_varput,cdfid,'efield_in_inertial_frame_spinfit_mgse',transpose(efield_inertial_spinfit_mgse.y)
  cdf_varput,cdfid,'efield_in_corotation_frame_spinfit_mgse',transpose(efield_corotation_spinfit_mgse.y)
;  cdf_varput,cdfid,'efield_in_inertial_frame_spinfit_edotb_mgse',transpose(efield_inertial_spinfit_edotb_mgse.y)
;  cdf_varput,cdfid,'efield_in_corotation_frame_spinfit_edotb_mgse',transpose(efield_corotation_spinfit_edotb_mgse.y)

  cdf_varput,cdfid,'density',transpose(density.y)

  cdf_varput,cdfid,'VxB_efield_of_earth_mgse',transpose(corotation_efield_mgse.y)
  cdf_varput,cdfid,'VscxB_motional_efield_mgse',transpose(vxb.y)

  cdf_varput,cdfid,'mlt',transpose(mlt.y)
  cdf_varput,cdfid,'mlat',transpose(mlat.y)
  cdf_varput,cdfid,'lshell',transpose(lshell.y)
  cdf_varput,cdfid,'position_gse',transpose(pos_gse.y)
  cdf_varput,cdfid,'velocity_gse',transpose(vel_gse.y)
  cdf_varput,cdfid,'spinaxis_gse',transpose(sa.y)
  cdf_varput,cdfid,'angle_spinplane_Bo',transpose(angles.y)
  ;if is_struct(edotb_b2bx_ratio) then cdf_varput,cdfid,'diagBratio',transpose(edotb_b2bx_ratio.y)


  cdf_varput,cdfid,'bfield_mgse',transpose(mag_mgse.y)
  cdf_varput,cdfid,'bfield_gse',transpose(mag_gse.y)

  cdf_varput,cdfid,'spacecraft_potential',vsvy_vavg.y


  cdf_varput,cdfid,'epoch_hsk',epochhsk
  cdf_varput,cdfid,'bias_current',transpose(ibias.y)


;**************TEMPORARY
;cdf_varput,cdfid,'efield_moving_with_sc_mgse_Wygant',transpose(efield_sc_frame_mgse.y)
  ;**************TEMPORARY


  cdf_close, cdfid

stop


end

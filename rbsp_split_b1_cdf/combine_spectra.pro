;Combine all the separate MGSE files for burst data that have been created with
;rbsp_split_burst_cdf.pro and rbsp_uvw_to_mgse_burstfiles.pro and create a
;single power spectrogram for them.


rbsp_efw_init

date = '2017-05-02'
d2 = strmid(date,0,4)+strmid(date,5,2)+strmid(date,8,2)
timespan,date

t0z = time_double(date+'/04:00')
t1z = time_double(date+'/07:00')

probe = 'a'
type = 'mscb1'
dt = 3*60.*60.  ;chunk size for each plot

;Create 'fce' overplot variables
rbsp_load_emfisis,probe=probe,cadence='4sec',coord='gse'
get_data,'rbsp'+probe+'_emfisis_l3_4sec_gse_Magnitude',t,bmag
store_data,'fce',t,28.*bmag
store_data,'fce_2',t,28.*bmag/2.
store_data,'fce_10',t,28.*bmag/10.
store_data,'flhr',t,sqrt(28.*bmag*28.*bmag/1836.)


rbsp_load_efw_spec,probe=probe,type='calibrated'


;path = '/Users/aaronbreneman/Desktop/Research/OTHER/Stuff_for_other_people/ARASE/'+d2+'/'
path = '/Users/aaronbreneman/Desktop/Research/OTHER/Stuff_for_other_people/Hartinger_Mike/'
fn = ['rbspa_mscb1_20170502_040000-041000_mgse.cdf',$
'rbspa_mscb1_20170502_041000-042000_mgse.cdf',$
'rbspa_mscb1_20170502_042000-043000_mgse.cdf',$
'rbspa_mscb1_20170502_043000-044000_mgse.cdf',$
'rbspa_mscb1_20170502_044000-045000_mgse.cdf',$
'rbspa_mscb1_20170502_045000-050000_mgse.cdf',$
'rbspa_mscb1_20170502_050000-051000_mgse.cdf',$
'rbspa_mscb1_20170502_051000-052000_mgse.cdf',$
'rbspa_mscb1_20170502_052000-053000_mgse.cdf',$
'rbspa_mscb1_20170502_053000-054000_mgse.cdf',$
'rbspa_mscb1_20170502_054000-055000_mgse.cdf',$
'rbspa_mscb1_20170502_055000-060000_mgse.cdf',$
'rbspa_mscb1_20170502_060000-061000_mgse.cdf',$
'rbspa_mscb1_20170502_061000-062000_mgse.cdf',$
'rbspa_mscb1_20170502_062000-063000_mgse.cdf',$
'rbspa_mscb1_20170502_063000-064000_mgse.cdf',$
'rbspa_mscb1_20170502_064000-065000_mgse.cdf',$
'rbspa_mscb1_20170502_065000-070000_mgse.cdf']

;make sure files are in ascending order
;fn = reverse(fn)



rbspx = 'rbsp' + probe

;store_data,tnames(),/delete


for i=0,n_elements(fn)-1 do begin

  cdf2tplot,path+fn[i]

  split_vec,rbspx+'_efw_'+type+'_mgse'


  rbsp_spec,rbspx+'_efw_'+type+'_mgse_x',npts=1024,n_ave=2
  tplot_rename,rbspx+'_efw_'+type+'_mgse_x_SPEC',rbspx+'_efw_'+type+'_mgse_x_SPEC'+strtrim(floor(i),2)
  store_data,rbspx+'_efw_'+type+'_mgse_x',/delete
  rbsp_spec,rbspx+'_efw_'+type+'_mgse_y',npts=1024,n_ave=2
  tplot_rename,rbspx+'_efw_'+type+'_mgse_y_SPEC',rbspx+'_efw_'+type+'_mgse_y_SPEC'+strtrim(floor(i),2)
  store_data,rbspx+'_efw_'+type+'_mgse_y',/delete
  rbsp_spec,rbspx+'_efw_'+type+'_mgse_z',npts=1024,n_ave=2
  tplot_rename,rbspx+'_efw_'+type+'_mgse_z_SPEC',rbspx+'_efw_'+type+'_mgse_z_SPEC'+strtrim(floor(i),2)
  store_data,rbspx+'_efw_'+type+'_mgse_z',/delete

  if i eq 0 then begin
    get_data,rbspx+'_efw_'+type+'_mgse_x_SPEC'+strtrim(floor(i),2),times,valsx,freqs
    get_data,rbspx+'_efw_'+type+'_mgse_y_SPEC'+strtrim(floor(i),2),times,valsy,freqs
    get_data,rbspx+'_efw_'+type+'_mgse_z_SPEC'+strtrim(floor(i),2),times,valsz,freqs
  endif else begin
    get_data,rbspx+'_efw_'+type+'_mgse_x_SPEC'+strtrim(floor(i),2),t,dx,v
    get_data,rbspx+'_efw_'+type+'_mgse_y_SPEC'+strtrim(floor(i),2),t,dy,v
    get_data,rbspx+'_efw_'+type+'_mgse_z_SPEC'+strtrim(floor(i),2),t,dz,v
    times = [times,t]
    valsx = [valsx,dx]
    valsy = [valsy,dy]
    valsz = [valsz,dz]
  endelse

  store_data,rbspx+'_efw_'+type+'_mgse_?_SPEC'+strtrim(floor(i),2),/delete

endfor


get_data,'rbsp'+probe+'_efw_64_spec0',times2,ddd

tinterpol_mxn,['fce','fce_2','fce_10','flhr'],times2,newname=['fce','fce_2','fce_10','flhr']

store_data,rbspx+'_efw_'+type+'_mgse_x_SPEC',times,valsx,freqs
store_data,rbspx+'_efw_'+type+'_mgse_y_SPEC',times,valsy,freqs
store_data,rbspx+'_efw_'+type+'_mgse_z_SPEC',times,valsz,freqs
options,rbspx+'_efw_'+type+'_mgse_?_SPEC','spec',1
ylim,rbspx+'_efw_'+type+'_mgse_?_SPEC',0,8000,0
ylim,rbspx+'_efw_'+type+'_mgse_?_SPEC',30,8000,1
if type eq 'mscb1' then zlim,rbspx+'_efw_'+type+'_mgse_?_SPEC',1d-12,1d-5,1
if type eq 'eb1' then zlim,rbspx+'_efw_'+type+'_mgse_?_SPEC',1d-6,1d-3,1



get_data,rbspx+'_efw_'+type+'_mgse_y_SPEC',dlim=dlim,lim=lim
store_data,rbspx+'_efw_'+type+'_mgse_y_SPECcomb',data=[rbspx+'_efw_'+type+'_mgse_y_SPEC','fce','fce_2','fce_10','flhr']
store_data,'rbsp'+probe+'_efw_64_spec0comb',data=['rbsp'+probe+'_efw_64_spec0','fce','fce_2','fce_10','flhr']
store_data,'rbsp'+probe+'_efw_64_spec4comb',data=['rbsp'+probe+'_efw_64_spec4','fce','fce_2','fce_10','flhr']
options,rbspx+'_efw_mscb1_mgse_y_SPECcomb','ztitle','nT!E2!N/Hz'
options,rbspx+'_efw_64_spec0','ztitle','(mV/m)!E2!N/Hz'
options,rbspx+'_efw_64_spec4','ztitle','nT!E2!N/Hz'
options,['fce','fce_2','fce_10','flhr'],'color',250


ylim,rbspx+'_efw_eb1_mgse_y_SPECcomb',400,4000,0
ylim,rbspx+'_efw_mscb1_mgse_y_SPECcomb',400,6000,1
ylim,'rbsp'+probe+'_efw_64_spec?comb',40,10000,1
zlim,rbspx+'_efw_eb1_mgse_y_SPECcomb',1d-6,1d-4,1
zlim,rbspx+'_efw_mscb1_mgse_y_SPECcomb',1d-11,1d-6,1
zlim,'rbsp'+probe+'_efw_64_spec0',1d-7,1d-3,1
zlim,'rbsp'+probe+'_efw_64_spec4',1d-7,1d-5,1
if type eq 'eb1' then options,rbspx+'_efw_eb1_mgse_y_SPECcomb','ztitle','[mV/m]^2/Hz'
if type eq 'eb1' then options,rbspx+'_efw_eb1_mgse_y_SPECcomb','ytitle','E12 burst!C[Hz]'
if type eq 'mscb1' then options,rbspx+'_efw_mscb1_mgse_y_SPECcomb','ztitle','[nT]^2/Hz'
if type eq 'mscb1' then options,rbspx+'_efw_mscb1_mgse_y_SPECcomb','ytitle','MSCw burst!C[Hz]'
;ylim,['rbsp'+probe+'_efw_64_spec0','rbsp'+probe+'_efw_64_spec4'],40,10000,1
ylim,['rbsp'+probe+'_efw_64_spec0','rbsp'+probe+'_efw_64_spec4'],400,4000,0




;Plot "dt" min chunks
ntimes = (time_double(t1z)-time_double(t0z))/dt

zlim,rbspx+'_efw_mscb1_mgse_y_SPECcomb',1d-11,1d-5,1
ylim,rbspx+'_efw_mscb1_mgse_y_SPECcomb',30,11000,1
zlim,rbspx+'_efw_eb1_mgse_y_SPECcomb',1d-6,1d-5,1
ylim,rbspx+'_efw_eb1_mgse_y_SPECcomb',40,11000,1

for i=0,ntimes-1 do begin
  ;tplot,['speccombT','rbspa_efw_64_spec0','rbspa_efw_64_spec4']
  ;tplot,[rbspx+'_efw_eb1_mgse_y_SPECcomb','rbsp'+probe+'_efw_64_spec0comb',rbspx+'_efw_mscb1_mgse_y_SPECcomb','rbsp'+probe+'_efw_64_spec4comb']

  timespan,t0z + i*dt,dt,/sec

  tstr1 = strmid(time_string(t0z+i*dt),11,2) + strmid(time_string(t0z+i*dt),14,2)
  tstr2 = strmid(time_string(t0z+(i+1)*dt),11,2) + strmid(time_string(t0z+(i+1)*dt),14,2)
  popen,'~/Desktop/'+d2+'_RBSP'+probe+'_EFW_'+type+'_'+tstr1+'-'+tstr2,/landscape
  tplot,[rbspx+'_efw_'+type+'_mgse_y_SPECcomb']
  pclose

endfor
stop




end


;pro rbsp_spec, tplot_var, $
;	tplot_var_spec=tplot_var_spec, $
;npts=npts, n_ave=n_ave, $
;	tspec=tspec, spec=spec, freq=freq, df=df, $
;	nan_fill_gaps=nan_fill_gaps, $
;	median_subtract=median_subtract, median_width=median_width, median_val=median_val, $
;	mingap=mingap, $
;	verbose=verbose

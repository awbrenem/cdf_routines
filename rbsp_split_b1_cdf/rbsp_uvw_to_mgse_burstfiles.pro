;Followup to program rbsp_split_burst_cdf.pro which divides up burst plots.
;This code takes these chunks and rotates them from UVW to MGSE coord.

;Written by Aaron W Breneman, July, 2017

;Called with call_rbsp_uvw_to_mgse_burstfiles.py

pro rbsp_uvw_to_mgse_burstfiles

  args = command_line_args()
  fn = args[0]
  date = args[1]
  probe = args[2]
  type = args[3]

;  date = '2017-07-08'
;  probe = 'a'
;  type = 'mscb1'
;  chunksz = 60*10.
;  fn = '~/Desktop/rbspa_mscb1_20160708_070000-071000_uvw.cdf'


  print,'fn = '+fn
  print,'date = '+date
  print,'probe = '+probe
  print,'type = '+type



  timespan,date
  rbspx = 'rbsp'+probe


  ;-------------------
  ;open the skeleton cdf file
  ;-------------------

  skeleton = 'rbsp_skeleton_00000000.cdf'
  source_file = '/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/rbsp-long-duration-cdfs/' + skeleton

  filename = 'rbsp_skeleton_'+strjoin(strsplit(date,'-',/extract))+'.cdf'
  filename2 = rbspx+'_'+type+'_'+strjoin(strsplit(date,'-',/extract))

  ;-------------------
  ;Get the spinaxis direction
  ;-------------------

  rbsp_efw_position_velocity_crib,/noplot
  store_data,'*both*',/delete
  tinterpol_mxn,rbspx+'_spinaxis_direction_gse',rbspx+'_state_pos_gse',newname=rbspx+'_spinaxis_direction_gse'
  get_data,rbspx+'_spinaxis_direction_gse',ttmp,wgse


  ;load the UVW file
  cdf2tplot,fn

  ;rotate to MGSE
  rbsp_uvw_to_mgse,probe,rbspx+'_efw_'+type+'_uvw',/no_spice_load,/nointerp,/no_offset

  tplot_rename,rbspx+'_efw_'+type+'_uvw_mgse',rbspx+'_efw_'+type+'_mgse'
  get_data,rbspx+'_efw_'+type+'_mgse',times,data


  ;Get epoch times for CDF file
  epoch = tplot_time_to_epoch(times,/epoch16)



  ;new name for file
  tmp = strpos(fn,'uvw')
  newname = strmid(fn,0,tmp) + 'mgse.cdf'



  ;Make copy of skeleton CDF file and rename
  file_copy,source_file,newname,/overwrite


  cdfid = cdf_open(newname)
  ;test to see if file opened correctly
  ;cdf_control, cdfid, get_var_info=info, variable='epoch'

  ;place data into cdf file
  cdf_varput,cdfid,'epoch',epoch
  cdf_varput,cdfid,'var1_3d_timeseries',transpose(data)
  cdf_varrename,cdfid,'var1_3d_timeseries',rbspx+'_efw_'+type+'_mgse'

  cdf_vardelete,cdfid,'var2_3d_timeseries'
  cdf_vardelete,cdfid,'var3_3d_timeseries'
  cdf_vardelete,cdfid,'var4_3d_timeseries'
  cdf_vardelete,cdfid,'var5_3d_timeseries'
  cdf_vardelete,cdfid,'var6_3d_timeseries'
  cdf_vardelete,cdfid,'var7_3d_timeseries'
  cdf_vardelete,cdfid,'var8_3d_timeseries'

  cdf_vardelete,cdfid,'var1_1d_timeseries'
  cdf_vardelete,cdfid,'var2_1d_timeseries'
  cdf_vardelete,cdfid,'var3_1d_timeseries'
  cdf_vardelete,cdfid,'var4_1d_timeseries'
  cdf_vardelete,cdfid,'var5_1d_timeseries'
  cdf_vardelete,cdfid,'var6_1d_timeseries'
  cdf_vardelete,cdfid,'var7_1d_timeseries'
  cdf_vardelete,cdfid,'var8_1d_timeseries'

  cdf_close, cdfid


end

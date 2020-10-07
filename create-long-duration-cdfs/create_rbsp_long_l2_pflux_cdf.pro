;Packs up L2 Pflux CDF files and puts them into a single long-duration cdf file.
;Calls rbsp_load_efw_pflux_cdf.pro to download the CDF file for each day
;and grab its data

;See rbsp_load_efw_pflux_cdf_crib.pro to call this program

pro create_rbsp_long_l2_pflux_cdf,sc,suffix,d0,d1


;  d0 = '2013-01-01'
;  d1 = '2014-01-01'
;
;  sc = 'a'
  rbspx = 'rbsp' + sc
;;  suffix = '10-50sec'
;;suffix = '60-300sec'
;suffix = '300-1800sec'

  ndays = floor((time_double(d1) - time_double(d0))/86400)
  days = time_string(indgen(ndays)*86400L + time_double(d0))
  days = strmid(days,0,10)
  days2 = strmid(days,0,4) + strmid(days,5,2) + strmid(days,8,2)


  path = '~/Desktop/'

  fn = 'rbsp'+sc+'_efw-pflux_'+days2+'_'+suffix+'_v01.cdf'


  t = 0d  ;main times

  density = 0d
  ;density_potential = [[0.],[0.],[0.],[0.],[0.],[0.],[0.],[0.]]
  flags_all = [[0.],[0.],[0.],[0.],[0.],[0.],[0.],[0.],[0.],[0.],[0.],[0.],[0.],[0.],[0.],[0.],[0.],[0.],[0.],[0.]]
  bfield_minus_model_mgse = [[0.],[0.],[0.]]
  bfield_mgse = [[0.],[0.],[0.]]
  bfield_model_mgse = [[0.],[0.],[0.]]
  pos_gse = [[0.],[0.],[0.]]
  vel_gse = [[0.],[0.],[0.]]
  efield_inertial_frame_mgse = [[0.],[0.],[0.]]
  ;efield_corotation_frame_mgse = [[0.],[0.],[0.]]
  bfield_magnitude_minus_modelmagnitude = 0d
  VcoroxB_mgse = [[0.],[0.],[0.]]
  VscxB_mgse = [[0.],[0.],[0.]]
  spinaxis_gse = [[0.],[0.],[0.]]
  bfield_magnitude = 0d
  Vavg = 0d
  mlt_lshell_mlat = [[0.],[0.],[0.]]
  flags_charging_bias_eclipse = [[0.],[0.],[0.]]
  Bfield = [[0.],[0.],[0.],[0.],[0.],[0.],[0.],[0.],[0.],[0.],[0.]]
  pos_gsm = [[0.],[0.],[0.]]
  bfield_model_gsm = [[0.],[0.],[0.]]
  bfield_model_gse = [[0.],[0.],[0.]]
  pos_foot_gse = [[0.],[0.],[0.]]
  radial_distance = 0d
  vel_mgse = [[0.],[0.],[0.]]
  pos_mgse = [[0.],[0.],[0.]]
  EdB_flag = 0d
  bfield_mgse_smoothed = [[0.],[0.],[0.]]
  S_para = 0d
  Sx_mgse = 0d
  Sy_mgse_Ex0 = 0d
  Sz_mgse_Ex0 = 0d
  Sy_mgse_EdB0 = 0d
  Sz_mgse_EdB0 = 0d
  S_mapped_Ex0 = 0d
  S_mapped_EdB0 = 0d
  S_spatial_int_mapped_Ex0 = 0d
  S_time_int_mapped_Ex0 = 0d
  S_spatial_int_mapped_EdB0 = 0d
  S_time_int_mapped_EdB0 = 0d
  S_earthward_logscale_FA = 0d
  S_upwards_logscale_FA = 0d
  S_dEperp2_x_dBperp1_Ex0 = 0d
  S_dEperp1_x_dBperp2_Ex0 = 0d
  S_dEperp2_x_dBperp1_EdB0 = 0d
  S_dEperp1_x_dBperp2_EdB0 = 0d
  S_azimuthal_eastward_Ex0 = 0d
  S_azimuthal_eastward_EdB0 = 0d
  S_radial_outward_Ex0 = 0d
  S_radial_outward_EdB0 = 0d
  S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_Ex0 = 0d
  S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_EdB0 = 0d
  dB_para = 0d
  dBfield_mgse = [[0.],[0.],[0.]]
  dEfield_mgse = [[0.],[0.],[0.]]
  dE_azimuthal_Ex0 = 0d
  dE_azimuthal_EdB0 = 0d
  dE_radial_Ex0 = 0d
  dE_radial_EdB0 = 0d
  dB_azimuthal = 0d
  dB_radial = 0d
  ExB_vel_xMGSE_5minavg = 0d
  ExB_vel_yMGSE_5minavg_Ex0 = 0d
  ExB_vel_yMGSE_5minavg_EdB0 = 0d
  ExB_vel_zMGSE_5minavg_Ex0 = 0d
  ExB_vel_zMGSE_5minavg_EdB0 = 0d
  S_para_noperigee = 0d
  dB_para_noperigee = 0d
  Sx_mgse_noperigee = 0d
  Sy_mgse_Ex0_noperigee = 0d
  Sz_mgse_Ex0_noperigee = 0d
  Sy_mgse_EdB0_noperigee = 0d
  Sz_mgse_EdB0_noperigee = 0d
  S_mapped_Ex0_noperigee = 0d
  S_mapped_EdB0_noperigee = 0d
  S_earthward_logscale_FA_noperigee = 0d
  S_upwards_logscale_FA_noperigee = 0d
  S_dEperp2_x_dBperp1_Ex0_noperigee = 0d
  S_dEperp1_x_dBperp2_Ex0_noperigee = 0d
  S_dEperp2_x_dBperp1_EdB0_noperigee = 0d
  S_dEperp1_x_dBperp2_EdB0_noperigee = 0d
  S_azimuthal_eastward_Ex0_noperigee = 0d
  S_azimuthal_eastward_EdB0_noperigee = 0d
  S_radial_outward_Ex0_noperigee = 0d
  S_radial_outward_EdB0_noperigee = 0d
  S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_Ex0_noperigee = 0d
  S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_EdB0_noperigee = 0d
  dBfield_mgse_noperigee = [[0.],[0.],[0.]]
  dEfield_mgse_noperigee = [[0.],[0.],[0.]]
  dE_azimuthal_Ex0_noperigee = 0d
  dE_azimuthal_EdB0_noperigee = 0d
  dE_radial_Ex0_noperigee = 0d
  dE_radial_EdB0_noperigee = 0d
  dB_azimuthal_noperigee = 0d
  dB_radial_noperigee = 0d



  for i=0,n_elements(days2)-1 do begin

    timespan,days[i]
    rbsp_load_efw_pflux_cdf,probe=sc,suffix=suffix


    d=0.
    get_data,rbspx+'_efw_'+'density',data=d
    get_data,rbspx+'_efw_'+'flags_all',tms,dd

    if is_struct(d) then begin

      t = [t,tms]
      if is_struct(d) then density = [density,d.y]
      ;     d=0.
      ;     get_data,rbspx+'_efw_'+'density_potential',data=d
      ;     if is_struct(d) then density_potential = [density_potential,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'flags_all',data=d
      if is_struct(d) then flags_all = [flags_all,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'bfield_minus_model_mgse',data=d
      if is_struct(d) then bfield_minus_model_mgse = [bfield_minus_model_mgse,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'bfield_mgse',data=d
      if is_struct(d) then bfield_mgse = [bfield_mgse,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'bfield_model_mgse',data=d
      if is_struct(d) then bfield_model_mgse = [bfield_model_mgse,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'pos_gse',data=d
      if is_struct(d) then pos_gse = [pos_gse,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'vel_gse',data=d
      if is_struct(d) then vel_gse = [vel_gse,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'efield_inertial_frame_mgse',data=d
      if is_struct(d) then efield_inertial_frame_mgse = [efield_inertial_frame_mgse,d.y]
      ;d=0.
      ;get_data,rbspx+'_efw_'+'efield_corotation_frame_mgse',data=d
      ;if is_struct(d) then efield_corotation_frame_mgse = [efield_corotation_frame_mgse,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'bfield_magnitude_minus_modelmagnitude',data=d
      if is_struct(d) then bfield_magnitude_minus_modelmagnitude = [bfield_magnitude_minus_modelmagnitude,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'VcoroxB_mgse',data=d
      if is_struct(d) then VcoroxB_mgse = [VcoroxB_mgse,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'VscxB_mgse',data=d
      if is_struct(d) then VscxB_mgse = [VscxB_mgse,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'spinaxis_gse',data=d
      if is_struct(d) then spinaxis_gse = [spinaxis_gse,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'bfield_magnitude',data=d
      if is_struct(d) then bfield_magnitude = [bfield_magnitude,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'Vavg',data=d
      if is_struct(d) then Vavg = [Vavg,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'mlt_lshell_mlat',data=d
      if is_struct(d) then mlt_lshell_mlat = [mlt_lshell_mlat,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'flags_charging_bias_eclipse',data=d
      if is_struct(d) then flags_charging_bias_eclipse = [flags_charging_bias_eclipse,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'Bfield',data=d
      if is_struct(d) then Bfield = [Bfield,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'pos_gsm',data=d
      if is_struct(d) then pos_gsm = [pos_gsm,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'bfield_model_gsm',data=d
      if is_struct(d) then bfield_model_gsm = [bfield_model_gsm,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'bfield_model_gse',data=d
      if is_struct(d) then bfield_model_gse = [bfield_model_gse,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'pos_foot_gse',data=d
      if is_struct(d) then pos_foot_gse = [pos_foot_gse,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'radial_distance',data=d
      if is_struct(d) then radial_distance = [radial_distance,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'vel_mgse',data=d
      if is_struct(d) then vel_mgse = [vel_mgse,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'pos_mgse',data=d
      if is_struct(d) then pos_mgse = [pos_mgse,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'EdB_flag',data=d
      if is_struct(d) then EdB_flag = [EdB_flag,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'bfield_mgse_smoothed',data=d
      if is_struct(d) then bfield_mgse_smoothed = [bfield_mgse_smoothed,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_para',data=d
      if is_struct(d) then S_para = [S_para,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'Sx_mgse',data=d
      if is_struct(d) then Sx_mgse = [Sx_mgse,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'Sy_mgse_Ex0',data=d
      if is_struct(d) then Sy_mgse_Ex0 = [Sy_mgse_Ex0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'Sz_mgse_Ex0',data=d
      if is_struct(d) then Sz_mgse_Ex0 = [Sz_mgse_Ex0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'Sy_mgse_EdB0',data=d
      if is_struct(d) then Sy_mgse_EdB0 = [Sy_mgse_EdB0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'Sz_mgse_EdB0',data=d
      if is_struct(d) then Sz_mgse_EdB0 = [Sz_mgse_EdB0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_mapped_Ex0',data=d
      if is_struct(d) then S_mapped_Ex0 = [S_mapped_Ex0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_mapped_EdB0',data=d
      if is_struct(d) then S_mapped_EdB0 = [S_mapped_EdB0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_spatial_int_mapped_Ex0',data=d
      if is_struct(d) then S_spatial_int_mapped_Ex0 = [S_spatial_int_mapped_Ex0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_time_int_mapped_Ex0',data=d
      if is_struct(d) then S_time_int_mapped_Ex0 = [S_time_int_mapped_Ex0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_spatial_int_mapped_EdB0',data=d
      if is_struct(d) then S_spatial_int_mapped_EdB0 = [S_spatial_int_mapped_EdB0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_time_int_mapped_EdB0',data=d
      if is_struct(d) then  S_time_int_mapped_EdB0 = [S_time_int_mapped_EdB0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_earthward_logscale_FA',data=d
      if is_struct(d) then S_earthward_logscale_FA = [S_earthward_logscale_FA,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_upwards_logscale_FA',data=d
      if is_struct(d) then S_upwards_logscale_FA = [S_upwards_logscale_FA,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_dEperp2_x_dBperp1_Ex0',data=d
      if is_struct(d) then S_dEperp2_x_dBperp1_Ex0 = [S_dEperp2_x_dBperp1_Ex0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_dEperp1_x_dBperp2_Ex0',data=d
      if is_struct(d) then S_dEperp1_x_dBperp2_Ex0 = [S_dEperp1_x_dBperp2_Ex0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_dEperp2_x_dBperp1_EdB0',data=d
      if is_struct(d) then S_dEperp2_x_dBperp1_EdB0 = [S_dEperp2_x_dBperp1_EdB0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_dEperp1_x_dBperp2_EdB0',data=d
      if is_struct(d) then S_dEperp1_x_dBperp2_EdB0 = [S_dEperp1_x_dBperp2_EdB0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_azimuthal_eastward_Ex0',data=d
      if is_struct(d) then S_azimuthal_eastward_Ex0 = [S_azimuthal_eastward_Ex0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_azimuthal_eastward_EdB0',data=d
      if is_struct(d) then S_azimuthal_eastward_EdB0 = [S_azimuthal_eastward_EdB0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_radial_outward_Ex0',data=d
      if is_struct(d) then S_radial_outward_Ex0 = [S_radial_outward_Ex0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_radial_outward_EdB0',data=d
      if is_struct(d) then S_radial_outward_EdB0 = [S_radial_outward_EdB0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_Ex0',data=d
      if is_struct(d) then S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_Ex0 = [S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_Ex0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_EdB0',data=d
      if is_struct(d) then S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_EdB0 = [S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_EdB0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'dB_para',data=d
      if is_struct(d) then dB_para = [dB_para,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'dBfield_mgse',data=d
      if is_struct(d) then dBfield_mgse = [dBfield_mgse,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'dEfield_mgse',data=d
      if is_struct(d) then dEfield_mgse = [dEfield_mgse,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'dE_azimuthal_Ex0',data=d
      if is_struct(d) then dE_azimuthal_Ex0 = [dE_azimuthal_Ex0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'dE_azimuthal_EdB0',data=d
      if is_struct(d) then dE_azimuthal_EdB0 = [dE_azimuthal_EdB0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'dE_radial_Ex0',data=d
      if is_struct(d) then dE_radial_Ex0 = [dE_radial_Ex0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'dE_radial_EdB0',data=d
      if is_struct(d) then dE_radial_EdB0 = [dE_radial_EdB0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'dB_azimuthal',data=d
      if is_struct(d) then dB_azimuthal = [dB_azimuthal,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'dB_radial',data=d
      if is_struct(d) then dB_radial = [dB_radial,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'ExB_vel_xMGSE_5minavg',data=d
      if is_struct(d) then ExB_vel_xMGSE_5minavg = [ExB_vel_xMGSE_5minavg,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'ExB_vel_yMGSE_5minavg_Ex0',data=d
      if is_struct(d) then ExB_vel_yMGSE_5minavg_Ex0 = [ExB_vel_yMGSE_5minavg_Ex0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'ExB_vel_yMGSE_5minavg_EdB0',data=d
      if is_struct(d) then ExB_vel_yMGSE_5minavg_EdB0 = [ExB_vel_yMGSE_5minavg_EdB0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'ExB_vel_zMGSE_5minavg_Ex0',data=d
      if is_struct(d) then ExB_vel_zMGSE_5minavg_Ex0 = [ExB_vel_zMGSE_5minavg_Ex0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'ExB_vel_zMGSE_5minavg_EdB0',data=d
      if is_struct(d) then ExB_vel_zMGSE_5minavg_EdB0 = [ExB_vel_zMGSE_5minavg_EdB0,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_para_noperigee',data=d
      if is_struct(d) then S_para_noperigee = [S_para_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'dB_para_noperigee',data=d
      if is_struct(d) then dB_para_noperigee = [dB_para_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'Sx_mgse_noperigee',data=d
      if is_struct(d) then Sx_mgse_noperigee = [Sx_mgse_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'Sy_mgse_Ex0_noperigee',data=d
      if is_struct(d) then Sy_mgse_Ex0_noperigee = [Sy_mgse_Ex0_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'Sz_mgse_Ex0_noperigee',data=d
      if is_struct(d) then Sz_mgse_Ex0_noperigee = [Sz_mgse_Ex0_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'Sy_mgse_EdB0_noperigee',data=d
      if is_struct(d) then Sy_mgse_EdB0_noperigee = [Sy_mgse_EdB0_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'Sz_mgse_EdB0_noperigee',data=d
      if is_struct(d) then Sz_mgse_EdB0_noperigee = [Sz_mgse_EdB0_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_mapped_Ex0_noperigee',data=d
      if is_struct(d) then S_mapped_Ex0_noperigee = [S_mapped_Ex0_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_mapped_EdB0_noperigee',data=d
      if is_struct(d) then S_mapped_EdB0_noperigee = [S_mapped_EdB0_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_earthward_logscale_FA_noperigee',data=d
      if is_struct(d) then S_earthward_logscale_FA_noperigee = [S_earthward_logscale_FA_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_upwards_logscale_FA_noperigee',data=d
      if is_struct(d) then S_upwards_logscale_FA_noperigee = [S_upwards_logscale_FA_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_dEperp2_x_dBperp1_Ex0_noperigee',data=d
      if is_struct(d) then S_dEperp2_x_dBperp1_Ex0_noperigee = [S_dEperp2_x_dBperp1_Ex0_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_dEperp1_x_dBperp2_Ex0_noperigee',data=d
      if is_struct(d) then S_dEperp1_x_dBperp2_Ex0_noperigee = [S_dEperp1_x_dBperp2_Ex0_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_dEperp2_x_dBperp1_EdB0_noperigee',data=d
      if is_struct(d) then S_dEperp2_x_dBperp1_EdB0_noperigee = [S_dEperp2_x_dBperp1_EdB0_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_dEperp1_x_dBperp2_EdB0_noperigee',data=d
      if is_struct(d) then S_dEperp1_x_dBperp2_EdB0_noperigee = [S_dEperp1_x_dBperp2_EdB0_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_azimuthal_eastward_Ex0_noperigee',data=d
      if is_struct(d) then S_azimuthal_eastward_Ex0_noperigee = [S_azimuthal_eastward_Ex0_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_azimuthal_eastward_EdB0_noperigee',data=d
      if is_struct(d) then S_azimuthal_eastward_EdB0_noperigee = [S_azimuthal_eastward_EdB0_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_radial_outward_Ex0_noperigee',data=d
      if is_struct(d) then S_radial_outward_Ex0_noperigee = [S_radial_outward_Ex0_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_radial_outward_EdB0_noperigee',data=d
      if is_struct(d) then S_radial_outward_EdB0_noperigee = [S_radial_outward_EdB0_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_Ex0_noperigee',data=d
      if is_struct(d) then S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_Ex0_noperigee = [S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_Ex0_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_EdB0_noperigee',data=d
      if is_struct(d) then S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_EdB0_noperigee = [S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_EdB0_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'dBfield_mgse_noperigee',data=d
      if is_struct(d) then dBfield_mgse_noperigee = [dBfield_mgse_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'dEfield_mgse_noperigee',data=d
      if is_struct(d) then dEfield_mgse_noperigee = [dEfield_mgse_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'dE_azimuthal_Ex0_noperigee',data=d
      if is_struct(d) then dE_azimuthal_Ex0_noperigee = [dE_azimuthal_Ex0_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'dE_azimuthal_EdB0_noperigee',data=d
      if is_struct(d) then dE_azimuthal_EdB0_noperigee = [dE_azimuthal_EdB0_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'dE_radial_Ex0_noperigee',data=d
      if is_struct(d) then dE_radial_Ex0_noperigee = [dE_radial_Ex0_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'dE_radial_EdB0_noperigee',data=d
      if is_struct(d) then dE_radial_EdB0_noperigee = [dE_radial_EdB0_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'dB_azimuthal_noperigee',data=d
      if is_struct(d) then dB_azimuthal_noperigee = [dB_azimuthal_noperigee,d.y]
      d=0.
      get_data,rbspx+'_efw_'+'dB_radial_noperigee',data=d
      if is_struct(d) then dB_radial_noperigee = [dB_radial_noperigee,d.y]

    endif

    store_data,tnames(),/delete
  endfor




  ;Remove the zeroth element

  t = t[1:*]
  density = density[1:*]
  ;density_potential = density_potential[1:*,*]
  flags_all = flags_all[1:*,*]
  bfield_minus_model_mgse = bfield_minus_model_mgse[1:*,*]
  bfield_mgse = bfield_mgse[1:*,*]
  bfield_model_mgse = bfield_model_mgse[1:*,*]
  pos_gse = pos_gse[1:*,*]
  vel_gse = vel_gse[1:*,*]
  efield_inertial_frame_mgse = efield_inertial_frame_mgse[1:*,*]
  ;efield_corotation_frame_mgse = efield_corotation_frame_mgse[1:*,*]
  bfield_magnitude_minus_modelmagnitude = bfield_magnitude_minus_modelmagnitude[1:*]
  VcoroxB_mgse = VcoroxB_mgse[1:*,*]
  VscxB_mgse = VscxB_mgse[1:*,*]
  spinaxis_gse = spinaxis_gse[1:*,*]
  bfield_magnitude = bfield_magnitude[1:*]
  Vavg = Vavg[1:*]
  mlt_lshell_mlat = mlt_lshell_mlat[1:*,*]
  flags_charging_bias_eclipse = flags_charging_bias_eclipse[1:*,*]
  Bfield = Bfield[1:*,*]
  pos_gsm = pos_gsm[1:*,*]
  bfield_model_gsm = bfield_model_gsm[1:*,*]
  bfield_model_gse = bfield_model_gse[1:*,*]
  pos_foot_gse = pos_foot_gse[1:*,*]
  radial_distance = radial_distance[1:*]
  vel_mgse = vel_mgse[1:*,*]
  pos_mgse = pos_mgse[1:*,*]
  EdB_flag = EdB_flag[1:*]
  bfield_mgse_smoothed = bfield_mgse_smoothed[1:*,*]
  S_para = S_para[1:*]
  Sx_mgse = Sx_mgse[1:*]
  Sy_mgse_Ex0 = Sy_mgse_Ex0[1:*]
  Sz_mgse_Ex0 = Sz_mgse_Ex0[1:*]
  Sy_mgse_EdB0 = Sy_mgse_EdB0[1:*]
  Sz_mgse_EdB0 = Sz_mgse_EdB0[1:*]
  S_mapped_Ex0 = S_mapped_Ex0[1:*]
  S_mapped_EdB0 = S_mapped_EdB0[1:*]
  S_spatial_int_mapped_Ex0 = S_spatial_int_mapped_Ex0[1:*]
  S_time_int_mapped_Ex0 = S_time_int_mapped_Ex0[1:*]
  S_spatial_int_mapped_EdB0 = S_spatial_int_mapped_EdB0[1:*]
  S_time_int_mapped_EdB0 = S_time_int_mapped_EdB0[1:*]
  S_earthward_logscale_FA = S_earthward_logscale_FA[1:*]
  S_upwards_logscale_FA = S_upwards_logscale_FA[1:*]
  S_dEperp2_x_dBperp1_Ex0 = S_dEperp2_x_dBperp1_Ex0[1:*]
  S_dEperp1_x_dBperp2_Ex0 = S_dEperp1_x_dBperp2_Ex0[1:*]
  S_dEperp2_x_dBperp1_EdB0 = S_dEperp2_x_dBperp1_EdB0[1:*]
  S_dEperp1_x_dBperp2_EdB0 = S_dEperp1_x_dBperp2_EdB0[1:*]
  S_azimuthal_eastward_Ex0 = S_azimuthal_eastward_Ex0[1:*]
  S_azimuthal_eastward_EdB0 = S_azimuthal_eastward_EdB0[1:*]
  S_radial_outward_Ex0 = S_radial_outward_Ex0[1:*]
  S_radial_outward_EdB0 = S_radial_outward_EdB0[1:*]
  S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_Ex0 = S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_Ex0[1:*]
  S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_EdB0 = S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_EdB0[1:*]
  dB_para = dB_para[1:*]
  dBfield_mgse = dBfield_mgse[1:*,*]
  dEfield_mgse = dEfield_mgse[1:*,*]
  dE_azimuthal_Ex0 = dE_azimuthal_Ex0[1:*]
  dE_azimuthal_EdB0 = dE_azimuthal_EdB0[1:*]
  dE_radial_Ex0 = dE_radial_Ex0[1:*]
  dE_radial_EdB0 = dE_radial_EdB0[1:*]
  dB_azimuthal = dB_azimuthal[1:*]
  dB_radial = dB_radial[1:*]
  ExB_vel_xMGSE_5minavg = ExB_vel_xMGSE_5minavg[1:*]
  ExB_vel_yMGSE_5minavg_Ex0 = ExB_vel_yMGSE_5minavg_Ex0[1:*]
  ExB_vel_yMGSE_5minavg_EdB0 = ExB_vel_yMGSE_5minavg_EdB0[1:*]
  ExB_vel_zMGSE_5minavg_Ex0 = ExB_vel_zMGSE_5minavg_Ex0[1:*]
  ExB_vel_zMGSE_5minavg_EdB0 = ExB_vel_zMGSE_5minavg_EdB0[1:*]
  S_para_noperigee = S_para_noperigee[1:*]
  dB_para_noperigee = dB_para_noperigee[1:*]
  Sx_mgse_noperigee = Sx_mgse_noperigee[1:*]
  Sy_mgse_Ex0_noperigee = Sy_mgse_Ex0_noperigee[1:*]
  Sz_mgse_Ex0_noperigee = Sz_mgse_Ex0_noperigee[1:*]
  Sy_mgse_EdB0_noperigee = Sy_mgse_EdB0_noperigee[1:*]
  Sz_mgse_EdB0_noperigee = Sz_mgse_EdB0_noperigee[1:*]
  S_mapped_Ex0_noperigee = S_mapped_Ex0_noperigee[1:*]
  S_mapped_EdB0_noperigee = S_mapped_EdB0_noperigee[1:*]
  S_earthward_logscale_FA_noperigee = S_earthward_logscale_FA_noperigee[1:*]
  S_upwards_logscale_FA_noperigee = S_upwards_logscale_FA_noperigee[1:*]
  S_dEperp2_x_dBperp1_Ex0_noperigee = S_dEperp2_x_dBperp1_Ex0_noperigee[1:*]
  S_dEperp1_x_dBperp2_Ex0_noperigee = S_dEperp1_x_dBperp2_Ex0_noperigee[1:*]
  S_dEperp2_x_dBperp1_EdB0_noperigee = S_dEperp2_x_dBperp1_EdB0_noperigee[1:*]
  S_dEperp1_x_dBperp2_EdB0_noperigee = S_dEperp1_x_dBperp2_EdB0_noperigee[1:*]
  S_azimuthal_eastward_Ex0_noperigee = S_azimuthal_eastward_Ex0_noperigee[1:*]
  S_azimuthal_eastward_EdB0_noperigee = S_azimuthal_eastward_EdB0_noperigee[1:*]
  S_radial_outward_Ex0_noperigee = S_radial_outward_Ex0_noperigee[1:*]
  S_radial_outward_EdB0_noperigee = S_radial_outward_EdB0_noperigee[1:*]
  S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_Ex0_noperigee = S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_Ex0_noperigee[1:*]
  S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_EdB0_noperigee = S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_EdB0_noperigee[1:*]
  dBfield_mgse_noperigee = dBfield_mgse_noperigee[1:*,*]
  dEfield_mgse_noperigee = dEfield_mgse_noperigee[1:*,*]
  dE_azimuthal_Ex0_noperigee = dE_azimuthal_Ex0_noperigee[1:*]
  dE_azimuthal_EdB0_noperigee = dE_azimuthal_EdB0_noperigee[1:*]
  dE_radial_Ex0_noperigee = dE_radial_Ex0_noperigee[1:*]
  dE_radial_EdB0_noperigee = dE_radial_EdB0_noperigee[1:*]
  dB_azimuthal_noperigee = dB_azimuthal_noperigee[1:*]
  dB_radial_noperigee = dB_radial_noperigee[1:*]





  ;******************************************



  store_data,'density',t,density
  ;store_data,'density_potential',t,density_potential
  store_data,'flags_all',t,flags_all
  store_data,'bfield_minus_model_mgse',t,bfield_minus_model_mgse
  store_data,'bfield_mgse',t,bfield_mgse
  store_data,'bfield_model_mgse',t,bfield_model_mgse
  store_data,'pos_gse',t,pos_gse
  store_data,'vel_gse',t,vel_gse
  store_data,'efield_inertial_frame_mgse',t,efield_inertial_frame_mgse
  ;store_data,'efield_corotation_frame_mgse',t,efield_corotation_frame_mgse
  store_data,'bfield_magnitude_minus_modelmagnitude',t,bfield_magnitude_minus_modelmagnitude
  store_data,'VcoroxB_mgse',t,VcoroxB_mgse
  store_data,'VscxB_mgse',t,VscxB_mgse
  store_data,'spinaxis_gse',t,spinaxis_gse
  store_data,'bfield_magnitude',t,bfield_magnitude
  store_data,'Vavg',t,Vavg
  store_data,'mlt_lshell_mlat',t,mlt_lshell_mlat
  store_data,'flags_charging_bias_eclipse',t,flags_charging_bias_eclipse
  store_data,'Bfield',t,Bfield
  store_data,'pos_gsm',t,pos_gsm
  store_data,'bfield_model_gsm',t,bfield_model_gsm
  store_data,'bfield_model_gse',t,bfield_model_gse
  store_data,'pos_foot_gse',t,pos_foot_gse
  store_data,'radial_distance',t,radial_distance
  store_data,'vel_mgse',t,vel_mgse
  store_data,'pos_mgse',t,pos_mgse
  store_data,'EdB_flag',t,EdB_flag
  store_data,'bfield_mgse_smoothed',t,bfield_mgse_smoothed
  store_data,'S_para',t,S_para
  store_data,'Sx_mgse',t,Sx_mgse
  store_data,'Sy_mgse_Ex0',t,Sy_mgse_Ex0
  store_data,'Sz_mgse_Ex0',t,Sz_mgse_Ex0
  store_data,'Sy_mgse_EdB0',t,Sy_mgse_EdB0
  store_data,'Sz_mgse_EdB0',t,Sz_mgse_EdB0
  store_data,'S_mapped_Ex0',t,S_mapped_Ex0
  store_data,'S_mapped_EdB0',t,S_mapped_EdB0
  store_data,'S_spatial_int_mapped_Ex0',t,S_spatial_int_mapped_Ex0
  store_data,'S_time_int_mapped_Ex0',t,S_time_int_mapped_Ex0
  store_data,'S_spatial_int_mapped_EdB0',t,S_spatial_int_mapped_EdB0
  store_data,'S_time_int_mapped_EdB0',t,S_time_int_mapped_EdB0
  store_data,'S_earthward_logscale_FA',t,S_earthward_logscale_FA
  store_data,'S_upwards_logscale_FA',t,S_upwards_logscale_FA
  store_data,'S_dEperp2_x_dBperp1_Ex0',t,S_dEperp2_x_dBperp1_Ex0
  store_data,'S_dEperp1_x_dBperp2_Ex0',t,S_dEperp1_x_dBperp2_Ex0
  store_data,'S_dEperp2_x_dBperp1_EdB0',t,S_dEperp2_x_dBperp1_EdB0
  store_data,'S_dEperp1_x_dBperp2_EdB0',t,S_dEperp1_x_dBperp2_EdB0
  store_data,'S_azimuthal_eastward_Ex0',t,S_azimuthal_eastward_Ex0
  store_data,'S_azimuthal_eastward_EdB0',t,S_azimuthal_eastward_EdB0
  store_data,'S_radial_outward_Ex0',t,S_radial_outward_Ex0
  store_data,'S_radial_outward_EdB0',t,S_radial_outward_EdB0
  store_data,'S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_Ex0',t,S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_Ex0
  store_data,'S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_EdB0',t,S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_EdB0
  store_data,'dB_para',t,dB_para
  store_data,'dBfield_mgse',t,dBfield_mgse
  store_data,'dEfield_mgse',t,dEfield_mgse
  store_data,'dE_azimuthal_Ex0',t,dE_azimuthal_Ex0
  store_data,'dE_azimuthal_EdB0',t,dE_azimuthal_EdB0
  store_data,'dE_radial_Ex0',t,dE_radial_Ex0
  store_data,'dE_radial_EdB0',t,dE_radial_EdB0
  store_data,'dB_azimuthal',t,dB_azimuthal
  store_data,'dB_radial',t,dB_radial
  store_data,'ExB_vel_xMGSE_5minavg',t,ExB_vel_xMGSE_5minavg
  store_data,'ExB_vel_yMGSE_5minavg_Ex0',t,ExB_vel_yMGSE_5minavg_Ex0
  store_data,'ExB_vel_yMGSE_5minavg_EdB0',t,ExB_vel_yMGSE_5minavg_EdB0
  store_data,'ExB_vel_zMGSE_5minavg_Ex0',t,ExB_vel_zMGSE_5minavg_Ex0
  store_data,'ExB_vel_zMGSE_5minavg_EdB0',t,ExB_vel_zMGSE_5minavg_EdB0
  store_data,'S_para_noperigee',t,S_para_noperigee
  store_data,'dB_para_noperigee',t,dB_para_noperigee
  store_data,'Sx_mgse_noperigee',t,Sx_mgse_noperigee
  store_data,'Sy_mgse_Ex0_noperigee',t,Sy_mgse_Ex0_noperigee
  store_data,'Sz_mgse_Ex0_noperigee',t,Sz_mgse_Ex0_noperigee
  store_data,'Sy_mgse_EdB0_noperigee',t,Sy_mgse_EdB0_noperigee
  store_data,'Sz_mgse_EdB0_noperigee',t,Sz_mgse_EdB0_noperigee
  store_data,'S_mapped_Ex0_noperigee',t,S_mapped_Ex0_noperigee
  store_data,'S_mapped_EdB0_noperigee',t,S_mapped_EdB0_noperigee
  store_data,'S_earthward_logscale_FA_noperigee',t,S_earthward_logscale_FA_noperigee
  store_data,'S_upwards_logscale_FA_noperigee',t,S_upwards_logscale_FA_noperigee
  store_data,'S_dEperp2_x_dBperp1_Ex0_noperigee',t,S_dEperp2_x_dBperp1_Ex0_noperigee
  store_data,'S_dEperp1_x_dBperp2_Ex0_noperigee',t,S_dEperp1_x_dBperp2_Ex0_noperigee
  store_data,'S_dEperp2_x_dBperp1_EdB0_noperigee',t,S_dEperp2_x_dBperp1_EdB0_noperigee
  store_data,'S_dEperp1_x_dBperp2_EdB0_noperigee',t,S_dEperp1_x_dBperp2_EdB0_noperigee
  store_data,'S_azimuthal_eastward_Ex0_noperigee',t,S_azimuthal_eastward_Ex0_noperigee
  store_data,'S_azimuthal_eastward_EdB0_noperigee',t,S_azimuthal_eastward_EdB0_noperigee
  store_data,'S_radial_outward_Ex0_noperigee',t,S_radial_outward_Ex0_noperigee
  store_data,'S_radial_outward_EdB0_noperigee',t,S_radial_outward_EdB0_noperigee
  store_data,'S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_Ex0_noperigee',t,S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_Ex0_noperigee
  store_data,'S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_EdB0_noperigee',t,S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_EdB0_noperigee
  store_data,'dBfield_mgse_noperigee',t,dBfield_mgse_noperigee
  store_data,'dEfield_mgse_noperigee',t,dEfield_mgse_noperigee
  store_data,'dE_azimuthal_Ex0_noperigee',t,dE_azimuthal_Ex0_noperigee
  store_data,'dE_azimuthal_EdB0_noperigee',t,dE_azimuthal_EdB0_noperigee
  store_data,'dE_radial_Ex0_noperigee',t,dE_radial_Ex0_noperigee
  store_data,'dE_radial_EdB0_noperigee',t,dE_radial_EdB0_noperigee
  store_data,'dB_azimuthal_noperigee',t,dB_azimuthal_noperigee
  store_data,'dB_radial_noperigee',t,dB_radial_noperigee





  ;  tplot,'*'
  timespan,time_double(days[0]),(time_double(days[n_elements(days)-1])-time_double(days[0]))/86400.,/days
  ;******************************************



  epoch = tplot_time_to_epoch(t,/epoch16)


  ;  skeleton = 'rbsp'+sc+'_efw-l2_00000000_v02.cdf'
  skeleton = 'rbsp'+sc+'_efw-pflux_00000000_v01.cdf
  source_file='~/Desktop/code/Aaron/RBSP/TDAS_trunk_svn/general/missions/rbsp/efw/l1_to_l2/' + skeleton

  filename = 'rbsp'+sc+'_efw-pflux_'+days2[0]+'-'+days2[n_elements(days2)-1]+'_'+suffix+'.cdf'

  file_copy,source_file,path+filename,/overwrite

  cdfid = cdf_open(path+filename)
  cdf_control, cdfid, get_var_info=info, variable='epoch'

  cdf_varput,cdfid,'epoch',epoch
  cdf_varput,cdfid,'density',density
;  ;cdf_varput,cdfid,'density_potential',transpose(density_potential)
;  cdf_varput,cdfid,'flags_all',transpose(flags_all)
;  cdf_varput,cdfid,'bfield_minus_model_mgse',transpose(bfield_minus_model_mgse)
  cdf_varput,cdfid,'bfield_mgse',transpose(bfield_mgse)
;  cdf_varput,cdfid,'bfield_model_mgse',transpose(bfield_model_mgse)
;  cdf_varput,cdfid,'pos_gse',transpose(pos_gse)
;  cdf_varput,cdfid,'vel_gse',transpose(vel_gse)
;  cdf_varput,cdfid,'efield_inertial_frame_mgse',transpose(efield_inertial_frame_mgse)
;  ;cdf_varput,cdfid,'efield_corotation_frame_mgse',transpose(efield_corotation_frame_mgse)
;  cdf_varput,cdfid,'bfield_magnitude_minus_modelmagnitude',transpose(bfield_magnitude_minus_modelmagnitude)
;  cdf_varput,cdfid,'VcoroxB_mgse',transpose(VcoroxB_mgse)
;  cdf_varput,cdfid,'VscxB_mgse',transpose(VscxB_mgse)
;  cdf_varput,cdfid,'spinaxis_gse',transpose(spinaxis_gse)
;  cdf_varput,cdfid,'bfield_magnitude',bfield_magnitude
;  cdf_varput,cdfid,'Vavg',Vavg
  cdf_varput,cdfid,'mlt_lshell_mlat',transpose(mlt_lshell_mlat)
  cdf_varput,cdfid,'flags_charging_bias_eclipse',transpose(flags_charging_bias_eclipse)
;  cdf_varput,cdfid,'Bfield',transpose(Bfield)
;  cdf_varput,cdfid,'pos_gsm',transpose(pos_gsm)
;  cdf_varput,cdfid,'bfield_model_gsm',transpose(bfield_model_gsm)
;  cdf_varput,cdfid,'bfield_model_gse',transpose(bfield_model_gse)
  cdf_varput,cdfid,'pos_foot_gse',transpose(pos_foot_gse)
  cdf_varput,cdfid,'radial_distance',radial_distance
;  cdf_varput,cdfid,'vel_mgse',transpose(vel_mgse)
;  cdf_varput,cdfid,'pos_mgse',transpose(pos_mgse)
;  cdf_varput,cdfid,'EdB_flag',transpose(EdB_flag)
;  cdf_varput,cdfid,'bfield_mgse_smoothed',transpose(bfield_mgse_smoothed)
;  cdf_varput,cdfid,'S_para',S_para
;  cdf_varput,cdfid,'Sx_mgse',Sx_mgse
;  cdf_varput,cdfid,'Sy_mgse_Ex0',Sy_mgse_Ex0
;  cdf_varput,cdfid,'Sz_mgse_Ex0',Sz_mgse_Ex0
;  cdf_varput,cdfid,'Sy_mgse_EdB0',Sy_mgse_EdB0
;  cdf_varput,cdfid,'Sz_mgse_EdB0',Sz_mgse_EdB0
;  cdf_varput,cdfid,'S_mapped_Ex0',S_mapped_Ex0
;  cdf_varput,cdfid,'S_mapped_EdB0',S_mapped_EdB0
  cdf_varput,cdfid,'S_spatial_int_mapped_Ex0',S_spatial_int_mapped_Ex0
  cdf_varput,cdfid,'S_time_int_mapped_Ex0',S_time_int_mapped_Ex0
  cdf_varput,cdfid,'S_spatial_int_mapped_EdB0',S_spatial_int_mapped_EdB0
  cdf_varput,cdfid,'S_time_int_mapped_EdB0',S_time_int_mapped_EdB0
;  cdf_varput,cdfid,'S_earthward_logscale_FA',S_earthward_logscale_FA
;  cdf_varput,cdfid,'S_upwards_logscale_FA',S_upwards_logscale_FA
;  cdf_varput,cdfid,'S_dEperp2_x_dBperp1_Ex0',S_dEperp2_x_dBperp1_Ex0
;  cdf_varput,cdfid,'S_dEperp1_x_dBperp2_Ex0',S_dEperp1_x_dBperp2_Ex0
;  cdf_varput,cdfid,'S_dEperp2_x_dBperp1_EdB0',S_dEperp2_x_dBperp1_EdB0
;  cdf_varput,cdfid,'S_dEperp1_x_dBperp2_EdB0',S_dEperp1_x_dBperp2_EdB0
;  cdf_varput,cdfid,'S_azimuthal_eastward_Ex0',S_azimuthal_eastward_Ex0
;  cdf_varput,cdfid,'S_azimuthal_eastward_EdB0',S_azimuthal_eastward_EdB0
;  cdf_varput,cdfid,'S_radial_outward_Ex0',S_radial_outward_Ex0
;  cdf_varput,cdfid,'S_radial_outward_EdB0',S_radial_outward_EdB0
;  cdf_varput,cdfid,'S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_Ex0',S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_Ex0
;  cdf_varput,cdfid,'S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_EdB0',S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_EdB0
;  cdf_varput,cdfid,'dB_para',dB_para
;  cdf_varput,cdfid,'dBfield_mgse',transpose(dBfield_mgse)
;  cdf_varput,cdfid,'dEfield_mgse',transpose(dEfield_mgse)
;  cdf_varput,cdfid,'dE_azimuthal_Ex0',dE_azimuthal_Ex0
;  cdf_varput,cdfid,'dE_azimuthal_EdB0',dE_azimuthal_EdB0
;  cdf_varput,cdfid,'dE_radial_Ex0',dE_radial_Ex0
;  cdf_varput,cdfid,'dE_radial_EdB0',dE_radial_EdB0
;  cdf_varput,cdfid,'dB_azimuthal',dB_azimuthal
;  cdf_varput,cdfid,'dB_radial',dB_radial
;  cdf_varput,cdfid,'ExB_vel_xMGSE_5minavg',ExB_vel_xMGSE_5minavg
;  cdf_varput,cdfid,'ExB_vel_yMGSE_5minavg_Ex0',ExB_vel_yMGSE_5minavg_Ex0
;  cdf_varput,cdfid,'ExB_vel_yMGSE_5minavg_EdB0',ExB_vel_yMGSE_5minavg_EdB0
;  cdf_varput,cdfid,'ExB_vel_zMGSE_5minavg_Ex0',ExB_vel_zMGSE_5minavg_Ex0
;  cdf_varput,cdfid,'ExB_vel_zMGSE_5minavg_EdB0',ExB_vel_zMGSE_5minavg_EdB0
  cdf_varput,cdfid,'S_para_noperigee',S_para_noperigee
;  cdf_varput,cdfid,'dB_para_noperigee',dB_para_noperigee
;  cdf_varput,cdfid,'Sx_mgse_noperigee',Sx_mgse_noperigee
;  cdf_varput,cdfid,'Sy_mgse_Ex0_noperigee',Sy_mgse_Ex0_noperigee
;  cdf_varput,cdfid,'Sz_mgse_Ex0_noperigee',Sz_mgse_Ex0_noperigee
;  cdf_varput,cdfid,'Sy_mgse_EdB0_noperigee',Sy_mgse_EdB0_noperigee
;  cdf_varput,cdfid,'Sz_mgse_EdB0_noperigee',Sz_mgse_EdB0_noperigee
  cdf_varput,cdfid,'S_mapped_Ex0_noperigee',S_mapped_Ex0_noperigee
  cdf_varput,cdfid,'S_mapped_EdB0_noperigee',S_mapped_EdB0_noperigee
  cdf_varput,cdfid,'S_earthward_logscale_FA_noperigee',S_earthward_logscale_FA_noperigee
  cdf_varput,cdfid,'S_upwards_logscale_FA_noperigee',S_upwards_logscale_FA_noperigee
  cdf_varput,cdfid,'S_dEperp2_x_dBperp1_Ex0_noperigee',S_dEperp2_x_dBperp1_Ex0_noperigee
  cdf_varput,cdfid,'S_dEperp1_x_dBperp2_Ex0_noperigee',S_dEperp1_x_dBperp2_Ex0_noperigee
  cdf_varput,cdfid,'S_dEperp2_x_dBperp1_EdB0_noperigee',S_dEperp2_x_dBperp1_EdB0_noperigee
  cdf_varput,cdfid,'S_dEperp1_x_dBperp2_EdB0_noperigee',S_dEperp1_x_dBperp2_EdB0_noperigee
  cdf_varput,cdfid,'S_azimuthal_eastward_Ex0_noperigee',S_azimuthal_eastward_Ex0_noperigee
  cdf_varput,cdfid,'S_azimuthal_eastward_EdB0_noperigee',S_azimuthal_eastward_EdB0_noperigee
  cdf_varput,cdfid,'S_radial_outward_Ex0_noperigee',S_radial_outward_Ex0_noperigee
  cdf_varput,cdfid,'S_radial_outward_EdB0_noperigee',S_radial_outward_EdB0_noperigee
  cdf_varput,cdfid,'S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_Ex0_noperigee',S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_Ex0_noperigee
  cdf_varput,cdfid,'S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_EdB0_noperigee',S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_EdB0_noperigee
;  cdf_varput,cdfid,'dBfield_mgse_noperigee',transpose(dBfield_mgse_noperigee)
;  cdf_varput,cdfid,'dEfield_mgse_noperigee',transpose(dEfield_mgse_noperigee)
;  cdf_varput,cdfid,'dE_azimuthal_Ex0_noperigee',dE_azimuthal_Ex0_noperigee
;  cdf_varput,cdfid,'dE_azimuthal_EdB0_noperigee',dE_azimuthal_EdB0_noperigee
;  cdf_varput,cdfid,'dE_radial_Ex0_noperigee',dE_radial_Ex0_noperigee
;  cdf_varput,cdfid,'dE_radial_EdB0_noperigee',dE_radial_EdB0_noperigee
;  cdf_varput,cdfid,'dB_azimuthal_noperigee',dB_azimuthal_noperigee
;  cdf_varput,cdfid,'dB_radial_noperigee',dB_radial_noperigee




;----------------------------------------------------------------------------
;Delete various variables
;----------------------------------------------------------------------------


;cdf_vardeletecdfid,'density_potential',transpose(density_potential)
cdf_vardelete,cdfid,'flags_all'
cdf_vardelete,cdfid,'bfield_minus_model_mgse'
cdf_vardelete,cdfid,'density_potential'
;;cdf_vardelete,cdfid,'bfield_mgse'
cdf_vardelete,cdfid,'bfield_model_mgse'
cdf_vardelete,cdfid,'pos_gse'
cdf_vardelete,cdfid,'vel_gse'
cdf_vardelete,cdfid,'efield_inertial_frame_mgse'
cdf_vardelete,cdfid,'efield_corotation_frame_mgse'
cdf_vardelete,cdfid,'bfield_magnitude_minus_modelmagnitude'
cdf_vardelete,cdfid,'VcoroxB_mgse'
cdf_vardelete,cdfid,'VscxB_mgse'
cdf_vardelete,cdfid,'spinaxis_gse'
cdf_vardelete,cdfid,'bfield_magnitude'
cdf_vardelete,cdfid,'Vavg'
;;cdf_vardelete,cdfid,'mlt_lshell_mlat'
;;cdf_vardelete,cdfid,'flags_charging_bias_eclipse'
cdf_vardelete,cdfid,'Bfield'
cdf_vardelete,cdfid,'pos_gsm'
cdf_vardelete,cdfid,'bfield_model_gsm'
cdf_vardelete,cdfid,'bfield_model_gse'
;;cdf_vardelete,cdfid,'pos_foot_gse'
;;cdf_vardelete,cdfid,'radial_distance'
cdf_vardelete,cdfid,'vel_mgse'
cdf_vardelete,cdfid,'pos_mgse'
cdf_vardelete,cdfid,'EdB_flag'
cdf_vardelete,cdfid,'bfield_mgse_smoothed'
cdf_vardelete,cdfid,'S_para'
cdf_vardelete,cdfid,'Sx_mgse'
cdf_vardelete,cdfid,'Sy_mgse_Ex0'
cdf_vardelete,cdfid,'Sz_mgse_Ex0'
cdf_vardelete,cdfid,'Sy_mgse_EdB0'
cdf_vardelete,cdfid,'Sz_mgse_EdB0'
cdf_vardelete,cdfid,'S_mapped_Ex0'
cdf_vardelete,cdfid,'S_mapped_EdB0'
;;cdf_vardelete,cdfid,'S_spatial_int_mapped_Ex0'
;;cdf_vardelete,cdfid,'S_time_int_mapped_Ex0'
;;cdf_vardelete,cdfid,'S_spatial_int_mapped_EdB0'
;;cdf_vardelete,cdfid,'S_time_int_mapped_EdB0'
cdf_vardelete,cdfid,'S_earthward_logscale_FA'
cdf_vardelete,cdfid,'S_upwards_logscale_FA'
cdf_vardelete,cdfid,'S_dEperp2_x_dBperp1_Ex0'
cdf_vardelete,cdfid,'S_dEperp1_x_dBperp2_Ex0'
cdf_vardelete,cdfid,'S_dEperp2_x_dBperp1_EdB0'
cdf_vardelete,cdfid,'S_dEperp1_x_dBperp2_EdB0'
cdf_vardelete,cdfid,'S_azimuthal_eastward_Ex0'
cdf_vardelete,cdfid,'S_azimuthal_eastward_EdB0'
cdf_vardelete,cdfid,'S_radial_outward_Ex0'
cdf_vardelete,cdfid,'S_radial_outward_EdB0'
cdf_vardelete,cdfid,'S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_Ex0'
cdf_vardelete,cdfid,'S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_EdB0'
cdf_vardelete,cdfid,'dB_para'
cdf_vardelete,cdfid,'dBfield_mgse'
cdf_vardelete,cdfid,'dEfield_mgse'
cdf_vardelete,cdfid,'dE_azimuthal_Ex0'
cdf_vardelete,cdfid,'dE_azimuthal_EdB0'
cdf_vardelete,cdfid,'dE_radial_Ex0'
cdf_vardelete,cdfid,'dE_radial_EdB0'
cdf_vardelete,cdfid,'dB_azimuthal'
cdf_vardelete,cdfid,'dB_radial'
cdf_vardelete,cdfid,'ExB_vel_xMGSE_5minavg'
cdf_vardelete,cdfid,'ExB_vel_yMGSE_5minavg_Ex0'
cdf_vardelete,cdfid,'ExB_vel_yMGSE_5minavg_EdB0'
cdf_vardelete,cdfid,'ExB_vel_zMGSE_5minavg_Ex0'
cdf_vardelete,cdfid,'ExB_vel_zMGSE_5minavg_EdB0'
;;cdf_vardelete,cdfid,'S_para_noperigee'
cdf_vardelete,cdfid,'dB_para_noperigee'
cdf_vardelete,cdfid,'Sx_mgse_noperigee'
cdf_vardelete,cdfid,'Sy_mgse_Ex0_noperigee'
cdf_vardelete,cdfid,'Sz_mgse_Ex0_noperigee'
cdf_vardelete,cdfid,'Sy_mgse_EdB0_noperigee'
cdf_vardelete,cdfid,'Sz_mgse_EdB0_noperigee'
;;cdf_vardelete,cdfid,'S_mapped_Ex0_noperigee'
;;cdf_vardelete,cdfid,'S_mapped_EdB0_noperigee'
;;cdf_vardelete,cdfid,'S_earthward_logscale_FA_noperigee'
;;cdf_vardelete,cdfid,'S_upwards_logscale_FA_noperigee'
;;cdf_vardelete,cdfid,'S_dEperp2_x_dBperp1_Ex0_noperigee'
;;cdf_vardelete,cdfid,'S_dEperp1_x_dBperp2_Ex0_noperigee'
;;cdf_vardelete,cdfid,'S_dEperp2_x_dBperp1_EdB0_noperigee'
;;cdf_vardelete,cdfid,'S_dEperp1_x_dBperp2_EdB0_noperigee'
;;cdf_vardelete,cdfid,'S_azimuthal_eastward_Ex0_noperigee'
;;cdf_vardelete,cdfid,'S_azimuthal_eastward_EdB0_noperigee'
;;cdf_vardelete,cdfid,'S_radial_outward_Ex0_noperigee'
;;cdf_vardelete,cdfid,'S_radial_outward_EdB0_noperigee'
;;cdf_vardelete,cdfid,'S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_Ex0_noperigee'
;;cdf_vardelete,cdfid,'S_dEperp2_x_dBperp1_minus_dEperp1_x_dBperp2_EdB0_noperigee'
cdf_vardelete,cdfid,'dBfield_mgse_noperigee'
cdf_vardelete,cdfid,'dEfield_mgse_noperigee'
cdf_vardelete,cdfid,'dE_azimuthal_Ex0_noperigee'
cdf_vardelete,cdfid,'dE_azimuthal_EdB0_noperigee'
cdf_vardelete,cdfid,'dE_radial_Ex0_noperigee'
cdf_vardelete,cdfid,'dE_radial_EdB0_noperigee'
cdf_vardelete,cdfid,'dB_azimuthal_noperigee'
cdf_vardelete,cdfid,'dB_radial_noperigee'
cdf_vardelete,cdfid,'orbit_num'
cdf_vardelete,cdfid,'Lstar'
cdf_vardelete,cdfid,'ephemeris'
cdf_vardelete,cdfid,'efield_inertial_frame_mgse_edotb_zero'
cdf_vardelete,cdfid,'efield_corotation_frame_mgse_edotb_zero'
cdf_vardelete,cdfid,'angle_Ey_Ez_Bo'
cdf_vardelete,cdfid,'bias_current'
cdf_vardelete,cdfid,'efield_mgse'








  cdf_close, cdfid


  store_data,tnames(),/delete


  ;  cdf2tplot,files = path + filename


end

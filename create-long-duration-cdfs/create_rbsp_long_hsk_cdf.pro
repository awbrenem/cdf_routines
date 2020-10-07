;Packs up daily HSK cdfs and puts them into a single long-duration cdf file.

pro create_rbsp_long_hsk_cdf


  d0 = '2014-11-01'
  d1 = '2015-04-12'

  sc = 'b'
  rbspx = 'rbsp' + sc
  ndays = floor((time_double(d1) - time_double(d0))/86400)
  days = time_string(indgen(ndays)*86400L + time_double(d0))
  days = strmid(days,0,10)
  days2 = strmid(days,0,4) + strmid(days,5,2) + strmid(days,8,2)

  path = '~/Desktop/code/Aaron/RBSP/l2_processing_cribs/'
  fn = 'rbsp'+sc+'_hsk_'+days2+'.cdf'


  t = 0d
  imon_beb = 0.
  imon_idpu = 0.
  imon_p15 = 0.
  imon_p33 = 0.
  imon_fvx = 0.
  imon_fvy = 0.
  imon_fvz = 0.

  vmon_p10va_b = 0.
  vmon_p33vd_i = 0.
  vmon_p10va_i = 0.
  vmon_p15vd_i = 0.
  vmon_p5va_b = 0.
  vmon_p5va_i = 0.
  vmon_p5vd_b = 0.
  vmon_p5vd_i = 0.
  vmon_n10va_b = 0.
  vmon_n10va_i = 0.
  vmon_n5va = 0.
  vmon_p36vd = 0.
  vmon_p18vd = 0.

  tmon_lvps = 0.
  tmon_axb5 = 0.
  tmon_axb6 = 0.
  tmon_fpga = 0.
  ssr_fillper = 0.
  b1_evalmax = 0.
  b1_playreq = 0.
  b1_recbbi = 0.
  b1_receci = 0.
  b1_thresh = 0.
  b2_thresh = 0.
  b2_recstate = 0.
  b2_evalmax = 0.
  eccsing = 0.
  eccmult = 0.
  rstctr = 0.
  rstflag = 0.

  eclipse = 0.
  auto_bias = 0.
  bias_sweep = 0.
  ant_deploy = 0.
  maneuver = 0.
  ibias = [[0.],[0.],[0.],[0.],[0.],[0.]]


  for i=0,n_elements(days2)-1 do begin

     cdf2tplot,files=path + fn[i]
     get_data,'IMON_IDPU_BEB',data=d
     t = [t,d.x]
     imon_beb = [imon_beb,d.y]
     get_data,'IMON_IDPU_IDPU',data=d
     imon_idpu = [imon_idpu,d.y]
     get_data,'IMON_IDPU_FVX',data=d
     imon_fvx = [imon_fvx,d.y]
     get_data,'IMON_IDPU_FVY',data=d
     imon_fvy = [imon_fvy,d.y]
     get_data,'IMON_IDPU_FVZ',data=d
     imon_fvz = [imon_fvz,d.y]
     get_data,'IMON_IDPU_P33',data=d
     imon_p33 = [imon_p33,d.y]
     get_data,'IMON_IDPU_P15',data=d
     imon_p15 = [imon_p15,d.y]



     get_data,'TMON_IDPU_LVPS',data=d
     tmon_lvps = [tmon_lvps,d.y]
     get_data,'TMON_IDPU_AXB5',data=d
     tmon_axb5 = [tmon_axb5,d.y]
     get_data,'TMON_IDPU_AXB6',data=d
     tmon_axb6 = [tmon_axb6,d.y]
     get_data,'TMON_IDPU_FPGA',data=d
     tmon_fpga = [tmon_fpga,d.y]

     get_data,'VMON_BEB_P10VA',data=d
     vmon_p10va_b = [vmon_p10va_b,d.y]
     get_data,'VMON_IDPU_P33VD',data=d
     vmon_p33vd_i = [vmon_p33vd_i,d.y]
     get_data,'VMON_IDPU_P10VA',data=d
     vmon_p10va_i = [vmon_p10va_i,d.y]
     get_data,'VMON_IDPU_P15VD',data=d
     vmon_p15vd_i = [vmon_p15vd_i,d.y]
     get_data,'VMON_BEB_P5VA',data=d
     vmon_p5va_b = [vmon_p5va_b,d.y]
     get_data,'VMON_IDPU_P5VA',data=d
     vmon_p5va_i = [vmon_p5va_i,d.y]
     get_data,'VMON_BEB_P5VD',data=d
     vmon_p5vd_b = [vmon_p5vd_b,d.y]
     get_data,'VMON_IDPU_P5VD',data=d
     vmon_p5vd_i = [vmon_p5vd_i,d.y]
     get_data,'VMON_BEB_N10VA',data=d
     vmon_n10va_b = [vmon_n10va_b,d.y]
     get_data,'VMON_IDPU_N10VA',data=d
     vmon_n10va_i = [vmon_n10va_i,d.y]
     get_data,'VMON_IDPU_N5VA',data=d
     vmon_n5va = [vmon_n5va,d.y]
     get_data,'VMON_IDPU_P36VD',data=d
     vmon_p36vd = [vmon_p36vd,d.y]
     get_data,'VMON_IDPU_P18VD',data=d
     vmon_p18vd = [vmon_p18vd,d.y]



     get_data,'SSR_FILLPER',data=d
     ssr_fillper = [ssr_fillper,d.y]
     get_data,'B1_EVALMAX',data=d
     b1_evalmax = [b1_evalmax,d.y]
     get_data,'B1_PLAYREQ',data=d
     b1_playreq = [b1_playreq,d.y]
     get_data,'B1_RECBBI',data=d
     b1_recbbi = [b1_recbbi,d.y]
     get_data,'B1_RECECI',data=d
     b1_receci = [b1_receci,d.y]
     get_data,'B1_THRESH',data=d
     b1_thresh = [b1_thresh,d.y]
     get_data,'B2_THRESH',data=d
     b2_thresh = [b2_thresh,d.y]
     get_data,'B2_RECSTATE',data=d
     b2_recstate = [b2_recstate,d.y]
     get_data,'B2_EVALMAX',data=d
     b2_evalmax = [b2_evalmax,d.y]
     get_data,'IO_ECCSING',data=d
     eccsing = [eccsing,d.y]
     get_data,'IO_ECCMULT',data=d
     eccmult = [eccmult,d.y]
     get_data,'RSTCTR',data=d
     rstctr = [rstctr,d.y]
     get_data,'RSTFLAG',data=d
     rstflag = [rstflag,d.y]


     get_data,'eclipse',data=d
     eclipse = [eclipse,d.y]
     get_data,'auto_bias',data=d
     auto_bias = [auto_bias,d.y]
     get_data,'bias_sweep',data=d
     bias_sweep = [bias_sweep,d.y]
     get_data,'ant_deploy',data=d
     ant_deploy = [ant_deploy,d.y]
     get_data,'maneuver',data=d
     maneuver = [maneuver,d.y]
     get_data,'bias_current',data=d
     ibias = [ibias,d.y]


     store_data,tnames(),/delete


  endfor


;Remove the zeroth element
  n = n_elements(t)-1

  t = t[1:n]
  imon_beb = imon_beb[1:n]
  imon_idpu = imon_idpu[1:n]
  imon_p33 = imon_p33[1:n]
  imon_p15 = imon_p15[1:n]
  tmon_lvps = tmon_lvps[1:n]
  tmon_fpga = tmon_fpga[1:n]
  tmon_axb5 = tmon_axb5[1:n]
  tmon_axb6 = tmon_axb6[1:n]
  imon_fvx = imon_fvx[1:n]
  imon_fvy = imon_fvy[1:n]
  imon_fvz = imon_fvz[1:n]
  ssr_fillper = ssr_fillper[1:n]
  b1_evalmax = b1_evalmax[1:n]
  b1_playreq = b1_playreq[1:n]
  b1_recbbi = b1_recbbi[1:n]
  b1_receci = b1_receci[1:n]
  b1_thresh = b1_thresh[1:n]
  b2_thresh = b2_thresh[1:n]
  b2_recstate = b2_recstate[1:n]
  b2_evalmax = b2_evalmax[1:n]
  eccsing = eccsing[1:n]
  eccmult = eccmult[1:n]
  rstctr = rstctr[1:n]
  rstflag = rstflag[1:n]

  vmon_p10va_b = vmon_p10va_b[1:n]
  vmon_p33vd_i = vmon_p33vd_i[1:n]
  vmon_p10va_i = vmon_p10va_i[1:n]
  vmon_p15vd_i = vmon_p15vd_i[1:n]
  vmon_p5va_b = vmon_p5va_b[1:n]
  vmon_p5va_i = vmon_p5va_i[1:n]
  vmon_p5vd_b = vmon_p5vd_b[1:n]
  vmon_p5vd_i = vmon_p5vd_i[1:n]
  vmon_n10va_b = vmon_n10va_b[1:n]
  vmon_n10va_i = vmon_n10va_i[1:n]
  vmon_n5va = vmon_n5va[1:n]
  vmon_p36vd = vmon_p36vd[1:n]
  vmon_p18vd = vmon_p18vd[1:n]

  eclipse = eclipse[1:n]
  auto_bias = auto_bias[1:n]
  bias_sweep = bias_sweep[1:n]
  ant_deploy = ant_deploy[1:n]
  maneuver = maneuver[1:n]
  ibias = ibias[1:n,*]






;******************************************
;Test out the variables

  store_data,'IMON_IDPU_BEB',data={x:t,y:imon_beb}
  store_data,'IMON_IDPU_IDPU',data={x:t,y:imon_idpu}
  store_data,'IMON_IDPU_FVX',data={x:t,y:imon_fvx}
  store_data,'IMON_IDPU_FVY',data={x:t,y:imon_fvy}
  store_data,'IMON_IDPU_FVZ',data={x:t,y:imon_fvz}
  store_data,'IMON_IDPU_P15',data={x:t,y:imon_p15}
  store_data,'IMON_IDPU_P33',data={x:t,y:imon_p33}

  store_data,'TMON_IDPU_LVPS',data={x:t,y:tmon_lvps}
  store_data,'TMON_IDPU_AXB5',data={x:t,y:tmon_axb5}
  store_data,'TMON_IDPU_AXB6',data={x:t,y:tmon_axb6}
  store_data,'TMON_IDPU_FPGA',data={x:t,y:tmon_fpga}

  store_data,'VMON_BEB_P10VA',data={x:t,y:vmon_p10va_b}
  store_data,'VMON_IDPU_P33VD',data={x:t,y:vmon_p33vd_i}
  store_data,'VMON_IDPU_P10VA',data={x:t,y:vmon_p10va_i}
  store_data,'VMON_IDPU_P15VD',data={x:t,y:vmon_p15vd_i}
  store_data,'VMON_BEB_P5VA',data={x:t,y:vmon_p5va_b}
  store_data,'VMON_IDPU_P5VA',data={x:t,y:vmon_p5va_i}
  store_data,'VMON_BEB_P5VD',data={x:t,y:vmon_p5vd_b}
  store_data,'VMON_IDPU_P5VD',data={x:t,y:vmon_p5vd_i}
  store_data,'VMON_BEB_N10VA',data={x:t,y:vmon_n10va_b}
  store_data,'VMON_IDPU_N10VA',data={x:t,y:vmon_n10va_i}
  store_data,'VMON_IDPU_N5VA',data={x:t,y:vmon_n5va}
  store_data,'VMON_IDPU_P36VD',data={x:t,y:vmon_p36vd}
  store_data,'VMON_IDPU_P18VD',data={x:t,y:vmon_p18vd}

  store_data,'SSR_FILLPER',data={x:t,y:ssr_fillper}
  store_data,'B1_EVALMAX',data={x:t,y:b1_evalmax}
  store_data,'B1_PLAYREQ',data={x:t,y:b1_playreq}
  store_data,'B1_RECBBI',data={x:t,y:b1_recbbi}
  store_data,'B1_RECECI',data={x:t,y:b1_receci}
  store_data,'B1_THRESH',data={x:t,y:b1_thresh}
  store_data,'B2_THRESH',data={x:t,y:b2_thresh}
  store_data,'B2_RECSTATE',data={x:t,y:b2_recstate}
  store_data,'B2_EVALMAX',data={x:t,y:b2_evalmax}
  store_data,'IO_ECCSING',data={x:t,y:eccsing}
  store_data,'IO_ECCMULT',data={x:t,y:eccmult}
  store_data,'RSTCTR',data={x:t,y:rstctr}
  store_data,'RSTFLAG',data={x:t,y:rstflag}

  store_data,'eclipse',data={x:t,y:eclipse}
  store_data,'auto_bias',data={x:t,y:auto_bias}
  store_data,'bias_sweep',data={x:t,y:bias_sweep}
  store_data,'ant_deploy',data={x:t,y:ant_deploy}
  store_data,'maneuver',data={x:t,y:maneuver}
  store_data,'bias_current',data={x:t,y:ibias}




  tplot,'*'
  tlimit,days[0],days[n_elements(days)-1]
  stop
;******************************************



  epoch = tplot_time_to_epoch(t,/epoch16)


  skeleton = 'rbsp'+sc+'_hsk_00000000.cdf'
                                ;source_file='~/Desktop/code/Aaron/RBSP/l2_processing_cribs/' + skeleton
  source_file='~/Desktop/code/Aaron/RBSP/TDAS_trunk_svn/general/missions/rbsp/efw/l1_to_l2/' + skeleton

  filename = 'rbsp'+sc+'_hsk_'+days2[0]+'-'+days2[n_elements(days2)-1]+'.cdf'

  file_copy,source_file,path+filename,/overwrite

  cdfid = cdf_open(path+filename)
  cdf_control, cdfid, get_var_info=info, variable='epoch'


  cdf_varput,cdfid,'epoch',epoch


  cdf_varput,cdfid,'IMON_IDPU_BEB',imon_beb
  cdf_varput,cdfid,'IMON_IDPU_IDPU',imon_idpu
  cdf_varput,cdfid,'IMON_IDPU_FVX',imon_fvx
  cdf_varput,cdfid,'IMON_IDPU_FVY',imon_fvy
  cdf_varput,cdfid,'IMON_IDPU_FVZ',imon_fvz
  cdf_varput,cdfid,'IMON_IDPU_P15',imon_p15
  cdf_varput,cdfid,'IMON_IDPU_P33',imon_p33

  cdf_varput,cdfid,'TMON_IDPU_LVPS',tmon_lvps
  cdf_varput,cdfid,'TMON_IDPU_AXB5',tmon_axb5
  cdf_varput,cdfid,'TMON_IDPU_AXB6',tmon_axb6
  cdf_varput,cdfid,'TMON_IDPU_FPGA',tmon_fpga

  cdf_varput,cdfid,'VMON_BEB_P10VA',vmon_p10va_b
  cdf_varput,cdfid,'VMON_IDPU_P33VD',vmon_p33vd_i
  cdf_varput,cdfid,'VMON_IDPU_P10VA',vmon_p10va_i
  cdf_varput,cdfid,'VMON_IDPU_P15VD',vmon_p15vd_i
  cdf_varput,cdfid,'VMON_BEB_P5VA',vmon_p5va_b
  cdf_varput,cdfid,'VMON_IDPU_P5VA',vmon_p5va_i
  cdf_varput,cdfid,'VMON_BEB_P5VD',vmon_p5vd_b
  cdf_varput,cdfid,'VMON_IDPU_P5VD',vmon_p5vd_i
  cdf_varput,cdfid,'VMON_BEB_N10VA',vmon_n10va_b
  cdf_varput,cdfid,'VMON_IDPU_N10VA',vmon_n10va_i
  cdf_varput,cdfid,'VMON_IDPU_N5VA',vmon_n5va
  cdf_varput,cdfid,'VMON_IDPU_P36VD',vmon_p36vd
  cdf_varput,cdfid,'VMON_IDPU_P18VD',vmon_p18vd

  cdf_varput,cdfid,'SSR_FILLPER',ssr_fillper
  cdf_varput,cdfid,'B1_EVALMAX',b1_evalmax
  cdf_varput,cdfid,'B1_PLAYREQ',b1_playreq
  cdf_varput,cdfid,'B1_RECBBI',b1_recbbi
  cdf_varput,cdfid,'B1_RECECI',b1_receci
  cdf_varput,cdfid,'B1_THRESH',b1_thresh
  cdf_varput,cdfid,'B2_THRESH',b2_thresh
  cdf_varput,cdfid,'B2_RECSTATE',b2_recstate
  cdf_varput,cdfid,'B2_EVALMAX',b2_evalmax
  cdf_varput,cdfid,'IO_ECCSING',eccsing
  cdf_varput,cdfid,'IO_ECCMULT',eccmult
  cdf_varput,cdfid,'RSTCTR',rstctr
  cdf_varput,cdfid,'RSTFLAG',rstflag

  cdf_varput,cdfid,'eclipse',eclipse
  cdf_varput,cdfid,'auto_bias',auto_bias
  cdf_varput,cdfid,'bias_sweep',bias_sweep
  cdf_varput,cdfid,'ant_deploy',ant_deploy
  cdf_varput,cdfid,'maneuver',maneuver
  cdf_varput,cdfid,'bias_current',transpose(ibias)


  cdf_close, cdfid



  stop


  store_data,tnames(),/delete


;  cdf2tplot,files = path + filename


end

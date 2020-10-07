;Splits up long RBSP burst files to manageable chunks.
;Outputs a number of CDF files with the burst UVW data

;After they're split you can run rbsp_uvw_to_mgse_burstfiles.pro to
;rotate each chunk into MGSE.

;Called with call_rbsp_uvw_to_mgse_burstfiles.py


;Written by Aaron W Breneman, July, 2017


pro rbsp_split_burst_cdf

	args = command_line_args()

	date = args[0]
	probe = args[1]
	type = args[2]
	bt = args[3]
	chunksz = float(args[4])


	print,'date = '+date
	print,'type = '+type
	print,'bt = '+bt
	print,'chunksz = ', chunksz
	help,chunksz

	openw,lun,'outfiles_tmp.txt',/get_lun
	printf,lun,date
	printf,lun,probe
	if type eq 'mscb' then printf,lun,'mscb'+bt
	if type eq 'eb' or type eq 'vb'+bt then printf,lun,'eb'+bt
	close,lun
	free_lun,lun

	rbsp_efw_init


	;Where the output cdf file will be saved
	outputfolder = '~/Desktop/'

	timespan,date

	rbspx = 'rbsp'+probe



	;set size of each output burst file in seconds
	;The entire day will be divided up into "nticks" of this size
	nticks = 86400/chunksz
	tticks = time_double(date) + indgen(nticks)*chunksz

	;Load the UVW burst data
	rbsp_load_efw_waveform_partial,probe=probe,type='calibrated',datatype=[type+bt]


	if type eq 'eb' then tplot_rename,rbspx+'_efw_eb'+bt,rbspx+'_efw_eb'+bt+'_uvw'
	if type eq 'mscb' then tplot_rename,rbspx+'_efw_mscb'+bt,rbspx+'_efw_mscb'+bt+'_uvw'
	;Create the Efield variable from single-ended potentials
	if type eq 'vb' then begin 	;Create E-field variables (mV/m)

		trange = timerange()
		;print,time_string(trange)
		cp0 = rbsp_efw_get_cal_params(trange[0])
		if probe eq 'a' then cp = cp0.a else cp = cp0.b


		boom_length = cp.boom_length
		boom_shorting_factor = cp.boom_shorting_factor

		get_data,rbspx+'_efw_vb'+bt,data=dd
		e12 = 1000.*(dd.y[*,0]-dd.y[*,1])/boom_length[0]
		e34 = 1000.*(dd.y[*,2]-dd.y[*,3])/boom_length[1]
		e56 = 1000.*(dd.y[*,4]-dd.y[*,5])/boom_length[2]

		eb = [[e12],[e34],[e56]]
		store_data,rbspx+'_efw_eb'+bt+'_uvw',data={x:dd.x,y:eb}

		;From now on the type is switch to 'eb'
		type = 'eb'
	endif



	;variable the time tags come from
	timevar = rbspx+'_efw_'+type+bt+'_uvw'
	get_data,timevar,times,data


	skeleton = 'rbsp_skeleton_00000000.cdf'
	source_file = '/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/rbsp-long-duration-cdfs/' + skeleton


	;open the skeleton cdf file
	;filename = 'rbsp_skeleton_'+strjoin(strsplit(date,'-',/extract))+'.cdf'
	filename2 = rbspx+'_'+type+bt+'_'+strjoin(strsplit(date,'-',/extract))
	;filenames = strarr(n_elements(tticks)-1)


	;Extract the data in each chunk and place in its own CDF file
	for i=0L,n_elements(tticks)-2 do begin

		goo = where((times ge tticks[i]) and (times lt tticks[i+1]))
		if goo[0] ne -1 then begin
			ttmp = times[goo]
			dattmp = data[goo,*]
			epoch = tplot_time_to_epoch(ttmp,/epoch16)
			t0 = time_string(tticks[i],tformat="hhmmss")
			t1 = time_string(tticks[i+1],tformat="hhmmss")

			;Copy the skeleton CDF file and rename
			file_copy,source_file,outputfolder+filename2+'_'+t0+'-'+t1 + '_uvw.cdf',/overwrite
			cdfid = cdf_open(outputfolder+filename2+'_'+t0+'-'+t1 + '_uvw.cdf')
			pathandfile = outputfolder+filename2+'_'+t0+'-'+t1 + '_uvw.cdf'

			print,'**********'
			print,'**********'
			print,'**********'
			print,pathandfile
			print,'**********'
			print,'**********'
			print,'**********'

;			cdf_control, cdfid, get_var_info=info, variable='epoch'


			;place data into cdf file
			cdf_varput,cdfid,'epoch',epoch
			cdf_varput,cdfid,'var1_3d_timeseries',transpose(dattmp)
			cdf_varrename,cdfid,'var1_3d_timeseries',rbspx+'_efw_'+type+bt+'_uvw'

			;delete unused variables
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


			;Write the names of the output files to a file so I can read this in with
			;Python script.

			openw,lun,'outfiles_tmp.txt',/get_lun,/append
			printf,lun,pathandfile
			close,lun
			free_lun,lun


		endif
	endfor
end

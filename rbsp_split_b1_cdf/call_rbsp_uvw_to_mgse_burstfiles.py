#! /usr/bin/env python


#use to call rbsp_split_burst_cdf.pro and rbsp_uvw_to_mgse_burstfiles.pro.
#These programs split up large EFW burst files into manageable chunks and then
#rotate them to MGSE coord.



import subprocess


dates = ['2017-06-13','2017-06-20','2017-06-23','2017-07-01','2017-07-02','2017-07-04','2017-07-10','2017-07-11']
probes = ['a','b']
types = ['mscb','vb']
bt = '1'
chunksz = 60*5.


for d in dates:
    for p in probes:
        for t in types:
            print '*************CURRENT LOOP ELEMENT***************'
            print 'DATE = ' + d
            print 'PROBE = ' + p
            print 'TYPE = ' + t

            exit_code = subprocess.call(['/Applications/exelis/idl84/bin/idl','-e',
            'rbsp_split_burst_cdf','-args','%s'%d,'%s'%p,'%s'%t,'%s'%bt,'%f'%chunksz])


            f = open('outfiles_tmp.txt','r')
            vals  = f.read()
            vals = vals.split("\n")
            date = vals[0]
            probe = vals[1]
            typee = vals[2]
            f.close()

            for y in range(3,len(vals)-1):
                print y
                fn = vals[y]
                exit_code = subprocess.call(['/Applications/exelis/idl84/bin/idl','-e',
                'rbsp_uvw_to_mgse_burstfiles','-args','%s'%fn,'%s'%date,'%s'%probe,'%s'%typee])

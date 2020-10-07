#!/opt/local/bin/python2.7
#
# Usage:
#
# Note: that steps 1 - 3 have already been completed for vb1 and mscb1 file types.
#
# Note: SpacePy and all its dependencies need to be installed.
#
#
# 1) Create a skeleton table from the source CDF:
#
# $ skeletontable -skeleton rbspa_l1_vb1 -values nrv rbspa_l1_vb1_20171121_v02
#
# 2) Edit the skeleton table and remove all RV variables except vb1
#    and epoch (in this example). Ensure that all DEPEND_XX variables
#    still exist. Also be sure to update the filename and number-of-
#    variables fields.
#
# 3) Create an empty CDF from the skeleton file. This will be used as
#    a template for the split files.
#
# $ skeletoncdf rbspa_l1_vb1.skt
#
# 3a) Ensure the template CDF name is correct. For VB1 and MSCB1
#     files, the names should be "rbspa_l1_vb1" and "rbspa_l1_mscb1",
#     respectively. The spacecraft name isn't critical as long as it's
#     valid (rbspa | rbspb).
#
# 4) Run the splitting script
#
# $ ./cdf_split.py rbspa_l1_vb1_20171121_v02.cdf
#
# [...output...]
#
# A directory called ./out will be created to hold the resultant
# files. Each file will have the first record's epoch appended to its
# name.
#
# jjl 2018/02/07
# josh@codeposse.com
#

import argparse
import sys
import os
import re

from bisect import bisect_left
from datetime import datetime, timedelta
from spacepy import pycdf


def validate_span(value):
    ival = int(value)
    if ival <= 10:
        raise argparse.ArgumentTypeError("value must be greater than 10")
    return ival


def validate_date(value):
    try:
        datetime.strptime(value, "%H:%M:%S")
    except ValueError:
        msg = "Not a valid date: '{}'".format(value)
        raise argparse.ArgumentTypeError(msg)

    return value



def parse_cmdline():
    parser = argparse.ArgumentParser(description="Split VB1 and MSCB1 CDF files.")

    parser.add_argument("--span", default=600, type=validate_span,
                        help="time span of each split CDF, in seconds. default 600.")

    parser.add_argument("--starttime", default=None, type=validate_date,
                        help="time from which to start. "
                        "default is the first record. "
                        "format='HH:MM:SS'")

    parser.add_argument("--endtime", default=None, type=validate_date,
                        help="end time. default is the epoch of the last record. "
                        "format='HH:MM:SS'")

    parser.add_argument("cdf", metavar="CDF_FILE", nargs=1,
                        help="CDF file to split")

    return parser.parse_args()


def get_instrument_name(filename):
    # pick out the data product type from the filename
    # "rbspa_l1_mscb1_20171121_v02.cdf"
    m = re.search("rbsp[ab]{1}_l1_([a-zA-Z0-9]+)_[0-9]{8}_v[0-9]{2}.cdf", filename)
    if not m:
        raise RuntimeError("bad filename format. "
                           "must match rbsp[ab]_l1_INST_YYYYMMDD_vNN.cdf. "
                           "e.g. rbspa_l1_mscb1_20171121_v02.cdf")

    return m.group(1)


def get_file_date(filename):
    # pick out the date from the filename
    # "rbspa_l1_mscb1_20171121_v02.cdf"
    m = re.search("rbsp[ab]{1}_l1_[a-zA-Z0-9]+_([0-9]{4})([0-9]{2})([0-9]{2})_v[0-9]{2}.cdf", filename)
    if not m:
        raise RuntimeError("bad filename format. "
                           "must match rbsp[ab]_l1_INST_YYYYMMDD_vNN.cdf. "
                           "e.g. rbspa_l1_mscb1_20171121_v02.cdf")

    return m.group(1) + "-" + m.group(2) + "-" + m.group(3)


# XXX put these values in a data structure.
def get_data_var_names(filename):
    inst = get_instrument_name(filename)

    if inst == "vb1":
        return ("epoch", "vb1")
    elif inst == "mscb1":
        return ("epoch", "mscb1")

    raise RuntimeError("unknown instrument name")


# XXX put these values in a data structure.
def get_template_filename(filename):
    inst = get_instrument_name(filename)

    if inst == "vb1":
        return "rbspa_l1_vb1.cdf"
    elif inst == "mscb1":
        return "rbspa_l1_mscb1.cdf"

    raise RuntimeError("unknown instrument name")



if __name__ == '__main__':
    pycdf.lib.set_backward(False)


    # parse the command line arguments
    args = parse_cmdline()

    # ascertain the span and input file
    infile = args.cdf[0]
    span = int(args.span)

    # find the appropriate variable names for the given file...
    (epoch_var, data_var) = get_data_var_names(infile)

    # ...and the template CDF for this file type.
    template_filename = get_template_filename(infile)

    # open the input CDF
    input_cdf = pycdf.CDF(infile)

    # get the number of records
    nrecs = len(input_cdf[epoch_var])

    # get the file date. we'll need this to search for epochs
    filedate = get_file_date(infile)

    print "CDF epoch[0]: " + str(input_cdf[epoch_var][0])

    # find begin_rec from starttime, if provided
    begin_rec = 0
    if args.starttime:
        starttime = datetime.strptime(filedate + " " + args.starttime,
                                      "%Y-%m-%d %H:%M:%S")
        begin_rec = bisect_left(input_cdf[epoch_var], starttime, lo=0)

        print "Start time: " + str(starttime)

    # get endtime as a datetime
    endtime = None
    if args.endtime:
        endtime = datetime.strptime(filedate + " " + args.endtime,
                                    "%Y-%m-%d %H:%M:%S")
        print "End time: " + str(endtime)


    print "input cdf has {} records".format(nrecs)
    print "---"



    while begin_rec < nrecs:
        # grab the epoch of the first record in this chunk
        begin_epoch = input_cdf[epoch_var][begin_rec]

        # calculate the end epoch for this chunk. use the span unless
        # the resulting epoch is greater than the endtime provided, if
        # any.
        end_epoch = begin_epoch + timedelta(seconds=span)
        if endtime and end_epoch > endtime:
            end_epoch = endtime

        # exit if we're done
        if begin_epoch >= end_epoch:
            break

        # find the record for the calculated end epoch
        end_rec = bisect_left(input_cdf[epoch_var], end_epoch, lo=begin_rec)

        print "begin_epoch: {}".format(begin_epoch)
        print "end_epoch:   {} (calculated)".format(end_epoch)
        print "end_epoch:   {} (record)".format(input_cdf[epoch_var][end_rec - 1])
        print "begin_rec:   {}".format(begin_rec)
        print "end_rec:     {}".format(end_rec)

        # build the output filename for this chunk.
        filename = os.path.splitext(os.path.basename(infile))[0]
        filename = "out/{}_{:02}:{:02}:{:02}.cdf".format(filename,
                                                         begin_epoch.hour,
                                                         begin_epoch.minute,
                                                         begin_epoch.second)

        print filename

        if not os.path.exists("out"):
            os.makedirs("out")

        # open the output CDF using the template
        output_cdf = pycdf.CDF(filename, template_filename)

        output_cdf.readonly(False)
        output_cdf.compress(pycdf.const.NO_COMPRESSION, 0)

        # finally, copy the records
        output_cdf[epoch_var] = input_cdf[epoch_var][begin_rec:end_rec]
        output_cdf[data_var] = input_cdf[data_var][begin_rec:end_rec]

        print "wrote {} {} records".format(len(output_cdf[epoch_var]), epoch_var)
        print "wrote {} {} records".format(len(output_cdf[data_var]), data_var)

        output_cdf.close()

        print "---"

        # move the begin_rec pointer to the next chunk.
        begin_rec = end_rec

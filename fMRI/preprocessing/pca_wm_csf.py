#!/usr/bin/python

"""
Check for motion outliers

This script checks for motion outliers in the specified bold fmri files and outputs
a cofound.txt file that can be used for motion scrubbing when modelling the data. If no motion outliers
are detected, the outputed confound.txt should be empty.

The script takes three arguments:

    * participant code (-s, e.g. "SF1")
    * scanning session (-t, e.g "pre", "post" or "postpost")
    * scan type (-f, e.g. "bodyloc", "rest" or "block")

The script looks for the bold files in /vols/Data/soma/6Finger/{participant code}/{scaning session}/func
folder.
"""

import glob
import os
import sys
from optparse import OptionParser

parser = OptionParser(description="Check for motion outliers")
parser.add_option("-s", "--subj", dest="subj", action="store", metavar="SUBJ")
parser.add_option("-t", "--time", dest="session", action="store", metavar="SESSION")
parser.add_option("-f", "--type", dest="type", action="store", metavar="TYPE")
    
(options, args) = parser.parse_args()

path = '/vols/Data/soma/6Finger/%s/%s'%(options.subj, options.session)
if type == "rest":
    bold_files = glob.glob('%s/func/%s_%s_rest.nii.gz'%(path, options.subj, options.session))
elif type == "bodyloc":
    bold_files = glob.glob('%s/func/%s_%s_bodyloc.nii.gz'%(path, options.subj, options.session))
else:
    bold_files = glob.glob('%s/func/%s_%s_block[1-4].nii.gz'%(path, options.subj, options.session))

for bold in list(bold_files):
    print(bold)
    out_dir = os.path.dirname(bold)
    # strip off .nii.gz from file name
    bold_name = bold.split('/')[-1][:-7]

    # Assessing motion
    if os.path.isdir("%s/motion_assess/"%(out_dir))==False:
        os.system("mkdir %s/motion_assess"%(out_dir))
    os.system("fsl_motion_outliers -i %s -o %s/motion_assess/confound_%s.txt --fd --thresh=0.9 -p %s/motion_assess/fd_plot_%s -v > %s/motion_assess/outlier_output_%s.txt"%(bold, out_dir, bold_name, out_dir, bold_name, out_dir, bold_name))

    # If no motion scrubbing is needed, create an empty file
    if os.path.isfile("%s/motion_assess/confound_%s.txt"%(out_dir, bold_name))==False:
      os.system("touch %s/motion_assess/confound_%s.txt"%(out_dir, bold_name))





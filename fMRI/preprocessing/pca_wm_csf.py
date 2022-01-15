#!/usr/bin/python

"""
Extract principal components of the WM and CSF signals

This script calculates the first five eigenvectors of unsmoothed resting state time series underlying the WM and CSF masks.
"""

import numpy as np
import pandas as pd
from scipy import signal
import nipype
import nipype.algorithms.confounds as pca

subjects=['SF1', 'SF2', 'SF3', 'SF4', 'SF5', 'SF6', 'SF7', 'SF8', 'SF11', 'SF12', 'SF13', 'SF14', 'SF15', 'SF16', 'SF17', 'SF19', 'SF21', 'SF22', 'SF23', 'SF24']
sessions=['pre', 'post']

# White matter
for sub in subjects:

    for ses in sessions:
    
    wma = pca.CompCor()
    wma.inputs.realigned_file = '/vols/Data/soma/6Finger/{}/{}/model/rest-init.feat/filtered_func_data.nii.gz'.format(sub,ses)
    wma.inputs.mask_files = '/vols/Data/soma/6Finger/{}/masks/WMmask_rest_bin.nii.gz'.format(sub)
    wma.inputs.num_components = 5
    wma.inputs.pre_filter = 'polynomial'
    wma.inputs.regress_poly_degree = 2
    wma.inputs.components_file = '/vols/Data/soma/6Finger/{}/{}/masks/{}_{}_WM_compcor.txt'.format(sub,ses,sub,ses)
    wma.run()

# Cerebrospinal fluid
for sub in subjects:

    for ses in sessions:
    
        cma = pca.CompCor()
        cma.inputs.realigned_file = '/vols/Data/soma/6Finger/{}/{}/model/rest-init.feat/filtered_func_data.nii.gz'.format(sub,ses)
        cma.inputs.mask_files = '/vols/Data/soma/6Finger/{}/masks/CSFmask_rest_bin.nii.gz'.format(sub)
        cma.inputs.num_components = 5
        cma.inputs.pre_filter = 'polynomial'
        cma.inputs.regress_poly_degree = 2
        cma.inputs.components_file = '/vols/Data/soma/6Finger/{}/{}/masks/{}_{}_CSF_compcor.txt'.format(sub,ses,sub,ses)
        cma.run()

#!/bin/bash
#%
#% Performs segmentation (FAST) of T1w images to WM, GM and CSF. Thresholds, binarises and
#% erodes the masks. Registers the created masks to the resting state space of the same
#% participant and susequently re-thresholds and re-binarises them.
#%
#% Takes the participant codes as the arguments, works with the Third Thumb study format.
#%
#=======================================================================================
#% USAGE
#% batch-fast [-h] [participant codes]
#%
#% EXAMPLE
#% batch-fast SF1 SF3 SF11 SF15
#%
#% PREREQUISITES
#% T1w images have to be pre-registered to the anatomical midspace
#% Transformations between the anatomical and rest midspaces have to be pre-calculated
#%
#=======================================================================================
# END_OF_HEADER
#=======================================================================================

# Printing help function
function usage() {
  HEADSIZE=$(head -200 "${0}" | grep -n "^# END_OF_HEADER" | cut -f1 -d:)
  head -"${HEADSIZE}" "${0}" | grep -e "^#%" | sed -e "s/^#%//g"
  exit 0
}

[ $# -lt 1 ] && usage && exit 1
[[ $1 == "-h" ]] && usage && exit 1

subjects=$@

cd /vols/Data/soma/6Finger
echo $subjects

for sub in $subjects; do
    cd "${sub}"
    pwd
		cd pre/anat

		if [ ! -f "${sub}"_pre_T1w_to_midsp_brain_pve_2.nii.gz ]; then
			echo "running FAST"
			fast "${sub}"_pre_T1w_to_midsp_brain.nii.gz
		fi

		cd ../../masks

		if [ ! -f WMmask_thr_ero.nii.gz ]; then
			cp ../pre/anat/"${sub}"_pre_T1w_to_midsp_brain_pve_0.nii.gz CSFmask_raw.nii.gz
			cp ../pre/anat/"${sub}"_pre_T1w_to_midsp_brain_pve_2.nii.gz WMmask_raw.nii.gz

			echo "Eroding"
			fslmaths WMmask_raw.nii.gz -thr 1 -bin -ero WMmask_thr_ero.nii.gz
			fslmaths CSFmask_raw.nii.gz -thr 1 -bin -ero CSFmask_thr_ero.nii.gz
		fi

		if [ ! -f CSF_mask_rest_bin.nii.gz ]; then
			echo "Registering to rest"
			flirt -in WMmask_thr_ero.nii.gz -ref ../coreg/restMidspace.nii.gz -applyxfm -init ../pre/model/rest-init.feat/reg/highres2example_func.mat -out WMmask_rest.nii.gz
			flirt -in CSFmask_thr_ero.nii.gz -ref ../coreg/restMidspace.nii.gz -applyxfm -init ../pre/model/rest-init.feat/reg/highres2example_func.mat -out CSFmask_rest.nii.gz

			fslmaths WMmask_rest.nii.gz -thr 0.3 -bin WMmask_rest_bin.nii.gz
			fslmaths CSFmask_rest.nii.gz -thr 0.3 -bin CSFmask_rest_bin.nii.gz
		fi

		cd ../..

done

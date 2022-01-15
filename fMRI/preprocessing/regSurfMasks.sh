
#!/bin/bash
#%
#% Registers (bilaterly - both hemispeheres) anatomical freesurfer masks (currently set up
#% to work with the Third Thumb study) to anatomical/functional space of a given participant.
#% Output files are saved inside subj/masks subfolder in the specified [output_directory].
#%
#=======================================================================================
#% USAGE
#% regSurfMasks [-h] -f -a [subj_code] [mask_name] [output_directory]
#%
#% OPTIONS
#% -h		Print this help
#% -f		Register masks to functional space (default: no)
#% -a 	    Register masks to anatomical space (default: yes IF -f not used)
#%
#% EXAMPLES
#% regSurfMasks SF15 M1 /vols/Data/soma/6Finger/beyond 	# (to anatomical)
#%				outputs /vols/Data/soma/6Finger/beyond/SF15/masks/M1amask_?H_highres.nii.gz
#% regSurfMasks -a SF3 S1 /vols/Data/soma/6Finger 	# (to anatomical)
#%				outputs /vols/Data/soma/6Finger/SF3/masks/S1mask_?H_highres.nii.gz
#% regSurfMasks -f SF2 S1 /vols/Data/soma/6Finger	# (to functional)
#%				outputs /vols/Data/soma/6Finger/SF2/masks/S1mask_?H.nii.gz
#% regSurfMasks -a -f SMA /vols/Data/soma/6Finger/beyond	# (to functional and anatomical)
#=======================================================================================
# END_OF_HEADER
#=======================================================================================

# Printing help function
function usage() {
  HEADSIZE=$(head -200 "${0}" | grep -n "^# END_OF_HEADER" | cut -f1 -d:)
  head -"${HEADSIZE}" "${0}" | grep -e "^#%" | sed -e "s/^#%//g"
  exit 0
}

[ $# -lt 2 ] && usage && exit 1
[[ $1 == "-h" ]] && usage && exit 1

anatFlag=0
funcFlag=0

firstchar=`echo "${1}" | head -c 1` # check for passed options

while [[ "${firstchar}" == "-" ]]; do
  if [[ "${1}" == -h ]]; then
    usage
    shift 1
  fi
  if [[ "${1}" == -a ]]; then
    anatFlag=1
    shift 1
  fi
  if [[ "${1}" == -f ]]; then
    funcFlag=1
    shift 1
  fi
  firstchar=`echo "${1}" | head -c 1`
done

subj=$1
mask=$2
outDir=$3

if [[ "${anatFlag}" -eq 0 && "${funcFlag}" -eq 0 ]]; then
  anatFlag=1
fi


# Handle the exception case for SF6 - participant without valid pre-struct image
if [[ "${subj}" == "SF6" ]]; then
  ses=post
  anatFile="${subj}"_"${ses}"_T1w.nii.gz
else
  ses=pre
  anatFile="${subj}"_"${ses}"_T1w_to_midsp.nii.gz
fi

# Register orig.nii.gz to highres used in feat
if [[ ! -f /vols/Data/soma/6Finger/surf/"${subj}"/gifti/orig2highres.mat ]]; then
  flirt -in /vols/Data/soma/6Finger/surf/"${subj}"/gifti/orig.nii.gz -ref /vols/Data/soma/6Finger/"${subj}"/"${ses}"/anat/"${anatFile}" -out /vols/Data/soma/6Finger/surf/"${subj}"/gifti/orig2highres.nii.gz -omat /vols/Data/soma/6Finger/surf/"${subj}"/gifti/orig2highres.mat
fi

# Register masks to anat space
if [[ "${anatFlag}" -eq 1 ]]; then
  fsl_sub -q veryshort.q flirt -in /vols/Data/soma/6Finger/surf/"${subj}"/gifti/Volume/"${subj}"."${mask}".LHemi.nii.gz -ref /vols/Data/soma/6Finger/"${subj}"/"${ses}"/model/rsa-reg/highres.nii.gz -applyxfm -init /vols/Data/soma/6Finger/surf/"${subj}"/gifti/orig2highres.mat -out "${outDir}"/"${subj}"/masks/"${mask}"mask_LHemi_highres.nii.gz
  fsl_sub -q veryshort.q flirt -in /vols/Data/soma/6Finger/surf/"${subj}"/gifti/Volume/"${subj}"."${mask}".RHemi.nii.gz -ref /vols/Data/soma/6Finger/"${subj}"/"${ses}"/model/rsa-reg/highres.nii.gz -applyxfm -init /vols/Data/soma/6Finger/surf/"${subj}"/gifti/orig2highres.mat -out "${outDir}"/"${subj}"/masks/"${mask}"mask_RHemi_highres.nii.gz
fi

# Register masks to func space
if [[ "${funcFlag}" -eq 1 ]]; then
  if [[ ! -f /vols/Data/soma/6Finger/surf/"${subj}"/gifti/orig2func.mat ]]; then
    convert_xfm -omat /vols/Data/soma/6Finger/surf/"${subj}"/gifti/orig2func.mat -concat /vols/Data/soma/6Finger/"${subj}"/"${ses}"/model/rsa-reg/highres2example_func.mat /vols/Data/soma/6Finger/surf/"${subj}"/gifti/orig2highres.mat
  fi
  fsl_sub -q veryshort.q flirt -in /vols/Data/soma/6Finger/surf/"${subj}"/gifti/Volume/"${subj}"."${mask}".LHemi.nii.gz -ref /vols/Data/soma/6Finger/"${subj}"/"${ses}"/model/rsa-reg/example_func.nii.gz -applyxfm -init /vols/Data/soma/6Finger/surf/"${subj}"/gifti/orig2func.mat -out "${outDir}"/"${subj}"/masks/"${mask}"mask_LHemi.nii.gz
  fsl_sub -q veryshort.q flirt -in /vols/Data/soma/6Finger/surf/"${subj}"/gifti/Volume/"${subj}"."${mask}".RHemi.nii.gz -ref /vols/Data/soma/6Finger/"${subj}"/"${ses}"/model/rsa-reg/example_func.nii.gz -applyxfm -init /vols/Data/soma/6Finger/surf/"${subj}"/gifti/orig2func.mat -out "${outDir}"/"${subj}"/masks/"${mask}"mask_RHemi.nii.gz
fi

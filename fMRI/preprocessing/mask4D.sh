
#!/bin/bash
#%
#% Registers given masks FROM THE STRUCTURAL to STANDARD SPACE and concatenates
#% them into a single 4D file to facilitate inspection. The individual standard space
#% masks are deleted. The script is made to work with the architecture of the 6Finger folder
#% i.e. it reads existing highres2standard_warp files from 6Finger/pre/<subj_code>/model/rsa-reg/
#%
#=======================================================================================
#% USAGE
#% mask4D [-h] [-o output_file] [mask_files]
#%
#% OPTIONS
#% -h		Print this help
#% -o   Name of the output 4D file (default mask4d.nii.gz)
#%
#% EXAMPLES
#% mask4D -o masks/S1_LH_4D.nii.gz SF1/masks/S1mask_LH_highres.nii.gz SF2/masks/S1mask_LH.nii.gz
#%				outputs /vols/Data/soma/6Finger/masks/S1_LH_4D.nii.gz
#% mask4D -o beyond/S1_LH_4D.nii.gz /vols/Data/soma/6Finger/beyond/SF*/masks/S1mask_LH_highres*
#%				outputs /vols/Data/soma/6Finger/beyond/S1_LH_4D.nii.gz
#% mask4D /vols/Data/soma/6Finger/beyond/SF*/masks/S1mask_LH*
#%				outputs /vols/Data/soma/6Finger/mask4d.nii.gz
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

[ $# -lt 2 ] && usage && exit 1

outFile=mask4d.nii.gz
firstchar=`echo "${1}" | head -c 1` # check for passed options

while [[ "${firstchar}" == "-" ]]; do
  if [[ "${1}" == -h ]]; then
    usage
    shift 1
  fi
  if [[ "${1}" == -o ]]; then
    outFile="${2}"
    shift 2
  fi
  firstchar=`echo "${1}" | head -c 1`
done

cd /vols/Data/soma/6Finger
declare -a tempOut

for f in $@; do
  subj=$(grep -Po '/\K[SC]F[1-9]+(?=/masks)' <<< $f)
  applywarp -i $f -o "${f%_high*}"_standard.nii.gz -r /vols/Data/soma/6Finger/SF1/pre/model/rsa-reg/standard.nii.gz -w /vols/Data/soma/6Finger/"${subj}"/pre/model/rsa-reg/highres2standard_warp
  tempOut+=("${f%_high*}"_standard.nii.gz)
done

fslmerge -t $outFile $(echo ${tempOut[@]})
rm $(echo ${tempOut[@]})

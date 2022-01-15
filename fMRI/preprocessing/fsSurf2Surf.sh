# !/bin/bash
#%
#% Resamples label or metric file from one surface onto another.
#% IMPORTANT: Native and target files have to be in the same hemisphere.
#% Makes sure all the necessary sphere and midthickness files are created.
#% Requires SUBJECTS_DIR to be defined.
#%
#=======================================================================================
#% USAGE
#% fsSurf2Surf [-h] [subject code] [directory with the native surface] [metric/label file to resample]
#%                  [hemisphere (L or R)] [directory with the target surface]
#%
#% EXAMPLE
#% fsSurf2Surf SF11 /vols/Data/soma/Atlases/Joern /vols/Data/soma/Atlases/Joern/ROI.label.gii
#%             L /vols/Data/soma/6Finger/surf/SF11/gifti
#%             # outputs /vols/Data/soma/6Finger/surf/SF11/gifti/ROI/SF11.ROI.L.label.gii
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
[[ $1 == "-h" ]] && usage && exit 1

subj="$1"
natDir="$2"
dataInput="$3"
side="$4"
targetDir="$5"

if [[ "$side" == "L" ]]; then
  struct="CORTEX_LEFT"
  hemi="lh"
elif [[ "$side" == "R" ]]; then
  struct="CORTEX_RIGHT"
  hemi="rh"
else
  echo "Please specify the hemisphere (L or R)"
fi

regex=".+\/(.+?[^L^R^\.])[LR\.]{1,3}(label|func)\.gii"
[[ "$dataInput" =~ $regex ]]
basename="${BASH_REMATCH[1]}"
filetype="${BASH_REMATCH[2]}"

mkdir "${targetDir}"/ROI

dataOutput="${targetDir}"/ROI/"${subj}"."${basename}"."${side}"."${filetype}".gii

#native surface
current_giisphere="${natDir}"/"${hemi}".sphere.reg.surf.gii
current_midthick="${natDir}"/"${hemi}".midthickness.surf.gii

#target surface
new_giisphere="${targetDir}"/"${hemi}".sphere.reg.surf.gii
new_midthick="${targetDir}"/"${hemi}".midthickness.surf.gii

# check whether all needed files are there, if not - create them
if [[ ! -f "$current_giisphere" ]] || [[ ! -f "$new_giisphere" ]] || [[ ! -f "$current_midthick" ]] || [[ ! -f "$new_midthick" ]]; then
  fswhite="${SUBJECTS_DIR}"/"${subj}"/surf/"${hemi}".white
  fspial="${SUBJECTS_DIR}"/"${subj}"/surf/"${hemi}".pial
  current_fssphere="${SUBJECTS_DIR}"/"${subj}"/surf/"${hemi}".sphere.reg
  if [[ -f $fswhite && -f $fspial && -f $current_fssphere ]]; then
    /home/fs0/daanw/Scripts/wb_shortcuts -freesurfer-resample-prep "$fswhite" "$fspial" "$current_fssphere" "$current_giisphere" "$new_midthick" "$current_midthick" "$new_giisphere"
  else
    echo ""${SUBJECTS_DIR}"/"${subj}"/surf/"${hemi}".white , "${SUBJECTS_DIR}"/"${subj}"/surf/"${hemi}".pial or "${SUBJECTS_DIR}"/"${subj}"/surf/"${hemi}".sphere.reg not found"
    exit 2
  fi
fi

if [[ $filetype == "func" ]]; then
  echo "metric file detected"
  wb_command -metric-resample "${dataInput}" "${current_giisphere}" "${new_giisphere}" ADAP_BARY_AREA "${dataOutput}" -area-surfs "${current_midthick}" "${new_midthick}"
  wb_command -set-structure "${dataOutput}" "${struct}"

elif [[ $filetype == "label" ]] ; then
  echo "label file detected"
  wb_command -label-resample "${dataInput}" "${current_giisphere}" "${new_giisphere}" ADAP_BARY_AREA "${dataOutput}" -area-surfs "${current_midthick}" "${new_midthick}"
  wb_command -set-structure "${dataOutput}" "${struct}"

else
  echo "filetype not recognised: supports only func.gii or label.gii"
fi

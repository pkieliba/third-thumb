# !/bin/bash
#%
#% Projects a label file from surface to the corresponding volume.
#% Requires SUBJECTS_DIR to be defined.
#%
#=======================================================================================
#% USAGE
#% fsSurfProjBackL [-h] [subject code] [side (L or R)] [label file]
#%
#% EXAMPLE
#% fsSurfProjBackL SF2 L /vols/Data/soma/6Finger/surf/SF2/gifti/ROI/SF2.ROImasked.L.label.gii
#%         # outputs: /vols/Data/soma/6Finger/surf/SF2/gifti/Volume/SF2.ROImasked.LHemi.nii.gz
#%
#% fsSurfProjBack SF3 R /vols/Data/soma/6Finger/surf/SF3/gifti/ROI/SF2.visual.label.gii
#%         # outputs: /vols/Data/soma/6Finger/surf/SF3/gifti/Volume/SF2.visual.nii.gz
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
side="$2"; # L or R
dataInput="$3"

surfpialL="${SUBJECTS_DIR}"/"${subj}"/gifti/"${subj}".L.pial.surf.gii
surfpialR="${SUBJECTS_DIR}"/"${subj}"/gifti/"${subj}".R.pial.surf.gii
surfwhiteL="${SUBJECTS_DIR}"/"${subj}"/gifti/"${subj}".L.white.surf.gii
surfwhiteR="${SUBJECTS_DIR}"/"${subj}"/gifti/"${subj}".R.white.surf.gii
volume="${SUBJECTS_DIR}"/"${subj}"/gifti/orig.nii.gz

mkdir "${SUBJECTS_DIR}"/"${subj}"/gifti/Volume

regex=".+\/(.+)\.label\.gii"
[[ "$dataInput" =~ $regex ]]
basename="${BASH_REMATCH[1]}"

if [[ ${basename:(-1)} == "R" || ${basename:(-1)} == "L" ]]; then
  basename="${basename}"Hemi
fi

if [[ $side == "L" ]]; then
  echo "wb_command -label-to-volume-mapping "${dataInput}" "${surfpialL}" "${volume}" "${SUBJECTS_DIR}"/"${subj}"/gifti/Volume/"${basename}".nii.gz -ribbon-constrained "${surfwhiteL}" "${surfpialL}""
  wb_command -label-to-volume-mapping "${dataInput}" "${surfpialL}" "${volume}" "${SUBJECTS_DIR}"/"${subj}"/gifti/Volume/"${basename}".nii.gz -ribbon-constrained "${surfwhiteL}" "${surfpialL}"
elif [[ $side == "R" ]]; then
  wb_command -label-to-volume-mapping "${dataInput}" "${surfpialR}" "${volume}" "${SUBJECTS_DIR}"/"${subj}"/gifti/Volume/"${basename}".nii.gz -ribbon-constrained "${surfwhiteR}" "${surfpialR}"
fi

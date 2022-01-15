# !/bin/bash
#%
#% Maps a label/metric file defined in one hemisphere onto the other hemisphere of
#% the same subject, using interhemispheric surface-based registration.
#% Requires the cross-hemisphere registration procedures to be run beforehand.
#% Requires SUBJECTS_DIR to be defined.
#%
#% Created by Paulina Kieliba, 2020
#=======================================================================================
#% USAGE
#% fsXhemi [-h] [subject code] [label file] [direction (rl or lr)]
#%
#% EXAMPLE
#% fsXhemi SF2 /vols/Data/soma/6Finger/surf/SF2/gifti/ROI/SF2.ROImasked.L.label.gii lr
#%         # outputs: /vols/Data/soma/6Finger/surf/SF2/gifti/ROI/SF2.ROImasked.R.label.gii
#%
#% fsXhemi SF3 /vols/Data/soma/6Finger/surf/SF3/gifti/ROI/SF2.ROImasked.R.label.gii rl
#%         # outputs: /vols/Data/soma/6Finger/surf/SF3/gifti/ROI/SF2.ROImasked.L.label.gii
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
dataInput="$2"
direction="$3"

if [[ ! -d "${SUBJECTS_DIR}"/"${subj}"/gifti ]]; then
  echo "No "${subj}"/gifti found inside the SUBJECTS_DIR. Is the SUBJECTS_DIR set properly? SUBJECTS DIR: "${SUBJECTS_DIR}""
  exit 2
fi

regex="(.+\/.+?[^L^R^\.])[LR\.]{1,3}(label|func)\.gii$"
[[ "$dataInput" =~ $regex ]]
basename="${BASH_REMATCH[1]}"
filetype="${BASH_REMATCH[2]}"

if [[ "$direction" == "lr" ]]; then
  hemi="lh"
  dataOutput="${basename}".R."${filetype}".gii
  struct="CORTEX_RIGHT"
elif [[ "$direction" == "rl" ]]; then
  hemi="rh"
  dataOutput="${basename}".L."${filetype}".gii
  struct="CORTEX_LEFT"
else
  echo "Invalid direction: supports only be lr for left-to-right-hemisphere mapping or rl for right-to-left-hemisphere mapping"
  exit 5
fi

# check if needed giftis exist, if not create them
if [[ ! -f "${SUBJECTS_DIR}"/"${subj}"/gifti/"${hemi}".xhemisphere.reg.surf.gii ]]; then
  mris_convert "${SUBJECTS_DIR}"/"${subj}"/xhemi/surf/"${hemi}".fsaverage_sym.sphere.reg "${SUBJECTS_DIR}"/"${subj}"/gifti/"${hemi}".xhemisphere.reg.surf.gii
  mris_convert "${SUBJECTS_DIR}"/"${subj}"/xhemi/surf/"${hemi}".white "${SUBJECTS_DIR}"/"${subj}"/xhemi/surf/"${hemi}".white.surf.gii
  mris_convert "${SUBJECTS_DIR}"/"${subj}"/xhemi/surf/"${hemi}".pial "${SUBJECTS_DIR}"/"${subj}"/xhemi/surf/"${hemi}".white.pial.gii
  wb_command -surface-average "${SUBJECTS_DIR}"/"${subj}"/gifti/"${hemi}".xhemimidthickness.surf.gii -surf "${SUBJECTS_DIR}"/"${subj}"/xhemi/surf/"${hemi}".white.surf.gii -surf "${SUBJECTS_DIR}"/"${subj}"/xhemi/surf/"${hemi}".white.pial.gii
fi

if [[ "$filetype" == "label" ]]; then
  wb_command -label-resample "${dataInput}" "${SUBJECTS_DIR}"/"${subj}"/gifti/"${hemi}".sphere.reg.surf.gii "${SUBJECTS_DIR}"/"${subj}"/gifti/"${hemi}".xhemisphere.reg.surf.gii ADAP_BARY_AREA "${dataOutput}" -area-surfs  "${SUBJECTS_DIR}"/"${subj}"/gifti/"${hemi}".midthickness.surf.gii "${SUBJECTS_DIR}"/"${subj}"/gifti/"${hemi}".xhemimidthickness.surf.gii
  wb_command -set-structure "${dataOutput}" "${struct}"
elif [[ "$filetype" == "func" ]]; then
  wb_command -metric-resample "${dataInput}" "${SUBJECTS_DIR}"/"${subj}"/gifti/"${hemi}".sphere.reg.surf.gii "${SUBJECTS_DIR}"/"${subj}"/gifti/"${hemi}".xhemisphere.reg.surf.gii ADAP_BARY_AREA "${dataOutput}" -area-surfs  "${SUBJECTS_DIR}"/"${subj}"/gifti/"${hemi}".midthickness.surf.gii "${SUBJECTS_DIR}"/"${subj}"/gifti/"${hemi}".xhemimidthickness.surf.gii
  wb_command -set-structure "${dataOutput}" "${struct}"
else
  echo "Filetype not recognised: supports only func.gii or label.gii"
  exit 5
fi

# !/bin/bash
#%
#% Creates gifti files form the freesurfer surface files
#% Requires SUBJECTS_DIR to be defined.
#%
#=======================================================================================
#% USAGE
#% fsCreateGifti [-h] [subject code] [directory with giftis]
#%
#% EXAMPLE
#% fsCreateGifti SF11 /vols/Data/soma/6Finger/surf/SF11/gifti
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
dirGifti="$2"

mkdir -p "$dirGifti"

# convert orig to raw T1w space
tkregister2 --mov "${SUBJECTS_DIR}"/"${subj}"/mri/orig.mgz --targ "${SUBJECTS_DIR}"/"${subj}"/mri/rawavg.mgz --regheader --reg junk --fslregout "${dirGifti}"/freesurfer2struct.mat --noedit
orig="${SUBJECTS_DIR}"/"${subj}"/mri/orig/001.mgz
mri_convert "${orig}" "${dirGifti}"/orig.nii.gz
conformed="${SUBJECTS_DIR}"/"${subj}"/mri/orig.mgz
mri_convert "${conformed}" "${dirGifti}"/conformed.nii.gz

for hemi in lh rh; do
  pial="${SUBJECTS_DIR}"/"${subj}"/surf/"${hemi}".pial
  white="${SUBJECTS_DIR}"/"${subj}"/surf/"${hemi}".white
  inflated="${SUBJECTS_DIR}"/"${subj}"/surf/"${hemi}".inflated

  mris_convert "$pial" "${dirGifti}"/"${subj}"."${hemi}".pial.asc
  mris_convert "$white" "${dirGifti}"/"${subj}"."${hemi}".white.asc
  mris_convert "$inflated" "${dirGifti}"/"${subj}"."${hemi}".inflated.asc

  echo "addpath ~saad/matlab/surfops" > "${dirGifti}"/matscript.m
  echo "p=surfread('$dirGifti/${subj}.${hemi}.pial.asc');" >> "${dirGifti}"/matscript.m
  echo "w=surfread('$dirGifti/${subj}.${hemi}.white.asc');" >> "${dirGifti}"/matscript.m
  echo "p.vertices=.5*(p.vertices+w.vertices);" >> "${dirGifti}"/matscript.m
  echo "surfwrite(p,'$dirGifti/${subj}.${hemi}.midthickness.asc')" >> "${dirGifti}"/matscript.m
  # This command creates the midthickness surface
  matlab -nodesktop -nosplash -r "run $dirGifti/matscript.m;quit;"

  #surf2surf - this will transform the surface into the original structural space
  for surf in pial white inflated midthickness; do
    if [ "${hemi}" == lh ]; then
      surf2surf -i "${dirGifti}"/"${subj}"."${hemi}"."${surf}".asc -o "${dirGifti}"/"${subj}".L."${surf}".surf.gii --convin=freesurfer --convout=caret --volin="${dirGifti}"/conformed --volout="${dirGifti}"/orig --xfm="${dirGifti}"/freesurfer2struct.mat
	    wb_command -set-structure "${dirGifti}"/"${subj}".L."${surf}".surf.gii CORTEX_LEFT
    else
      surf2surf -i "${dirGifti}"/"${subj}"."${hemi}"."${surf}".asc -o "${dirGifti}"/"${subj}".R."${surf}".surf.gii --convin=freesurfer --convout=caret --volin="${dirGifti}"/conformed --volout="${dirGifti}"/orig --xfm="${dirGifti}"/freesurfer2struct.mat
      wb_command -set-structure "${dirGifti}"/"${subj}".R."${surf}".surf.gii CORTEX_RIGHT
    fi
  done
done

#Retrieve curvature information
hemi=lh
curv="${SUBJECTS_DIR}"/"${subj}"/surf/"${hemi}".curv
surf="${SUBJECTS_DIR}"/"${subj}"/surf/"${hemi}".white
mris_convert -c "$curv" "$surf" "${dirGifti}"/"${subj}"."${hemi}".curv.func.gii
wb_command -set-structure "${dirGifti}"/"${subj}"."${hemi}".curv.func.gii CORTEX_LEFT
hemi=rh
curv="${SUBJECTS_DIR}"/"${subj}"/surf/"${hemi}".curv
surf="${SUBJECTS_DIR}"/"${subj}"/surf/"${hemi}".white
mris_convert -c "$curv" "$surf" "${dirGifti}"/"${subj}"."${hemi}".curv.func.gii
wb_command -set-structure "${dirGifti}"/"${subj}"."${hemi}".curv.func.gii CORTEX_RIGHT

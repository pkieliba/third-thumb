#!/bin/bash

SUBJ=$1
WORKDIR="/vols/Data/soma/6Finger/scripts"
COMMAND="fsRegisterXhem({'${SUBJ}'});"

matlab -nodisplay -nodesktop -nosplash -singleCompThread -r "cd '${WORKDIR}'; ${COMMAND}; quit;"



#!/bin/bash

SUBJ=$1
MASK=$2
WORKDIR="/vols/Data/soma/6Finger/scripts"
COMMAND="runRSA('${SUBJ}', '${MASK}');"

matlab -nodisplay -nodesktop -nosplash -singleCompThread -r "cd '${WORKDIR}'; ${COMMAND}; quit;"



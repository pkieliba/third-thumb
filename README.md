# Neurocognitive consequences of hand augmentation

In the recent years there has been an increased interest in augmentative technologies aimed to extend the physical and cognitive abilities of our bodies. But while tremendous resources are being dedicated to the development of augmentative devices, little notice is given to how the human brain might support them. Here, using human somatosensory cortex as a model, we investigate neurocognitive conequences of hand augmentation. We have trained a group of healthy able-bodied participants to use a supernumerary robotic finger (Third Thumb) over the course of one week. We have used a variaty of pre-post behavioural and neuroimaing tests to assess the impact of hand augmentation on the body representation in the brain. We found that training improved Third Thumb’s motor control, dexterity and hand-robot coordination, even when cognitive load was increased or when vision was occluded, and resulted in increased sense of embodiment over the robotic Thumb. Third Thumb usage also weakened natural kinematic hand synergies. Importantly, brain decoding of the augmented hand’s motor representation demonstrated mild collapsing of the canonical hand structure following training, suggesting that motor augmentation may impact the biological hand representation.

### This repository contains a codebase used for data acquisition, preprocessing and analysis employed in the ["Robotic hand augmentation drives changes in neural body representation"](https://www.science.org/doi/10.1126/scirobotics.abd7935) study published in Science Robotics (2021)

----

## Repository structure

The repository has been divided into separate data-acquisition, behav and fMRI folders.

<b>data-acquisition</b> folder contains Python and Matlab scripts used for data-acquisition and stimuli presentation in the MRI scanner. 

<b>behav</b> folder contains Python, Matlab and R scripts used to preprocess and analyse collected behavioural data, such as hand kinematics, hand laterality judgements, tactile distance perception etc. 

<b>fMRI</b> folder contains Python, Matlab and Bash scripts used to preprocess and and analyse collected neuroimaging data. Preprocessing and GLM analyses were carried out in FSL.




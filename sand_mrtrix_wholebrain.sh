#!/bin/bash
## Sandra Hanekamp,2017
# make your .b file first using matlab use sand_create_b_file.m
## build paths
##change the path to your topdir (subject folder)
TOPDIR=/path/to/your/subject/folder
SUBJ=${TOPDIR}/$1

##Transform your white matter mask (wm_mask.nii.gz) to the same space as your DWI data
mrtransform ${SUBJ}/wm_mask.nii.gz -template ${SUBJ}/dwi_aligned_trilin.nii.gz ${SUBJ}/wm_transform.nii.gz

## Convert files from files to mrtrix format (.mif)
mrconvert ${SUBJ}/wm_transform.nii.gz ${SUBJ}/wmMask.mif
mrconvert ${SUBJ}/dtiInit/bin/brainMask.nii.gz ${SUBJ}/brainMask.mif
mrconvert ${SUBJ}/dwi_aligned_trilin.nii.gz ${SUBJ}/dwi_aligned_trilin.mif

## Fit the tensor model to the dti data
dwi2tensor ${SUBJ}/dwi_aligned_trilin.mif -grad ${SUBJ}/dwi_aligned_trilin.b ${SUBJ}/dt.mif

## Calculate map of FA  from diffusion tensor image and the white matter mask
tensor2FA ${SUBJ}/dt.mif - | mrmult - ${SUBJ}/wmMask.mif ${SUBJ}/fa.mif 

## Perform filtering operations on the brain mask, we'll create a single fiber mask of FA. We apply the filter 3 times and use a threshold of 0.7 (default)
erode ${SUBJ}/brainMask.mif -npass 3 - | mrmult ${SUBJ}/fa.mif - - | threshold - -abs 0.7 ${SUBJ}/sf.mif

## Estimate the fibre response function for use in spherical deconvolution (CDS)
estimate_response ${SUBJ}/dwi_aligned_trilin.mif ${SUBJ}/sf.mif -grad ${SUBJ}/dwi_aligned_trilin.b -lmax 8 ${SUBJ}/response.txt

## Perform constrained spherical deconvulation, creates a spherical harmonics coefficients image
csdeconv ${SUBJ}/dwi_aligned_trilin.mif ${SUBJ}/response.txt ${SUBJ}/csd8.mif -grad ${SUBJ}/dwi_aligned_trilin.b -lmax 8 -mask ${SUBJ}/brainMask.mif

## Now, we are ready to perform the actual tractography! 
streamtrack SD_PROB ${SUBJ}/csd8.mif ${SUBJ}/mrtrix_csd8_prob_curv-1_wholeBrain.tck \
           -seed ${SUBJ}/wmMask.mif -mask ${SUBJ}/wmMask.mif -curvature 1 -grad ${SUBJ}/dwi_aligned_trilin.b \
            -minlength 5 -number 500000 -maxnum 1000000



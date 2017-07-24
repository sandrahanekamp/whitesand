#!/bin/bash
## Sandra Hanekamp,2017
# make your .b file first using matlab use create_b_file_sand.m
## build paths
##change the path to your topdir (subject folder)
TOPDIR=/path/to/your/subject/folder
SUBJ=${TOPDIR}/$1

##Transform your white matter mask (wm_mask.nii.gz) to the same space as your DWI data
mrtransform ${SUBJ}/wm_mask.nii.gz -template ${SUBJ}/dwi_aligned_trilin.nii.gz ${SUBJ}/wm_transform.nii.gz

## Convert dwi files from files to mrtrix format (.mif)
mrconvert ${SUBJ}/wm_transform.nii.gz ${SUBJ}/wmMask.mif
mrconvert ${SUBJ}/dtiInit/bin/brainMask.nii.gz ${SUBJ}/brainMask.mif
mrconvert ${SUBJ}/dwi_aligned_trilin.nii.gz ${SUBJ}/dwi_aligned_trilin.mif

## convert inclusion roi files from to mrtrix format (.mif)
mrconvert ${SUBJ}/LGN_L.nii.gz ${SUBJ}/LGN_L.mif
mrconvert ${SUBJ}/LGN_R.nii.gz ${SUBJ}/LGN_R.mif
mrconvert ${SUBJ}/V1_L.nii.gz ${SUBJ}/V1_L.mif
mrconvert ${SUBJ}/V1_R.nii.gz ${SUBJ}/V1_R.mif

## convert exclusion roi files from to mrtrix format (.mif)
mrconvert ${SUBJ}/rect_R_Xm.nii.gz ${SUBJ}/rect_R_Xm.mif
mrconvert ${SUBJ}/rect_L_Xm.nii.gz ${SUBJ}/rect_L_Xm.mif
mrconvert ${SUBJ}/rect_LR_Y.nii.gz ${SUBJ}/rect_LR_Y.mif
mrconvert ${SUBJ}/rect_LR_Zs.nii.gz ${SUBJ}/rect_LR_Zs.mif

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


## ROI to ROI tracking, LEFT OR
streamtrack SD_PROB ${SUBJ}/csd8.mif ${SUBJ}/mrtrix_OR_L.tck\
            -seed ${SUBJ}/OR_L.mif -mask ${SUBJ}/wmMask.mif -grad ${SUBJ}/dwi_aligned_trilin.b\
            -include ${SUBJ}/LGN_L.mif -include ${SUBJ}/V1_L.mif\
            -exclude ${SUBJ}/rect_L_Xm.mif -exclude ${SUBJ}/rect_LR_Y.mif -exclude ${SUBJ}/rect_LR_Zs.mif\
            -curvature 1\
            -number 50000 -maxnum 500000\
            -minlength 5\

## ROI to ROI tracking, RIGHT OR
streamtrack SD_PROB ${SUBJ}/csd8.mif ${SUBJ}/mrtrix_OR_R.tck\
            -seed ${SUBJ}/OR_R.mif -mask ${SUBJ}/wmMask.mif -grad ${SUBJ}/dwi_aligned_trilin.b\
            -include ${SUBJ}/LGN_R.mif -include ${SUBJ}/V1_R.mif\
            -exclude ${SUBJ}/rect_R_Xm.mif -exclude ${SUBJ}/rect_LR_Y.mif -exclude ${SUBJ}/rect_LR_Zs.mif\
            -curvature 1\
            -number 50000 -maxnum 500000\


%Sandra Hanekamp, 2017
%Making ROIs in native space. First, you create an ROI in MNI space. You
%can do this by drawing ROIs yourself in mrDiffusion (draw on MNI
%template). MrDiffusion saves them as matlab files.

%Convert your exclusion ROIs to native space

% 1. save MNI .mat ROI created in mrDiffusion as nifti ROI
roi_dir = '/N/dc2/projects/lifebid/Sandra/OR/'; %path of your MNI roi
tdir=fullfile(fileparts(which('mrDiffusion')), 'templates');%this is the MNI_EPI.nii.gz by default

V1_R = (fullfile(roi_dir, 'V1_R.mat'))
V1_L = (fullfile(roi_dir,'V1_L.mat'))
  

    load(V1_R)%load MNI .mat ROI
    dtiExportRoiToNifti(V1_R, '/N/dc2/projects/lifebid/code/vistasoft/mrDiffusion/templates/MNI_EPI.nii.gz', 'V1_R.nii.gz') %(roi, template, newname)
    load(V1_L)%load MNI .mat ROI
    dtiExportRoiToNifti(V1_L, '/N/dc2/projects/lifebid/code/vistasoft/mrDiffusion/templates/MNI_EPI.nii.gz', 'V1_L.nii.gz')

    %2. Transform your MNI .nii ROI to native space of the subject
%Load subject dt6
Dir = '/N/dc2/projects/lifebid/Sandra/OR';
%Subj = importdata('/N/dc2/projects/lifebid/Sandra/OR/all_subjects.txt')
Subj = {'Pt_13'}
for ii = 1:length(Subj)
ROI_img_file = (fullfile(roi_dir, 'V1_R.nii.gz'));
[RoiFileName, invDef, roiMask] = dtiCreateRoiFromMniNifti(char(fullfile(Dir, Subj(ii),'dt6.mat')), ROI_img_file, [], true, []); 
ROI_img_file = (fullfile(roi_dir, 'V1_L.nii.gz'));
[RoiFileName, invDef, roiMask] = dtiCreateRoiFromMniNifti(char(fullfile(Dir, Subj(ii),'dt6.mat')), ROI_img_file, [], true, []); 
end 

% %3. Since this is saved as mat, file convert back to nii. again Transfrom this native .mat ROI to a nifti ROI
%2. Load B0 as your reference image for conversion

clear all
Dir = '/N/dc2/projects/lifebid/Sandra/OR';
%Subj = importdata('/N/dc2/projects/lifebid/Sandra/OR/all_subjects.txt')
Subj = {'Pt_13'}
%Subj = importdata('/N/dc2/projects/lifebid/Sandra/monoculi/NL/subjects_MS.txt');

for ii = 1:length(Subj)
    cd(fullfile(Dir, Subj{ii}, 'ROIs')); 
    V1_R_nii = 'V1_R.nii.gz';
    load('V1_R')
    cd(fullfile(Dir, Subj{ii}));
dtiExportRoiToNifti(roi, 'b0.nii.gz', V1_R_nii)
    cd(fullfile(Dir, Subj{ii}, 'ROIs')); 
    V1_L_nii = 'V1_L.nii.gz';
    load('V1_L')
    cd(fullfile(Dir, Subj{ii}));
dtiExportRoiToNifti(roi, 'b0.nii.gz', V1_L_nii)
end
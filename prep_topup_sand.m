%% Sandra Hanekamp
%When having two DTIscans, one APA and one APP, you have to merge the nifti files that you get after converting the PAR/Rec files.
% input is the nifti APA file and the nifti APP file (one is ni1, other is ni2)  
% output is one nifti file, the "dti.nii.gz" 
% (whole file names, incl. directories, or make sure you are in the directory, tha/N/dc2/projects/lifebid/Sandra/monoculi/AFQ/GL34/dti.bvals
% /N/dc2/projects/lifebid/Sandra/monoculi/AFQ/GL34/dti.bvecs
% /N/dc2/projects/lifebid/Sandra/monoculi/AFQ/GL34/dti.nii.gzn only filename)

% import nifti and copy into output objects
nii = readFileNifti('dwi.nii.gz');

% copy and fix file names
panii = nii;
panii.fname = 'PA_dwi.nii.gz';

apnii = nii;
apnii.fname = 'AP_dwi.nii.gz';

b0nii = nii;
b0nii.fname = 'b0_dwi.nii.gz';

% index pa volumes
panii.data = panii.data(:,:,:,1:61);
panii.dim = [128 128 51 61];

% index ap volumes
apnii.data = apnii.data(:,:,:,62:end);
apnii.dim = [128 128 51 61];

% create b0
b0nii.data = b0nii.data(:,:,:,[122 61]);
b0nii.dim = [128 128 51 2];

% saves out in wrong dimensions
writeFileNifti(panii);
writeFileNifti(apnii);
writeFileNifti(b0nii);

% % create the grads.b file for mrtrix from bvecs/bvals files
% mrtrix_bfileFromBvecs('dti.bvecs', 'dti.bvals', 'dti_aligned_trilin.b');

%% original import

% Subjectsdir = ('/Users/sandrahanekamp/Documents/data/monoculi_GL/AFQ/'); 
% Subject = {'HC01', 'HCO2', 'HC03', 'HC04', 'HC05', 'HC06', 'HC07', 'HC08', 'HC09', 'HC10', 'HC11', 'HC12', 'HC13', 'HC14', 'HC15', 'HC16', 'HC17', 'HC18', 'HC19', 'HC20'};
% 
% for i =1:length(Subject)
%     
%     ni1 = readFileNifti([Subjectsdir Subject{i} filesep 'WIPDTIs60dirAPASENSE.nii.gz']);    
%     ni2 = readFileNifti([Subjectsdir Subject{i} filesep 'WIPDTIs60dirAPPSENSE.nii.gz']);
%     ni1.data = cat(4, ni1.data, ni2.data);
%     ni1.fname = [Subjectsdir Subject{i} filesep 'dti.nii.gz'];
%     writeFileNifti(ni1);
%     
% end 
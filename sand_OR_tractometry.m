%% Tract Profiles of the Optic Radiation (or any tract you prefer)
%% Sandra Hanekamp, 2016

% Set up paths 
Dir = '/path/to/subjects/dir'; %path to the folder with al your subjects
Subj = {'HC01'}; % or Subj = importdata('path/to/subjectlist.txt');
paths.dt6 = (fullfile(Dir, Subj, '/dt6.mat')); % path to to the dt6 file
paths.fiberGroup.OR_L = (fullfile(Dir, Subj, '/quench_OR_L.pdb')); % path to your fiber group that you created with mrtrix
paths.fiberGroup.OR_R = (fullfile(Dir, Subj, '/quench_OR_R.pdb')); % a second FG you want to quantify
paths.anatomy = (fullfile(Dir, Subj,'/ACPC_T1.nii.gz')); %path to anatomy (for figures, optionally)

%% Or,load the paths if you saved these previously:
%load('/N/dc2/projects/lifebid/Sandra/OR/results/paths_all_subjects.mat')


%% Here we indicate the format of the variables we will be creating later. This speeds up the proces. No need to change this part
% FG 1 (OR left) and the diffusion measures we want (Subj (rows) x 100 nodes (columns))
wm_val.OR_L.fa = zeros(length(Subj), 100);
wm_val.OR_L.md = zeros(length(Subj), 100);
wm_val.OR_L.rd = zeros(length(Subj), 100);
wm_val.OR_L.ad = zeros(length(Subj), 100); 
% FG 2 (OR right) and the diffusion measures we want
wm_val.OR_R.fa = zeros(length(Subj), 100);
wm_val.OR_R.md = zeros(length(Subj), 100);
wm_val.OR_R.rd = zeros(length(Subj), 100);
wm_val.OR_R.ad = zeros(length(Subj), 100); 

% Loading the FG and dt6 file.
for ii = 1:length(Subj)
fg.OR_L(ii) = fgRead(paths.fiberGroup.OR_L{ii});
fg.OR_R(ii) = fgRead(paths.fiberGroup.OR_R{ii});
dt(ii) = dtiLoadDt6(paths.dt6{ii}); 
end

%%  COMPUTE DIFFUSION PROPERTIES ALONG THE FIBER GROUP
for ii = 1:length(Subj)
[wm_val.OR_L.fa(ii, :), wm_val.OR_L.md(ii, :), wm_val.OR_L.rd(ii, :), wm_val.OR_L.ad(ii, :)]  = dtiComputeDiffusionPropertiesAlongFG(fg.OR_L(ii), dt(ii),[],[],100);
[wm_val.OR_R.fa(ii, :), wm_val.OR_R.md(ii, :), wm_val.OR_R.rd(ii, :), wm_val.OR_R.ad(ii, :)]  = dtiComputeDiffusionPropertiesAlongFG(fg.OR_R(ii), dt(ii),[],[],100);
end 

%%
%We computed 100 nodes for each structure. We'll clip the first and last 10
%nodes, the new name for this clipped FG is s = structure and 21 = OR_L and
%22 = OR_R (format AFQ structure)
% OR_L
TractProfile.all.OR_L.FA =  wm_val.OR_L.fa(:,11:90); 
TractProfile.all.OR_L.MD =  wm_val.OR_L.md(:,11:90);
TractProfile.all.OR_L.AD =  wm_val.OR_L.ad(:,11:90);
TractProfile.all.OR_L.RD =  wm_val.OR_L.rd(:,11:90);

% OR_R
TractProfile.all.OR_R.FA =  wm_val.OR_R.fa(:,11:90); 
TractProfile.all.OR_R.MD =  wm_val.OR_R.md(:,11:90);
TractProfile.all.OR_R.AD =  wm_val.OR_R.ad(:,11:90);
TractProfile.all.OR_R.RD =  wm_val.OR_R.rd(:,11:90);

%make mean value of left and right OR
TractProfile.all.OR_LR.FA = (TractProfile.all.OR_L.FA + TractProfile.all.OR_R.FA)/2;
TractProfile.all.OR_LR.MD = (TractProfile.all.OR_L.MD + TractProfile.all.OR_R.MD)/2;
TractProfile.all.OR_LR.AD = (TractProfile.all.OR_L.AD + TractProfile.all.OR_R.AD)/2;
TractProfile.all.OR_LR.RD = (TractProfile.all.OR_L.RD + TractProfile.all.OR_R.RD)/2;


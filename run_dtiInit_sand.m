% Version of Sandra Hanekamp, 2016
% 
%Run the mrDiffusion pre-processing steps on raw DWI and T1 data.
%  only changes the folder names or purple file names
%See dtiInitParams.m for default parameters.
Dir = '/path/to/subjects/dir';%change path to your data folder
Subj = importdata('/path/to/textfile/with/subjects.txt')%make a text file with each subject name on a row (so one column) or {'HC01'; 'HC02';}
Outdir = '/path/to/where/you/want/your/data';%this can be the same path as Dir

%one subject
    dwp = dtiInitParams;
    dwp.clobber = 1;% overwrite 1 = yes
    dwp.dt6BaseName = 'dtiInit';
    dwp.eddyCorrect = 1;
    dwp.phaseEncodeDir = 2;
    dwp.dwOutMm = [2.5 2.5 2.5];
    dwp.rotateBvecsWithRx = 0; % 
    dwp.rotateBvecsWithCanXform = 1; % 
    dwp.bvecsFile = char(fullfile(Dir, Subj, '/bvec.bvec'));%or apa.bvec
    dwp.bvalsFile =  char(fullfile(Dir, Subj, '/bval.bval'));%or apa.bval
    dwp.outDir	= char(fullfile(Outdir, Subj));
    dtiInit_sand(char(fullfile(Dir, Subj, '/dwi.nii.gz')), char(fullfile(Dir, Subj, '/T1_ACPC.nii.gz')), dwp); %use dtiInit_sand script instead of default dtiInit, the default gives motion correction error


% %loop all subjects
% 
% for ii = 1:length(Subj)
%     
%     dwp = dtiInitParams;
%     dwp.clobber = 1;% overwrite 1 = yes
%     dwp.dt6BaseName = 'dtiInit';
%     dwp.eddyCorrect = 1;
%     dwp.phaseEncodeDir = 2;
%     dwp.dwOutMm = [2.5 2.5 2.5];
%     dwp.rotateBvecsWithRx = 0; % 
%     dwp.rotateBvecsWithCanXform = 1; % 
%     dwp.bvecsFile = char(fullfile(Dir, Subj(ii), '/bvec.bvec'));%make sure your files names are like this
%     dwp.bvalsFile =  char(fullfile(Dir, Subj(ii), '/bval.bval'));
%     dwp.outDir	= char(fullfile(Outdir, Subj(ii)));
%     dtiInit_sand(char(fullfile(Dir, Subj(ii), '/data.nii.gz')), char(fullfile(Dir, Subj(ii), '/average.nii.gz')), dwp); %use dtiInit_sand script instead of default dtiInit, the default gives motion correction error
% 
% end 


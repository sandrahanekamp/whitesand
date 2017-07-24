
%1. Load your paths 
Dir = '/path/to/subject/folder';
%Subj = importdata('/N/dc2/projects/lifebid/Sandra/monoculi/NL/subjects_MS.txt');
Subj = {'HC01'};

for ii = 1:length(Subj)
    cd(fullfile(Dir, Subj{ii}));
    fg_R = mtrImportFibers('quench_OR_R.pdb');
    fg_L = mtrImportFibers('quench_OR_L.pdb');
    dt = dtiLoadDt6('dt6.mat');
    AFQ_RenderFibers(fg_R, 'radius', [1 6], 'jittershading', 0.2, 'color', [0.8 0.6 0.4], 'camera', 'axial', 'dt',dt,'subdivs',25', 'alpha',0.65); 
    AFQ_RenderFibers(fg_L, 'radius', [1 6], 'jittershading', 0.2, 'color', [0.8 0.6 0.4], 'camera', 'axial', 'dt',dt,'subdivs',25', 'alpha',0.65); 
    title('Left Optic Radiation','fontsize',18)
   
        
end

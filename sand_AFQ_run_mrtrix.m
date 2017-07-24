%Sandra Hanekamp, 2017 

%How to use AFQ_run 
%with mrtrix tractography and cleaning settings
% Create a cell array where each cell is the path to a data directory
Dir = '/path/to/your/subjects/dir'; %change this to your subjects directory path
Subj = importdata('/list/of/your/subjects.txt'); %change this path to a textfile in which you list the subjects (or just list them)
sub_dirs = (fullfile(Dir, Subj, 'dtiInit'))

% Create a binary vector of 0s and 1s defining who is a patient 1 and a control 0
%keep the order of your subjects.txt, This file has to be one row (not
%column (or use )
sub_group = importdata('/path/to/subgroup/file.txt');

% Create AFQ file structure
%Indicate which cleaning settings you want to use, maxdist 3 and maxlen may
%work for prob tracking
afq = AFQ_Create('maxDist', [3], 'maxLen', [4], 'sub_dirs', sub_dirs, 'sub_group', sub_group);

%You can in test mode to save time (will not show figures)
% afq = AFQ_Create('run_mode','test', 'sub_dirs', sub_dirs, 'sub_group', sub_group, 'showfigs',false);

% Now, we indicate that we will use the probabilistic tractography, make sure name of .tck file is correct 
mrtrix_fibers = (fullfile(Dir, Subj, 'mrtrix_csd8_prob_curv-1_wholeBrain.tck'))

%Here, we overwrite the default afq tracking
Nsubj = AFQ_get(afq,'numberofsubjects');
for iSubj = 1:Nsubj
    afq.files.fibers.wholebrain{iSubj} = ( mrtrix_fibers{iSubj} );
    afq.overwrite.fibers.clean(iSubj) = true; %true if you want to (re) do cleaning
    afq.overwrite.fibers.segmented(iSubj) = true; %true if your segmenting tracts for the first time,
    %if you ran afq before you do not need to do segmenting again, so then choose false
end

%Run AFQ
[afq, patient_data, control_data, norms, abn, abnTracts] = AFQ_run(sub_dirs, sub_group, afq);

%change this to a folder where you want your results and choose a name for
%the .mat file that saves the results
save ('/path/to/results/folder/Results/workspace_3_4_prob.mat')

% Save the plots 
h = get(0,'children');
for i=1:length(h)
  saveas(h(i), ['figure_prob_3_4' num2str(i)], 'png');
end
%close all

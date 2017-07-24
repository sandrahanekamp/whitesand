%Sandra Hanekamp, 2017 create .b file using mrvista
Dir = '/path/to/your/subjects/dir';

Subj = importdata('/path/to/subjects/list/in/one/column.txt')

for ii = 1:length(Subj)
    cd(fullfile(Dir, Subj{ii}));
mrtrix_bfileFromBvecs('data_aligned_trilin.bvecs', 'data_aligned_trilin.bvals','data_aligned_trilin.b')
end 

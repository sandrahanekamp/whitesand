%Sandra Hanekamp, check to see how AFQ did segmentation and cleaning for
%all fiber groups and subjects

%Set up data
Dir = '/path/to/your/subjects/dir'; 
Subj = importdata('/path/to/subjects/list.txt')
Outdir = '/path/to/where/you/want/your/figures/'; 

%Which cleaning parameters/model did you use?
model = 'D4_L3';
%model = {'D5_L4', 'D5_L3', 'D5_L2','D4_L4', 'D4_L3', 'D4_L2','D3_L4', 'D3_L3', 'D3_L2'}; 


for ii = 1:length(Subj)
    
    %Read fibers 
    fg = dtiReadFibers(fullfile([Dir, Subj{ii}, '/dtiInit/fibers'], ['MoriGroups_clean_', model, '.mat']));
    
    %Load dt6
    dt = dtiLoadDt6(char(fullfile(Dir, Subj(ii), '/dtiInit/dt6.mat')));
    
    %Render fibers with their default view
    for jj = 1:length(fg)    
        AFQ_RenderFibers(fg(jj), 'radius', [1 6], 'jittershading', 0.2, 'color', [1 0 0.2],'subdivs',25', 'alpha',0.65); 
        title((fullfile(Subj(ii), fg(jj).name, model)),'fontsize',18)
        filename = fullfile(Outdir, [Subj{ii}, '_', fg(jj).name, '_', model '.png']);
        saveas(gcf, filename)
        close(gcf)
   
   %Render fibers that look best with an axial view
        AFQ_RenderFibers(fg(1),'radius', [1 6], 'jittershading', 0.2, 'color', [1 0 0.2], 'camera', 'axial','subdivs',25', 'alpha',0.65); 
        title((fullfile(Subj(ii), fg(1).name, model)),'fontsize',18)
        filename = fullfile(Outdir, [Subj{ii}, '_', fg(1).name, '_', model '.png']);
        saveas(gcf, filename)
        close(gcf)
    
        AFQ_RenderFibers(fg(2), 'radius', [1 6], 'jittershading', 0.2, 'color', [1 0 0.2], 'camera', 'axial','subdivs',25', 'alpha',0.65); 
        title((fullfile(Subj(ii), fg(2).name, model)),'fontsize',18)
        filename = fullfile(Outdir, [Subj{ii}, '_', fg(2).name, '_', model '.png']);
        saveas(gcf, filename)
        close(gcf)      
        
        AFQ_RenderFibers(fg(9), 'radius', [1 6], 'jittershading', 0.2, 'color', [1 0 0.2], 'camera', 'axial','subdivs',25', 'alpha',0.65); 
        title((fullfile(Subj(ii), fg(9).name, model)),'fontsize',18)
        filename = fullfile(Outdir, [Subj{ii}, '_', fg(9).name, '_', model '.png']);
        saveas(gcf, filename)
        close(gcf)
        
        AFQ_RenderFibers(fg(10), 'radius', [1 6], 'jittershading', 0.2, 'color', [1 0 0.2], 'camera', 'axial','subdivs',25', 'alpha',0.65); 
        title((fullfile(Subj(ii), fg(10).name, model)),'fontsize',18)
        filename = fullfile(Outdir, [Subj{ii}, '_', fg(10).name, '_', model '.png']);
        saveas(gcf, filename)
        close(gcf)
    end
end



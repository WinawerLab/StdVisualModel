function T = chooseData(  quick_choice, optimizer, fittime )
% This is a simple function to help select model

% The input value means: selectioning one of the dataset: 
% 'all'
% 'orientation',
% 'space' 

% dataset is [which_dataset (1-4) | which_roi (V1-V3)];
datasets = [1, 2, 3, 4];
roi_idx  = [1, 2, 3 ];
ROIs     = {'V1', 'V2', 'V3'};

models = cell( 4, 1);
models{1} = contrastModel( optimizer, fittime);
models{3} = normVarModel( optimizer, fittime);
models{4} = SOCModel( optimizer, fittime);
models{5} = oriSurroundModel( optimizer, fittime);

switch quick_choice
    case {'figure1'}
        model_idx = [1];
        datasets = [1];
    case {'figure2'}
        model_idx = [1];
        datasets = [1];
    case {'figure3'}
        model_idx = [4];
        datasets = [1];
    case {'figure4'}
        model_idx = [5];
        datasets = [1];
    case {'figure5'}
       % models = {model1, model3};
        model_idx = [3];
        datasets = [1];
    case {'figure6'}
        model_idx = [3];
        datasets  = [1];
    case {'figure7'}
        model_idx = [1, 3];
        datasets  = [1];
    case {'figureS2'}
        model_idx = [ 3];
        datasets  = [1, 2, 3, 4];
    case {'figureS3'}
        model_idx = [3];
        datasets  = [2];
    case {'figureS4'}
        model_idx = [3];
        datasets  = [3];
    case {'figureS5'}
        model_idx = [3];
        datasets  = [4];
    case {'con'}
        model_idx = [1];
    case {'all', 'All' }
        model_idx = [ 1, 4, 5, 3];
    case 'orientation'
        model_idx = [ 1, 3];
    case 'noOri'
        model_idx = [ 1, 3, 4];
    case {'SOC', 'soc'}
        model_idx = [ 4];
    case 'oriSurround'
        model_idx = [ 5];
    case 'noVar'
        model_idx = [1, 4, 5];
    case 'no_model'
        model_idx = NaN;
end


n = length(datasets) * length(ROIs) * length(model_idx);

dataset     = NaN(n,1);
roiNum      = NaN(n,1);
roiName     = cell(n,1);
modelNum    = NaN(n,1);
modelLoader   = cell(n,1);

idx = 0;
for d = 1:length(datasets)
    for r = 1:length(ROIs)
        for m = 1:length(model_idx)
             
            idx = idx+1;
        
            dataset(idx)     = datasets(d);
            roiNum(idx)      = roi_idx(r);
            roiName(idx)     = ROIs(r);
            modelNum(idx)    = model_idx(m);
            modelLoader{idx} = models{model_idx(m)};

        end
    end
end

T = table(dataset, roiNum, roiName, modelNum, modelLoader);

end

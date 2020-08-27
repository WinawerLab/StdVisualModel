function plot_loss_landscape( target,dataset, roi, model_idx, param_pbound )

if (nargin < 5), param_pbound=false; end

% assign path
[curPath, prevPath] = stdnormRootPath();

% add path to the model
addpath( genpath( fullfile( curPath, 'models' )))

interval = 20;
show_interval = 10;
loss_mat = NaN( interval, interval );

switch model_idx
    case 1
        model = contrastModel();
        param1_label = 'g';
        param2_label = 'n';
    case 2
        model = normStdModel();
        param2 = .3;
        param1_label = 'w';
        param2_label = 'n';
        display = [ 'param2: g', num2str(param2) ];
        disp(display)
    case 3
        model = normVarModel();
        param2 = .3;
        param1_label = 'w';
        param2_label = 'n';
        display = [ 'param2: g', num2str(param2) ];
        disp(display)
end

if param_pbound == 0
    param_pbound = model.param_pbound;
end
param_vec1 = linspace( param_pbound( 1, 1), param_pbound( 1,2), interval );
param_vec2 = linspace( param_pbound( end, 1), param_pbound( end,2), interval );


for i = 1:interval
    for j = 1:interval
        
        %show
        if (mod( i, show_interval) == 0) * (mod( j, show_interval) == 0)
            display = [ 'param1:', num2str(i), 'param2:', num2str(j) ];
            disp(display)
        end
        
        % Load target
        BOLD_target = dataloader( prevPath, 'BOLD_target', target, dataset, roi );
        
        % set up paramter
        switch model_idx
            case 1
                param = [ param_vec1(i), param_vec2(j) ];
            case {2, 3}
                param = [ param_vec1(i), param2, param_vec2(j) ];
        end
        model = model.fixparameters( model, param);
        
        switch model.model_type
            case 'orientation'
                which_obj ='E_ori';
            case 'space'
                which_obj = 'E_xy';
        end
        E = dataloader( prevPath, which_obj, target, dataset, roi, 'old' );
        BOLD_pred = model.predict( model, E );
        loss_mat(i,j) = mse( BOLD_pred, BOLD_target);
        
    end
end

imagesc( loss_mat )
colorbar
xrange = [1 : interval/show_interval : interval];
yrange = [1 : interval/show_interval : interval];
set(gca, 'xtick', xrange );
set(gca, 'ytick', yrange );
set(gca, 'XTickLabel', round(param_vec2(1:interval/show_interval:end),2));
set(gca, 'YTickLabel', round(param_vec1(1:interval/show_interval:end),2));
xlabel( param2_label )
ylabel( param1_label )
title( sprintf( 'Loss landscape of-dataset%d-roi%d-model%d', dataset, roi, model_idx ))




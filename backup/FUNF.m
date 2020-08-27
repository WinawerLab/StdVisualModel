function sumSSE = FUNF(x, E, v2_mean, which_model, which_type ,w_d, weight_E )

switch which_type
    case 'orientation'
        w= x(1);
        g = x(2);
        n = x(3);
        
        switch which_model
            case 'contrast'
                % Energy model
                d = E;% ori x examples x stimuli
            case 'normStd'
                % std model
                d = E ./(1+ w.*std(E, 1));% ori x examples x stimuli
            case 'normVar'
                % var model
                d = E.^2 ./(1+w^2.*var(E, 1));% ori x examples x stimuli
            case 'normPower'
                % square model
                d = E.^2 ./(1 + w^2.*mean(E.^2 , 1)); % ori x examples x stimuli
            otherwise
                disp('Please select the right model')
        end
        
        % sum over orientation
        s = squeeze(mean(d , 1)) ; % examples x stimuli
        
 case 'space'
        w = x(1);
        g = x(2);
        n = x(3);
        
        switch which_model
            case 'SOC'
                
                % Do a variance-like calculation
                v =  (E - w*mean(mean(E, 1) , 2)).^2; % X x Y x ep x stimuli
                
                
            case 'ori_surround'
                
                % calculate d
                d_theta = E./( 1 + w * weight_E ); %E: 3D 
                v  = squeeze(mean( d_theta , 3) );
                d = bsxfun(@times, v, w_d);
                
        end
        % Sum over spatial position
        s = squeeze(mean(mean( d , 1) , 2)); % ep x stimuli
        
        
    otherwise
        disp('Right model')
end

% Nonlinearity
BOLD_prediction_ind = g.*s.^n; % ep x stimuli

% Sum over different examples
BOLD_prediction = squeeze(mean(BOLD_prediction_ind, 1)); % stimuli

% Compare with the data
SSE=(v2_mean - BOLD_prediction).^2;

sumSSE=double(sum(SSE));


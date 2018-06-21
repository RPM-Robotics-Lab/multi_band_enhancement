function [ A, I_out ] = fcn_estim_ambient( I, amb_map, debug_mode )
% Function for ambient light estimation

n_channel = size(I, 3);
amb_map = mean(amb_map, 3);
A = zeros(1, n_channel);
if (debug_mode)
    I_out = I;
end

amb_num = 0.001 * numel(amb_map);
[max_val, max_ind] = sort(amb_map(:), 'descend');
max_ind = max_ind(1:amb_num);

% compute ambient light for each channel
for c = 1:n_channel
    I_each = I(:,:,c);
    A(c) = median(I_each(max_ind));
    
    if (debug_mode)
        I_each(max_ind) = 1;
        I_out(:,:,c) = I_each;
    end
end

end


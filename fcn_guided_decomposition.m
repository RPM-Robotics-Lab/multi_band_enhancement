function [ base_layer, detail_layer, amb_map, mean_I, var_I, N, residual_img ] = fcn_guided_decomposition(I, p, r, eps, scale_mapping)
% Function for guided filtering based image decomposition

% pre-compute common variables
[hei, wid] = size(I);
detail_layer = zeros(size(I));

N = boxfilter(ones(hei, wid), r); % the size of each local patch; N=(2r+1)^2 except for boundary pixels.

mean_I = boxfilter(I, r) ./ N;
mean_p = boxfilter(p, r) ./ N;
mean_Ip = boxfilter(I.*p, r) ./ N;
cov_Ip = mean_Ip - mean_I .* mean_p; % this is the covariance of (I, p) in each local patch.

mean_II = boxfilter(I.*I, r) ./ N;
var_I = mean_II - mean_I .* mean_I;

% decomposition process
% ------------------------------------------------------------
q{1} = I;
for i = 1:length(eps)
    a = cov_Ip ./ (var_I + eps(i));
    b = mean_p - a .* mean_I;
    mean_a{i+1} = boxfilter(a, r) ./ N;
    mean_b{i+1} = boxfilter(b, r) ./ N;
   
    q{i+1} = mean_a{i+1} .* I + mean_b{i+1};
    residual_img{i} = q{i} - q{i+1};
    detail_layer = detail_layer + fcn_mapping(residual_img{i}, 'nonlinear', scale_mapping{i}(1), scale_mapping{i}(2), 0);

end

base_layer = q{end};
amb_map = mean_b{end};

end


function [ out_I, trans_map, A ] = fcn_multiscale_enhancement( I, p, box_size, scale_smooth, scale_mapping)
% The core implementation of "Multi-band-enhancement". Given predefined
% parameters, each module is operated sequentially. The detail of the
% process is implemented in each function.
% This code is motivated by the code form original guided filter
% implementation of Kaiming He (http://kaiminghe.com/eccv10/)
%
%   Input arguments:
%   ----------------
%	- I : guidance image
%   - p : filtering input image
%	- scale_smooth : predifined smoothing factors (epsilon)
%	- scale_mapping : parameters for mapping function (optional)
%   - box_size: size of default box for filtering

%% Preallocation
n_channel = size(I,3);
out_I = zeros(size(I));
base_layer = zeros(size(I));
detail_layer = zeros(size(I));
amb_map = zeros(size(I));
mean_I = zeros(size(I));
var_I = zeros(size(I));
A = zeros(1, n_channel);

%% Guided-filtering based decomposition
for i = 1:n_channel
    [base_layer(:,:,i), detail_layer(:,:,i), amb_map(:,:,i), mean_I(:,:,i), var_I(:,:,i), N] = .... 
        fcn_guided_decomposition(I(:,:,i), p(:,:,i), box_size, scale_smooth, scale_mapping);
end


%% Intensity Module

% ambient light estimation
A = fcn_estim_ambient(I, amb_map, 0);

% transmission estimation
trans_map = fcn_estim_transmission(base_layer, A, box_size, 0);


%% Laplacian Module 
if size(I,3) == 3
    guide_I = rgb2gray(base_layer);
else
    guide_I = base_layer;
end

% transmission refinement
trans_map = fcn_refine_transmission(guide_I, trans_map, box_size, mean(mean_I, 3), mean(var_I,3), N);
       

%% Color correction
if n_channel == 3
    if std(A) >  0.2
        disp ('Color biased');
        A2 = norm(A)*ones(size(A)) ./ sqrt(3);
    else
        A2 = A;
    end
else
    A2 = A;
end


%% Reconstruction
J = zeros(size(out_I));
for i = 1:n_channel
    J(:,:,i) = (base_layer(:,:,i) - A(i))./trans_map + A2(i);
    out_I(:,:,i) = J(:,:,i) + detail_layer(:,:,i);
end

end




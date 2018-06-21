function [out_img, time, trans_map, A] = fcn_multi(img)
%The main function of multi-band enhancement.
% 
% The details of the algorithm are described in our paper: 
% Model Assisted Multi-band Fusion for Single Image Enhancement and Applications to Robot Vision
% Y. Cho, J. Jeong, A. Kim, IEEE RA-L, 2018
% which can be found at:
% http://irap.kaist.ac.kr/publications/ycho-2018-ral.pdf
% If you use this code, please cite the paper.
%
%   Input arguments:
%   ----------------
%	- img : input haze image, type "double"
%	- scale_smooth : predifined smoothing factors (epsilon)
%	- scale_mapping : parameters for mapping function (optional)
%   - box_size: size of default box for filtering
%
%   Output arguments:
%   ----------------
%   - out_img: output dehazed image
%   - trans_map: transmission map
%   - A: ampbient light
%
% Author: Younggun Cho (yg.cho@kaist.ac.kr)
%
% The software code is provided under the attached LICENSE.md


scale_smooth = [1e-4, 1e-3, 1e-2]; 
% scale_mapping = {[0.5, 20], [0.8, 20], [0.8, 10]};
scale_mapping = {[0.5, 40], [0.8, 40], [0.8, 10]};
box_size = 20;

tic;

[out_img, trans_map, A] = fcn_multiscale_enhancement(img, img, box_size, scale_smooth, scale_mapping);
adj_percent = [0.005, 0.995];
out_img = imadjust(out_img, adj_percent);

time = toc;


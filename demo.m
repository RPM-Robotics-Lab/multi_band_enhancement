% This is a demo script demonstrating Model Assisted Multi-band Fusion for 
% Single Image Enhancement and Applications to Robot Vision
% Y. Cho, J. Jeong, A. Kim, IEEE RA-L, 2018
% Paper: http://irap.kaist.ac.kr/publications/ycho-2018-ral.pdf
% If you use this code, please cite our paper.
% 
% Please read the instructions on README.md in order to use this code.
%
% Author: Younggun Cho (yg.cho@kaist.ac.kr)
%
% The software code is provided under the attached LICENSE.md

clear; close all;
save_name = 'train';
img = im2double(imread('images/fattal/train_input.png'));


[dehazed_img, comp_time, trans_map] = fcn_multi(img);

imwrite(dehazed_img, ['results/' save_name '.png']);

figure(1);
imshow([img dehazed_img]);
title('Enhancement result');

figure(2);
imagesc(trans_map); 
title('transmission map');

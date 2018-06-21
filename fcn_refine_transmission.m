function [ trans_map ] = fcn_refine_transmission(I, trans_map, r, mean_I, var_I, N )
% Function for transmission refinement

    mean_I = boxfilter(I, r) ./ N;
    mean_II = boxfilter(I.*I, r) ./ N;

    var_I = mean_II - mean_I .* mean_I;
    mean_t = boxfilter(trans_map, r) ./ N;
    mean_It = boxfilter(I.*trans_map, r) ./ N;
    cov_It = mean_It - mean_I .* mean_t; % this is the covariance of (I, p) in each local patch.
    at = cov_It ./ (var_I + 0.00001);
    bt = mean_t - at.* mean_I;
    mean_at = boxfilter(at, r) ./ N;
    mean_bt = boxfilter(bt, r) ./ N;
    qt = mean_at .* I + mean_bt;
    trans_map = qt;

end


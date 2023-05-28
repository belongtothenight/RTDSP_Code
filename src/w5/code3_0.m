% Q3_0
% Create pseudo-random uniform distribution in the interval of [0, 1]
% default distribution range of rand is [0, 1]
% ===================================================================

function distribution = w5_code3_0(n, offset, unitVariance)
    distribution = rand(n, 1, "single") + offset;
    if unitVariance == "T"
        distribution = (distribution - mean(distribution)) / std(distribution);
    end
end
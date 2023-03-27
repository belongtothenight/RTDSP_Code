% Q3_5
% Run code3_1 to code3_4 in parallel
% ===================================================================

function w5_code3_5(minNum, maxNum, n, fps)
    % Create parallel pool
    parpool(6);
    % Run all 4 files together
    parfeval(@code3_1, 0, minNum, maxNum, n, fps);
    parfeval(@code3_2, 0, minNum, maxNum, n, fps);
    parfeval(@code3_3, 0, minNum, maxNum, n, fps);
    parfeval(@code3_4, 0, minNum, maxNum, n, fps);
end

% run "delete(gcp('nocreate'))" to shutdown parpool
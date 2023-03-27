% Q3_2
% Display variance value
% ==================

function w5_code3_2(minNum, maxNum, n, fps)
    function var_hist = genVarHist(minNum, maxNum)
        testArray = minNum:1:maxNum;
        arraySize = size(testArray);
        var_hist = zeros(arraySize);
        for i = 1:1:arraySize(2)
        var_hist(i) = var(w5_code3_0(i, 0, "F"));
        end
    end

    tic
    % Initialize figure
    f = figure;
    f.WindowState = "maximized";
    f.Position = [0 0 1920 1080];
    hold on;
    grid on;
    xlabel("How many random number")
    ylabel("Variance value")

    % Initialize video
    filename = strcat("Variance_Variation_", int2str(minNum), "_", int2str(maxNum), "_", int2str(n), ".avi");
    v = VideoWriter(filename); %open video file
    v.FrameRate = fps;  %30
    open(v)
    
    % Plot all mean hist
    for j = 1:1:n
        var_record = genVarHist(minNum, maxNum);
        plot(var_record, "Color", [0, 0, 1, 0.2]);
        title(strcat("Variation Variance Range | Elapse time: ", num2str(toc), " s"));
        legend(strcat(int2str(j), " th variance hist line"));
        drawnow;
        frame = getframe(gcf); %get frame
        writeVideo(v, frame);
    end
    close(v)
end



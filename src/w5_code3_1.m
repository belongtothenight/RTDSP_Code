% Q3_1
% Display mean value
% ==================

function w5_code3_1(minNum, maxNum, n, fps)
    function mean_hist = genMeanHist(minNum, maxNum)
        testArray = minNum:1:maxNum;
        arraySize = size(testArray);
        mean_hist = zeros(arraySize);
        for i = 1:1:arraySize(2)
        mean_hist(i) = mean(w5_code3_0(i, 0, "F"));
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
    ylabel("Mean value")

    % Initialize video
    filename = strcat("Mean_Variation_", int2str(minNum), "_", int2str(maxNum), "_", int2str(n), ".avi");
    v = VideoWriter(filename); %open video file
    v.FrameRate = fps;  %30
    open(v)
    
    % Plot all mean hist
    for j = 1:1:n
        mean_record = genMeanHist(minNum, maxNum);
        plot(mean_record, "Color", [0, 0, 1, 0.2]);
        title(strcat("Mean Variance Range | Elapse time: ", num2str(toc), " s"));
        legend(strcat(int2str(j), " th mean hist line"));
        drawnow;
        frame = getframe(gcf); %get frame
        writeVideo(v, frame);
    end
    close(v)
end



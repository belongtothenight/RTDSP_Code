% Q3_3
% Display zero-mean unit-variance random numbers' mean and variance
% ==================

function w5_code3_4(minNum, maxNum, n, fps)
    function mean_hist = genMeanHist(minNum, maxNum)
        testArray = minNum:1:maxNum;
        arraySize = size(testArray);
        mean_hist = zeros(arraySize);
        for i = 1:1:arraySize(2)
        mean_hist(i) = mean(w5_code3_0(i, -0.5, "T"));
        end
    end
    function var_hist = genVarHist(minNum, maxNum)
        testArray = minNum:1:maxNum;
        arraySize = size(testArray);
        var_hist = zeros(arraySize);
        for i = 1:1:arraySize(2)
        var_hist(i) = var(code3_0(i, -0.5, "T"));
        end
    end

    tic
    % Initialize figure
    f = figure;
    f.WindowState = "maximized";
    f.Position = [0 0 1920 1080];
    subplot(2, 1, 1);
    hold on;
    grid on;
    title("Mean Variance Range")
    xlabel("How many random number")
    ylabel("Mean value")
    h = axes;
    set(h,'xscale','log')
    subplot(2, 1, 2);
    hold on;
    grid on;
    title("Variation Variance Range")
    xlabel("How many random number")
    ylabel("Variance value")

    % Initialize video
    filename = strcat("Zero-mean_Unit-variance_", int2str(minNum), "_", int2str(maxNum), "_", int2str(n), ".avi");
    v = VideoWriter(filename); %open video file
    v.FrameRate = fps;  %30
    open(v)
    
    % Plot all mean hist
    for j = 1:1:n
        subplot(2, 1, 1);
        mean_record = genMeanHist(minNum, maxNum);
        plot(mean_record, "Color", [0, 0, 1, 0.2]);
        legend(strcat(int2str(j), " th mean hist line"));
        subplot(2, 1, 2);
        var_record = genVarHist(minNum, maxNum);
        plot(var_record, "Color", [0, 0, 1, 0.2]);
        
        sgtitle(strcat("Zero-mean Unit-variance Random Numbers | Elapse time: ", num2str(toc), " s"));
        legend(strcat(int2str(j), " th variance hist line"));
        drawnow;
        frame = getframe(gcf); %get frame
        writeVideo(v, frame);
    end
    close(v)
end



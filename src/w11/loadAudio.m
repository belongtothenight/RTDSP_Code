function [Fs, chunk1s, chunk2s, chunk5s, chunk10s, y, path]=w11_loadAudio(plotAudio)
    % load audio file
    path = "./classical.00000.wav";
    info = audioinfo(path);
    [y, Fs] = audioread(path);
    info
    % separate into 1s chunks
    chunk1s = y(1:Fs, :);
    chunk1s = chunk1s(:, 1);
    % separate into 2s chunks
    chunk2s = y(1:Fs*2, :);
    chunk2s = chunk2s(:, 1);
    % separate into 5s chunks
    chunk5s = y(1:Fs*5, :);
    chunk5s = chunk5s(:, 1);
    % separate into 10s chunks
    chunk10s = y(1:Fs*10, :);
    chunk10s = chunk10s(:, 1);
    % plot
    if plotAudio
        hold on;
        plot(y);
        plot(chunk1s);
        plot(chunk2s);
        plot(chunk5s);
        plot(chunk10s);
        legend('original', '1s', '2s', '5s', '10s');
        hold off;
    end
end
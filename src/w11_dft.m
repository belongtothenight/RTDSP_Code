function w11_dft
    function [f, P1]=calFP(chunk, Fs)
        L = length(chunk);
        fft_ = fft(chunk);
        P2 = abs(fft_/L);
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        f = Fs*(0:(L/2))/L;
    end
    function [pxx, f, pmax, pmin] = calWelch(chunk, Fs)
        [pxx, f] = pwelch(chunk, [], [], [], Fs);
        pmax = pwelch(chunk, [], [], [], Fs, 'maxhold');
        pmin = pwelch(chunk, [], [], [], Fs, 'minhold');
    end
    [Fs, chunk1s, chunk2s, chunk5s, chunk10s, y, path] = loadAudio(false);
    % fft of 1s
    [f_1s, P1_1s] = calFP(chunk1s, Fs);
    subplot(5,2,1)
    plot(f_1s,P1_1s)
    title('Single-Sided Amplitude Spectrum of 1s')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    % fft of 2s
    subplot(5,2,3)
    [f_2s, P1_2s] = calFP(chunk2s, Fs);
    plot(f_2s,P1_2s)
    title('Single-Sided Amplitude Spectrum of 2s')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    % fft of 5s
    subplot(5,2,5)
    [f_5s, P1_5s] = calFP(chunk5s, Fs);
    plot(f_5s,P1_5s)
    title('Single-Sided Amplitude Spectrum of 5s')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    % fft of 10s
    subplot(5,2,7)
    [f_10s, P1_10s] = calFP(chunk10s, Fs);
    plot(f_10s,P1_10s)
    title('Single-Sided Amplitude Spectrum of 10s')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    % fft of y
    subplot(5,2,9)
    [f_y, P1_y] = calFP(y, Fs);
    plot(f_y,P1_y)
    title('Single-Sided Amplitude Spectrum of y')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    % pwelch of 1s
    subplot(5,2,2)
    [pxx_1s, f_1s, pmax_1s, pmin_1s] = calWelch(chunk1s, Fs);
    hold on
    plot(f_1s,pow2db(pxx_1s))
    plot(f_1s,pow2db([pmax_1s pmin_1s]), ':')
    hold off
    title('Power Spectral Density Estimate of 1s')
    xlabel('Frequency (Hz)')
    ylabel('Power/Frequency (dB/Hz)')
    legend('pwelch','maxhold','minhold')
    % pwelch of 2s
    subplot(5,2,4)
    [pxx_2s, f_2s, pmax_2s, pmin_2s] = calWelch(chunk2s, Fs);
    hold on
    plot(f_2s,pow2db(pxx_2s))
    plot(f_2s,pow2db([pmax_2s pmin_2s]), ':')
    hold off
    title('Power Spectral Density Estimate of 2s')
    xlabel('Frequency (Hz)')
    ylabel('Power/Frequency (dB/Hz)')
    legend('pwelch','maxhold','minhold')
    % pwelch of 5s
    subplot(5,2,6)
    [pxx_5s, f_5s, pmax_5s, pmin_5s] = calWelch(chunk5s, Fs);
    hold on
    plot(f_5s,pow2db(pxx_5s))
    plot(f_5s,pow2db([pmax_5s pmin_5s]), ':')
    hold off
    title('Power Spectral Density Estimate of 5s')
    xlabel('Frequency (Hz)')
    ylabel('Power/Frequency (dB/Hz)')
    legend('pwelch','maxhold','minhold')
    % pwelch of 10s
    subplot(5,2,8)
    [pxx_10s, f_10s, pmax_10s, pmin_10s] = calWelch(chunk10s, Fs);
    hold on
    plot(f_10s,pow2db(pxx_10s))
    plot(f_10s,pow2db([pmax_10s pmin_10s]), ':')
    hold off
    title('Power Spectral Density Estimate of 10s')
    xlabel('Frequency (Hz)')
    ylabel('Power/Frequency (dB/Hz)')
    legend('pwelch','maxhold','minhold')
    % pwelch of y
    subplot(5,2,10)
    [pxx_y, f_y, pmax_y, pmin_y] = calWelch(y, Fs);
    hold on
    plot(f_y,pow2db(pxx_y))
    plot(f_y,pow2db([pmax_y pmin_y]), ':')
    hold off
    title('Power Spectral Density Estimate of y')
    xlabel('Frequency (Hz)')
    ylabel('Power/Frequency (dB/Hz)')
    legend('pwelch','maxhold','minhold')
    % title
    sgtitle(strcat('DFT and Welch''s Method of file  ', path))
end
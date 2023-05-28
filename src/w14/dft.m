function [f1, p, f2, pxx, pmax, pmin] = dft(audioData, fs)
    % Single-Sided Amplitude Spectrum of audioData (y(t))
    L = length(audioData);
    fft_ = fft(audioData);
    P2 = abs(fft_/L);
    p = P2(1:L/2+1);
    p(2:end-1) = 2*p(2:end-1);
    f1 = fs*(0:(L/2))/L;
    % Power Spectral Density
    [pxx, f2] = pwelch(audioData, [], [], [], fs);
    pmax = pwelch(audioData, [], [], [], fs, 'maxhold');
    pmin = pwelch(audioData, [], [], [], fs, 'minhold');
end
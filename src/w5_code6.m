% code2_1
% Add white noise to the 200 Hz sinewave generated in step 1 with different SNRs (0, 5, 10 dB). Use amplitude spectrum to verify that the SNR of generated signals are correct.

function w5_code6
    N=10000;
    f=200;
    fs=10000;
    n=[0:N-1];
    k=[0:N-1];
    omega=2*pi*f/fs;
    xn=sin(omega*n);
    xnPRMS = rms(xn)^2;
    xnPowBP = bandpower(xn, fs, [0 fs/2]);

    subplot(3, 4, 1);
    plot(xn);
    title(strcat('signal | f=', num2str(f), ' | pRMS=', num2str(xnPRMS), ' | powbp=', num2str(xnPowBP)));
    xlabel('time');
    ylabel('amplitude');

    noise = 2*sqrt(3)*(rand(size(xn))-0.5);
    nsPRMS = rms(noise)^2;
    nsPowBP = bandpower(noise, fs, [0 fs/2]);

    subplot(3, 4, 2);
    plot(noise);
    title(strcat('noise | pRMS=', num2str(nsPRMS), ' | powbp=', num2str(nsPowBP)));
    xlabel('time');
    ylabel('amplitude');

    corruptedSignal = xn + noise;
    csPRMS = rms(corruptedSignal)^2;
    csPowBP = bandpower(corruptedSignal, fs, [0 fs/2]);

    subplot(3, 4, 3);
    plot(corruptedSignal);
    title(strcat('corrupted signal | pRMS=', num2str(csPRMS), ' | powbp=', num2str(csPowBP)));
    xlabel('time');
    ylabel('amplitude');

    Xk = fft(corruptedSignal, N);
    magXk = 20*log10(abs(Xk));
    SNR=snr(xn, sqrt(2)/2*noise);

    subplot(3, 4, 4);
    plot(k, magXk);
    title(strcat('SNR=', num2str(SNR), 'dB | N=', num2str(N), ' | fs=', num2str(fs)));
    axis([0, N/2, -inf, inf]);
    xlabel('Frequency index, k');
    ylabel('Magnitude in dB');

    subplot(3, 4, 5);
    plot(xn);
    title(strcat('signal | f=', num2str(f), ' | pRMS=', num2str(xnPRMS), ' | powbp=', num2str(xnPowBP)));
    xlabel('time');
    ylabel('amplitude');

    noise = 2*sqrt(3)*(rand(size(xn))-0.5)*nthroot(10, 4);
    nsPRMS = rms(noise)^2;
    nsPowBP = bandpower(noise, fs, [0 fs/2]);

    subplot(3, 4, 6);
    plot(noise);
    title(strcat('noise | pRMS=', num2str(nsPRMS), ' | powbp=', num2str(nsPowBP)));
    xlabel('time');
    ylabel('amplitude');

    corruptedSignal = xn + noise;
    csPRMS = rms(corruptedSignal)^2;
    csPowBP = bandpower(corruptedSignal, fs, [0 fs/2]);

    subplot(3, 4, 7);
    plot(corruptedSignal);
    title(strcat('corrupted signal | pRMS=', num2str(csPRMS), ' | powbp=', num2str(csPowBP)));
    xlabel('time');
    ylabel('amplitude');

    Xk = fft(corruptedSignal, N);
    magXk = 20*log10(abs(Xk));
    SNR=snr(xn, sqrt(2)/2*noise);

    subplot(3, 4, 8);
    plot(k, magXk);
    title(strcat('SNR=', num2str(SNR), 'dB | N=', num2str(N), ' | fs=', num2str(fs)));
    axis([0, N/2, -inf, inf]);
    xlabel('Frequency index, k');
    ylabel('Magnitude in dB');

    subplot(3, 4, 9);
    plot(xn);
    title(strcat('signal | f=', num2str(f), ' | pRMS=', num2str(xnPRMS), ' | powbp=', num2str(xnPowBP)));
    xlabel('time');
    ylabel('amplitude');

    noise = 2*sqrt(3)*(rand(size(xn))-0.5)*nthroot(10, 2);
    nsPRMS = rms(noise)^2;
    nsPowBP = bandpower(noise, fs, [0 fs/2]);

    subplot(3, 4, 10);
    plot(noise);
    title(strcat('noise | pRMS=', num2str(nsPRMS), ' | powbp=', num2str(nsPowBP)));
    xlabel('time');
    ylabel('amplitude');

    corruptedSignal = xn + noise;
    csPRMS = rms(corruptedSignal)^2;
    csPowBP = bandpower(corruptedSignal, fs, [0 fs/2]);

    subplot(3, 4, 11);
    plot(corruptedSignal);
    title(strcat('corrupted signal | pRMS=', num2str(csPRMS), ' | powbp=', num2str(csPowBP)));
    xlabel('time');
    ylabel('amplitude');

    Xk = fft(corruptedSignal, N);
    magXk = 20*log10(abs(Xk));
    SNR=snr(xn, sqrt(2)/2*noise);

    subplot(3, 4, 12);
    plot(k, magXk);
    title(strcat('SNR=', num2str(SNR), 'dB | N=', num2str(N), ' | fs=', num2str(fs)));
    axis([0, N/2, -inf, inf]);
    xlabel('Frequency index, k');
    ylabel('Magnitude in dB');

end
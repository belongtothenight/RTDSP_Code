% code 1
% ======
% Generate 512 samples of digital sinewaves at different frequencies
% (100, 200, and 300 Hz) with the sampling rate of 1000 Hz). Use amplitude
% spectrum to verify that the frequencies of generated signals are correct.
% ////////////////////////////////////////////////////////////////////////

function w5_code5_2
    N=500;
    f1 = 100;
    f2 = 200;
    f3 = 300;
    fs=1000;
    n=[0:N-1];
    k=[0:N-1];
    omega1=2*pi*f1/fs;
    omega2=2*pi*f2/fs;
    omega3=2*pi*f3/fs;
    A=1;
    xn1=A*sin(omega1*n);
    xn2=A*sin(omega2*n);
    xn3=A*sin(omega3*n);
    Xk1=fft(xn1, N);
    Xk2=fft(xn2, N);
    Xk3=fft(xn3, N);
    magXk1=20*log10(abs(Xk1));
    magXk2=20*log10(abs(Xk2));
    magXk3=20*log10(abs(Xk3));

    figure;
    sgtitle(strcat('Amplitude spectrum of 3 sinewaves | N = ', num2str(N), ' | fs = ', num2str(fs), ' Hz'));
    subplot(3, 2, 1);
    plot(xn1);
    title('100 Hz')
    xlabel('Time index, n');
    ylabel('Amplitude');
    
    subplot(3, 2, 2);
    plot(k, magXk1);
    axis([0, N/2, -inf, inf]);
    title('100 Hz')
    xlabel('Frequency index, k');
    ylabel('Magnitude in dB');
    
    subplot(3, 2, 3);
    plot(xn2);
    title('200 Hz')
    xlabel('Time index, n');
    ylabel('Amplitude');

    subplot(3, 2, 4);
    plot(k, magXk2);
    axis([0, N/2, -inf, inf]);
    title('200 Hz')
    xlabel('Frequency index, k');
    ylabel('Magnitude in dB');

    subplot(3, 2, 5);
    plot(xn3);
    title('300 Hz')
    xlabel('Time index, n');
    ylabel('Amplitude');

    subplot(3, 2, 6);
    plot(k, magXk3);
    axis([0, N/2, -inf, inf]);
    title('300 Hz')
    xlabel('Frequency index, k');
    ylabel('Magnitude in dB');
end
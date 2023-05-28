% global setting
dt = 1e-6; % precision
maxT = 2e-3; % max time
maxF = 10;
s1F = 3e3;
s2F = 5e3;
Fs = 6e3;

[s1, ss1, t1, n1] = signal_sampling(1, s1F, 0, Fs, maxT, dt);
[s2, ss2, t2, n2] = signal_sampling(1, s2F, 0, Fs, maxT, dt);

subplot(3, 3, 1);
plot(t1, s1);
xlabel('time(sec)');
ylabel('Amplitude');
title("Signal 1 " + s1F/1e3 + "kHz Sine");
subplot(3, 3, 2);
stem(n1, ss1);
xlabel('time(sec)');
ylabel('Amplitude');
title("Sampling signal 1 with " + Fs/1e3 + "kHz");
subplot(3, 3, 3);
pxx = pwelch(s1,[],[],[],Fs);
pxx = pxx(1:maxF);
plot(pxx);
xlabel('Frequency');
ylabel('Power');
title('Spectrum');

subplot(3, 3, 4);
plot(t2, s2);
xlabel('time(sec)');
ylabel('Amplitude');
title("Signal 2 " + s2F/1e3 + "kHz Sine")
subplot(3, 3, 5);
stem(n2, ss2);
xlabel('time(sec)');
ylabel('Amplitude');
title("Sampling signal 2 with " + Fs/1e3 + "kHz")
subplot(3, 3, 6);
pxx = pwelch(s2,[],[],[],Fs);
pxx = pxx(1:maxF);
plot(pxx);
xlabel('Frequency');
ylabel('Power');
title('Spectrum');

subplot(3, 3, 7);
plot(t1, s1+s2);
xlabel('time(sec)');
ylabel('Amplitude');
title('Signal 1+2');
subplot(3, 3, 8);
stem(n1, ss1+ss2);
xlabel('time(sec)');
ylabel('Amplitude');
title("Sampling signal 1+2 with " + Fs/1e3 + "kHz")
subplot(3, 3, 9);
pxx = pwelch(s1+s2,[],[],[],Fs);
pxx = pxx(1:maxF);
plot(pxx);
xlabel('Frequency');
ylabel('Power');
title('Spectrum');

function [s, ss, t, n] = signal_sampling(A, F, theta, Fs, maxT, dt)
    % =========================================================
    % This function is to generate signal and sampled signal
    % Input:
    %   A: amplitude
    %   F: frequency
    %   theta: phase
    %   Fs: sampling frequency
    %   maxT: max time
    %   dt: time precision
    % Output:
    %   s: signal
    %   ss: sampled signal
    %   t: time
    %   n: sampling time
    % =========================================================
    t = 0:dt:maxT;
    s = A * sin(2*pi*F*t + theta);
    T = 1/Fs;
    n = 0:T:maxT;
    ss = A * sin(2*pi*F*n + theta);
end
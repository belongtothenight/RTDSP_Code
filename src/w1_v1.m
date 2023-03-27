% global setting
dt = 0.001; % precision
maxT = 2;
t = 0:dt:maxT;
pltNum = 9;

% signal 1 sine 3 Hz
A = 1; F = 3; theta = 0;
s1 = A * sin(2*pi*F*t + theta);
% sampling 6 Hz signal 1
Fs = 6; T = 1/Fs;
n = 0:T:maxT;
ss1 = A * sin(2*pi*F*n + theta);

% signal 2 sine 5 Hz
A = 1; F = 5; theta = 0;
s2 = A * sin(2*pi*F*t + theta);
% sampling 6 Hz signal 2
Fs = 6; T = 1/Fs;
n = 0:T:maxT;
ss2 = A * sin(2*pi*F*n + theta);

% signal 1 + 2
st = s1 + s2;
% sampling 6 Hz signal 1 + 2
sst = ss1 + ss2;

% spectrum
% https://www.mathworks.com/matlabcentral/answers/251061-how-to-plot-frequency-spectrum-of-a-signal-in-matlab
p1 = pspectrum(s1);
p2 = pspectrum(s2);
pt = pspectrum(st);

% subplot 1 signal 1
subplot(pltNum/3, pltNum/3, 1);
plot(t, s1);
xlabel('time(sec)');
ylabel('s1');
title('Signal 1 3Hz Sine');
% subplot 2 sampling signal 1
subplot(pltNum/3, pltNum/3, 2);
stem(n, ss1);
xlabel('time(sec)');
ylabel('ss1');
title('Sampling signal 1');
% subplot 3 spectrum signal 1
subplot(pltNum/3, pltNum/3, 3);
plot(p1);
xlabel('frequency(Hz)');
ylabel('p1');
title('Spectrum signal 1');

% subplot 4 signal 2
subplot(pltNum/3, pltNum/3, 4);
plot(t, s2);
xlabel('time(sec)');
ylabel('s2');
title('Signal 2 5Hz Sine');
% subplot 5 sampling signal 2
subplot(pltNum/3, pltNum/3, 5);
stem(n, ss2);
xlabel('time(sec)');
ylabel('ss2');
title('Sampling signal 2');
% subplot 6 spectrum signal 2
subplot(pltNum/3, pltNum/3, 6);
plot(p2);
xlabel('frequency(Hz)');
ylabel('p2');
title('Spectrum signal 2');

% subplot 7 signal 1 + 2
subplot(pltNum/3, pltNum/3, 7);
plot(t, st);
xlabel('time(sec)');
ylabel('st');
title('Signal 1+2');
% subplot 8 sampling signal 1 + 2
subplot(pltNum/3, pltNum/3, 8);
stem(n, sst);
xlabel('time(sec)');
ylabel('sst');
title('Sampling signal 1+2');
% subplot 9 spectrum signal 1+2
subplot(pltNum/3, pltNum/3, 9);
plot(pt);
xlabel('frequency(Hz)');
ylabel('pt');
title('Spectrum signal 1+2');
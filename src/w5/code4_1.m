% Q4_1
% Creating 0dB SNR noise & signal
% ===============================

N=10000;
f=1000;
fs=10000;
n=[0:N-1];
k=[0:N-1];
omega=2*pi*f/fs;
xn=sin(omega*n);
xnPRMS = rms(xn)^2;
xnPowBP = bandpower(xn, fs, [0 fs/2]);

subplot(2, 1, 1);
plot(xn);
title(strcat('signal | pRMS=', num2str(xnPRMS), ' | powbp=', num2str(xnPowBP)));
xlabel('time');
ylabel('amplitude');

noise = 2*sqrt(3)*(rand(size(xn))-0.5);
xnPRMS = rms(noise)^2;
xnPowBP = bandpower(noise, fs, [0 fs/2]);

subplot(2, 1, 2);
plot(noise);
title(strcat('noise | pRMS=', num2str(xnPRMS), ' | powbp=', num2str(xnPowBP)));
xlabel('time');
ylabel('amplitude');

SNR=snr(xn, sqrt(2)/2*noise);
sgtitle(['SNR=', num2str(SNR), 'dB']);
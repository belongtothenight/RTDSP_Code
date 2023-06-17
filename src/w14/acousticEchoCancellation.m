% originalAudio = ".\HW\p232_365.wav"; %! timit_a_
originalAudio = ".\TIMIT\TEST\DR1\FAKS0\SA1.WAV"; %! timit_b_
outputPath = ".\output\";
playback = 0;
plotPlot = 1;
writeAudio = 1;
writeWeights = 1;
subplotx = 3;
subploty = 3;

[status, msg, msgID] = mkdir(outputPath);

%* Read the audio file
[info, u_n, fs] = readAudio(originalAudio);
%! Use 600Hz sine wave to test the acoustic echo cancellation
u_n = (0.1*sin(2*pi*600*t_1))';
%!
ts = 1/fs;
t_1 = linspace(0, length(u_n)/fs, length(u_n));
[f1_1, p_1, f2_1, pxx_1, pmax_1, pmin_1] = dft(u_n, fs);
if playback == 1
    soundsc(u_n, fs);
end
if writeAudio == 1
    audiowrite(strcat(outputPath, 'raw_audio.wav'), u_n, fs);
end

%* Send the audio through the simulated acoustic echo with FIR filter
p_z = fir1(511, 0.9); % acoustic echo path P(z)
d_n = filter(p_z, 1, u_n) .* -1; % simulated acoustic echo
t_2 = linspace(0, length(d_n)/fs, length(d_n));
[f1_2, p_2, f2_2, pxx_2, pmax_2, pmin_2] = dft(d_n, fs);
if playback == 1
    soundsc(d_n, fs);
end
if writeAudio == 1
    audiowrite(strcat(outputPath, 'simulated_acoustic_echo_path.wav'), d_n, fs);
end

%* Without the acoustic echo cancellation
e_n = u_n - d_n;
t_3 = linspace(0, length(e_n)/fs, length(e_n));
[f1_3, p_3, f2_3, pxx_3, pmax_3, pmin_3] = dft(e_n, fs);
if playback == 1
    soundsc(e_n, fs);
end
if writeAudio == 1
    audiowrite(strcat(outputPath, 'without_acoustic_echo_cancellation.wav'), e_n, fs);
end

%* With LMS-256 acoustic echo cancellation
LMSmethod = 'LMS';
LMSlength = 256;
LMSstepSize = 0.01;
[y_n_lms256, e_n_lms256, t_4, f1_4, p_4, f2_4, pxx_4, pmax_4, pmin_4] = LMSprocedure(u_n, d_n, fs, outputPath, LMSmethod, LMSlength, LMSstepSize, playback, writeAudio, writeWeights);

%* With LMS-512 acoustic echo cancellation
LMSmethod = 'LMS';
LMSlength = 512;
LMSstepSize = 0.01;
[y_n_lms512, e_n_lms512, t_5, f1_5, p_5, f2_5, pxx_5, pmax_5, pmin_5] = LMSprocedure(u_n, d_n, fs, outputPath, LMSmethod, LMSlength, LMSstepSize, playback, writeAudio, writeWeights);

%* With LMS-1024 acoustic echo cancellation
LMSmethod = 'LMS';
LMSlength = 1024;
LMSstepSize = 0.01;
[y_n_lms1024, e_n_lms1024, t_6, f1_6, p_6, f2_6, pxx_6, pmax_6, pmin_6] = LMSprocedure(u_n, d_n, fs, outputPath, LMSmethod, LMSlength, LMSstepSize, playback, writeAudio, writeWeights);

%* With NLMS-256 acoustic echo cancellation
LMSmethod = 'Normalized LMS';
LMSlength = 256;
LMSstepSize = 0.01;
[y_n_nlms256, e_n_nlms256, t_7, f1_7, p_7, f2_7, pxx_7, pmax_7, pmin_7] = LMSprocedure(u_n, d_n, fs, outputPath, LMSmethod, LMSlength, LMSstepSize, playback, writeAudio, writeWeights);

%* With NLMS-512 acoustic echo cancellation
LMSmethod = 'Normalized LMS';
LMSlength = 512;
LMSstepSize = 0.01;
[y_n_nlms512, e_n_nlms512, t_8, f1_8, p_8, f2_8, pxx_8, pmax_8, pmin_8] = LMSprocedure(u_n, d_n, fs, outputPath, LMSmethod, LMSlength, LMSstepSize, playback, writeAudio, writeWeights);

%* With NLMS-1024 acoustic echo cancellation
LMSmethod = 'Normalized LMS';
LMSlength = 1024;
LMSstepSize = 0.01;
[y_n_nlms1024, e_n_nlms1024, t_9, f1_9, p_9, f2_9, pxx_9, pmax_9, pmin_9] = LMSprocedure(u_n, d_n, fs, outputPath, LMSmethod, LMSlength, LMSstepSize, playback, writeAudio, writeWeights);

%* With custom LMS-256 acoustic echo cancellation
LMSmethod = 'LMS';
LMSlength = 256;
LMSstepSize = 0.01;
[y_n_lms_ct_256, e_n_lms_ct_256, t_ct_4, f1_ct_4, p_ct_4, f2_ct_4, pxx_ct_4, pmax_ct_4, pmin_ct_4, wts_lms_ct_256, lms_lc_ct_256, lms_erle_ct_256] = LMSprocedure2(u_n, d_n, fs, outputPath, LMSmethod, LMSlength, LMSstepSize, playback, writeAudio, writeWeights);

%* With custom LMS-512 acoustic echo cancellation
LMSmethod = 'LMS';
LMSlength = 512;
LMSstepSize = 0.01;
[y_n_lms_ct_512, e_n_lms_ct_512, t_ct_5, f1_ct_5, p_ct_5, f2_ct_5, pxx_ct_5, pmax_ct_5, pmin_ct_5, wts_lms_ct_512, lms_lc_ct_512, lms_erle_ct_512] = LMSprocedure2(u_n, d_n, fs, outputPath, LMSmethod, LMSlength, LMSstepSize, playback, writeAudio, writeWeights);

%* With custom LMS-1024 acoustic echo cancellation
LMSmethod = 'LMS';
LMSlength = 1024;
LMSstepSize = 0.01;
[y_n_lms_ct_1024, e_n_lms_ct_1024, t_ct_6, f1_ct_6, p_ct_6, f2_ct_6, pxx_ct_6, pmax_ct_6, pmin_ct_6, wts_lms_ct_1024, lms_lc_ct_1024, lms_erle_ct_1024] = LMSprocedure2(u_n, d_n, fs, outputPath, LMSmethod, LMSlength, LMSstepSize, playback, writeAudio, writeWeights);

%* With custom NLMS-256 acoustic echo cancellation
LMSmethod = 'Normalized LMS';
LMSlength = 256;
LMSstepSize = 0.01;
[y_n_nlms_ct_256, e_n_nlms_ct_256, t_ct_7, f1_ct_7, p_ct_7, f2_ct_7, pxx_ct_7, pmax_ct_7, pmin_ct_7, wts_nlms_ct_256, nlms_lc_ct_256, nlms_erle_ct_256] = LMSprocedure2(u_n, d_n, fs, outputPath, LMSmethod, LMSlength, LMSstepSize, playback, writeAudio, writeWeights);

%* With custom NLMS-512 acoustic echo cancellation
LMSmethod = 'Normalized LMS';
LMSlength = 512;
LMSstepSize = 0.01;
[y_n_nlms_ct_512, e_n_nlms_ct_512, t_ct_8, f1_ct_8, p_ct_8, f2_ct_8, pxx_ct_8, pmax_ct_8, pmin_ct_8, wts_nlms_ct_512, nlms_lc_ct_512, nlms_erle_ct_512] = LMSprocedure2(u_n, d_n, fs, outputPath, LMSmethod, LMSlength, LMSstepSize, playback, writeAudio, writeWeights);

%* With custom NLMS-1024 acoustic echo cancellation
LMSmethod = 'Normalized LMS';
LMSlength = 1024;
LMSstepSize = 0.01;
[y_n_nlms_ct_1024, e_n_nlms_ct_1024, t_ct_9, f1_ct_9, p_ct_9, f2_ct_9, pxx_ct_9, pmax_ct_9, pmin_ct_9, wts_nlms_ct_1024, nlms_lc_ct_1024, nlms_erle_ct_1024] = LMSprocedure2(u_n, d_n, fs, outputPath, LMSmethod, LMSlength, LMSstepSize, playback, writeAudio, writeWeights);

if plotPlot == 1
    %! Official Library LMS
    %* Plotting the raw audio
    figure(1);
    sgtitle('Acoustic Echo Cancellation Raw Audio');
    subplot(subplotx, subploty, 1);
    plot(t_1, u_n);
    title('Raw Audio');
    xlabel('Time');
    ylabel('Amplitude');
    subplot(subplotx, subploty, 2);
    plot(t_2, d_n);
    title('Simulated Acoustic Echo Path');
    xlabel('Time');
    ylabel('Amplitude');
    subplot(subplotx, subploty, 3);
    plot(t_3, e_n);
    title('Without Acoustic Echo Cancellation');
    xlabel('Time');
    ylabel('Amplitude');
    subplot(subplotx, subploty, 4);
    plot(t_4, e_n_lms256);
    title('LMS-256');
    xlabel('Time');
    ylabel('Amplitude');
    subplot(subplotx, subploty, 5);
    plot(t_5, e_n_lms512);
    title('LMS-512');
    xlabel('Time');
    ylabel('Amplitude');
    subplot(subplotx, subploty, 6);
    plot(t_6, e_n_lms1024);
    title('LMS-1024');
    xlabel('Time');
    ylabel('Amplitude');
    subplot(subplotx, subploty, 7);
    plot(t_7, e_n_nlms256);
    title('NLMS-256');
    xlabel('Time');
    ylabel('Amplitude');
    subplot(subplotx, subploty, 8);
    plot(t_8, e_n_nlms512);
    title('NLMS-512');
    xlabel('Time');
    ylabel('Amplitude');
    subplot(subplotx, subploty, 9);
    plot(t_9, e_n_nlms1024);
    title('NLMS-1024');
    xlabel('Time');
    ylabel('Amplitude');

    %* Single-sided amplitude spectrum
    figure(2);
    sgtitle('Acoustic Echo Cancellation Single-Sided Amplitude Spectrum');
    subplot(subplotx, subploty, 1);
    plot(f1_1, p_1);
    title('Raw Audio');
    xlabel('Frequency (Hz)');
    ylabel('|P1(f)|');
    subplot(subplotx, subploty, 2);
    plot(f1_2, p_2);
    title('Simulated Acoustic Echo Path');
    xlabel('Frequency (Hz)');
    ylabel('|P1(f)|');
    subplot(subplotx, subploty, 3);
    plot(f1_3, p_3);
    title('Without Acoustic Echo Cancellation');
    xlabel('Frequency (Hz)');
    ylabel('|P1(f)|');
    subplot(subplotx, subploty, 4);
    plot(f1_4, p_4);
    title('LMS-256');
    xlabel('Frequency (Hz)');
    ylabel('|P1(f)|');
    subplot(subplotx, subploty, 5);
    plot(f1_5, p_5);
    title('LMS-512');
    xlabel('Frequency (Hz)');
    ylabel('|P1(f)|');
    subplot(subplotx, subploty, 6);
    plot(f1_6, p_6);
    title('LMS-1024');
    xlabel('Frequency (Hz)');
    ylabel('|P1(f)|');
    subplot(subplotx, subploty, 7);
    plot(f1_7, p_7);
    title('NLMS-256');
    xlabel('Frequency (Hz)');
    ylabel('|P1(f)|');
    subplot(subplotx, subploty, 8);
    plot(f1_8, p_8);
    title('NLMS-512');
    xlabel('Frequency (Hz)');
    ylabel('|P1(f)|');
    subplot(subplotx, subploty, 9);
    plot(f1_9, p_9);
    title('NLMS-1024');
    xlabel('Frequency (Hz)');
    ylabel('|P1(f)|');

    %* Power spectrum density
    figure(3);
    sgtitle('Acoustic Echo Cancellation Power Spectrum Density');
    subplot(subplotx, subploty, 1);
    hold on;
    plot(f2_1, pow2db(pxx_1));
    plot(f2_1, pow2db(pmax_1));
    plot(f2_1, pow2db(pmin_1));
    title('Raw Audio');
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    legend('PSD', 'PSD Max', 'PSD Min');
    hold off;
    subplot(subplotx, subploty, 2);
    hold on;
    plot(f2_2, pow2db(pxx_2));
    plot(f2_2, pow2db(pmax_2));
    plot(f2_2, pow2db(pmin_2));
    title('Simulated Acoustic Echo Path');
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    legend('PSD', 'PSD Max', 'PSD Min');
    hold off;
    subplot(subplotx, subploty, 3);
    hold on;
    plot(f2_3, pow2db(pxx_3));
    plot(f2_3, pow2db(pmax_3));
    plot(f2_3, pow2db(pmin_3));
    title('Without Acoustic Echo Cancellation');
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    legend('PSD', 'PSD Max', 'PSD Min');
    hold off;
    subplot(subplotx, subploty, 4);
    hold on;
    plot(f2_4, pow2db(pxx_4));
    plot(f2_4, pow2db(pmax_4));
    plot(f2_4, pow2db(pmin_4));
    title('LMS-256');
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    legend('PSD', 'PSD Max', 'PSD Min');
    hold off;
    subplot(subplotx, subploty, 5);
    hold on;
    plot(f2_5, pow2db(pxx_5));
    plot(f2_5, pow2db(pmax_5));
    plot(f2_5, pow2db(pmin_5));
    title('LMS-512');
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    legend('PSD', 'PSD Max', 'PSD Min');
    hold off;
    subplot(subplotx, subploty, 6);
    hold on;
    plot(f2_6, pow2db(pxx_6));
    plot(f2_6, pow2db(pmax_6));
    plot(f2_6, pow2db(pmin_6));
    title('LMS-1024');
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    legend('PSD', 'PSD Max', 'PSD Min');
    hold off;
    subplot(subplotx, subploty, 7);
    hold on;
    plot(f2_7, pow2db(pxx_7));
    plot(f2_7, pow2db(pmax_7));
    plot(f2_7, pow2db(pmin_7));
    title('NLMS-256');
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    legend('PSD', 'PSD Max', 'PSD Min');
    hold off;
    subplot(subplotx, subploty, 8);
    hold on;
    plot(f2_8, pow2db(pxx_8));
    plot(f2_8, pow2db(pmax_8));
    plot(f2_8, pow2db(pmin_8));
    title('NLMS-512');
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    legend('PSD', 'PSD Max', 'PSD Min');
    hold off;
    subplot(subplotx, subploty, 9);
    hold on;
    plot(f2_9, pow2db(pxx_9));
    plot(f2_9, pow2db(pmax_9));
    plot(f2_9, pow2db(pmin_9));
    title('NLMS-1024');
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    legend('PSD', 'PSD Max', 'PSD Min');
    hold off;

    %! Custom Coded LMS
    %* Plotting the raw audio
    figure(4);
    sgtitle('Custom Acoustic Echo Cancellation Raw Audio');
    subplot(subplotx, subploty, 1);
    plot(t_1, u_n);
    title('Raw Audio');
    xlabel('Time');
    ylabel('Amplitude');
    subplot(subplotx, subploty, 2);
    plot(t_2, d_n);
    title('Simulated Acoustic Echo Path');
    xlabel('Time');
    ylabel('Amplitude');
    subplot(subplotx, subploty, 3);
    plot(t_3, e_n);
    title('Without Acoustic Echo Cancellation');
    xlabel('Time');
    ylabel('Amplitude');
    subplot(subplotx, subploty, 4);
    plot(t_ct_4, e_n_lms_ct_256);
    title('LMS-256');
    xlabel('Time');
    ylabel('Amplitude');
    subplot(subplotx, subploty, 5);
    plot(t_ct_5, e_n_lms_ct_512);
    title('LMS-512');
    xlabel('Time');
    ylabel('Amplitude');
    subplot(subplotx, subploty, 6);
    plot(t_ct_6, e_n_lms_ct_1024);
    title('LMS-1024');
    xlabel('Time');
    ylabel('Amplitude');
    subplot(subplotx, subploty, 7);
    plot(t_ct_7, e_n_nlms_ct_256);
    title('NLMS-256');
    xlabel('Time');
    ylabel('Amplitude');
    subplot(subplotx, subploty, 8);
    plot(t_ct_8, e_n_nlms_ct_512);
    title('NLMS-512');
    xlabel('Time');
    ylabel('Amplitude');
    subplot(subplotx, subploty, 9);
    plot(t_ct_9, e_n_nlms_ct_1024);
    title('NLMS-1024');
    xlabel('Time');
    ylabel('Amplitude');

    %* Single-sided amplitude spectrum
    figure(5);
    sgtitle('Custom Acoustic Echo Cancellation Single-Sided Amplitude Spectrum');
    subplot(subplotx, subploty, 1);
    plot(f1_1, p_1);
    title('Raw Audio');
    xlabel('Frequency (Hz)');
    ylabel('|P1(f)|');
    subplot(subplotx, subploty, 2);
    plot(f1_2, p_2);
    title('Simulated Acoustic Echo Path');
    xlabel('Frequency (Hz)');
    ylabel('|P1(f)|');
    subplot(subplotx, subploty, 3);
    plot(f1_3, p_3);
    title('Without Acoustic Echo Cancellation');
    xlabel('Frequency (Hz)');
    ylabel('|P1(f)|');
    subplot(subplotx, subploty, 4);
    plot(f1_ct_4, p_ct_4);
    title('LMS-256');
    xlabel('Frequency (Hz)');
    ylabel('|P1(f)|');
    subplot(subplotx, subploty, 5);
    plot(f1_ct_5, p_ct_5);
    title('LMS-512');
    xlabel('Frequency (Hz)');
    ylabel('|P1(f)|');
    subplot(subplotx, subploty, 6);
    plot(f1_ct_6, p_ct_6);
    title('LMS-1024');
    xlabel('Frequency (Hz)');
    ylabel('|P1(f)|');
    subplot(subplotx, subploty, 7);
    plot(f1_ct_7, p_ct_7);
    title('NLMS-256');
    xlabel('Frequency (Hz)');
    ylabel('|P1(f)|');
    subplot(subplotx, subploty, 8);
    plot(f1_ct_8, p_ct_8);
    title('NLMS-512');
    xlabel('Frequency (Hz)');
    ylabel('|P1(f)|');
    subplot(subplotx, subploty, 9);
    plot(f1_ct_9, p_ct_9);
    title('NLMS-1024');
    xlabel('Frequency (Hz)');
    ylabel('|P1(f)|');

    %* Power spectrum density
    figure(6);
    sgtitle('Custom Acoustic Echo Cancellation Power Spectrum Density');
    subplot(subplotx, subploty, 1);
    hold on;
    plot(f2_1, pow2db(pxx_1));
    plot(f2_1, pow2db(pmax_1));
    plot(f2_1, pow2db(pmin_1));
    title('Raw Audio');
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    legend('PSD', 'PSD Max', 'PSD Min');
    hold off;
    subplot(subplotx, subploty, 2);
    hold on;
    plot(f2_2, pow2db(pxx_2));
    plot(f2_2, pow2db(pmax_2));
    plot(f2_2, pow2db(pmin_2));
    title('Simulated Acoustic Echo Path');
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    legend('PSD', 'PSD Max', 'PSD Min');
    hold off;
    subplot(subplotx, subploty, 3);
    hold on;
    plot(f2_3, pow2db(pxx_3));
    plot(f2_3, pow2db(pmax_3));
    plot(f2_3, pow2db(pmin_3));
    title('Without Acoustic Echo Cancellation');
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    legend('PSD', 'PSD Max', 'PSD Min');
    hold off;
    subplot(subplotx, subploty, 4);
    hold on;
    plot(f2_ct_4, pow2db(pxx_ct_4));
    plot(f2_ct_4, pow2db(pmax_ct_4));
    plot(f2_ct_4, pow2db(pmin_ct_4));
    title('LMS-256');
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    legend('PSD', 'PSD Max', 'PSD Min');
    hold off;
    subplot(subplotx, subploty, 5);
    hold on;
    plot(f2_ct_5, pow2db(pxx_ct_5));
    plot(f2_ct_5, pow2db(pmax_ct_5));
    plot(f2_ct_5, pow2db(pmin_ct_5));
    title('LMS-512');
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    legend('PSD', 'PSD Max', 'PSD Min');
    hold off;
    subplot(subplotx, subploty, 6);
    hold on;
    plot(f2_ct_6, pow2db(pxx_ct_6));
    plot(f2_ct_6, pow2db(pmax_ct_6));
    plot(f2_ct_6, pow2db(pmin_ct_6));
    title('LMS-1024');
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    legend('PSD', 'PSD Max', 'PSD Min');
    hold off;
    subplot(subplotx, subploty, 7);
    hold on;
    plot(f2_ct_7, pow2db(pxx_ct_7));
    plot(f2_ct_7, pow2db(pmax_ct_7));
    plot(f2_ct_7, pow2db(pmin_ct_7));
    title('NLMS-256');
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    legend('PSD', 'PSD Max', 'PSD Min');
    hold off;
    subplot(subplotx, subploty, 8);
    hold on;
    plot(f2_ct_8, pow2db(pxx_ct_8));
    plot(f2_ct_8, pow2db(pmax_ct_8));
    plot(f2_ct_8, pow2db(pmin_ct_8));
    title('NLMS-512');
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    legend('PSD', 'PSD Max', 'PSD Min');
    hold off;
    subplot(subplotx, subploty, 9);
    hold on;
    plot(f2_ct_9, pow2db(pxx_ct_9));
    plot(f2_ct_9, pow2db(pmax_ct_9));
    plot(f2_ct_9, pow2db(pmin_ct_9));
    title('NLMS-1024');
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    legend('PSD', 'PSD Max', 'PSD Min');
    hold off;

    %* Plotting learning curve
    figure(7);
    sgtitle('Learning Curve');
    subplot(subplotx-1, subploty, 1);
    plot(lms_lc_ct_256);
    title('LMS-256');
    xlabel('Iterations');
    ylabel('MSE');
    subplot(subplotx-1, subploty, 2);
    plot(lms_lc_ct_512);
    title('LMS-512');
    xlabel('Iterations');
    ylabel('MSE');
    subplot(subplotx-1, subploty, 3);
    plot(lms_lc_ct_1024);
    title('LMS-1024');
    xlabel('Iterations');
    ylabel('MSE');
    subplot(subplotx-1, subploty, 4);
    plot(nlms_lc_ct_256);
    title('NLMS-256');
    xlabel('Iterations');
    ylabel('MSE');
    subplot(subplotx-1, subploty, 5);
    plot(nlms_lc_ct_512);
    title('NLMS-512');
    xlabel('Iterations');
    ylabel('MSE');
    subplot(subplotx-1, subploty, 6);
    plot(nlms_lc_ct_1024);
    title('NLMS-1024');
    xlabel('Iterations');
    ylabel('MSE');

    %* Plotting ERLE
    figure(8);
    sgtitle('Echo Return Loss Enhancement');
    subplot(subplotx-1, subploty, 1);
    plot(lms_erle_ct_256);
    title('LMS-256');
    xlabel('Iterations');
    ylabel('ERLE');
    subplot(subplotx-1, subploty, 2);
    plot(lms_erle_ct_512);
    title('LMS-512');
    xlabel('Iterations');
    ylabel('ERLE');
    subplot(subplotx-1, subploty, 3);
    plot(lms_erle_ct_1024);
    title('LMS-1024');
    xlabel('Iterations');
    ylabel('ERLE');
    subplot(subplotx-1, subploty, 4);
    plot(nlms_erle_ct_256);
    title('NLMS-256');
    xlabel('Iterations');
    ylabel('ERLE');
    subplot(subplotx-1, subploty, 5);
    plot(nlms_erle_ct_512);
    title('NLMS-512');
    xlabel('Iterations');
    ylabel('ERLE');
    subplot(subplotx-1, subploty, 6);
    plot(nlms_erle_ct_1024);
    title('NLMS-1024');
    xlabel('Iterations');
    ylabel('ERLE');
end

function [y_n_lms, e_n_lms, t, f1, p, f2, pxx, pmax, pmin] = LMSprocedure(inputSignal, desiredSignal, fs, outputPath, LMSmethod, LMSlength, LMSstepSize, playbacFlag, writeAudioFlag, writeWeightsFlag)
    lms = dsp.LMSFilter(LMSlength, 'Method', LMSmethod, 'StepSize', LMSstepSize);
    [y_n_lms, e_n_lms, wts_lms] = lms(inputSignal, desiredSignal);
    t = linspace(0, length(e_n_lms)/fs, length(e_n_lms));
    [f1, p, f2, pxx, pmax, pmin] = dft(e_n_lms, fs);
    if playbacFlag == 1
        soundsc(e_n_lms, fs);
    end
    if writeAudioFlag == 1
        audiowrite(strcat(outputPath, 'with_', LMSmethod, '_', num2str(LMSlength), '_', num2str(LMSstepSize), '_acoustic_echo_cancellation.wav'), e_n_lms, fs);
    end
    if writeWeightsFlag == 1
        wts_lms = flip(wts_lms, 1);
        writematrix(wts_lms, strcat(outputPath, 'with_', LMSmethod, '_', num2str(LMSlength), '_', num2str(LMSstepSize), '_acoustic_echo_cancellation_weights.csv'));
    end
end

function [y_n_lms, e_n_lms, t, f1, p, f2, pxx, pmax, pmin, wts_lms, lc, erle] = LMSprocedure2(inputSignal, desiredSignal, fs, outputPath, LMSmethod, LMSlength, LMSstepSize, playbacFlag, writeAudioFlag, writeWeightsFlag)
    if LMSmethod == "LMS"
        [y_n_lms, e_n_lms, wts_lms, lc, erle] = LMS(inputSignal, desiredSignal, LMSstepSize, LMSlength);
    elseif LMSmethod == "Normalized LMS"
        [y_n_lms, e_n_lms, wts_lms, lc, erle] = NLMS(inputSignal, desiredSignal, LMSstepSize, LMSlength);
    end
    t = linspace(0, length(e_n_lms)/fs, length(e_n_lms));
    [f1, p, f2, pxx, pmax, pmin] = dft(e_n_lms, fs);
    if playbacFlag == 1
        soundsc(e_n_lms, fs);
    end
    if writeAudioFlag == 1
        audiowrite(strcat(outputPath, 'with_custom_', LMSmethod, '_', num2str(LMSlength), '_', num2str(LMSstepSize), '_acoustic_echo_cancellation.wav'), e_n_lms, fs);
    end
    if writeWeightsFlag == 1
        wts_lms = flip(wts_lms, 1);
        writematrix(wts_lms, strcat(outputPath, 'with_custom_', LMSmethod, '_', num2str(LMSlength), '_', num2str(LMSstepSize), '_acoustic_echo_cancellation_weights.csv'));
    end
end
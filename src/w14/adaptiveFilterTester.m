originalAudio = ".\TIMIT\TEST\DR1\FAKS0\SA1.WAV";
outputPath = ".\output\";
playback = 0;
plotPlot = 1;
writeAudio = 0;
writeWeights = 1;
subplotx = 3;
subploty = 3;
order = 1024;

[status, msg, msgID] = mkdir(outputPath);

%* Read the audio file
[info, u_n, fs] = readAudio(originalAudio);
ts = 1/fs;
t_1 = linspace(0, length(u_n)/fs, length(u_n));
[f1_1, p_1, f2_1, pxx_1, pmax_1, pmin_1] = dft(u_n, fs);
% replace u_n with 50Hz noise
u_n = (0.1*sin(2*pi*50*t_1))';
disp('Read Audio Complete.');

%* Send the audio through the simulated acoustic echo with FIR filter
p_z = fir1(511, 0.9); % acoustic echo path P(z)
d_n = filter(p_z, 1, u_n) .* -1; % simulated acoustic echo
t_2 = linspace(0, length(d_n)/fs, length(d_n));
[f1_2, p_2, f2_2, pxx_2, pmax_2, pmin_2] = dft(d_n, fs);
disp('Simulated Acoustic Echo Path Complete.');

%* Modify for testing
% u_n = u_n(1:order+1);
% d_n = d_n(1:order+1);

%* LMS/NLMS-256 Standard Library
LMSmethod = 'Normalized LMS';
LMSlength = order;
LMSstepSize = 0.01;
[y_n_lms_st, e_n_lms_st, t_st, f1_st, p_st, f2_st, pxx_st, pmax_st, pmin_st, wts_lms_st] = LMSprocedure1(u_n, d_n, fs, outputPath, LMSmethod, LMSlength, LMSstepSize, playback, writeAudio, writeWeights);
audiowrite(strcat(outputPath, 'y_n_lms_st.wav'), y_n_lms_st, fs);

%* LMS/NLMS-256 Custom Library
LMSlength = order;
LMSstepSize = 0.01;
[y_n_lms_ct, e_n_lms_ct, t_ct, f1_ct, p_ct, f2_ct, pxx_ct, pmax_ct, pmin_ct, wts_lms_ct, lc_ct, erle_ct] = LMSprocedure2(u_n, d_n, fs, outputPath, LMSmethod, LMSlength, LMSstepSize, playback, writeAudio, writeWeights);

%* Plotting LMS/NLMS
figure(1);
plot(lc_ct);
title('Learning Curve');
figure(2);
plot(erle_ct);
title('ERLE');
audiowrite(strcat(outputPath, 'y_n_lms_ct.wav'), y_n_lms_ct, fs);

%* Compare the two LMS/NLMS methods
if y_n_lms_st == y_n_lms_ct
    disp('The two y_n_lms data are the same.');
else
    disp('The two y_n_lms data are different.');
    % combine the two y_n_lms data into one matrix
    y_n_lms = [u_n, d_n, y_n_lms_st, y_n_lms_ct];
    % export to csv
    csvwrite(strcat(outputPath, 'y_n_lms.csv'), y_n_lms);
end
if e_n_lms_st == e_n_lms_ct
    disp('The two e_n_lms data are the same.');
else
    disp('The two e_n_lms data are different.');
end
if t_st == t_ct
    disp('The two t data are the same.');
else
    disp('The two t data are different.');
end
if f1_st == f1_ct
    disp('The two f1 data are the same.');
else
    disp('The two f1 data are different.');
end
if p_st == p_ct
    disp('The two p data are the same.');
else
    disp('The two p data are different.');
end
if f2_st == f2_ct
    disp('The two f2 data are the same.');
else
    disp('The two f2 data are different.');
end
if pxx_st == pxx_ct
    disp('The two pxx data are the same.');
else
    disp('The two pxx data are different.');
end
if pmax_st == pmax_ct
    disp('The two pmax data are the same.');
else
    disp('The two pmax data are different.');
end
if pmin_st == pmin_ct
    disp('The two pmin data are the same.');
else
    disp('The two pmin data are different.');
end
if wts_lms_st == wts_lms_ct
    disp('The two wts_lms data are the same.');
else
    disp('The two wts_lms data are different.');
    % combine the two wts_lms data into one matrix
    wts_lms = [wts_lms_st, wts_lms_ct];
    % export to csv
    csvwrite(strcat(outputPath, 'wts_lms.csv'), wts_lms);
end

function [y_n_lms, e_n_lms, t, f1, p, f2, pxx, pmax, pmin, wts_lms] = LMSprocedure1(inputSignal, desiredSignal, fs, outputPath, LMSmethod, LMSlength, LMSstepSize, playbacFlag, writeAudioFlag, writeWeightsFlag)
    lms = dsp.LMSFilter(LMSlength, 'Method', LMSmethod, 'StepSize', LMSstepSize);
    [y_n_lms, e_n_lms, wts_lms] = lms(inputSignal, desiredSignal);
    t = linspace(0, length(e_n_lms)/fs, length(e_n_lms));
    [f1, p, f2, pxx, pmax, pmin] = dft(e_n_lms, fs);
end

function [y_n_lms, e_n_lms, t, f1, p, f2, pxx, pmax, pmin, wts_lms, lc, erle] = LMSprocedure2(inputSignal, desiredSignal, fs, outputPath, LMSmethod, LMSlength, LMSstepSize, playbacFlag, writeAudioFlag, writeWeightsFlag)
    [y_n_lms, e_n_lms, wts_lms, lc, erle] = NLMS(inputSignal, desiredSignal, LMSstepSize, LMSlength);
    t = linspace(0, length(e_n_lms)/fs, length(e_n_lms));
    [f1, p, f2, pxx, pmax, pmin] = dft(e_n_lms, fs);
end
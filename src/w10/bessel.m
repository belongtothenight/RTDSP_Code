n=1;
nmax=100; % Maximum order of filter limited by MATLAB
w0=2000;
fp=2000;
fs=2500;
fp_hist=[0];
fs_hist=[0];

% Find optimum filter coefficient
figure;
hold on;
try
    for n=1:1:nmax
        % disp(n)
        [b,a]=besself(n,w0,'low');
        [h,w]=freqs(b,a);
        hdB=20*log10(abs(h));
        flag_fs=0;
        flag_fp=0;
        pass_fs=0;
        pass_fp=0;
        for i=1:1:200
            if w(i) > fs
                if flag_fs == 0
                    fs_result_hdB=hdB(i);
                    flag_fs=1;
                end
            elseif w(i) > fp
                if flag_fp == 0
                    fp_result_hdB=hdB(i);
                    flag_fp=1;
                end
            end
        end
        if fs_result_hdB < -60
            %disp('fs pass')
            pass_fs=1;
        else
            %disp('fs fail')
        end
        if fp_result_hdB > -3
            %disp('fp pass')
            pass_fp=1;
        else
            %disp('fp fail')
        end
        fp_hist = [fp_hist fp_result_hdB];
        fs_hist = [fs_hist fs_result_hdB];
        if pass_fs == 1 && pass_fp == 1
            disp('n=')
            disp(n)
            break
        end
        plot(w,hdB,'DisplayName',num2str(n))
    end
catch exception
    legend()
    hold off;
    xlabel('Frequency (rad/s)')
    ylabel('Magnitude (dB)')
    title('Bessel Filter Magnitude Response')
end

figure;
hold on;
plot(fp_hist,'DisplayName','fp')
plot(fs_hist,'DisplayName','fs')
legend()
xlabel('Order')
ylabel('Magnitude (dB)')
title('$f_s$ and $f_p$ with respect to Order', 'Interpreter', 'latex')
hold off;


% Magnitude Response

% Pole-Zero Plot

% Phase Response

% Magnitude and Phase Response

% Step Response

% Impulse Response

% Group Delay

% Phase Delay
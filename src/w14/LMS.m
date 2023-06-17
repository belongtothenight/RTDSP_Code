function [y, e, wts, lc, erle] = LMS(x, d, mu, order)
    % * Input parameters:
    %   - x:     (array, lx1) input signal
    %   - d:     (array, lx1) desired signal
    %   - mu:    (int) step size
    %   - order: (int) filter order (length)
    % * Intermediate variables:
    %   - L:     (int) filter order (length)
    %   - alpha  (int) 1
    %   - c:     (int) 1e-8
    %   - b:     (int) 1 / L
    % * Output parameters:
    %   - y:     (array, lx1) output signal
    %   - e:     (array, lx1) error signal
    %   - wts:   (array, orderx1) filter weights
    %   - lc:    (array, lx1) learning curve, mean square error
    %   - erle:  (array, lx1) error return loss enhancement
    % * Calculation:
    %  y(n) = w(n)' * x(n) = \sum^{L-1}_{l=0} w_l(n) * x(n-l)
    %  e(n) = d(n) - y(n)
    %  w_l(n+1) = w_l(n) + mu * e(n) * x(n-l)
    
    % * Initialization
    L = order;
    % alpha = 1;
    % c = 1e-8;
    % b = 1 / L;
    l = length(x);
    wts = zeros(1, L);
    y = zeros(1, l);
    e = zeros(1, l);
    lc = zeros(1, l);
    erle = zeros(1, l);
    % P_x = 0;

    % * LMS
    for n = 1:l
        lowerIndex = n-L+1;
        % * Method 1
        if lowerIndex < 1
            window_x = x(n:-1:1)';
            window_x = [zeros(1, abs(lowerIndex)+1), window_x];
        else
            window_x = x(n:-1:n-L+1)';
        end
        y(n) = wts * window_x';
        % * Method 2
        % for index = 1:L
        %     y(n) = y(n) + wts(index) * x(n-index+1);
        % end

        e(n) = d(n) - y(n);

        % * Method 1
        wts = wts + mu * e(n) * window_x;
        % * Method 2
        % for index = 1:L
        %     wts(index) = wts(index) + mu * e(n) * x(n-index+1);
        % end

        if lowerIndex < 1
            window_e = e(n:-1:1);
            window_d = d(n:-1:1)';
            window_e = [zeros(1, abs(lowerIndex)+1), window_e];
            window_d = [zeros(1, abs(lowerIndex)+1), window_d];
        else
            window_e = e(n:-1:n-L+1);
            window_d = d(n:-1:n-L+1)';
        end

        % * Learning curve
        lc(n) = mean(window_e.^2);
        % * Error return loss enhancement
        erle(n) = 10 * log10(mean(window_d.^2) / mean(window_e.^2));
    end

    y = y';
    wts = wts';
end
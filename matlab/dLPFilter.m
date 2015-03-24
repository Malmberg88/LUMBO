function lpf = dLPFilter(alpha, Ts, plots)
%   lpf = dLPFilter(alpha);
%           alpha [0,1]     - weight between insignal and outsignal
%                             a larger alpha will yield larger values for
%                             previous out signals shortening the cut off
%                             frequency.
%           Ts              - sampling period
%           plots           - plots the bode diagram, 1 plots and a 0 zero
%                             doesn't
%           lpf             - returned low pass filter (tf)
%
%   creates a discrete second order low pass filter for the LUMBO-motor of following
%   charactersitics:
%                      (1 - alpha)
%           H(z) =    ---------------
%                      (z  - alpha)^2
%
%       y(k) = alpha*y(k-1) + (1 - alpha)*u(k)

trans = tf((1-alpha),[1 -alpha], Ts);
lpf1 = trans*trans;

if plots == 1
    figure(2)
    bode(lpf1)
end


lpf = lpf1;
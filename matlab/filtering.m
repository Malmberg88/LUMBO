function [num, den] = filtering(sys, lpf, scaling, denom, Ts)
%   [num, den] = filtering(sys, lpf, scaling, Ts)
%
%       This function discretizes the estimated transfer function and
%       multiplies with the discrete low pass filter. It also has the
%       posibities to remove unwanted system characteristics, that lets
%       through higher frequencies than there should be.
%
%       sys        - estimated transfer funcion, continuous time
%       lpf        - low pass filter, discrete time
%       scaling    - can add a scaling so that the system follows reference
%                    signal.
%       denom      - Due to unwanted system behviour in the motor at higher 
%                    frequencies; only the numerator is used, however if
%                    set to 1, the denominator will also be used when
%                    modeling.
%       Ts         - sampling periods
%
%
%
%       [num, den] - final transfer values used in simulink



sys_d = c2d(sys, Ts);   % Discretize the motor
invsys_d = inv(sys_d);  % take the inverse


if denom == 0 
    % Due to unwanted system behviour only numerator is used
    qwerty = invsys_d.num{1,1};
    sys_inv_d = tf(qwerty, 1, Ts);
else 
    sys_inv_d = invsys_d;
end


%ihopsättning av systemet
sys_tot_d = sys_inv_d*lpf;
% kollar om överföringsfunktionen är stabil

isstable(sys_tot_d)
%return values
num = sys_tot_d.num{1,1}/scaling;
den = sys_tot_d.den{1,1};

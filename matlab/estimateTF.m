function transf = estimateTF(y, u, t, Ts, plot)
%   transf = estimateTF(y, u, t, Ts, plot)
%       creates an estimate of the transfer function supplied from the
%       motor.
%
%       y       - vector of output signal
%       u       - vector of input singal
%       t       - time stamp vector to revert graph x-axis to seconds and not
%                 samples
%       Ts   	- sampling period
%       plot    - 1 = plot, 0 = no plot
%
%       transf  - returned transfer function (tf!)

obj = iddata(y, u, Ts);
sys = tfest(obj, 2,0);
if plot == 1    
    y_sim = lsim(sys, u, t);
   
    
end

transf = sys;
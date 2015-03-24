function y = LowPassFilter(p,f)
% Low pass RC filter gain transfer function
% 
% R=990;     % Resistance (ohms)
% C=p(1);
% w=2*pi*f;
% y=1./(1+(R*C*w).^2);

omega = p(1);
K = p(3);
zeta = p(2);
y = K*((omega.^2)./(f.^2 + 2*zeta*omega*f + omega.^2));
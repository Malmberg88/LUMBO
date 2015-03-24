%% Curve Fitting Tutorial
% Benn Thomsen, December 2011

%% Linear Fitting (e.g. Current through a resistor)

% Experimentally measured data
% xdata=[0 1 2 3 4 5 6 7 8 9 10];     % Input Voltage (V)
% ydata=[1.66 4.55 5.82 9.25 11.59 13.60 16.36 19.10 22.57 24.83 26.09]; % Current (mA)
% 
% % In order to fit a model to some experimental data you first need to
% % define a mathematical model for the system. Here we define a linear model
% % in the function file LinearModel.m
% 
% % We then need to define a cost function that quantifies the quality of the
% % fit between the model and the experimental data. The least squares metric
% % is often used. This is simply defined as the sum over all the vertical
% % distances between the experimental points and the model evaluated at each
% % point squared. The squaring is required to remove the direction
% % information that is contained in the difference
% 
% %  Cost Function = sum( (ydata - Model(xdata)).^2 )
% 
% % Set initial guess for the model parameters. Choosing an initial value
% % that is close to the right value will speed up the minimisation and make
% % the algorithm more robust to avoiding local minima. For example, you
% % might use the values that you obtained from independent measurements of
% % the resistance using an ohm meter.
% p_initial = [1,0]; 
% 
% % Find minima of cost function
% p_fit=fminsearch(@(p) LSCostFunction(p,@LinearModeler,xdata,ydata),p_initial);
% 
% % Evaluate the model using the optimum parameters obtained
% xfit = linspace(0,10,100);
% yfit = LinearModeler(p_fit,xfit);
% 
% % Plot the results
% figure(1)
% plot(xdata,ydata,'x',xfit,yfit)
% xlabel('Input Voltage (V)')
% ylabel('Current (mA)')
% title(['Linear fit m = ' num2str(p_fit(1)) '  c = ' num2str(p_fit(2))])
% 
% % Note because we are fitting a 1st order polynomial we can also use 
% % Matlabs polyfit function for this problem as follows
% 
% % Polynomial order
% order = 1;      %Linear
% 
% % Determine the parameters
% p_fit = polyfit(xdata,ydata,order);
% 
% % Evaluate the model using the optimum parameters obtained
% yfit = polyval(p_fit,xfit);
% 
% % Plot the resultsds
% figure(2)
% plot(xdata,ydata,'x',xfit,yfit)
% xlabel('Input Voltage (V)')
% ylabel('Current (mA)')
% title(['Linear fit m = ' num2str(p_fit(1)) '  c = ' num2str(p_fit(2))])

%% Nonlinear curve fitting E.g. The Low Pass filter
% Polyfit won't work here...
close all;
% Measured data from RC filter
% fdata=[10,14.3,20.6,29.7,42.8,61.5,88.5,127,183,263,379,545,784,1.12e3,...
%     1.62e3,2.33e3,3.35e3,4.83e3,6.95e3,1e4];
% Gdata=[1.02,1.01,0.999,0.998,0.994,0.987,0.969,0.937,0.880,0.773,0.627,...
%     0.448,0.282,0.157,0.0838,0.0433,0.0239,0.0107,0.00849,0.00290];

fdata = youtdot2;
Gdata = yin(552:end).';

% Set initial guess for the capacitor value.
% p_initial = 0.3e-6;  % Capacitance(F)
p_initial = [1,4.51,1];

% Find minima of cost function. Note the LowPassFilter model function has been used 
p_fit=fminsearch(@(p) LSCostFunction(p,@LowPassFilter,fdata,Gdata),p_initial);

% Evaluate the model using the optimum parameters obtained
xfit = logspace(1,2,100);
yfit = LowPassFilter(p_fit,xfit);

% Plot the results in dB on a log scale
figure()
semilogx(fdata,10*log10(Gdata),'x',xfit,10*log10(yfit)),grid
xlabel('Frequency (Hz)')
ylabel('Gain (dB)')
title(['Transfer filter Omega = ' num2str(p_fit(1)) ', Zeta = ' num2str(p_fit(2)) ', K = ' num2str(p_fit(3)) ])

num = [ p_fit(3)*(p_fit(1).^2) ] ;
den = [1 2*p_fit(2)*p_fit(1) p_fit(1).^2] ;
sys = tf(num, den);
figure
bode(sys),grid
figure
subplot(211), step(sys), grid
subplot(212), impulse(sys),grid






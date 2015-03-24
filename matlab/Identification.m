clear all
y = csvread('W-P0_6-I3600-D2500-X.csv');
 %y = csvread('W-P7-I1200-D2100-Y.csv');
%y = csvread('X-4-direct-stepsize1.csv');
yout = y(:,2);
yin = y(:,1);

%Wierd sampling time???
samplingtime = 0.03;

%Differentiating for Anglevelocity
youtdot = filter([1 -1], samplingtime , yout(1:end));
youtdot = youtdot(2:end);

%Interpolation for wierd data-spikes
for i = 1:length(youtdot)-1
    if youtdot(i) > 1.2
        y1dot(i) = (youtdot(i-1) + youtdot(i+1))/2;
    else
        y1dot(i) = youtdot(i);
    end
end

% Additional differentiation for impuls response
% youtdot2 = filter([1 -1], samplingtime , y1dot);
% plot(youtdot2)

% Prints results
t = linspace(-0.5, samplingtime*(length(y1dot)-1), length(y1dot));


%% TF-estimation
close all;
u = yin(1:end-2);
obj = iddata(y1dot', u, samplingtime);
sys = tfest(obj, 2,0);
% sysd = c2d(sys, samplingtime);
% invsysd  = inv(sysd);
% isstable(invsysd)
y_sim = lsim(sys, u, t);

figure(1)
hold on
%title('Windowtest P: 2 - I: 1200 - D: 2100 Y');
title('Windowtest P:0.6 I:3600 D:2500 X');
ylabel('Angular velocity [degrees/s]');
xlabel('Time [s]');
axis([0 3 0.5 1.2]);
plot(t, y1dot);
plot(t, yin(1:end-2),'r');
%plot(t, y_sim, 'g')


%% Create Lowpass filter for inverse filter
close all;
samplingtime = 0.02;
% n = 2;                                      %second order filter
% Fc = 40/(25*2*pi);                                % Cut-off frequency; calculated: maximum speed (Hz) / 2*sampling freuency (Hz)
% [num_butt, den_butt] = butter(n, Fc, 'z');  %create butterworth-filter
% lpf = tf(num_butt,den_butt, samplingtime);% create system transfer function
alpha2 = 0.4;
alpha = 0.2;
trans = tf((1-alpha),[1 -alpha], 0.04);
trans2 = tf((1-alpha2),[1 -alpha2], 0.02);
lpf = trans*trans;
lpf2 = trans2*trans2;


bode(lpf)       % plot bode diagram for transferfunction
figure;
bode(lpf2)


%% Multiply filter and tf
close all
% DC-motorn diskretiserad, används i Simulink-blocken
sys_d = c2d(sys, 0.04);
sys_d2 = c2d(sys, 0.02);

num = sys_d.num;
den = sys_d.den;

num2 = sys_d2.num;
den2 = sys_d2.den;

nums = sys.num;
dens = sys.den;

invsys_d = inv(sys_d);
invsys_d2 = inv(sys_d2);

%inverse överföringsfunktion av motor multiplicerad med lågpassfilter 
sys_lpfd = lpf;
qwerty = invsys_d.num{1,1};
sys_no_den_d = tf(qwerty, 1, 0.04);

sys_lpfd2 = lpf2;
qwerty2 = invsys_d2.num{1,1};
sys_no_den_d2 = tf(qwerty2, 1, 0.02);

%ihopsättning av systemet
sys_tot = sys_no_den_d*sys_lpfd;
sys_tot2 = sys_no_den_d2*sys_lpfd2;

% kollar om överföringsfunktionen är stabil
isstable(sys_tot)

%nämnare och täljare plockas ut för att blocken i simulink ska fungera
%-------- För X-motor --------%
numi = sys_tot.num{1,1}/0.2025; % 0.2 från början
numi2 = sys_tot2.num{1,1}/0.0593;   % 0.059 från början

%-------- För Y-motor --------%
%  numi = sys_tot.num{1,1}/0.369;
%  numi2 = sys_tot2.num{1,1}/0.123;


%-------- Nämnare för både X- och Y-motor --------%
deni = sys_tot.den{1,1};
deni2 = sys_tot2.den{1,1};

%% Final analysis
d = linspace(0, samplingtime*(length(yin)-1), length(yin));
% signal = [zeros(1,20) ones(1,20)];

for i = 1:length(yin)
    signal_r(i) = filtering(yin(i),i);
end

rerun = filter(numi, deni, signal_r);


figure
hold on
plot(d,yin)
% plot(t,signal,'r')
plot(d,rerun,'g');

%% test
clear all
close all
y = csvread('W-P7-I1200-D2100-Y.csv');
yout = y(:,2);
yin = y(:,1);
Ts = 0.02;
interpolation = 1.2;

%Differentiating for Anglevelocity
ydot = filter([1 -1], Ts , yout);
ydot = ydot(2:end);


%Interpolation for wierd data-spikes
if (interpolation ~= 0)
    for i = 1:length(ydot)-1
        if ydot(i) > interpolation || ydot(i) < -interpolation
            y1dot(i) = (ydot(i-1) + ydot(i+1))/2;
        else
            y1dot(i) = ydot(i);
        end
    end
    t = linspace(0, Ts*(length(y1dot)-1), length(y1dot));
    y = y1dot';

else
    t = linspace(0, Ts*(length(ydot)-1), length(ydot));
    y = ydot(1:end-1)';
end
u = yin(2:end-1);

obj = iddata(y(550:end), u(550:end), Ts);
sys = tfest(obj, 2,0);  
    y_sim = lsim(sys, u(550:end), t(550:end));
    figure(1)
    hold on
    title('Analysis of step response from motor');
    ylabel('Angular velocity [degrees/s]');
    xlabel('Time [s]');
    plot(t(550:end), y(550:end)');
    plot(t(550:end), u(550:end),'r');
    plot(t(550:end), y_sim, 'g')


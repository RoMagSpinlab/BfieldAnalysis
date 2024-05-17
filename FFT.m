
close all
clear
clc

%Load Data
file_name = '800W_25C_97mT_Elsa3';
load([file_name '.mat']);
temp_name = BData;       % Number corresponds to current

%Data to fit
time = temp_name(1:1e4,1); % seconds
Bx   = temp_name(1:1e4,2); % mT
By   = temp_name(1:1e4,3); % mT
Bz   = temp_name(1:1e4,4); % mT
Btot = sqrt(Bx.^2 + By.^2 + Bz.^2);

%Plot data
figure
plot(time,Bz)
hold on
plot(time,movmean(Bz,200),'-k')
grid on
xlabel('Time [s]','Interpreter','LaTex')
ylabel('$B_z$ [mT]','Interpreter','LaTex')
title(file_name,'Interpreter','LaTex')
ax = gca;
ax.FontSize = 16;
%ax.YLim = [1e-6 1e-1];
print(gcf,'-dpng','-r250',[file_name '_TimeSeries'])

%%%%

%FFT
Y_Data = detrend(Bz-mean(Bz));
Fs = 1./mean(time(2:end)-time(1:end-1));
L = length(time);
freq = 0:(Fs/L):(Fs/2-Fs/L);
Y_Data2 = hann(L).*Y_Data;
Y = fft(Y_Data2',L);
P2 = abs(Y/L);
P1(1,:) = P2(1:L/2+1);
P1(1,2:end-1) = 2*P1(1,2:end-1); 

%Plot FFT
figure
loglog(freq,2*P1(1,1:L/2),'Linewidth',1.01)
hold on
% [pks,locs] = findpeaks(2*P1(1,1:L/2),'NPeaks',2,'SortStr','descend');
% loglog(freq(locs),pks,'ok','LineWidth',1.5);
% hold on
xlabel('$f$ [1/s]','Interpreter','LaTex')
ylabel('FFT Amplitude','Interpreter','LaTex')
title(file_name,'Interpreter','LaTex')
ax = gca;
ax.FontSize = 16;
%ax.YLim = [1e-6 1e-1];
print(gcf,'-dpng','-r250',[file_name '_FFT'])




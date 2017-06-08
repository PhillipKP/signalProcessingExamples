% Phillip K Poon
% June 7th 2017
% This script demonstrates a naive denoise algorithm which simply takes the
% FFT of the signal then implements a simple low pass filter. This is done
% by setting a maximum frequency. Anything above that frequency is set to
% zero. 

clc;
clearvars;
close all;

% Sampling Frequency In Hertz
fs = 1000;

% Setup the time Axis
startTime = 0.0;
endTime = 1.0; % The number of seconds you want it to last
t = startTime: 1/fs : endTime - 1/fs;

% Frequency and phase of the first cosine signal
f1 = 2.5; % Frequency in Hertz
phi1 = 0.0; % Phase in Radians
a1 = 0.5; % Amplitude


f2 = 1.0;
phi2 = 1.0;
a2 = 1.0;

% Original Signal with Frequency f1 and Phase phi1
orig = 1 + a1*cos(2*pi*f1*t + phi1) + a2*cos(2*pi*f2*t + phi2);

% Noise
n = 0.2*randn(size(orig));

% Signal plus noise
x0 = orig + n;

% Plot the original noise corrupted signal
fig1 = figure;
plot(t, x0,'linewidth',2);
title('The Original Signal')
xlabel('Time (Sec)')
ylabel('Original Signal Plus Noise')
ylim([0 3.0]);
makeFontBig(fig1);


% Take the fft
X1 = fft(x0);

% Extract the magnitude
X1_mag = abs(X1);

% Plot the magnitude before low pass filter
fig2 = figure;
plot(X1_mag);
title('Unscaled |X(f)|')
xlabel('Frequency Bin Number')
ylabel('Amplitude (Arb. Units)')
makeFontBig(fig2)

% Apply low pass filter
X1(11:990) = 0;

% Inverse FFT
x0_est = ifft(X1);


fig3 = figure;
plot(abs(x0_est));
ylim([0 3.0]);
xlabel('Time (Sec)')
ylabel('Amplitude (Arb. Units)')
title('Estimated Signal After Denoising')
makeFontBig(fig2)

fig3 = figure;
plot(x0,'linewidth',2);
hold all;
plot(abs(x0_est),'linewidth',2);
plot(orig,'linewidth',2);
hold off;
legend('Original Noisey Signal','Filtered Signal','Original Signal Before Noise Added')
makeFontBig(fig3)

return

% Turn on zero-padding
zeroPadFlag = 1;
% Turn on windowing using the Hanning window to reduce the
% side lobes
hanningWindowFlag = 1;




if zeroPadFlag == 0
    
    x1 = x0;
    
    X1 = fft(x1);
    
elseif zeroPadFlag == 1
    
    if hanningWindowFlag == 1
        
        % You should apply the window BEFORE zero padding!
        
        x0 = x0.*hanning(length(x0)).';
    end
    
        % You can change the amount of zero-padding to increase
        % of decrease the frequency resolution.
        % The frequency resolution is fs/N, where N is the length of 
        % x1 AFTER zero-padding. 
        
        x1 = [x0 zeros(1,1100000)];
        X1 = fft(x1);
end

X1_mag = abs(X1);
X1_phase = angle(X1);

figure;

% Subplot the signal in the time domain
subplot(2,1,1);
plot(x1,'-');
xlabel('Samples')
ylabel('Amplitude')


subplot(2,1,2);

% Subplot the signal in the frequency domain
plot(0: length(X1) - 1, abs(X1) ,'o');
ylabel('Magnitude')
xlabel('Bins')


% A properly scaled amplitude in the frequency domain
X1_magAmpScaled = X1_mag /  ( length(x0)/4 );

% Setup the frequency axis
freqAxis =  ( ( 1:length(X1) ) - 1 ) * fs / length(X1);

% Plot the magnitude of the FFT with the proper amplitude and
% frequency domain scaling
figure;
plot(freqAxis, X1_magAmpScaled);
xlabel('Hertz')
ylabel('Magnitude')
title('The properly scaled spectrum using the MATLAB FFT')
grid on;
xlim([0 fs/2]);
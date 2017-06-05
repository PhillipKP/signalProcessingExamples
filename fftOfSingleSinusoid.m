% Phillip K Poon
% 05 June 2017
% 
% This script demonstrates the proper use of zero padding and
% windowing of the time domain signal. It also hows how to
% extract the amplitude, phase, and frequency information of a
% sinusoid in the frequency domain after the fft has been applied

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
phi1 = 0.2; % Phase in Radians
a1 = 0.6; % Amplitude


% Original Signal with Frequency f1 and Phase phi1
x0 = a1*cos(2*pi*f1*t + 0.2);

% Plot the original signal
figure;
plot(x0);
title('The Original Signal')



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
    
    
    x1 = [x0 zeros(1,11000)];
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


% Determine the amplitude, phase, and frequency using 
% the frequency domain information only

[maxVal, maxInd] =  max(X1_mag);

% Estimate the amplitude
a1_est = X1_mag(maxInd)/ (length(x0)/4)

% Estimate the phase
phi1_est = X1_phase(maxInd)

% Estimate the frequency
f1_est = (maxInd - 1)*fs/length(X1)
clear; close all; clc;

x = -10:0.001:10;

y1 = sin(2*pi*x);
y2 = sin(2*pi*x+0.6);

figure;
plot(x,y1,x,y2)
grid on
xlim([-1 1])
legend('y1', 'y2')

[c,lag]=xcorr(y1,y2);
[maxC,I]=max(c);
phaseLag = lag(I)*0.001*2*pi

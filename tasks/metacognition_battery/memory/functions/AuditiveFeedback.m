function AuditiveFeedback(performance)

% Plays a sound accoding to performance.
% High-pitch sound f performance is 1
% Low pitch sound if performance is 0

Fs = 8192; % sampling frequency
x = [1:1000]; % length of tone in sampling frequency unit

if performance,
	y = sin(x);
else
	y = sin(x/3)*10;
end

sound(y,Fs);
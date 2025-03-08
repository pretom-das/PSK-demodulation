clc; clear; close all;

% Parameters
fs = 100;   % Sampling frequency per bit
fc = 10;    % Carrier frequency (Hz)
N = 10;     % Number of bits
T = 1;      % Bit duration (sec)
t = linspace(0, T, fs); % Time vector for one bit
time_axis = linspace(0, N*T, N*fs); % Full signal time axis

% Generate random bit sequence (0s and 1s)
bits = randi([0 1], 1, N);

% Generate Square Wave Input
square_wave = [];
for i = 1:N
    square_wave = [square_wave, bits(i) * ones(1, fs)];
end

% BPSK Modulation: Map 0 -> -1, 1 -> +1
bpsk_signal = 2*bits - 1;

% Modulated signal
modulated_signal = [];
for i = 1:N
    modulated_signal = [modulated_signal, bpsk_signal(i) * cos(2 * pi * fc * t)];
end

% BPSK Demodulation (Perfect Channel)
demodulated_bits = [];
received_signal = modulated_signal .* cos(2 * pi * fc * time_axis); % Coherent detection
for i = 1:N
    bit_energy = sum(received_signal((i-1)*fs + 1 : i*fs)); % Integrate over bit duration
    demodulated_bits = [demodulated_bits, bit_energy > 0];
end


% Plot all signals in a single figure
figure;

% Subplot 1: Original Square Wave Bit Sequence
subplot(3,1,1);
plot(time_axis, square_wave, 'LineWidth', 1.5);
ylim([-0.5, 1.5]);
xlabel('Time (s)');
ylabel('Amplitude');
title('Original Square Wave Bit Sequence');
grid on;

% Subplot 2: BPSK Modulated Signal
subplot(3,1,2);
plot(time_axis, modulated_signal, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
title('BPSK Modulated Signal');
grid on;

% Subplot 3: Demodulated Bit Sequence
subplot(3,1,3);
stair(demodulated_bits);
ylim([-0.5 1.5]);
xlabel('Bit Index');
ylabel('Bit Value');
title('Demodulated Bit Sequence');
grid on;


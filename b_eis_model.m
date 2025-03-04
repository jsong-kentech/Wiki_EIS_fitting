% freq
log_w = linspace(6,-3,47);
w = 10.^(log_w); % Rad

% para
r = 20; % [ Ohm]
tau = 1000^-1; %[sec]
r0 = 20;

% out (expression)
% DeLeive model
z_model = r0 + r./sqrt(1i*w*tau).*tanh(sqrt(1i*w*tau)); % complex vector
z_model_real = real(z_model);
z_model_imag = imag(z_model);

% plot
figure(1); hold on
plot(z_model_real,-z_model_imag,'-')


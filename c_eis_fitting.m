clear
close all
clc

%% DATA

% Load Data
filename = '250202_LJW093_EIS_Full cell_AC_low loading_NCMA95_LYC_SuperC65_60_40_3_70MPa.xlsx';
data = xlsread(filename);
z_data_real = data(2:30,2);
z_data_imag = data(2:30,3);
freq_data = data(2:30,1); %[Hz]

% plot
figure(1)

plot(z_data_real,-z_data_imag,'o')
xlim([10 60])
ylim([-5 45])

hold on

%% MODEL
% freq
w = freq_data*(2*pi); % [Rad]

% para (initial guess)
r = 20; % [ Ohm]
tau = 1000^-1; %[sec]
r0 = 20;
para_0 = [r0, r, tau];

% out (expression)
% DeLeive model
z_model = func_model(w,para_0); % complex vector
z_model_real = real(z_model);
z_model_imag = imag(z_model);

% plot
figure(1); hold on
plot(z_model_real,-z_model_imag,'o')



%% FITTING

% minimizer (fmincon)
% function handle
para_hat = fmincon(...
    @(para)func_cost(freq_data,para,z_data_real,z_data_imag),...
    para_0,[],[],[],[],[0 0 0],para_0*10);


% model with para_hat
z_hat = func_model(w,para_hat);
z_hat_real = real(z_hat);
z_hat_imag = imag(z_hat);


% plot
figure(1); hold on
plot(z_hat_real, -z_hat_imag)

legend({'data','initial','hat'})




%% VAlIDATION

r_vec = linspace(para_hat(2)/2,para_hat(2)*1.5,21);
tau_vec = 10.^linspace(0.5*log10(para_hat(3)),1.2*log10(para_hat(3)),31);


for i = 1:length(r_vec)
    for j = 1:length(tau_vec)
    
    i
    j
        cost_mat(i,j) = func_cost(freq_data,[para_hat(1),r_vec(i),tau_vec(j)],z_data_real,z_data_imag);


    end
end

figure(2)
surf(tau_vec,r_vec,cost_mat)

hold on
scatter3(para_0(3),para_0(2),func_cost(freq_data,para_0,z_data_real,z_data_imag),'ok')
scatter3(para_hat(3),para_hat(2),func_cost(freq_data,para_hat,z_data_real,z_data_imag),'or')





function cost = func_cost(f,para,z_data_real,z_data_imag)

% model
w = f*(2*pi); % [Rad]
z_model = func_model(w,para); % complex vector
z_model_real = real(z_model);
z_model_imag = imag(z_model);

% cost
cost = sum((z_data_real-z_model_real).^2 + (z_data_imag-z_model_imag).^2);

end

function z_model = func_model(w,para)
r0 = para(1);
r = para(2);
tau = para(3);
z_model = r0 + r./sqrt(1i*w*tau).*tanh(sqrt(1i*w*tau)); 

end
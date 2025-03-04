

% Load Data
filename = '250202_LJW093_EIS_Full cell_AC_low loading_NCMA95_LYC_SuperC65_60_40_3_70MPa.xlsx';
data = xlsread(filename);


% Plot
z_real = data(2:end,2);
z_imag = data(2:end,3);



figure(1)

plot(z_real,-z_imag,'o')
xlim([10 80])
ylim([-5 65])

hold on

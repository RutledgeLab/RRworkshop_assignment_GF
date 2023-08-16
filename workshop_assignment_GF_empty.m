%% Rutledge lab modeling workshop 2023 - Risk Taking Exp design
% 
% You are provided with a toy dataset of n=100. 
% In this sample, there is a known r= -0.3 correlation between 
% people's anxiety symptoms (GAD-7 score) and their risk aversion (alpha) parameter.
% You are a researcher interested in a research question that builds upon 
% this anxiety-related risk aversion effect. 
% You are deciding whether you should implement matrix A or matrix B 
% for your next risk taking study. 

%% Load the dataset
clear;
load('toy_data_rrworkshop.mat')


%% Question 1: Which design matrix lends itself to better alpha recovery? 
% To simulate choices, use the function 'sim_pt_model_rrworkshop'
% Append these simulated choices to each design matrix so you can recover
% the parameters using 'fitmodel_pt_rrworkshop'

% Generating fake data
for s = 1:length(toy_data)
    fprintf(sprintf('MTX A: generating behavior for person %.0f of %.0f...\n',s,length(toy_data)))
    % code here.

    fprintf(sprintf('MTX B: generating behavior for person %.0f of %.0f...\n',s,length(toy_data)))
    % code here.
end

% fit the data

pt_params_sim = nan(length(toy_data),3);
pt_params_a = nan(length(toy_data),3);
pt_params_b = nan(length(toy_data),3);


for s = 1:length(toy_data)
    pt_params_sim(s,:) = toy_data(s).pt_params;

    fprintf(sprintf('fitting participant %.0f of %.0f...\n',s,length(toy_data)))
    % code here. 

    % Save each person's A matrix parameters as a row in the pt_params_a
    % matrix.
    %pt_params_a(s,:) = result.b; % uncomment

    result = fitmodel_pt_rrworkshop(toy_data(s).design_mtx_b);
    % code here. 

    % Save each person's B matrix parameters as a row in the pt_params_b
    % matrix.
    %pt_params_b(s,:) = result.b; % uncomment

end

%% Plot the correlation
param_name = {'\mu','\lambda','\alpha'};

[r_param_recovery_a,p_param_recovery_a] = corr(pt_params_sim,pt_params_a,'Type','Spearman')
[r_param_recovery_b,p_param_recovery_b] = corr(pt_params_sim,pt_params_b,'Type','Spearman')


figure
for p = 1:size(pt_params_sim,2)
    hold on;
    subplot(1,size(pt_params_sim,2),p);
    axis('square');
    scatter(pt_params_a(:,p),pt_params_sim(:,p),'filled',...
        'MarkerFaceColor',[182 214 240]/255,'MarkerEdgeColor',[0 0 0]); hold on;
    axis('square')
    ylabel(['Simulated ' param_name{p}]);
    xlabel(['Recovered '  param_name{p}]);
    title(sprintf('Matrix A %s, rho = %.3f',param_name{p},r_param_recovery_a(p,p)));
    xline(0); yline(0);   
end

figure
for p = 1:size(pt_params_sim,2)
    hold on;
    subplot(1,size(pt_params_sim,2),p);
    axis('square');
    scatter(pt_params_b(:,p),pt_params_sim(:,p),'filled',...
        'MarkerFaceColor',[182 214 240]/255,'MarkerEdgeColor',[0 0 0]); hold on;
    axis('square')
    ylabel(['Simulated ' param_name{p}]);
    xlabel(['Recovered '  param_name{p}]);
    title(sprintf('Matrix B %s, rho = %.3f',param_name{p},r_param_recovery_b(p,p)));
    xline(0); yline(0);   
end

%% Question 2: Which design matrix lends itself to producing a clearer correlation between anxiety and risk aversion?

[r_gadcorr_original,p_gadcorr_original] = corr(pt_params_sim(:,3),[toy_data.gad_score]')
[r_gadcorr_a,p_gadcorr_a] = corr(pt_params_a(:,3),[toy_data.gad_score]')
[r_gadcorr_b,p_gadcorr_b] = corr(pt_params_b(:,3),[toy_data.gad_score]')


%% Question 3: Can you try to figure out why the better matrix is preferred?
% Hint: You could start by looking at things like simulated gambling behavior between the two
% matrices. 






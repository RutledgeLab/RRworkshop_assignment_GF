function result = fitmodel_pt_rrworkshop(indata)

% INDATA is a matrix with at least 4 columns (col 1 certain amount, col 2
% win amount, col 3 loss amount, col 4 chose risky is 1, chose safe is 0)

result           = struct;
result.data      = indata;
result.betalabel = {'mu','lambda','alpha'}; 

result.inx       = [1       2 0.8];   %initial values for parameters
result.lb        = [0.01  0.5 0.3]; %min values possible for design matrix
result.ub        = [20      5 1.3];   %max values

result.options   = optimset('Display','off','MaxIter',100000,'TolFun',1e-10,'TolX',1e-10,...
    'DiffMaxChange',1e-2,'DiffMinChange',1e-4,'MaxFunEvals',10000,'LargeScale','off');
warning off;                    %to see outputs use 'Display','iter'

try
    [b, ~, exitflag, output, ~, ~, H] = fmincon(@mymodel,result.inx,[],[],[],[],result.lb,result.ub,[],result.options,result);
    clear temp;
    [loglike, utildiff, logodds, probchoice] = mymodel(b, result);
    result.b          = b;      %parameter estimates
    result.se         = transpose(sqrt(diag(inv(H)))); %SEs for parameters from inverse of the Hessian
    result.modelLL    = -loglike;
    result.exitflag   = exitflag;
    result.output     = output;
    result.utildiff   = utildiff;
    result.logodds    = logodds;
    result.probchoice = probchoice;
catch
    fprintf(1,'model fit failed\n');
end

end


function [loglike, utildiff, logodds, probchoice] = mymodel(x, data)

data.mu         = x(1);
data.lambda     = x(2);
data.alpha  = x(3);

[loglike, utildiff, logodds, probchoice] = mypt_model(data);

end


function [loglike, utildiff, logodds, probchoice] = mypt_model(data)

%data.data is a matrix with at least 7 columns (col 1 certain amount, col 2
%win amount, col 3 loss amount, col 4 chose risky is 1, chose safe is 0)
%data.lambda and data.mu are loss aversion and inverse temperature
%parameters. function returns -loglikelihood and vectors for trial-by-trial
%utility difference, logodds, and probability of taking the risky option


utilcertain   = (data.data(:,1)>0).*abs(data.data(:,1)).^data.alpha - ...
                (data.data(:,1)<0).*data.lambda.*abs(data.data(:,1)).^data.alpha;
winutil       = data.data(:,2).^data.alpha;                   %utility for potential risky gain
lossutil      = -data.lambda*(-data.data(:,3)).^data.alpha; %utility for potential risky loss
utilgamble    = 0.5*winutil+0.5*lossutil;         %utility for risky option
utildiff      = utilgamble - utilcertain;         %utility difference between risky and safe options
logodds       = data.mu*utildiff;                 %convert to logodds using noise parameter
probchoice    = 1 ./ (1+exp(-logodds));           %prob of choosing gamble
choice        = data.data(:,4);                   %1 chose risky, 0 chose safe


probchoice(probchoice==0) = eps;                  %to prevent fmincon crashing from log zero
probchoice(probchoice==1) = 1-eps;
loglike       = - (transpose(choice(:))*log(probchoice(:)) + transpose(1-choice(:))*log(1-probchoice(:)));
loglike       = sum(loglike);                     %number to minimize

end
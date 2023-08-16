function [probchoice, choice] = sim_pt_model_rrworkshop(x, data)

mu        = x(1);
lambda    = x(2);
alpha     = x(3);

% x should be the vector of parameters

%data should be a 3-column matrix (certain, gain, loss(neg numbers))


utilcertain = (data(:,1)>0).*abs(data(:,1)).^alpha - ...
    (data(:,1)<0).*lambda.*abs(data(:,1)).^alpha;
winutil       = data(:,2).^alpha;
lossutil      = -lambda*(-data(:,3)).^alpha;
utilgamble    = 0.5*winutil+0.5*lossutil;
utildiff      = utilgamble - utilcertain;
logodds       = mu.*utildiff;

probchoice = 1 ./ (1+exp(-logodds));

choice        = rand(length(probchoice),1) < probchoice;


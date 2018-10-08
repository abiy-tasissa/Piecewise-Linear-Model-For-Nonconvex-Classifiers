% -------------------------------------------------------------------------
% This code implements the piecewise linear classification(PWL SVM)
% -------------------------------------------------------------------------
function [energy,a0,alpha,A] = pwl_classifer(x,y,N,opts,a0_init,A_init,alpha_init)
m = opts.m; % number of piecewise components
maxit = opts.maxit; % maximum number of iterations
lam1 = opts.lam1; lam2 = opts.lam2; % regularization parameters 
delta = opts.delta; % hinge smoothing parameter(delta)

% initialize variable Z
version_id = sum(version=='8.5.0.197613 (R2015a)');
if(version_id==21), Z = x*diag(y); else Z = y'.*x; end

% initial a0, a, alpha
a0 = a0_init;
A = A_init;
alpha = alpha_init;

energy = zeros(maxit,1); % store objective value

for i = 1:maxit
    gamma = 1/sqrt(i); % update stepsize
    % if (opts.print==1), fprintf("-%d\n ",i); end
    % define vectorized form of the piecewise function f
    tmp_Ax = A*x;
    f_vec = (a0'*x+alpha'*max(tmp_Ax,0))';
    y_fvec = y.*f_vec;
    hinge_grad_yfvec = hinge_grad(y_fvec);
    % update a0
    a0 = a0 - gamma * (1/N)*Z*hinge_grad_yfvec;
	tmp_2 = (tmp_Ax>0);
    % update alpha, with proximal l1 term
    if(version_id==21), tmp = max(tmp_Ax,0)*diag(y); else tmp = y'.*max(tmp_Ax,0); end
    alpha_tmp = (1-gamma*lam2)*alpha - gamma *(1/N)*tmp*hinge_grad_yfvec;
    alpha = max(abs(alpha_tmp)-gamma*lam1,0).*sign(alpha_tmp);
    % update A
    B_transpose = (tmp_2*diag(hinge_grad_yfvec))*Z';
    A_tmp1 = (1-lam2*gamma)*A-(1/N)*(gamma*diag(alpha)*B_transpose);
    A = max(abs(A_tmp1)-gamma*lam1,0).*sign(A_tmp1);
    % energy
    energy(i) = (1/N)*sum(hinge(y_fvec));
end

% This function defines the hinge function
function[h] = hinge(t)
    h = (1-t-0.5*delta).*(t-1+delta<=0)+(1-t).^2/(2*delta).*((t-1<=0).*(t-1+delta>0));
end

% This function defines the gradient of the hinge function        
function[hgrad] = hinge_grad(t)
    hgrad = -1*(t-1+delta<=0)+(t-1)/(delta).*((t-1<=0).*(t-1+delta>0));
end

end

function [energy,a0,A,alpha] = run_sequentially(data_file,num_training,data_params,...
    m_vec,m_old,x,y,xtest,ytest,N,opts,a0,A,alpha)
dim = size(x,1)-1; %subtract 1 because of column of ones padded
ntest = numel(ytest);
xtest = xtest';
for i=1:numel(m_vec)
%     tic;
    opts.m = m_vec(i);
    a0_init = a0;
    alpha_init = randn(opts.m,1);
    alpha_init = sign(alpha_init);
    A_init = randn(opts.m,dim+1);
    
    rand_indices = randperm(opts.m,m_old);
    alpha_init(rand_indices) = alpha;
    A_init(rand_indices,:) = A;

    m_old = opts.m;
    [energy,a0,alpha,A] = pwl_classifer(x,y,N,opts,a0_init,A_init,alpha_init);
    %% test prediction accuracy
    F = a0'*xtest+alpha'*max(A*xtest,0);
    F = F';
    y_predicted = sign(F);
    accuracy = 1-(nnz(abs(y_predicted-ytest))/ntest);
    fprintf('accuracy with m = %d is %f \n',opts.m,accuracy);
%     toc
    plot_boundary(data_file,num_training,data_params,opts.m,a0,A,alpha,accuracy,0);
%      plot_surface(h,data_file,num_training,data_params,opts.m,a0,A,alpha,accuracy,1);
end
end
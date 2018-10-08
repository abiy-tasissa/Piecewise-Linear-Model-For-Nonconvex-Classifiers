% -------------------------------------------------------------------------
% A script that calls the piecewise SVM classifier for testing
% -------------------------------------------------------------------------
clc; %clear command window

%choose a dataset
a = load('./data/Moon_SD.mat','a'); data_file = './data/Moon_SD'; data_params = [-1.5 2.7 -1.5 1.5];
a = load('./data/2D_LSD.mat'); data_file = './data/2D_LSD'; data_params = [3000 -2 1 -2 4 -2 4];
a = load('./data/2D_PLSD.mat'); data_file = './data/2D_PLSD'; data_params = [3000 -2 1 2 -1 -2 4 -2 4];
a = load('./data/2D_bendingLineSD.mat'); data_file = './data/2D_bendingLineSD'; data_params = [-1.5 2.7 -1.5 1.5];
a = load('./data/2D_diamondSD.mat'); data_file = './data/2D_diamondSD'; data_params = [-1.5 1.5 -1.5 1.5];
a = load('./data/2D_circlesSD.mat','a'); data_file = './data/2D_circlesSD'; data_params = [-1 1 -1 1];
a = load('./data/2D_polySD.mat'); data_file = './data/2D_polySD'; data_params = [-1.5 1.6 -1.5 1.5];
a = load('./data/2D_polySD_nw.mat'); data_file = './data/2D_polySD_nw'; data_params = [-3.2 3.2 -1.3 1.3];

a = cell2mat(struct2cell(a));
num_input = size(a,1);

% h = create_data;
% h.pd(data_file,200);
% return
dim = size(a,2)-1;
temp = zeros(num_input,dim+2); %+2 for bias and labels
temp(:,1) = ones(num_input,1);
temp(:,2:dim+2) = a;
data = temp;

num_training = ceil(0.7*num_input);
xtrain = data(1:num_training,1:dim+1);
ytrain = data(1:num_training,dim+2);
xtest = data(num_training+1:num_input,1:dim+1);
ytest = data(num_training+1:num_input,dim+2);
% load the feature vectors x and the labels y
x = xtrain';
y = ytrain;
% number of feature vectors and the dimension 
N = length(ytrain);

opts.maxit = 200; % set maximum number of iterations
opts.gamma = 1e-3; % set initial step sise
% regularization parameters 
opts.lam1 = 1e-4; opts.lam2 = 1e-3;
% set hinge smoothing parameter(delta)
opts.delta = 0.001;

%--------------------------------------------------------------------------
% Run just one instance of the algorithm(this can be used to initialize
% when m>1)
% -------------------------------------------------------------------------
% For m>2: initialize with results from m= 0 run and re-run again
% [energy1,a01] = pwl_classifer_initializer(x,y,N,opts,a0_init);
opts.m = 1; % number of picewise components
m_old = opts.m; %for continuous purpose with reintialized variables

a0_init = randn(dim+1,1);
alpha_init = randn(opts.m,1);
A_init = randn(opts.m,dim+1);

opts.print = 1;
%stop when highest accuracy is achieved
m_vec = [2 5 10 15 18 20 25 30 35];
% m_vec = 1:30;

[energy,a0,A,alpha] = run_sequentially(data_file,num_training,data_params,m_vec,m_old,x,y,...
    xtest,ytest,N,opts,a0_init,A_init,alpha_init);

function plot_surface(cd_handle,data_file,num_training,data_params,m,...
    a0_tilde,A_tilde,alpha,accuracy,save_fig)
% [data_file,data_params,nrmlz_params] = cd_handle.itd(data_file,data_params);
if(~exist('nrmlz_params','var') || isempty(nrmlz_params))
    nrmlz_params = [0 1 0 1 0 1];
end
x1ll = data_params(end-5);
x1rl = data_params(end-4);
x2ll = data_params(end-3);
x2rl = data_params(end-2);
x3ll = data_params(end-1);
x3rl = data_params(end-0);
plot_points(data_file,num_training); hold on;
% disc_points = 1000;
% x1Vec = linspace(x1ll,x1rl,1000);
% x2Vec = linspace(x2ll,x2rl,1000);
fun = @(x1,x2,x3) do_sum(x1,x2,x3,m,a0_tilde,A_tilde,alpha,nrmlz_params);
fimplicit3(fun,[x1ll x1rl x2ll x2rl x3ll x3rl]);
title(sprintf(strcat('m=',num2str(m),',  Accuracy=',num2str(accuracy))),'FontSize',20)
if(save_fig==1)
    pathname = fileparts('./figures_boundary/'); %for saving
    if(m<10) name_string = strcat(data_file,'_0',num2str(m));
    else name_string = strcat(data_file,'_',num2str(m)); end
    matfile = fullfile(pathname, name_string);
    saveas(gcf,matfile,'png')
end
end

function output = do_sum(x1,x2,x3,m,a0_tilde,A_tilde,alpha,nrmlz_params)
output = a0_tilde(1)+a0_tilde(2)*x1+a0_tilde(3)*x2+a0_tilde(4)*x3;
mu_x1 = nrmlz_params(1);
sigma_x1 = nrmlz_params(2);
mu_x2 = nrmlz_params(3);
sigma_x2 = nrmlz_params(4);
mu_x3 = nrmlz_params(5);
sigma_x3 = nrmlz_params(6);
x1 = (x1-mu_x1)/sigma_x1;
x2 = (x2-mu_x2)/sigma_x2;
x3 = (x3-mu_x3)/sigma_x3;
for i=1:m
    output = output + alpha(i)*max(A_tilde(i,1)+...
        A_tilde(i,2)*x1+A_tilde(i,3)*x2+A_tilde(i,4)*x3,0);
%     output = output + alpha(i)*sigmoid(A_tilde(i,1)+A_tilde(i,2)*x1+A_tilde(i,3)*x2);
end
end

function plot_points(data_file,num_training)
a = cell2mat(struct2cell(load(data_file)));
a = a(num_training:size(a,1),:);
figure,
indices_p1 = a(:,4)==1;
indices_m1 = a(:,4)==-1;
scatter3(a(indices_p1,1),a(indices_p1,2),a(indices_p1,3),'bo'); hold on;
scatter3(a(indices_m1,1),a(indices_m1,2),a(indices_m1,3),'rx');
end
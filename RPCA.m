clear;clc;
close all;
load('vangogh-4.mat')
picname=[vg,nvg];
color=repmat([1 1 0],64,1);
color=[color;repmat([1 0 1],15,1)];
tX=X;
%rpca
n=size(tX,1);
k=size(tX,2);
% Choose the regularization parameter
lambda = 0.1;
% Solve the SDP by calling cvx toolbox
%if exist('cvx_setup.m','file')
    cd ../cvx/
    cvx_setup
%end
cvx_begin
    variable L(k,n);
    variable S(k,n);
    variable W1(k,k);
    variable W2(n,n);
    variable Y(k+n,k+n) symmetric;
    Y == semidefinite(k+n);
    minimize(.5*trace(W1)+.5*trace(W2)+lambda*sum(sum(abs(S))));
    subject to
        L + S >= tX' - 1e-5;
        L + S <= tX' + 1e-5;
        Y == [W1, L;L' W2];
cvx_end

cd ../vangogh

% embedding 
B=L'*L;
[V d]=eig(B);
[d i] = sort(diag(d), 'descend');
figure(2);
plot(d/sum(d),'*-');
title('eigenvalue proportion(lambda=0.1)');
print(2,'-djpeg','2.jpeg')
nV = V(:,i(1:2));
nd = diag(sqrt(d(1:2)));
ntX = nV*nd';

figure(3);
scatter(ntX(:,1),ntX(:,2),20,color,'filled');
text(ntX(:,1),ntX(:,2),picname,...
        'FontSize',8,'FontWeight','normal');
title('RPCA embedding location(lambda=0.1)');
axis off;
print(3,'-djpeg','3.jpeg');

close all;

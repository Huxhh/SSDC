function distance = Mydistance(x,model)
%% ===========Parameters============
%calculate the distance between each samples
%date: 2010-11-28
%author:Yazhou Ren www.scut.edu.cn  email:yazhou.ren@mail.scut.edu.cn 
%Input
%  x    ---  data,N*R
%  model---  model of distance. Default:euclidean
%Output
% distance ---  distance matrix

%% ============main()============
if (0==nargin)
    error('Not enough input arguments');
elseif (1==nargin)
  model = 'euclidean';  
end

switch model
    case 'euclidean'        
        N = size(x,1);  %the number of samples
        X_2 = sum(x.^2,2);
        test = repmat(X_2,1,N);
        test2 = 2.*x*x';
        distance = repmat(X_2,1,N) + repmat(X_2',N,1) - 2.*x*x';
end
% for i=1:N
%     distance(i,i) = 0; % ensure distance(i,i)=0
% end
distance( logical(eye(N)) ) = 0; % ensure distance(i,i)=0
distance = sqrt(distance); % attention
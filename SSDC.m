function [cl] = SSDC(X,percent, ML, CL,D)
X = single(X);
dist = single( Mydistance(X) ); 
ND = size(X,1);
%��dist��Ϊ���ظ���������
xx = single( reshape(dist,ND*ND,1) );
xx = unique(xx);
N = size(xx,1);
% 
% sddist = mydist(dist);
% 
% [abc, sda_num] = sort(sddist(:,3));

if(~exist('percent','var'))
    percent=3;
end
fprintf('average percentage of neighbours (hard coded): %5.6f\n', percent);
position=round(N*percent/100);
sda=sort(xx);
dc=sda(position);
fprintf('Computing Rho with gaussian kernel of radius: %12.6f\n', dc);
clear xx sda;

rho = zeros(ND,1);
%
% Gaussian kernel
% %
% for i=1:ND-1
%   for j=i+1:ND
%      rho(i)=rho(i)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
%      rho(j)=rho(j)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
%   end
% end
%
% "Cut off" kernel
%
for i=1:ND-1
 for j=i+1:ND
   if (dist(i,j)<dc)
      rho(i)=rho(i)+1.;
      rho(j)=rho(j)+1.;
   end
 end
end

maxd=max(max(dist));

[rho_sorted,ordrho]=sort(rho,'descend');
delta(ordrho(1))=-1.;
% nneigh(ordrho(1))=0;
nneigh(ordrho(1))=ordrho(1);

for ii=2:ND
   delta(ordrho(ii))=maxd;
   for jj=1:ii-1
     if(dist(ordrho(ii),ordrho(jj))<delta(ordrho(ii)))
        delta(ordrho(ii))=dist(ordrho(ii),ordrho(jj));
        nneigh(ordrho(ii))=ordrho(jj);
     end
   end
end
delta(ordrho(1))=max(delta(:));
disp('Generated file:DECISION GRAPH')
disp('column 1:Density')
disp('column 2:Delta')


for i = 1 : ND
    rhomdelta(i) = rho(i) * delta(i);
end

rhomdeltaord = sort(rhomdelta, 'descend');
clbord = fix(sqrt(ND) / D);
rhomdeltamin = rhomdeltaord(clbord);
NCLUST=0;
cl = zeros(ND,1)-1;


for i = 1 : ND
    if(rhomdelta(i) >= rhomdeltamin)
        NCLUST = NCLUST + 1;
        cl(i) = NCLUST;
        icl(NCLUST) = i;
    end
end

fprintf('NUMBER OF CLUSTERS: %i \n', NCLUST);
disp('Performing assignation')

%assignation
for i=1:ND
  if (cl(ordrho(i))==-1)
    cl(ordrho(i))=cl(nneigh(ordrho(i)));
  end
end

%halo
[halo]=halo_func(NCLUST,ND,cl,rho,dc,icl);


[MLrow,MLcol]=size(ML);
[CLrow,CLcol]=size(CL);
q=4;
if(~isempty(CL))
    [ML,CL]=cconstrains(ML,CL,cl);
    %%�ж����������Ƿ����cannot-link
    flag=true;
    while(flag==true)
        row=find(CL(:,3)==CL(:,4));
        if(isempty(row))
            flag=false;
        %����ʱ���д���CL
        else
            %ѡȡ������
             rhodelta=zeros(ND,1);%��ʼ��rho*delta
             clrow=find(cl==CL(row(1),3));%�ҳ���һ������CL��ʱ�������Ԫ��
             rhodelta(clrow)=rho(clrow)'.*delta(clrow);%�������������Ԫ�ص�rho*delta
             NCLUST=NCLUST+1;
             %���ܳ���rhodeltaȫΪ0�������ֻ��һ��Ԫ�ط��� ������rho���кܶ�0��
             if ((~any(rhodelta)) || (length(find(rhodelta))==1))
                 if(ismember(CL(row(1),1),icl))%����һ����Ϊ���ĵ�
                     icl(NCLUST)=CL(row(1),2);%ȡ�ڶ�����Ϊ�����ĵ�
                     cl(CL(row(1),2))=NCLUST;
                 else   icl(NCLUST)=CL(row(1),1);
                     cl(CL(row(1),1))=NCLUST;
                 end
             else%���ж��Ԫ�ط���
                 [hs,sh]=sort(rhodelta,'descend');%����rhodelta�Ӵ�С����
                 icl(NCLUST)=sh(2);%ȡrhodelta�ڶ����Ϊ������
                 cl(sh(2))=NCLUST;
             end
            %���·���ʣ���
            clrow=find(cl(ordrho)==CL(row(1),3));
            cl(ordrho(clrow))=-1;
            cl(icl(CL(row(1),3)))=CL(row(1),3);
            cl(icl(NCLUST))=NCLUST;
             for k=1:ND   
              if(cl(ordrho(k))==-1)
                cl(ordrho(k))=cl(nneigh(ordrho(k)));
              end
             end
            [ML,CL]=cconstrains(ML,CL,cl);
        end
    end


    MC=0;
   % q=4;
    for i=1:MLrow
        %%�ж���mlԼ�����Ƿ��Ѿ���һ����
      if(ML(i,3)==ML(i,4))
          continue;
      else
            for j=1:CLrow
              %%�ж��Ƿ���clԼ��ì��
            if((CL(j,3)==ML(i,3) && CL(j,4)==ML(i,4)) || (CL(j,3)==ML(i,4) && CL(j,4)==ML(i,3)))
              MC=1;
              break;
            end
            end
            if(MC==0)
            %%����ì����ϲ�
            [icl,cl,NCLUST,ML,CL]=MLmerge(i,rho,icl,cl,ND,ML,CL,NCLUST);
%             myplot(NCLUST, rho, delta, icl, dist, ND, halo, cl, X,q);
            q=q+1;
            end 
      end
    end
end
%%��ʼ������
for i=1:NCLUST
  for j=1:NCLUST
    dij(i,j)=max(max(dist));
  end
end
%%������
for i=1:ND-1
    for j=i+1:ND
        if(halo(i)~=0 && halo(j)~=0 && cl(i)~=cl(j) && dist(i,j)<dij(cl(i),cl(j)))
            dij(cl(i),cl(j))=dist(i,j);
        end
    end
end
%%�ϲ��ڽ���
flag=true;
while(flag==true)
    [row,col]=find(dij<dc);
    if(isempty(row))
        flag=false;
    else
        MC=0;
%         if(CLrow==0)
        if(CLrow~=0)
            for k=1:CLrow
                %%�ж��ٽ����Ƿ���clԼ��ì��
                if((CL(k,3)==row(1) && CL(k,4)==col(1))||(CL(k,3)==col(1)) && CL(k,4)==row(1))
                MC=1;
                dij(row(1),col(1))=max(max(dist));
                dij(col(1),row(1))=max(max(dist));
                break;
                end
            end
        end
        if(MC==0)
            %%����ì����ϲ�
            [icl,cl,NCLUST,ML,CL,dij]=neighbormerge(row(1),col(1),rho,icl,cl,ML,CL,NCLUST,dij);
%             myplot(NCLUST, rho, delta, icl, dist, ND, halo, cl, X,q);
            q=q+1;
        end
    end
end


%halo
[halo]=halo_func(NCLUST,ND,cl,rho,dc,icl);

% accuracy = accu(cl,Y, ND);
% fprintf('accu=%f\n', accuracy);

% cmap=colormap;
% disp('Performing 2D nonclassical multidimensional scaling')
% if(size(X,2)==2)
%     figure(3);
%     plot(X(:,1),X(:,2),'o','MarkerSize',2,'MarkerFaceColor','k','MarkerEdgeColor','k');
%     xlabel ('X')
%     ylabel ('Y')    
%     A = zeros(ND,2);
%     for i=1:NCLUST
%         nn=0;
%         ic=int8((i*64.)/(NCLUST*1.));
%         for j=1:ND
%              if (halo(j)==i)
%                 nn=nn+1;
%                 A(nn,1)=X(j,1);
%                 A(nn,2)=X(j,2);
%             end
%         end
%         hold on
%         plot(X(icl(i),1),X(icl(i),2),'o','MarkerSize',12,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor','r','LineWidth',1.5);
%         plot(A(1:nn,1),A(1:nn,2),'o','MarkerSize',2,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
%     end
% end
% faa = fopen('CLUSTER_ASSIGNATION', 'w');
% disp('Generated file:CLUSTER_ASSIGNATION')
% disp('column 1:element id')
% disp('column 2:cluster assignation without halo control')
% disp('column 3:cluster assignation with halo control')
% for i=1:ND
%    fprintf(faa, '%i %i %i\n',i,cl(i),halo(i));
% end
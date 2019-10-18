function [icl,cl,NCLUST,ML,CL,dij]=neighbormerge(i,j,rho,icl,cl,ML,CL,NCLUST,dij)
if(i<j)
    newcl=i;
    oldcl=j;
else newcl=j;
    oldcl=i;
end
rho1=rho(icl(i));
rho2=rho(icl(j));
if(rho1<rho2)
  icl(i)=icl(j);
else icl(j)=icl(i);
end         
cl(find(cl==oldcl))=newcl;
cl(find(cl>oldcl))=cl(find(cl>oldcl))-1;
icl(oldcl)=[];
dij(oldcl,:)=[];
dij(:,oldcl)=[];
NCLUST=NCLUST-1;
if(~isempty(CL))
[ML,CL]=cconstrains(ML,CL,cl);
end

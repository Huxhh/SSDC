function [icl,cl,NCLUST,ML,CL]=MLmerge(i,rho,icl,cl,ND,ML,CL,NCLUST)      

if(ML(i,3)<ML(i,4))
    newcl=ML(i,3);
    oldcl=ML(i,4);
else newcl=ML(i,4);
    oldcl=ML(i,3);
end
rho1=rho(icl(ML(i,3)));                        
rho2=rho(icl(ML(i,4)));
if(rho1<rho2)
  icl(newcl)=icl(ML(i,4));
else icl(newcl)=icl(ML(i,3));
end
for k=1:ND
  if(cl(k)==ML(i,3)||cl(k)==ML(i,4))
    cl(k)=newcl;
  end  
end
for k=oldcl+1:NCLUST
    for n=1:ND
        if(cl(n)==k)
            cl(n)=k-1;
        end
    end
    icl(k-1)=icl(k);
end

NCLUST=NCLUST-1;
icl=icl(1:NCLUST);
[ML,CL]=cconstrains(ML,CL,cl);



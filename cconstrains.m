%%生成类间约束
function [ML,CL]=cconstrains(cml,ccl,cl)
[mlrow,mlcol]=size(cml);
[clrow,clcol]=size(ccl);
for i=1:mlrow
    ML(i,:)=[cml(i,1) cml(i,2) cl(cml(i,1)) cl(cml(i,2))];
end
for i=1:clrow
    CL(i,:)=[ccl(i,1),ccl(i,2),cl(ccl(i,1)),cl(ccl(i,2))];
end
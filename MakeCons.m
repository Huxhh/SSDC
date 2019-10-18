function [CL, ML] = MakeCons2(gnd,N)

ND=length(gnd);

k=1;
% for i=1:ND-1
%     for j=i+1:ND
%          constrains(k,:)=[i,j];
%         k=k+1;
%     end
%     fprintf('%d\n', i);
% end

x = 1;
for i = 1:ND-1
    y = x + ND - i;
    constrains(x : y - 1, 1) = i;
    constrains(x : y - 1, 2) = i + 1 : ND;
    x = y;
end

t=round(ND*(ND-1)/2);
num=randperm(t,fix(ND *(N / 10))); 
numCL = 1;
numML = 1;
for i=1:length(num)
    if(gnd(constrains(num(i), 1)) ~= gnd(constrains(num(i), 2)))
        CL(numCL,1)=constrains(num(i),1);
        CL(numCL,2)=constrains(num(i),2);
        numCL=numCL+1;
    else
        ML(numML,1)=constrains(num(i),1);
        ML(numML,2)=constrains(num(i),2);
        numML=numML+1;
    end
end
if(numML == 1)
    ML(1,1) = 1;
    ML(1,2) = 1;
end
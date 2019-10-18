function [resultAR,resultRI,p] = one_sample(data)
fprintf('%s\n', data);
load(data);
X = zscore(fea);
Y = fixlabel(gnd);

Perc = 2;
T = 2;
for i = 1 : Perc
    for j = 1 : T
        [CL, ML] = MakeCons(Y, i);
        [cl] = SSDC(X, 3, ML, CL, 1);
        [AR,RI,MI,HI] = valid_RandIndex(gnd,cl);
        resultAR(i,j) = AR;
        resultRI(i,j) = RI;
        p(i, j) = GetNMI(gnd, cl);
    end
    resultAR(i, j + 1) = mean(resultAR(i,1 : T));
    resultRI(i, j + 1) = mean(resultRI(i,1 : T));
    p(i, j + 1) = mean(p(i, 1 : T));
end

rs=['./',data,'-result.mat'];
save(rs, 'resultAR', 'resultRI', 'p');
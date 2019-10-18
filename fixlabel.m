function y = fixlabel(gnd)
% ============Parameter============
% date: 2013-05-07
% fix labels in {1,2,...}
% author:Yazhou Ren  www.scut.edu.cn  email:yazhou.ren@mail.scut.edu.cn 
%Input
%  gnd   ---  original labels (vector)
%Output
%   y    ---  fixed labels {1,2,...}

% ==============Main===============
y=zeros(size(gnd));
uniquelabels = unique(gnd);
for i=1:length(uniquelabels)
    idx = (gnd==uniquelabels(i));
    y(idx) = i;
end


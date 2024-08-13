function [rgnInfoCell, varargout] = createRngInfoFromLablels(Labels)
%CREATERNGINFOFROMLABLELS intialize regigion information cell from a label
%matrix
% inPut:
%   Labels:Label matrix start from 1.
%outPut:
%   rgnInfoCell:a Cell, and every element is one region's information.

% 2014/03/22 revised in order to accord with new °±labels2edges°∞ function°£
% leiguang

rgnInfoCell = cell(1,max(Labels(:)));
stats = regionprops(Labels,'PixelIdxList');

%label and ponits index
for i = 1:max(Labels(:))
    rgnInfoCell{i}.label = i;
    rgnInfoCell{i}.points_list = (stats(i).PixelIdxList)';
end


%¡⁄”Ú–≈œ¢
edges = labels2edges(Labels);

% 
if nargout == 2
%     NeiborMat = sparse(false(numel(stats),numel(stats)));
      NeiborMat = (false(numel(stats),numel(stats)));

    for i = 1:numel(rgnInfoCell)
        rgnInfoCell{i}.Neibor = edges(edges(:,1)==i,2);
        NeiborMat(i,edges(edges(:,1)==i,2)) = true;
        NeiborMat(edges(edges(:,1)==i,2),i) = true;
    end
    varargout{1} = sparse(NeiborMat);
else
    for i = 1:numel(rgnInfoCell)
        rgnInfoCell{i}.Neibor  = edges(edges(:,1)==i,2);
    end
end

return;


function varargout = labels2edges(labels)
%IMRAG 依据区域标记矩阵，获得每个结点的边（由imRAG改写）

% 2014/03/22 修改“邻接区域有1-2 无 2-1"的问题

% count number of regions
N = double(max(labels(:)));

if size(labels,3) ~=1
    error('标记矩阵必为一维')
end

% size of label matrix
dim = size(labels);

%//统计计算当前点的标号与右、下、右下、左下的标号是否相同来确定区域邻接关系

%---1.计算上下变化（第i行，为labels(i+1,:）-labels(i,:）
diff1 = abs(diff(double(labels), 1, 1));

%非0元素意味着区域的变化
[rows, cols] = find(diff1);

% 变化的当前位置和相邻位置在labels矩阵中对应的索引
indx1 = sub2ind(dim, rows, cols);
indx2 = sub2ind(dim, rows+1, cols);

%统计边
edges = unique([labels(indx1) labels(indx2)], 'rows');

%---2.计算左右变化（第i列，为labels(:，i+1）-labels(:,i）
diff2 = abs(diff(double(labels), 1, 2));

%非0元素意味着区域的变化
[rows, cols] = find(diff2);

% 变化的当前位置和相邻位置在labels矩阵中对应的索引
indx1 = sub2ind(dim, rows, cols);
indx2 = sub2ind(dim, rows, cols+1);

%统计边
edges = unique([edges; unique([labels(indx1) labels(indx2)], 'rows')],'rows');


%---3.计算右下对角变化（第(i,j)，为labels(j+1，i+1）-labels(j,i）
diff3 =abs(labels(2:end,2:end)-labels(1:end-1,1:end-1));

%非0元素意味着区域的变化
[rows, cols] = find(diff3);

% 变化的当前位置和相邻位置在labels矩阵中对应的索引
indx1 = sub2ind(dim, rows, cols);
indx2 = sub2ind(dim, rows+1, cols+1);

%统计边
edges = unique([edges; unique([labels(indx1) labels(indx2)], 'rows')],'rows');

% %---计算左下对角变化（第(i,j)，为labels(i，j+1）-labels(i+1,j）
diff4 =abs(labels(2:end,1:end-1)-labels(1:end-1,2:end));

%非0元素意味着区域的变化
[rows, cols] = find(diff4);

% 变化的当前位置和相邻位置在labels矩阵中对应的索引
indx1 = sub2ind(dim, rows, cols+1);
indx2 = sub2ind(dim, rows+1, cols);

%统计边
edges = unique([edges; unique([labels(indx1) labels(indx2)], 'rows')],'rows');


% 位置互换
edges = [edges;edges(:,2),edges(:,1)];

% 消除重复并排序
edges = unique(edges, 'rows');
edges = sortrows(edges);


if nargout == 1
    varargout{1} = edges;
end

if nargout == 2
    % Also compute region centroids
    stats = regionprops(labels, 'centroid');
    tab = [stats.Centroid];
    if length(size(labels))==2
        points = [tab(1:2:2*N-1)' tab(2:2:2*N)'];
    elseif length(size(labels))==3
        points = [tab(1:3:3*N-2)' tab(2:3:3*N-1)' tab(3:3:3*N)'];
    end
    
    varargout{1} = points;
    varargout{2} = edges;
end

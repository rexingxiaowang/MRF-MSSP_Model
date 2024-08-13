function [stat,edges] = labels2edges_self(labels)
%IMRAG 依据区域标记矩阵，获得每个结点的边（由imRAG改写）

% count number of regions
N = double(max(labels(:)));   %---------在这里N是等于rgnCount的数目，只不过用双精度进行了表示

if size(labels,3) ~=1
    error('标记矩阵必为一维')
end

% size of label matrix
dim = size(labels);

%建立邻接矩阵
stat=zeros(N);

%//统计计算当前点的标号与右、下、右下、左下的标号是否相同来确定区域邻接关系

%---1.计算上下变化（第i行，为labels(i+1,:）-labels(i,:）
diff1 = abs(diff(double(labels), 1, 1));   %---abs函数返回数组 （）中每个元素的绝对值。Y = diff(X,n,dim) 是沿 dim 指定的维计算的第 n 个差分。dim 输入是一个正整数标量。计算像素上下的差值   

%非0元素意味着区域的变化
[rows_1,cols_1] = find(diff1);   %  [row,col] = find(___) 使用前面语法中的任何输入参数返回数组 X 中每个非零元素的行和列下标

% 变化的当前位置和相邻位置在labels矩阵中对应的索引
indx1_1 = sub2ind(dim, rows_1, cols_1);   %将下标转换为线性索引
indx2_1 = sub2ind(dim, rows_1+1, cols_1);

%---2.计算左右变化（第i列，为labels(:，i+1）-labels(:,i）
diff2 = abs(diff(double(labels), 1, 2));

%非0元素意味着区域的变化
[rows_2,cols_2] = find(diff2);

% 变化的当前位置和相邻位置在labels矩阵中对应的索引
indx1_2 = sub2ind(dim, rows_2, cols_2);
indx2_2 = sub2ind(dim, rows_2, cols_2+1);

%---3.计算右下对角变化（第(i,j)，为labels(j+1，i+1）-labels(j,i）
diff3 =abs(labels(2:end,2:end)-labels(1:end-1,1:end-1));

%非0元素意味着区域的变化
[rows_3,cols_3] = find(diff3);

% 变化的当前位置和相邻位置在labels矩阵中对应的索引
indx1_3 = sub2ind(dim, rows_3, cols_3);
indx2_3 = sub2ind(dim, rows_3+1, cols_3+1);

% %---计算左下对角变化（第(i,j)，为labels(i，j+1）-labels(i+1,j）
diff4 =abs(labels(2:end,1:end-1)-labels(1:end-1,2:end));

%非0元素意味着区域的变化
[rows_4,cols_4] = find(diff4);

% 变化的当前位置和相邻位置在labels矩阵中对应的索引
indx1_4 = sub2ind(dim, rows_4, cols_4+1);
indx2_4 = sub2ind(dim, rows_4+1, cols_4);

%% 统计索引
indx1=[indx1_1;indx1_2;indx1_3;indx1_4];
indx2=[indx2_1;indx2_2;indx2_3;indx2_4];
l1=labels(indx1);
l2=labels(indx2);

indx_a=[indx1;indx2];indx_b=[indx2;indx1];
%统计边
edges = unique([l1 l2], 'rows');
[~,ia,~] = unique([(indx_a) labels(indx_b)], 'rows');

%统计矩阵
num_1=numel(ia);
for i=1:num_1
    stat(labels(indx_a(ia(i))),labels(indx_b(ia(i))))=stat(labels(indx_a(ia(i))),labels(indx_b(ia(i))))+1;
end

% num_2=numel(ib);
% for i=1:num_2
%     stat(labels(indx2(ib(i))),labels(indx1(ib(i))))=stat(labels(indx2(ib(i))),labels(indx1(ib(i))))+1;
% end

% %统计边
% edges = unique([labels(indx1) labels(indx2)], 'rows');
% 
% %---2.计算左右变化（第i列，为labels(:，i+1）-labels(:,i）
% diff2 = abs(diff(double(labels), 1, 2));
% 
% %非0元素意味着区域的变化
% [rows cols] = find(diff2);
% 
% % 变化的当前位置和相邻位置在labels矩阵中对应的索引
% indx1 = sub2ind(dim, rows, cols);
% indx2 = sub2ind(dim, rows, cols+1);
% 
% %统计矩阵
% num_2=numel(indx1);
% for i=1:num_2
%     stat(labels(indx1(i)),labels(indx2(i)))=stat(labels(indx1(i)),labels(indx2(i)))+1;
%     stat(labels(indx2(i)),labels(indx1(i)))=stat(labels(indx2(i)),labels(indx1(i)))+1;
% end
% 
% %统计边
% edges = unique([edges; unique([labels(indx1) labels(indx2)], 'rows')],'rows');
% 
% 
% %---3.计算右下对角变化（第(i,j)，为labels(j+1，i+1）-labels(j,i）
% diff3 =abs(labels(2:end,2:end)-labels(1:end-1,1:end-1));
% 
% %非0元素意味着区域的变化
% [rows cols] = find(diff3);
% 
% % 变化的当前位置和相邻位置在labels矩阵中对应的索引
% indx1 = sub2ind(dim, rows, cols);
% indx2 = sub2ind(dim, rows+1, cols+1);
% 
% %统计矩阵
% num_3=numel(indx1);
% for i=1:num_3
%     stat(labels(indx1(i)),labels(indx2(i)))=stat(labels(indx1(i)),labels(indx2(i)))+1;
%     stat(labels(indx2(i)),labels(indx1(i)))=stat(labels(indx2(i)),labels(indx1(i)))+1;
% end
% 
% %统计边
% edges = unique([edges; unique([labels(indx1) labels(indx2)], 'rows')],'rows');
% 
% % %---计算左下对角变化（第(i,j)，为labels(i，j+1）-labels(i+1,j）
% diff4 =abs(labels(2:end,1:end-1)-labels(1:end-1,2:end));
% 
% %非0元素意味着区域的变化
% [rows cols] = find(diff4);
% 
% % 变化的当前位置和相邻位置在labels矩阵中对应的索引
% indx1 = sub2ind(dim, rows, cols+1);
% indx2 = sub2ind(dim, rows+1, cols);
% 
% %统计矩阵
% num_4=numel(indx1);
% for i=1:num_4
%     stat(labels(indx1(i)),labels(indx2(i)))=stat(labels(indx1(i)),labels(indx2(i)))+1;
%     stat(labels(indx2(i)),labels(indx1(i)))=stat(labels(indx2(i)),labels(indx1(i)))+1;
% end
% 
% %统计边
% edges = unique([edges; unique([labels(indx1) labels(indx2)], 'rows')],'rows');


%排序并消除重复
% format output to have increasing order of n1,  n1<n2, and
% increasintg order of n2 for n1=constant.

edges = sortrows(sort(edges, 2));

% remove eventual double edges
edges = unique(edges, 'rows');
stat=floor(stat);            %Y = floor(X) 将 X 的每个元素四舍五入到小于或等于该元素的最接近整数。
 
% 
% if nargout == 1
%     varargout{1} = edges;
% end
% 
% if nargout == 2
%     varargout{1} = floor(stat);
%     varargout{2} = edges;
% end


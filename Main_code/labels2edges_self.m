function [stat,edges] = labels2edges_self(labels)
%IMRAG ���������Ǿ��󣬻��ÿ�����ıߣ���imRAG��д��

% count number of regions
N = double(max(labels(:)));   %---------������N�ǵ���rgnCount����Ŀ��ֻ������˫���Ƚ����˱�ʾ

if size(labels,3) ~=1
    error('��Ǿ����Ϊһά')
end

% size of label matrix
dim = size(labels);

%�����ڽӾ���
stat=zeros(N);

%//ͳ�Ƽ��㵱ǰ��ı�����ҡ��¡����¡����µı���Ƿ���ͬ��ȷ�������ڽӹ�ϵ

%---1.�������±仯����i�У�Ϊlabels(i+1,:��-labels(i,:��
diff1 = abs(diff(double(labels), 1, 1));   %---abs������������ ������ÿ��Ԫ�صľ���ֵ��Y = diff(X,n,dim) ���� dim ָ����ά����ĵ� n ����֡�dim ������һ�������������������������µĲ�ֵ   

%��0Ԫ����ζ������ı仯
[rows_1,cols_1] = find(diff1);   %  [row,col] = find(___) ʹ��ǰ���﷨�е��κ���������������� X ��ÿ������Ԫ�ص��к����±�

% �仯�ĵ�ǰλ�ú�����λ����labels�����ж�Ӧ������
indx1_1 = sub2ind(dim, rows_1, cols_1);   %���±�ת��Ϊ��������
indx2_1 = sub2ind(dim, rows_1+1, cols_1);

%---2.�������ұ仯����i�У�Ϊlabels(:��i+1��-labels(:,i��
diff2 = abs(diff(double(labels), 1, 2));

%��0Ԫ����ζ������ı仯
[rows_2,cols_2] = find(diff2);

% �仯�ĵ�ǰλ�ú�����λ����labels�����ж�Ӧ������
indx1_2 = sub2ind(dim, rows_2, cols_2);
indx2_2 = sub2ind(dim, rows_2, cols_2+1);

%---3.�������¶ԽǱ仯����(i,j)��Ϊlabels(j+1��i+1��-labels(j,i��
diff3 =abs(labels(2:end,2:end)-labels(1:end-1,1:end-1));

%��0Ԫ����ζ������ı仯
[rows_3,cols_3] = find(diff3);

% �仯�ĵ�ǰλ�ú�����λ����labels�����ж�Ӧ������
indx1_3 = sub2ind(dim, rows_3, cols_3);
indx2_3 = sub2ind(dim, rows_3+1, cols_3+1);

% %---�������¶ԽǱ仯����(i,j)��Ϊlabels(i��j+1��-labels(i+1,j��
diff4 =abs(labels(2:end,1:end-1)-labels(1:end-1,2:end));

%��0Ԫ����ζ������ı仯
[rows_4,cols_4] = find(diff4);

% �仯�ĵ�ǰλ�ú�����λ����labels�����ж�Ӧ������
indx1_4 = sub2ind(dim, rows_4, cols_4+1);
indx2_4 = sub2ind(dim, rows_4+1, cols_4);

%% ͳ������
indx1=[indx1_1;indx1_2;indx1_3;indx1_4];
indx2=[indx2_1;indx2_2;indx2_3;indx2_4];
l1=labels(indx1);
l2=labels(indx2);

indx_a=[indx1;indx2];indx_b=[indx2;indx1];
%ͳ�Ʊ�
edges = unique([l1 l2], 'rows');
[~,ia,~] = unique([(indx_a) labels(indx_b)], 'rows');

%ͳ�ƾ���
num_1=numel(ia);
for i=1:num_1
    stat(labels(indx_a(ia(i))),labels(indx_b(ia(i))))=stat(labels(indx_a(ia(i))),labels(indx_b(ia(i))))+1;
end

% num_2=numel(ib);
% for i=1:num_2
%     stat(labels(indx2(ib(i))),labels(indx1(ib(i))))=stat(labels(indx2(ib(i))),labels(indx1(ib(i))))+1;
% end

% %ͳ�Ʊ�
% edges = unique([labels(indx1) labels(indx2)], 'rows');
% 
% %---2.�������ұ仯����i�У�Ϊlabels(:��i+1��-labels(:,i��
% diff2 = abs(diff(double(labels), 1, 2));
% 
% %��0Ԫ����ζ������ı仯
% [rows cols] = find(diff2);
% 
% % �仯�ĵ�ǰλ�ú�����λ����labels�����ж�Ӧ������
% indx1 = sub2ind(dim, rows, cols);
% indx2 = sub2ind(dim, rows, cols+1);
% 
% %ͳ�ƾ���
% num_2=numel(indx1);
% for i=1:num_2
%     stat(labels(indx1(i)),labels(indx2(i)))=stat(labels(indx1(i)),labels(indx2(i)))+1;
%     stat(labels(indx2(i)),labels(indx1(i)))=stat(labels(indx2(i)),labels(indx1(i)))+1;
% end
% 
% %ͳ�Ʊ�
% edges = unique([edges; unique([labels(indx1) labels(indx2)], 'rows')],'rows');
% 
% 
% %---3.�������¶ԽǱ仯����(i,j)��Ϊlabels(j+1��i+1��-labels(j,i��
% diff3 =abs(labels(2:end,2:end)-labels(1:end-1,1:end-1));
% 
% %��0Ԫ����ζ������ı仯
% [rows cols] = find(diff3);
% 
% % �仯�ĵ�ǰλ�ú�����λ����labels�����ж�Ӧ������
% indx1 = sub2ind(dim, rows, cols);
% indx2 = sub2ind(dim, rows+1, cols+1);
% 
% %ͳ�ƾ���
% num_3=numel(indx1);
% for i=1:num_3
%     stat(labels(indx1(i)),labels(indx2(i)))=stat(labels(indx1(i)),labels(indx2(i)))+1;
%     stat(labels(indx2(i)),labels(indx1(i)))=stat(labels(indx2(i)),labels(indx1(i)))+1;
% end
% 
% %ͳ�Ʊ�
% edges = unique([edges; unique([labels(indx1) labels(indx2)], 'rows')],'rows');
% 
% % %---�������¶ԽǱ仯����(i,j)��Ϊlabels(i��j+1��-labels(i+1,j��
% diff4 =abs(labels(2:end,1:end-1)-labels(1:end-1,2:end));
% 
% %��0Ԫ����ζ������ı仯
% [rows cols] = find(diff4);
% 
% % �仯�ĵ�ǰλ�ú�����λ����labels�����ж�Ӧ������
% indx1 = sub2ind(dim, rows, cols+1);
% indx2 = sub2ind(dim, rows+1, cols);
% 
% %ͳ�ƾ���
% num_4=numel(indx1);
% for i=1:num_4
%     stat(labels(indx1(i)),labels(indx2(i)))=stat(labels(indx1(i)),labels(indx2(i)))+1;
%     stat(labels(indx2(i)),labels(indx1(i)))=stat(labels(indx2(i)),labels(indx1(i)))+1;
% end
% 
% %ͳ�Ʊ�
% edges = unique([edges; unique([labels(indx1) labels(indx2)], 'rows')],'rows');


%���������ظ�
% format output to have increasing order of n1,  n1<n2, and
% increasintg order of n2 for n1=constant.

edges = sortrows(sort(edges, 2));

% remove eventual double edges
edges = unique(edges, 'rows');
stat=floor(stat);            %Y = floor(X) �� X ��ÿ��Ԫ���������뵽С�ڻ���ڸ�Ԫ�ص���ӽ�������
 
% 
% if nargout == 1
%     varargout{1} = edges;
% end
% 
% if nargout == 2
%     varargout{1} = floor(stat);
%     varargout{2} = edges;
% end


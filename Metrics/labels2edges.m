function varargout = labels2edges(labels)
%IMRAG ���������Ǿ��󣬻��ÿ�����ıߣ���imRAG��д��

% 2014/03/22 �޸ġ��ڽ�������1-2 �� 2-1"������

% count number of regions
N = double(max(labels(:)));

if size(labels,3) ~=1
    error('��Ǿ����Ϊһά')
end

% size of label matrix
dim = size(labels);

%//ͳ�Ƽ��㵱ǰ��ı�����ҡ��¡����¡����µı���Ƿ���ͬ��ȷ�������ڽӹ�ϵ

%---1.�������±仯����i�У�Ϊlabels(i+1,:��-labels(i,:��
diff1 = abs(diff(double(labels), 1, 1));

%��0Ԫ����ζ������ı仯
[rows, cols] = find(diff1);

% �仯�ĵ�ǰλ�ú�����λ����labels�����ж�Ӧ������
indx1 = sub2ind(dim, rows, cols);
indx2 = sub2ind(dim, rows+1, cols);

%ͳ�Ʊ�
edges = unique([labels(indx1) labels(indx2)], 'rows');

%---2.�������ұ仯����i�У�Ϊlabels(:��i+1��-labels(:,i��
diff2 = abs(diff(double(labels), 1, 2));

%��0Ԫ����ζ������ı仯
[rows, cols] = find(diff2);

% �仯�ĵ�ǰλ�ú�����λ����labels�����ж�Ӧ������
indx1 = sub2ind(dim, rows, cols);
indx2 = sub2ind(dim, rows, cols+1);

%ͳ�Ʊ�
edges = unique([edges; unique([labels(indx1) labels(indx2)], 'rows')],'rows');


%---3.�������¶ԽǱ仯����(i,j)��Ϊlabels(j+1��i+1��-labels(j,i��
diff3 =abs(labels(2:end,2:end)-labels(1:end-1,1:end-1));

%��0Ԫ����ζ������ı仯
[rows, cols] = find(diff3);

% �仯�ĵ�ǰλ�ú�����λ����labels�����ж�Ӧ������
indx1 = sub2ind(dim, rows, cols);
indx2 = sub2ind(dim, rows+1, cols+1);

%ͳ�Ʊ�
edges = unique([edges; unique([labels(indx1) labels(indx2)], 'rows')],'rows');

% %---�������¶ԽǱ仯����(i,j)��Ϊlabels(i��j+1��-labels(i+1,j��
diff4 =abs(labels(2:end,1:end-1)-labels(1:end-1,2:end));

%��0Ԫ����ζ������ı仯
[rows, cols] = find(diff4);

% �仯�ĵ�ǰλ�ú�����λ����labels�����ж�Ӧ������
indx1 = sub2ind(dim, rows, cols+1);
indx2 = sub2ind(dim, rows+1, cols);

%ͳ�Ʊ�
edges = unique([edges; unique([labels(indx1) labels(indx2)], 'rows')],'rows');


% λ�û���
edges = [edges;edges(:,2),edges(:,1)];

% �����ظ�������
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

function region_class = getRegionClass(ClassLabels, labels)

rgnCount = max(labels(:));
NumClass = max(ClassLabels(:));

h = histogram2(labels(:),ClassLabels(:),[rgnCount,NumClass]);
labelHistc = h.Values;
close(gcf)
[~,region_class] = max(labelHistc,[],2);
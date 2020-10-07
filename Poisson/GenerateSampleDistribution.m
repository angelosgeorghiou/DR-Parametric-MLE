function [x_c_sample,y_c_sample,N_c_sample,C_sample] = GenerateSampleDistribution(x_c_true,y_c_true,N_c_true,C_true,SampleSize)

%%%%%%%%%%%%%%%%%%%%%%%%%
% Sampled Distribution
%%%%%%%%%%%%%%%%%%%%%%%%%

TotalSampleSize = sum(N_c_true);
N_c_true_cumulative = cumsum(N_c_true);

SampleIndices = ceil(TotalSampleSize*rand(1,SampleSize));

% Find clusters and indices
cluster_vec = zeros(1,SampleSize);
index_vec = zeros(1,SampleSize);
for i = 1:1:SampleSize
    index_cluster = 0;
    index_within_cluster = 0;
    for j = 1:1:C_true
        if (SampleIndices(i) <= N_c_true_cumulative(j))
            index_cluster = j;
            if j == 1
                index_within_cluster = SampleIndices(i);
            else
                index_within_cluster = SampleIndices(i) - N_c_true_cumulative(j-1);
            end
            break
        end
    end
    cluster_vec(i) = index_cluster;
    index_vec(i) = index_within_cluster;
end

% Create sample
unique_clusters = unique(cluster_vec);
[temp,C_sample] = size(unique_clusters);
x_c_sample = x_c_true(unique(cluster_vec),:);


N_c_sample = zeros(C_sample,1); 
mean_y_c_true = zeros(1,C_sample);
for j = 1:1:C_sample
    y_c_sample{j} = [];
    for i = 1:1:SampleSize
        if (unique_clusters(j) == cluster_vec(i))
            N_c_sample(j) =  N_c_sample(j)+1;
            y_c_sample{j}(end+1) =  y_c_true{cluster_vec(i)}(index_vec(i));
        end
    end
    y_c_sample{j};
end


return














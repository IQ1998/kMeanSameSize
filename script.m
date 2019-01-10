pkg load io

data = xlsread('Group_Data_modified.xlsx', 'E3:G45');

Points = data';

fixed_size = 4;

k = 10;

[cluster_same_size_returned, centroid_coor] = DoIt(k, Points, fixed_size);

cost = 0;
numCol = size(cluster_same_size_returned, 2);

for j = 1:3:27
  for fs = 1: fixed_size
    cost = cost + norm(cluster_same_size_returned(j:j+2, fs) - cluster_same_size_returned(j:j+2, numCol));
  endfor    
endfor
 cost = cost/40;
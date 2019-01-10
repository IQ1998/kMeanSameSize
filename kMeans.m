function [cluster, centroid] = kMeans(k, Points)
  % k: number of clusters
  
  % Points: mxn matrix: n poicnts/ m dimensions
  % centroid: a mxk matrix: k points / m dimensions
  % cluster: column vector: 1xn -> from 0->k-1
  % indicating which points belong to what clusters
  
  
  numP = size(Points, 2); % number of points
  dimP = size(Points, 1); % points' dimensions
  
  % Choose k data points as initial centroids
  centroid = Points(:, randperm(numP, k));
  % Init cluster
  cluster = zeros(1, numP);
  % Init previous cluster->stop when the 2 equal
  cluster_pre = zeros(1, numP);
  
  % Number of iters
  iters = 0;
  stop = false;
  
  while stop == false
    for index_P = 1:numP
      % vector showing distance of this point to
      % a centroid
      dis_to_cen = zeros(1, k);
      % calculate
      for i = 1:k
        dis_to_cen(i) = norm(Points(:, index_P) - centroid(:, i)); 
      endfor
      % Find index of closest centroid
      [~, cluster(index_P)] = min(dis_to_cen);
      
      
    endfor
    
    %Recompute centroid using average position
    %of all points in a cluster
    
    for index_centroid = 1:k
      centroid(:, index_centroid) = mean(Points(:, cluster == index_centroid), 2);
    endfor
    
    if cluster_pre == cluster
      stop = true;
    endif
    
    cluster_pre = cluster;
    iters = iters + 1;
  endwhile
  
  
  
  
  
endfunction

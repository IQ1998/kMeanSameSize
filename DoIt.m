function [cluster_same_size_returned, centroid_coor] = DoIt(k, Points, fixed_size)
  % centroid_coor is a 3 x k vector containing the coordinate of each centroid
  centroid_coor = zeros(3, k);
  
   % Init cluster_same_size
   % size will be number of point * 3 (get the coordinate)  x fixed_size + 1
  cluster_same_size_returned = [];
  
  while k > 0
    if k > 1
          [cluster, centroid] = kMeans(k, Points);
          
          numP = size(Points, 2); % number of points
          dimP = size(Points, 1); % points' dimensions
          %+1 indicating which centroid it belong
          %dimP because it returned the coordinate
          cluster_same_size = zeros(dimP, fixed_size + 1); 
          
          % Calculate numMem
          numMem = zeros(2, k);
          numMem(1, :) = 1:k;
          for index_C = 1:k
            logical_vector = (cluster == index_C);
            numMemC = 0;
            for i = 1:length(logical_vector)
              if logical_vector(i) == 1
                ++numMemC;
              endif
              
            endfor
            numMem(2, index_C) = numMemC;
          endfor
          center_of_centroid = mean(centroid, 2);
          %distance from each centroid to center
          
          centroid_to_center = zeros(2, k);
          centroid_to_center(1,:) = 1:k;
          for index_C = 1:k
             centroid_to_center(2, index_C) = norm(centroid(:,index_C) - center_of_centroid(:, 1));
          endfor
         
          
          %Find the furthest point
          [~, indexMax] = max(centroid_to_center(2, :));
          
          %Determine whether we recruit or discard points
          numberone = (numMem(2,indexMax) - fixed_size);
          if (numMem(2,indexMax) - fixed_size) >0   % discard
            numDiscard = numMem(2,indexMax) - fixed_size;
            %Find the closest centroid to this centroid_discarded 
            
            dist_to_other_centroid = zeros(1, k);
            for index_C = 1:k
                if index_C == indexMax 
                  dist_to_other_centroid(index_C) = 10^6;
                else
                  dist_to_other_centroid(index_C) = norm(cluster(:, index_C) - cluster(:, indexMax));
                endif
               
            endfor
            
            [~, indexClosest] = min(dist_to_other_centroid);
            %List all the point of this centroid_discarded column vector
            listPoint = [];
            for indexP = 1:numP
              if cluster(:, indexP) == indexMax
                listPoint = [listPoint indexP];
              endif
            endfor
            %Calculate the distance of these points to to closet centroid
            dP_closest_centroid = zeros(2, length(listPoint));
            for j = 1:length(dP_closest_centroid)
               dP_closest_centroid(1, :) = listPoint;
               dP_closest_centroid(2, j) = norm(Points(:,listPoint(j)) - centroid(:,indexClosest));
            endfor
            %Find numDiscard points to be discarded to the centroid 
            for i = 1:numDiscard
              [~, indexDis] = min(dP_closest_centroid(2,:));
              %remove the point from dP_closest_centroid
              cluster(1, dP_closest_centroid(1,indexDis)) = indexClosest;
              dP_closest_centroid(:,indexDis) = [];
            endfor
            
            cluster_same_size(:, 1:fixed_size) = Points(:, cluster == indexMax);
            
            
            cluster_same_size(:, fixed_size+1) = centroid(:, indexMax);
            
          
        
        
          elseif numMem(2,indexMax) - fixed_size == 0 
            cluster_same_size(:, 1:fixed_size) = Points(: ,cluster == indexMax);
            cluster_same_size(:, fixed_size+1) = centroid(:, indexMax);
    
  











  
          elseif numMem(2,indexMax) - fixed_size <0   % recruit
            numRecruit = -numMem(2,indexMax) + fixed_size;
            %Find distance to all points 
            dist_to_points = zeros(2, numP);
            for indexP = 1:numP
              dist_to_points(1, indexP) = indexP;
              dist_to_points(2, indexP) = norm(Points(:, indexP) - centroid(:, indexMax));
            
            endfor
            %Iterate throught these distance
           for i = 1:fixed_size
              [~, indexRe] = min(dist_to_points(2, :));
              
              cluster(1, dist_to_points(1, indexRe)) = indexMax;
              dist_to_points(:, indexRe) = [];
           endfor
            
           cluster_same_size(:, 1:fixed_size) = Points(:, cluster == indexMax);
           
           cluster_same_size(:, fixed_size+1) = centroid(:, indexMax);
          endif
          
          
          centroid_coor(:, k) = centroid(:, indexMax);
          cluster_same_size_returned = [cluster_same_size_returned; cluster_same_size];
          k = k - 1;
          get_out = [];
          for i = 1:numP
            if cluster(:, i) == indexMax
               get_out = [get_out i];
            endif
          endfor
          Points(:,get_out) = [];
    elseif k == 1
          [cluster, centroid] = kMeans(k, Points);
          centroid_coor(:, k) = centroid(:, k);
          
          
          cluster_same_size(:, 1:fixed_size) = Points;
          
           cluster_same_size(:, fixed_size+1) = centroid(:, k);
           cluster_same_size_returned = [cluster_same_size_returned; cluster_same_size];
           k = k - 1;
          
    endif
      
  endwhile
  
endfunction

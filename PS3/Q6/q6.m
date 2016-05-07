
img = double(imread("mandrill-small.tiff"));
pixelRows = size(img, 1);
pixelColumns = size(img, 2);

clusterAssociations = zeros(pixelRows, pixelColumns);

numClusters = 16;

clusters = zeros(numClusters, 3);


# Randomly initialize clusters
for i=1:numClusters
	randomRowIdx = int32(1 + rand() * pixelRows);
	randomColIdx = int32(1 + rand() * pixelColumns);
	clusters(i,:) = img(randomRowIdx, randomColIdx, :);
end




numChanges = 1;
numIteration = 0;

while(numChanges > 0)
	numIteration = numIteration + 1
	numChanges = 0;

	printf("Assigning pixels to clusters\n");
	fflush(stdout);
	for m=1:pixelRows
		for n=1:pixelColumns
			pixel = reshape(img(m, n, :), 1, 3);

			bestDistance = inf;
			bestCluster = inf;

			for j=1:numClusters
				cluster_j = clusters(j, :);
				distance = norm(cluster_j - pixel, 2)^2;

				if(distance < bestDistance) 
					bestDistance = distance;
					bestCluster = j;
				end
			end

			if(clusterAssociations(m,n) != bestCluster)
				clusterAssociations(m,n) = bestCluster;
				numChanges = numChanges + 1;
			end
		end
	end

	printf("Calculating centroids\n");
	fflush(stdout);
	clusters = zeros(numClusters, 3);
	numPixelsPerCluster = zeros(numClusters, 1);
	

	for m=1:pixelRows
		for n=1:pixelColumns
			pixel = reshape(img(m, n, :), 1, 3);
			associatedCluster = clusterAssociations(m, n);

			clusters(associatedCluster, :) += pixel;
			numPixelsPerCluster(associatedCluster) += 1;
		end
	end

	numPixelsPerCluster = numPixelsPerCluster

	for j=1:numClusters
		if(numPixelsPerCluster(j) > 0)
			clusters(j, :) /= numPixelsPerCluster(j);
		end
	end

	numChanges = numChanges

	printf("Calculating new total cost\n");
	totalCost = 0;
	for m=1:pixelRows
		for n=1:pixelColumns
			pixel = reshape(img(m, n, :), 1, 3);
			associatedCluster = clusterAssociations(m, n);

			cluster = clusters(associatedCluster, :);

			totalCost += norm(cluster - pixel, 2)^2;
		end
	end

	totalCost

	fflush(stdout);
end

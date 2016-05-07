img = double(imread("mandrill-small.tiff"));
pixelRows = size(img, 1);
pixelColumns = size(img, 2);

compressedImg = img;

for m=1:pixelRows
		for n=1:pixelColumns
			pixel = reshape(img(m, n, :), 1, 3);

			bestDistance = inf;
			bestCluster;

			for j=1:numClusters
				cluster_j = clusters(j, :);
				distance = norm(cluster_j - pixel, 2)^2;

				if(distance < bestDistance) 
					bestDistance = distance;
					bestCluster = cluster_j;
				end
			end

			compressedImg(m, n, :) = bestCluster;
		end
end

imwrite(uint8(round(compressedImg)), 'compressed-small.tiff');
imshow(uint8(round(compressedImg)));

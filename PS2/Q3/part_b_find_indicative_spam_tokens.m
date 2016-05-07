% Available variables
% phi_y = numSpam / numTrainDocs;
% phi_k_1 = phi_k_1_nominators ./ phi_k_1_denominators;
% phi_k_0 = phi_k_0_nominators ./ phi_k_0_denominators;

result = zeros(numTokens, 2);

for j = 1:numTokens
	result(j,1) = j;
	result(j, 2) = -log(phi_k_1(j) / phi_k_0(j));
end

sorted_result = sortrows(result, 2);

token_array = strsplit(tokenlist, " ");

for i = 1:10
	high_indicator = [i, sorted_result(i, 2), token_array(sorted_result(i,1))]
end
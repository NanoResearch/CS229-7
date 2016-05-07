function [classificationError] = nb_test(phi_y, phi_k_1, phi_k_0)

[spmatrix, tokenlist, category] = readMatrix('MATRIX.TEST');

testMatrix = full(spmatrix);
numTestDocs = size(testMatrix, 1);
numTokens = size(testMatrix, 2);

% Assume nb_train.m has just been executed, and all the parameters computed/needed
% by your classifier are in memory through that execution. You can also assume 
% that the columns in the test set are arranged in exactly the same way as for the
% training set (i.e., the j-th column represents the same token in the test data 
% matrix as in the original training data matrix).

% Write code below to classify each document in the test set (ie, each row
% in the current document word matrix) as 1 for SPAM and 0 for NON-SPAM.

% Construct the (numTestDocs x 1) vector 'output' such that the i-th entry 
% of this vector is the predicted class (1/0) for the i-th  email (i-th row 
% in testMatrix) in the test set.
output = zeros(numTestDocs, 1);

%---------------
% YOUR CODE HERE

% Available variables
% phi_y = numSpam / numTrainDocs;
% phi_k_1 = phi_k_1_nominators ./ phi_k_1_denominators;
% phi_k_0 = phi_k_0_nominators ./ phi_k_0_denominators;

for i = 1:numTestDocs
	% Document i
	x_i = testMatrix(i, :);

	% Probability that document i is spam/non-spam
	p_i_1 = 0;
	p_i_0 = 0;

	% Using log because the numbers get very small very quickly
	p_i_1_nominator = log(phi_y);
	p_i_0_nominator = log(1 - phi_y);

	% We can ignore the denominator because it is the same for both spam and non-spam
	% p_i_denominator = log(phi_y) + log(1 - phi_y);
	
	for j = 1:numTokens
		% Number of times token j occurs in document i
		x_i_j = x_i(j);

		p_i_0_nominator += x_i_j * log(phi_k_0(j));
		p_i_1_nominator += x_i_j * log(phi_k_1(j));

		% p_i_denominator += (x_i_j * log(phi_k_0(j))) + (x_i_j * log(phi_k_1(j)));
	end

	if(p_i_1_nominator >= p_i_0_nominator)
		output(i) = 1;
	else
		output(i) = 0;
	end
end


%---------------


% Compute the error on the test set
error=0;
for i=1:numTestDocs
  if (category(i) ~= output(i))
    error=error+1;
  end
end

%Print out the classification error on the test set
classificationError=error/numTestDocs



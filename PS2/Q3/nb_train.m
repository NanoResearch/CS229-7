function [phi_y, phi_k_1, phi_k_0] = nb_train(filename = "MATRIX.TRAIN")

[spmatrix, tokenlist, trainCategory] = readMatrix(filename);

trainMatrix = full(spmatrix);
numTrainDocs = size(trainMatrix, 1);
numTokens = size(trainMatrix, 2);

% trainMatrix is now a (numTrainDocs x numTokens) matrix.
% Each row represents a unique document (email).
% The j-th column of the row $i$ represents the number of times the j-th
% token appeared in email $i$. 

% tokenlist is a long string containing the list of all tokens (words).
% These tokens are easily known by position in the file TOKENS_LIST

% trainCategory is a (1 x numTrainDocs) vector containing the true 
% classifications for the documents just read in. The i-th entry gives the 
% correct class for the i-th email (which corresponds to the i-th row in 
% the document word matrix).

% Spam documents are indicated as class 1, and non-spam as class 0.
% Note that for the SVM, you would want to convert these to +1 and -1.


% YOUR CODE HERE

phi_y = 0;

% phi_k really just says: 
% "Divide number of times token x occurs in all"
% "emails together divded by number of all words"
% "-- Separated by the spam classification"
% "ie total number of times token x occured in"
% "all spam emails divided by total number of words in all spam emails"
% "It will say what the probability is that a word Z in a spam/non-spam email is token X"
phi_k_1 = zeros(numTokens, 1);
phi_k_0 = zeros(numTokens, 1);

phi_k_1_nominators = zeros(numTokens, 1);
phi_k_1_denominators = zeros(numTokens, 1);

phi_k_0_nominators = zeros(numTokens, 1);
phi_k_0_denominators = zeros(numTokens, 1);


% Laplace smoothing
phi_k_0_nominators(:) = 1;
phi_k_1_nominators(:) = 1;
phi_k_0_denominators(:) = numTokens;
phi_k_1_denominators(:) = numTokens;

numSpam = 0;

for i = 1:numTrainDocs
	% Label of i
	y_i = trainCategory(i); 
	if(y_i == 1)
		numSpam = numSpam + 1;
	end 

	% Document i
	x_i = trainMatrix(i, :); 

	% Number of words in document i
	n_i = 0; 

	for j = 1:numTokens
		% Number of times token j appears in document i
		x_i_j = x_i(j);

		% Increment number of words in document i
		n_i = n_i + x_i_j; 

		if(y_i == 1)
			phi_k_1_nominators(j) += x_i_j;
		else
			phi_k_0_nominators(j) += x_i_j;
		end
	end


	% Add number of words in document i to denominator
	if(y_i == 1) 
		phi_k_1_denominators(:) += n_i;
	else
		phi_k_0_denominators(:) += n_i;
	end
end

phi_y = numSpam / numTrainDocs;
phi_k_1 = phi_k_1_nominators ./ phi_k_1_denominators;
phi_k_0 = phi_k_0_nominators ./ phi_k_0_denominators;

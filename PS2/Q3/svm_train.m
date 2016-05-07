function [model] = svm_train(filename = "MATRIX.TRAIN")

% addpath('liblinear-1.7/matlab');  % add LIBLINEAR to the path
[sparseTrainMatrix, tokenlist, trainCategory] = readMatrix(filename);

numTrainDocs = size(sparseTrainMatrix, 1);
numTokens = size(sparseTrainMatrix, 2);

% sparseTrainMatrix is a (numTrainDocs x numTokens) sparse matrix.
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

% Note that the train function for LIBLINEAR uses the sparse matrix 
% representation of the document word matrix, which is stored in sparseTrainMatrix.
% Additionally, it expects the labels to be a regular vector
% of dimension (numTrainDocs x 1).


%---------------
% YOUR CODE HERE

% Turn 0s into -1s and leave 1s as is
svmTrainCategory = (trainCategory*2) - 1;

% Flip the train category so its a long column vector
svmTrainCategory = svmTrainCategory';

model = train(svmTrainCategory, sparseTrainMatrix);


%---------------

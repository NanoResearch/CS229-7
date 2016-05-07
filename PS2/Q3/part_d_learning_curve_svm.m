f = {"MATRIX.TRAIN.50"; "MATRIX.TRAIN.100";"MATRIX.TRAIN.200"; "MATRIX.TRAIN.400"; "MATRIX.TRAIN.800"; "MATRIX.TRAIN.1400"};

for i = 1:size(files,1)
	file = f{i}
	[model] = svm_train(file);
	svm_test(model);
end
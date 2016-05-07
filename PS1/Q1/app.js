'use strict';

var Readlines = require('sync-read-lines');
var readLines = new Readlines('./q1x.dat');
var _  = require('lodash');
require('sylvester');

var readMatrix = (path, prepend) => {
	var result = [];

	new Readlines(path).each((index, data) => {
		if(data) {
			var parts = data.trim().split(' ');
			var line = [];
			if(prepend) {
				line.push(1);
			}
			for(let p of parts) {
				p && line.push(parseFloat(p));
			}
			result.push(line);
		}
	});

	return result;
};

var x = readMatrix('./q1x.dat', true);
var y = readMatrix('./q1y.dat');

var multiplyVectors = function(v1, v2) {	
	if(v1.length !== v2.length) {
		throw 'WA';
	}

	var result = 0;
	for(var i = 0; i < v1.length; i++) {
		result += v1[i] * v2[i];
	}	
	return result;
}

var calcH = function(v1, v2) {
	return (1 / (1 + (Math.pow(Math.E, -multiplyVectors(v1, v2)))));
}

var learningRate = 0.01; //100.00001;

var calcFirstDerivativeFlat = (t,m,n) => {	
	return learningRate * ((y[m] - calcH(t, x[m])) * x[m][n]);
};

var calcSecondDerivativeFlat = (t, m, ni, nj) => {
	return -learningRate * (calcH(t, x[m]) * (1 - calcH(t, x[m])) * x[m][ni] * x[m][nj]);
};

var buildHessian = (t) => {
	var h = [];
	for(var i = 0; i < t.length; i++) {
		var row = [];
		for(var j = 0; j < t.length; j++) {
			row.push(0);
		}
		h.push(row);
	}

	for(var m = 0; m < x.length; m++) {
		for(var i = 0; i < t.length; i++) {			
			var row = h[i];
			for(var j = 0; j < t.length; j++) {
				row[j] += calcSecondDerivativeFlat(t, m, i, j);
			}
		}
	}
	return h;
}

var buildGradient = (t) => {
	var g = [];
	for(var i = 0; i < t.length; i++) {
		g.push(0);
	}
	
	for(var m = 0; m < x.length; m++) {
		for(var i = 0; i < t.length; i++) {
			g[i] += calcFirstDerivativeFlat(t,m,i);
		}
	}

	return g;
}

var multiplyMatrixWithVector = (m, v) => {
	var newVector = [];

	for(var i = 0; i < m.length; i++) {
		newVector[i] = 0;
		var row = m[i];

		if(row.length !== v.length)
			throw new Error('Matrix col span doesnt equal vector length');

		for(var j = 0; j < row.length; j++) {
			newVector[i] += row[j] * v[j]; 
		}
	}

	return newVector;
};

var buildMatrixInverse = (m) => {
	var matrix = $M(m);
	var inverse = matrix.inverse();
	
	return inverse.elements;
};

var optimizeUsingNewtonsMethod = () => {
	var theta = [0,0,0];
	var prevTheta = theta;
	var totalDelta = 1;
	var iteration = 0;

	while(totalDelta > 0.0001) {
		theta = _.clone(prevTheta);
		totalDelta = 0;
		
		var hessian = buildHessian(prevTheta);
		var gradient = buildGradient(prevTheta);

		var hessianInverse = buildMatrixInverse(hessian);
		var thetaChange = multiplyMatrixWithVector(hessianInverse, gradient);

		for(var n = 0; n < theta.length; n++) {
			theta[n] -= thetaChange[n];
		}		

		for(var n = 0; n < theta.length; n++) {
			totalDelta += Math.abs(theta[n] - prevTheta[n]);
		}

		console.log('Iteration ' + ++iteration);
		console.log(theta);

		prevTheta = theta;
	}

	console.log('Newton Solution:');
	console.log(theta);
};

var optimizeUsingGradientAscent = () => {
	var theta = [0,0,0];
	var prevTheta = theta;
	var totalDelta = 1;
	var iteration = 0;

	while(totalDelta > 0.0001) {
		theta = _.clone(prevTheta);
		totalDelta = 0;
		
		var gradient = buildGradient(prevTheta);
		var thetaChange = gradient;

		for(var n = 0; n < theta.length; n++) {
			theta[n] += thetaChange[n];
		}		

		for(var n = 0; n < theta.length; n++) {
			totalDelta += Math.abs(theta[n] - prevTheta[n]);
		}

		console.log('Iteration ' + ++iteration);
		console.log(theta);

		prevTheta = theta;
	}

	console.log('Gradient Ascent Solution:');
	console.log(theta);
};


optimizeUsingGradientAscent();
optimizeUsingNewtonsMethod();
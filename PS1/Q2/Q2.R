
xDataFrame = read.table("q2x.dat")
xDataFrame$x0 = 1
xDataFrame = xDataFrame[,c(2,1)] #Switch column 1 and 2

x = data.matrix(xDataFrame)
y = data.matrix(read.table("q2y.dat"))
numDataPoints = nrow(x)

x_t = t(x)



# Part 1
 theta = solve(x_t %*% x) %*% x_t %*% y # (X^T * X)^-1 * X^T * y
 plot(x[,2],y)
 abline(coef=theta)


# Part 2

calc_wi = function(xPoint_i, i, roh) {
	# xPointVector = vector(length=numDataPoints)
	# xPointVector[] = x[xPoint_i,2]

	xPoint_val = x[xPoint_i, 2]
	x_i_val = x[i, 2];

	return(exp(-((xPoint_val - x_i_val)^2) / (2*roh*roh) ))
}

calc_theta_p = function(p, roh) {

	w = vector(length=numDataPoints);

	for(i in 1:numDataPoints) {
		w[i] = calc_wi(p, i, roh)
	}

	wMatrix = diag(w/2) # Need to divide wi by 2 according to what we found

	theta_p = solve(x_t %*% wMatrix %*% x) %*% x_t %*% wMatrix %*% y

	return(theta_p)
}

render_locally_weighted_fit = function(roh) {
	dev.new()
	plot(x[,2],y,main=paste("Roh",roh))
	predicted_y = vector(length=numDataPoints)
	for(p in 1:numDataPoints) {
		theta_p = calc_theta_p(p, roh)
		predicted_y[p] =  x[p, ] %*% theta_p
	}

	lineData = cbind(x,predicted_y)
	lineData = lineData[order(lineData[,2]),]
	lines(lineData[,2],lineData[,3])
}

render_locally_weighted_fit(0.8)
render_locally_weighted_fit(0.1)
render_locally_weighted_fit(0.3)
render_locally_weighted_fit(2)
render_locally_weighted_fit(10)


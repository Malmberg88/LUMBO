function error=LSCostFunction(p,model,xdata,ydata)

% Fit cost function - Least squares

% Evaluate model at x data points
yfit=model(p,xdata);

% Calculate Least squares error
error=sum((ydata-yfit).^2);
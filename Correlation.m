X = O(1:100);
X = X';
Test_data = O(301:end);
Test_data = Test_data';
P = size(Test_data)-200;
coeff = [];
for k = 1:P
    Y = Test_data(k:k+99);
%     fenzi = sum(X.*Y)-(sum(X) * sum(Y))/200;
%     fenmu = sqrt((sum(X.^2)-sum(X)^2/200) * (sum(Y.^2)-sum(Y)^2/200));
    coeff = [coeff; corr(X,Y)];
%     coeff = [coeff; fenzi / fenmu];
end

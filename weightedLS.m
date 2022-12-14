function [a,b,c,sigma,totalErr]=weightedLS(w,x,y)
% 加权最小二乘法
% w为权重向量
% 用ax+by+c=0(a^2+b^2=1)拟合
% sigma为用于M估计法的尺度参数（权重w=sigma^2/(sigma^2+u^2)，u为残差）
% totalErr返回总的加权残差平方和
n=length(x);
a11=n*sum(w.*x.^2)-power(sum(w.*x),2);
a12=n*sum(w.*x.*y)-sum(w.*x)*sum(w.*y);
a22=n*sum(w.*y.^2)-power(sum(w.*y),2);
A=[a11 a12;a12 a22];
[V,D]=eig(A);
Vab1=V(:,1);
Vab2=V(:,2);
%比较两个解的总误差
avgX=sum(x)/n;
avgY=sum(y)/n;
c1=[-avgX,-avgY]*Vab1;
c2=[-avgX,-avgY]*Vab2;
errM1=Vab1(1)*x+Vab1(2)*y+c1;
errM2=Vab2(1)*x+Vab2(2)*y+c2;
totalErr1=sum(w.*errM1.*errM1);
totalErr2=sum(w.*errM2.*errM2);
if totalErr1<totalErr2
    a=Vab1(1);
    b=Vab1(2);
    c=c1;
    sigma=1.4826*median(abs(errM1));
    totalErr=totalErr1;
else
    a=Vab2(1);
    b=Vab2(2);
    c=c2;
    sigma=1.4826*median(abs(errM2));
    totalErr=totalErr2;
end

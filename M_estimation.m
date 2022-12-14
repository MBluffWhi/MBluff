
function [a,b,c]=M_estimation(x,y,K,R,err)
% M估计法拟合直线，这里拟合直线全部使用完全最小二乘法，即用ax+by+c=0(a^2+b^2=1)拟合
% 输入k为随机抽取样本的次数
% R为单次采样的采样点个数
% err为终止迭代的系数残差模值
% M估计法权重w=1/(sigma^2+u^2)，u为残差
n=length(x);
x=reshape(x,n,1);
y=reshape(y,n,1);
totalErr=zeros(K,1);
abcM=zeros(K,3);
for i=1:K
    index=randperm(n);
    indexK=index(1:R);
    xK=x(indexK);
    yK=y(indexK);
    w=ones(R,1)/R;
    [a,b,c,sigma,~]=weightedLS(w,xK,yK);
    abc_old=[a,b,c]+err*ones(1,3);
    abc=[a,b,c];
    
    errM=a*xK+b*yK+c;
    w=1./(sigma^2+errM.*errM);
    w=w/sum(w);
    while norm(abc-abc_old)>err
        abc_old=abc;
        [a,b,c,sigma,thisErr]=weightedLS(w,xK,yK);
        abc=[a,b,c];
        w=1./(sigma^2+errM.*errM);
        w=w/sum(w);
    end
    totalErr(i)=thisErr;
    abcM(i,:)=abc;
end
index=find(totalErr==median(totalErr));
abc=abcM(index(1),:);
a=abc(1);
b=abc(2);
c=abc(3);

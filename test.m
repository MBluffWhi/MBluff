clear;
clc;
close all;
[num,txt,raw] = xlsread('D:\Scholar\01-IDS\Data\S12\S32-100ms-1.xlsx');
Num1 = size(num,1);
raw_revised = raw(1:Num1,2);
raw_struct = char(raw_revised);
raw_char = cell(Num1,3);
raw_integrated = cell(Num1,1);
raw_integrated_char = [];
raw_integrated_num = zeros(Num1,1);

for i = 1:Num1
    raw_char(i,:) = strsplit(raw_struct(i,:),'.');
    raw_integrated(i) =  strcat(raw_char(i,1),raw_char(i,2),raw_char(i,3));
    raw_integrated_char = [raw_integrated_char; char(raw_integrated(i))];
end
raw_integrated_num = str2num(raw_integrated_char);
raw_integrated_num_test = raw_integrated_num/1000;  %获取delta_t 单位us

Timestamp = 0;


% 赋值并舍去前N项，与论文字母变量一致（N表示用于计算的族）
N = 10;
T = raw_integrated_num_test(1:end);
Num2 = size(T,1);

%数据预处理
M = size(T,1);
Sigma = std(T(1:50),1);
Avg = mean(T(1:50),1);
Est_val = max(T(1:50))-min(T(1:50));

flag = 0;
% for i = 3*N+1:M
%     if flag<10
%          if abs(T(i)-Avg) > 2*Est_val
%             T(i) = T(i-1);
%             flag = flag + 1;
%          else
%             T(i) = T(i);
%             flag = 0;
%          end
%     else
%         T(i) = T(i);
%         flag = 0;
%     end
%    Avg = mean(T(i-3*N+1):T(i),1);
%    Est_val = max(T(i-3*N+1:i))-min(T(i-3*N+1:i));
% end
% for i = 2*N+1:M
%     if flag<10
%          if abs(T(i)-Avg) > 2*Sigma
%             T(i) = T(i-1);
%             flag = flag + 1;
%          else
%             T(i) = T(i);
%             flag = 0;
%          end
%     else
%         T(i) = T(i);
%         flag = 0;
%     end
%    Avg = mean(T(i-2*N):T(i-1),1);
%    Sigma = std(T(i-2*N:i-1),1);
% end

for p = 2:Num1
    Timestamp = [Timestamp; Timestamp(p-1) + T(p)];
end

Sum = 0;
Mu_T(1) = mean(raw_integrated_num_test(1:N));
Oacc(1) = 0;
S(1) = 0; 
P(1) = 1;
Lamda = 0.9995; 
for p = 1:Num1
    t(p) = 0.05*p;
end

for k = 2:(Num2-N)
    Timestamp_interval = T(k:k+N-1);
    a = Timestamp(k:k+N-1);
    Mu_T(k) = mean(Timestamp_interval);
    for j = 2:N
        Sum = ((Sum + a(j)-(a(1)+(j-1)*Mu_T(k-1))));
    end
    O(k) = Sum/(N-1);
    Oacc(k) = Oacc(k-1) + O(k);
    e(k) = Oacc(k) - S(k-1)*t(k);
    
    G(k) = (Lamda^(-1)*P(k-1)*t(k))/(1+Lamda*(-1)*t(k)*t(k)*P(k-1));
    P(k) = Lamda*(-1)*(P(k-1)-G(k)*t(k)*P(k-1));
    S(k) = S(k-1) + G(k)*e(k);
   
%     h = animatedline;
%     axis([0,6000,0,30]);
%     addpoints(h,k,e(k));
%     drawnow

% 根据e的数据检测异常行为

end

e_avg = mean(e(1:2*N));
e_std = std(e(1:2*N));
L_upper = 0;
L_lower = 0;
L_record = [];
L_roll = [];
for j = 2*N+1:(Num2-2*N)

    if abs((e(j)-e_avg)/e_std)<3
        e_avg = mean(e(j-2*N+1:j));
        e_std = std(e(j-2*N+1:j));
    end
    
%     L_upper =  ((e(j)-e_avg)/e_std);
    L_upper = max(0, (e(j)-e_avg)/e_std);
    L_lower = max(0, L_lower - (e(j)-e_avg)/e_std);
    L_record = [L_record; L_upper];
    L_roll = [L_roll; L_lower];
    
end
    

% 
% figure (1)
% plot(1:Num2-N,e);
% title('e value')
% figure (2)
% plot(1:Num2-N,S);
% title('S value')
% 













   
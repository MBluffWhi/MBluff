function confusion_matrix_plot(mat,state)
% 混淆矩阵


is_normalize = state; % 该参数决定是否采用百分数显示，默认false，即显示原始数据(整数)
                    % PS. 我想写默认参数的，然而matlab不支持，哭辽~~
                    
if is_normalize
    mat=mat./(sum(mat,2));  % 按行缩放到[0, 1]内
end

% 简单检查输入
if size(mat,1)~=size(mat,2)
    error("Error occurred: Wrong input!")
end
% 输入矩阵大小为dim*dim
dim=size(mat,1);


% 标签
label = {'A','B','C','D','E','F','G','H'};

% 混淆矩阵主题颜色
% 可通过各种拾色器获得rgb色值
% maxcolor = [191,54,10]; % 最大值颜色
maxcolor = [191,64,60]; % 最大值颜色
mincolor = [255,255,255]; % 最小值颜色

% 绘制坐标轴
m = length(mat);
imagesc(1:m,1:m,mat)
xticks(1:m)
xlabel('Predicted class','fontsize',12)
xticklabels(label)
yticks(1:m)
ylabel('Actual class','fontsize',12)
yticklabels(label)


% 构造渐变色
mymap = [linspace(mincolor(1)/255,maxcolor(1)/255,64)',...
         linspace(mincolor(2)/255,maxcolor(2)/255,64)',...
         linspace(mincolor(3)/255,maxcolor(3)/255,64)'];

colormap(mymap)
colorbar()

format bank
% 色块填充数字
for i = 1:m
    for j = 1:m

    if mat(j,i) < 0.001
        text(i,j,strcat(num2str(mat(j,i).*100, '%.0f')),...
            'horizontalAlignment','center',...
            'verticalAlignment','middle',...
            'fontname','Times New Roman',...
             'FontWeight','normal',...
            'fontsize',12);
    elseif  mat(j,i) == 1
            text(i,j,strcat(num2str(mat(j,i).*100, '%.0f'),{'%'}),...
            'horizontalAlignment','center',...
            'verticalAlignment','middle',...
            'fontname','Times New Roman',...
             'FontWeight','normal',...
            'fontsize',12);
    else
        text(i,j,strcat(num2str(mat(j,i).*100, '%.1f'),{'%'}),...
            'horizontalAlignment','center',...
            'verticalAlignment','middle',...
            'fontname','Times New Roman',...
            'FontWeight','normal',...
            'Fontsize',12);
    end
        
    end
end

% 图像坐标轴等宽
ax = gca;
ax.FontName = 'Times New Roman';
set(gca,'box','on','xlim',[0.5,m+0.5],'ylim',[0.5,m+0.5]);
axis square

end
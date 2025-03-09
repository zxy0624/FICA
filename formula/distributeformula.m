close all
clc; clear
n = 8; % 总的数字数量
k = 5;  % 需要选择的数字数量

% 初始化结果矩阵
results = zeros(nchoosek(n+k-1,k), k);

% 生成所有可能的组合
count = 1;
for i1 = 1:n
    for i2 = i1:n
        for i3 = i2:n
            for i4 = i3:n
                for i5 = i4:n
                    results(count, :) = [i1, i2, i3, i4, i5];
                    count = count + 1;
                end
            end
        end
    end
end
Fcombination = results;
% 打印结果
save Fcombination.mat Fcombination


% 假设你的矩阵是matrix
matrix = Fcombination; % 请将这里替换为你的矩阵

% 获取矩阵的大小
[m, n] = size(matrix);

% 初始化结果矩阵
result = zeros(m, n*6);

% 对每一行进行处理
for i = 1:m
    for j = 1:n
        % 将每个数乘100然后分别从1加到6
        result(i, (j-1)*6+1:j*6) = matrix(i, j) * 100 + (1:6);
    end
end

Gcombination = result;
save combination.mat Gcombination;

% 加载你的矩阵
load('combination.mat');

% 获取矩阵的大小
[m, n] = size(Gcombination);

% 初始化结果矩阵
result = zeros(m, n);

%%打乱index
inde = zeros(6188, 30);

% 对每一行进行处理
for i = 1:6188
    % 对每一列进行处理
    for j = 1:30
        % 计算当前的数字
        num = floor((j-1)/6) * 100 + mod(j-1, 6) + 101;
        
        % 将数字存入矩阵
        index(i, j) = num;
    end
end

% 对每一行进行处理
for i = 1:m
    % 获取当前行，并计算每个元素除以100的余数
    row = index(i, :);
    remainders = mod(row, 100);
    
    % 根据余数对元素进行排序
    [~, idx] = sort(remainders);
    result(i, :) = row(idx);
end

% 保存结果
index = result;
Gcombination = index;
save('combination.mat', 'Gcombination','Fcombination');

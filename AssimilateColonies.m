%% Assimilation of colonies
% 这是AssimilateColonies函数的定义。它接受三个输入参数：TheEmpire，ProblemParams和Empires。
% 这个函数的目的是将殖民地同化到 全球 非支配解集中随机选择的一个帝国主义者那里。
% 在同化之后，有20%的概率应用经济变化操作
%分段替换！！！！先全局选父本！！！
%局部探索可以加
function TheEmpire = AssimilateColonies(TheEmpire,ProblemParams, Empires,Decade,AlgorithmParams,Deals,numofmec)
GlobalNDS.Cost = [];
GlobalNDS.Position = [];

for i=1:numel(Empires) %%大帝国的个数,将每个州所有帝国主义者的位置和成本添加到GlobalNDS结构体中。
    Empires(i).ImperialistPosition = cell2mat(Empires(i).ImperialistPosition);
    GlobalNDS.Position(end+1:end+size(Empires(i).ImperialistPosition),:) = Empires(i).ImperialistPosition;
    GlobalNDS.Cost(end+1:end+size(Empires(i).ImperialistPosition)/numofmec,:) = Empires(i).ImperialistCost;
end

GlobalNDS.Position = matrix_to_cell(GlobalNDS.Position,numofmec);%所有的第一梯队中再取第一梯队
[GlobalNDS.Cost, NewIn] = NonDominationSort(GlobalNDS.Cost,ProblemParams.M); % 非支配排序
GlobalNDS.Position = GlobalNDS.Position(NewIn,:);%将位置排序成与非支配排序结果一一对应

GlobalNDS.Position = GlobalNDS.Position(GlobalNDS.Cost(:,ProblemParams.M+1) == 1,:);%所有的第一梯队中再取第一梯队%得到所有帝国的位置
GlobalNDS.Cost =  GlobalNDS.Cost(GlobalNDS.Cost(:,ProblemParams.M+1) == 1,1:ProblemParams.M);%%得到所有帝国的cost

%%
%%至此，所有的区域中的殖民国家，都被纳入

NumOfColonies = size(TheEmpire.ColoniesPosition,1);
for n = 1:NumOfColonies%国家内每个殖民地的变化

    if Decade <= AlgorithmParams.NumOfDecades*0.2%可以更改%前xxx代，从所有帝国中随机选取父本，一百代之后，从自身的帝国中选取
        R = randi(size(GlobalNDS.Position,1), 1);
        parent1 = GlobalNDS.Position(R);
    else
        R = randi(size(TheEmpire.ImperialistPosition,1), 1);
        parent1=TheEmpire.ImperialistPosition(R);
    end%前xxx代，从所有帝国中随机选取父本，xxx代之后，从自身的帝国中选取

    parent1 = cell2mat(parent1);
    parent2 = cell2mat(TheEmpire.ColoniesPosition(n));
    parent1d = reshape(parent1(:,1:400/numofmec)', [], 1)';%按照行读取任务清单并存入，方便后续进行交换
    parent2d = reshape(parent2(:,1:400/numofmec)', [], 1)';%按照行读取任务清单并存入，方便后续进行交换

    myfun = @(g, G) exp(-(g-0.5*G).^2/(2*(0.2*G)^2));%值域为0-1,g==0.5G的时候，取到最大值
         g = linspace(0, 1); % 定义 g 的取值范围
         G = 1; % 定义 G 的值
         y = myfun(g, G); % 计算 y 的值
         plot(g, y) % 绘制图像
    Q=myfun(Decade,AlgorithmParams.NumOfDecades);%Q是影响因子，正态分布函数的数值。先增大后减少。所以交换数量也先增大后减少
    a = rand;%0-1的随机系数
    length_1 = round(Q*a*numel(parent1d)*0.5+6);%一共要替换的长度%%系数可以改变，+6保证最开始也有的变
    if length_1 >= numel(parent1d)*0.5
        length_1 = numel(parent1d)*0.5;%排除这个+6的影响
    end%同时保证length_1不超过200，即变化总长度不超过自身一半
    parts=4;%分割的份数
    lengthofpart = numel(parent1d)/parts;
    length = zeros(1,4);

 part = zeros(parts,1);
    for i = 1:3
        upper_limit = min(length_1 - sum(part), lengthofpart/2);
        part(i) = randi([0, upper_limit]);
    end
    part(4) = length_1 - sum(part(1:3));
    
    % Check if any part is greater than lengthofpart/2
    for i = 1:4
        if part(i) > lengthofpart/2
            excess = part(i) - lengthofpart/2;
            part(i) = lengthofpart/2;
            
            % Distribute the excess to other parts
            while excess > 0
                for j = 1:4
                    if j ~= i && part(j) < lengthofpart/2
                        transfer = min(excess, lengthofpart/2 - part(j));
                        part(j) = part(j) + transfer;
                        excess = excess - transfer;
                    end
                end
            end
        end
    end




    %%具体的替换步骤
    point = zeros(parts,2);%point即点位矩阵，代表等会同化的起始点和终止点
    x = zeros(1,4);
    for part = 1 : parts%确定点位
        x(part) = randi(lengthofpart) + lengthofpart*(part - 1);%选取开始的点位x
        if x(part) + length(part) <= lengthofpart
            point(part,1)=x(part);
            point(part,2)=x(part) + length(part)-1;
        else
            point(part,1) = x(part) - length(part)+1;
            point(part,2) = x(part); 
        end
    end
    %选取x之后，若x加长度大于该part的长度，则从x往前取  length(part)个数字，
    %前文保证 length(part)小于一半的 lengthofpart，所以往前去和向后必然有一个可以取到

    offspring = zeros(size(parent1d));%子代初始化

    tihuan=[];%存储替换的序列（按照num索引的形式）
    for part = 1 : parts%开始交叉

        x1 = point(part,1);
        x2 = point(part,2);

        % 选取parent1d中x1到x2的片段，复制到子代同样的位置
        offspring(x1:x2) = parent1d(x1:x2);

        tihuan(1,end+1:end + numel(parent1d(x1:x2))) = parent1d(x1:x2);
        %找到具体是哪些是父本来的.存储替换的序列
    end

    % 从parent2d中剔除与刚刚被选取的相同内容
    remain = setdiff(parent2d, tihuan, 'stable');
    % 将剩下的部分前后顺序不变，填补到x1至x2片段之外的地方

    % 找到 offspring 中为0的位置
    zero_indices = find(offspring == 0);


    % 将 remain 中的值按顺序填入 offspring 中为0的位置
    for i = 1:numel(zero_indices)
        offspring(zero_indices(i)) = remain(i);
    end

    %起点和终点序列分别为x1，x2。父本母本为parent1d，parent2d，1.选取parent1d中x1到x2的片段，复制到子代同样的位置。
    %2，从parent2d中剔除与刚刚被选取的相同内容，将剩下的部分前后顺序不变，填补到x1至x2片段之外的地方
    offspring = reshape(offspring, [400/numofmec, numofmec])';%重新变为八行
    

        result = offspring;
%        aaa = setdiff(parent1, result, 'stable');
%         result == parent1;%检验代码
    TheEmpire.ColoniesPosition{n} = result;%存储为cell

end
end

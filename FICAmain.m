close all
clc; clear
dbstop if error

%% 下载数据
load data formula time speed mcost clean hcost htime hptime
%formula是配方，time是每种气体充满一整瓶的时间，speed常数越小，机器加工时间越久，mcost是机器的耗能,
% clean（换气不换瓶）是清洁时间以及能耗,hcost,htime (换瓶不换机)是替换同一批次内瓶子的时候的过渡损耗和过度时间.hptime是批次之间更换时间
load batchdata.mat;
load combination.mat;
%% Problem Statement
ProblemParams.CostFuncName = 'BenchmarkFunction'; % 代价函数的名称
ProblemParams.M = 2; % 每个个体目标函数的维度
ProblemParams.N = 20;%一个解集中个体的个数

numofdeal = 10; %一个解集中订单的个数%不要动
numofmec = 8;%4.5.8.10 机器的数量

% Deals20 = Creatdeal(numofdeal,lenofdeal,formula);%创造解集
% save Deals.mat Deals5 Deals10 Deals15 Deals20
%400/5=80，一共80批，80=4*20  5*16   8*10 10*8  所以机器数为4 5 8 10
load Deals.mat
Deals = Deals20;
lenofdeal = 20; % 订单中任务的个数!!!订单可为5.10.15.20
Deals(:,lenofdeal:40) = 0;%先补充到上限
%% Algorithmic Parameter Setting
AlgorithmParams.NumOfCountries = 100; % 初始国家数量
AlgorithmParams.NumOfInitialImperialists = 8; % 初始帝国数量
AlgorithmParams.NumOfAllColonies = AlgorithmParams.NumOfCountries - AlgorithmParams.NumOfInitialImperialists; % 殖民地数量
AlgorithmParams.NumOfDecades = 6000; % 迭代次数
AlgorithmParams.RevolutionRate_1 = 0.1; % 革命概率，帝国发生革命的概率
AlgorithmParams.RevolutionRate_2 = 0.3; % 革命概率，帝国发生革命的概率
AlgorithmParams.ImperialisticCompetition = 0.1;%帝国竞争发生概率
AlgorithmParams.ImperialistPercentage = 0.3; % 帝国最大数量的百分比，作为帝国数量的上限
AlgorithmParams.coef = 2;%%时间和cost的评比系数

%% Creation of Initial Empires
InitialCountries = GenerateNewCountry(AlgorithmParams.NumOfCountries ,Deals,numofmec); % 创建初始国家

% 计算每个国家的代价。代价越小，国家的权力越大。
InitialCost = feval(ProblemParams.CostFuncName,InitialCountries,mcost,Deals,hptime,Fcombination,op_1,op_5,op_8,c_1,c_5,c_8,speed,numofmec,lenofdeal);%feval,执行后续函数
[InitialCost, SortInd] = NonDominationSort(InitialCost,ProblemParams.M); % 进行非支配排序，InitialCost按照梯队排序
InitialCost = InitialCost(:,1:ProblemParams.M);
InitialCountries = sort_matrix(InitialCountries,SortInd,numofmec,AlgorithmParams); % 根据代价对种群进行排序 ，从而和InitialCost一一对应
InitialCountries = mat2cell(InitialCountries, repmat(numofmec,AlgorithmParams.NumOfCountries,1), 400/numofmec);
Empires = CreateInitialEmpires(InitialCountries,InitialCost,AlgorithmParams, ProblemParams); % 创建初始帝国

Solutions = [];
ArchInd = 1;
Solutionscost_max = zeros(AlgorithmParams.NumOfDecades,1);
Solutionscost_min = zeros(AlgorithmParams.NumOfDecades,1);
Solutionscost_even = zeros(AlgorithmParams.NumOfDecades,1);
numberofempiresindex= zeros(AlgorithmParams.NumOfDecades,1);
tic
for Decade = 1:AlgorithmParams.NumOfDecades
    for ii = 1:numel(Empires) %大帝国的个数，遍历每一个殖民帝国

        Empires(ii) = AssimilateColonies(Empires(ii),ProblemParams, Empires,Decade,AlgorithmParams,Deals,numofmec); % 吸收殖民地？
        Empires(ii) = RevolveColonies(Empires(ii),AlgorithmParams,ProblemParams,Deals,numofmec); % 革命殖民地？

        %% % 计算新的殖民地的代价
        Empires(ii).ColoniesCost = feval(ProblemParams.CostFuncName,Empires(ii).ColoniesPosition,mcost,Deals,hptime,Fcombination,op_1,op_5,op_8,c_1,c_5,c_8,speed,numofmec,lenofdeal); % 计算殖民地的代价

        %% % 交换帝国和最佳殖民地的位置（帝国占有）
        Empires(ii) = PossesEmpire(Empires(ii), ProblemParams, AlgorithmParams);%重新根据非支配排序算出谁是帝国

        %% 把帝国和殖民地的cost排列到一起
        empirePop = [Empires(ii).ImperialistCost
            Empires(ii).ColoniesCost];%把帝国和殖民地的cost排列到一起
        [TotalCosts, ~] = NonDominationSort(empirePop,ProblemParams.M);
        FirstFront =  find(TotalCosts(:,ProblemParams.M+1) == 1); %找到前多少个是第一梯队
        Empires(ii).TotalCost = size(FirstFront, 1);%%%这是实际的第一梯队数值！

    end

    %     uncomment below line to see the decrease of number of empires in each
    %      generation...
    numberofempires = numel(Empires)
    numberofempiresindex(Decade) = numel(Empires);

    %% 帝国竞争
    Empires = ImperialisticCompetition(Empires,AlgorithmParams); % 帝国竞争%%

    %% 非支配排序解
    AllCosts = [];
    AllPositions = [];
    AllCostsIndex = 1;

    for u=1:numel(Empires)
        AllCosts(AllCostsIndex:AllCostsIndex + size(Empires(u).ImperialistCost,1) - 1,:) = Empires(u).ImperialistCost;
        [AllPositions{AllCostsIndex:AllCostsIndex + size(Empires(u).ImperialistPosition,1) - 1,1}] = Empires(u).ImperialistPosition{:};
        AllCostsIndex = AllCostsIndex + size(Empires(u).ImperialistCost,1);
    end
    %把所有帝国中的殖民国家位置和cost录入到ALL里面

    %     tempArr = [];
    %     tempArrPositions = [];
    %     tempInd = 1;
    %     for y=1:size(AllCosts,1)
    %         if isempty(find(sum(ismember(tempArr,AllCosts(y,:)),2) == 2))
    %             %使用find和ismember函数检查tempArr矩阵中是否存在与当前行完全相同的行。如果不存在这样的行，则执行下一步。
    %             tempArr(tempInd,:) = AllCosts(y,:);
    %             tempArrPositions(tempInd, :) = AllPositions(y,:);
    %             tempInd = tempInd + 1;
    %         end
    %     end
    %     %AllCosts矩阵中筛选出不重复的行，并将它们保存在一个新的矩阵中。同时，它还会保存每一行对应的位置信息。
    %     [tempArr, NewIn] = NonDominationSort(tempArr,ProblemParams.M); % 进行非支配排序...
    %
    %     tempArrPositions = tempArrPositions(NewIn,:);

    %     Solutions(ArchInd:ArchInd+size(tempArr(find(tempArr(:,ProblemParams.M+1) == 1),1:ProblemParams.M),1)-1,:) = tempArr(find(tempArr(:,ProblemParams.M+1) == 1),1:ProblemParams.M);
    %     SolutionPositions(ArchInd:ArchInd+size(tempArr(find(tempArr(:,ProblemParams.M+1) == 1),1:ProblemParams.M),1)-1,:) = tempArrPositions(1:size(tempArr(find(tempArr(:,ProblemParams.M+1) == 1),1:ProblemParams.M),1),:);
    %     ArchInd = ArchInd + size(tempArr(find(tempArr(:,ProblemParams.M+1) == 1),1:ProblemParams.M),1);

    Solutions = AllCosts;
    %     SolutionPositions=AllPositions;
    %     ArchInd =  AllCostsIndex -1;


    % 乘以系数
    first_col = AllCosts(:, 1) * AlgorithmParams.coef;
    % 加上第二列
    Solutionscost = first_col + AllCosts(:, 2);
    Solutionscost_max(Decade,1) = max(Solutionscost);
    Solutionscost_min(Decade,1) = min(Solutionscost);
    Solutionscost_even(Decade,1) = sum(Solutionscost)/(AllCostsIndex-1);

    disp(['Decade ', num2str(Decade), ' 已经结束了。']);

end % 算法结束
toc

FinalSolutions = AllCosts;
FinalSolutionPositions=AllPositions;
FinalArchInd =  AllCostsIndex -1;

save Solutions.mat FinalArchInd FinalSolutionPositions FinalSolutions Solutionscost_even Solutionscost_max Solutionscost_min

x = AllCosts(:, 1); % 第一列作为横坐标
y = AllCosts(:, 2); % 第二列作为纵坐标

figure; % 创建一个新的图形窗口
scatter(x, y); % 绘制点阵图

xlabel('AllCosts 第一列'); % 设置横坐标轴标签
ylabel('AllCosts 第二列'); % 设置纵坐标轴标签
title('AllCosts 第一列和第二列的点阵图'); % 设置图形标题


% data = Solutionscost_max;
% figure;  % 创建一个新的图形窗口
% plot(data);  % 绘制折线图
% title('Solutionscostmax');  % 添加标题
% xlabel('Index');  % 添加x轴标签
% ylabel('Value');  % 添加y轴标签

data = Solutionscost_min;
figure;  % 创建一个新的图形窗口
plot(data);  % 绘制折线图
title('Solutionscostmin');  % 添加标题
xlabel('Index');  % 添加x轴标签
ylabel('Value');  % 添加y轴标签

data = numberofempiresindex;
figure;  % 创建一个新的图形窗口
plot(data);  % 绘制折线图
title('numberofempiresindex');  % 添加标题
xlabel('Index');  % 添加x轴标签
ylabel('Value');  % 添加y轴标签

% data = Solutionscost_even;
% figure;  % 创建一个新的图形窗口
% plot(data);  % 绘制折线图
% title('Solutionscosteven');  % 添加标题
% xlabel('Index');  % 添加x轴标签
% ylabel('Value');  % 添加y轴标签
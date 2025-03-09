close all
clc; clear
load data.mat
formula(8,:)= 0;
load combination.mat

%%
ProblemParams.CostFuncName = 'test'; % 代价函数的名称
ProblemParams.M = 2; % 每个个体目标函数的维度
ProblemParams.N = 30;%一个解集中个体的个数

%% Algorithmic Parameter Setting
AlgorithmParams.NumOfCountries = 100; % 初始国家数量
AlgorithmParams.NumOfInitialImperialists = 6; % 初始帝国数量
AlgorithmParams.NumOfAllColonies = AlgorithmParams.NumOfCountries - AlgorithmParams.NumOfInitialImperialists; % 殖民地数量
AlgorithmParams.NumOfDecades = 800; % 迭代次数
AlgorithmParams.RevolutionRate_1 = 0.1; % 革命概率，帝国发生革命的概率
AlgorithmParams.RevolutionRate_2 = 0.6; % 革命概率，帝国发生革命的概率
AlgorithmParams.ImperialisticCompetition = 0.9;%帝国竞争发生概率
AlgorithmParams.ImperialistPercentage = 0.3; % 帝国最大数量的百分比，作为帝国数量的上限
AlgorithmParams.coef = 2;%%时间和cost的评比系数

%% 遍历他的每一行在每个机器上
tic
op_1 = zeros(792,30);
c_1 = zeros(792,2);
op_5 = zeros(792,30);
c_5 = zeros(792,2);
op_8 = zeros(792,30);
c_8 = zeros(792,2);
for numberofGcombination = 1 : numel(Gcombination)/30-1%每个批次种类

    for numberofm = 1%5 8 %每种机器
        InitialCountries = GenerateNewCountry(AlgorithmParams.NumOfCountries ,Gcombination(numberofGcombination,:)); % 创建初始国家
        InitialCost = feval(ProblemParams.CostFuncName,InitialCountries,numberofm,Fcombination(numberofGcombination,:),formula,time,clean,mcost,speed,hcost,htime);%feval,执行后续函数
        [InitialCost, SortInd] = NonDominationSort(InitialCost,ProblemParams.M); % 进行非支配排序，InitialCost按照梯队排序
        InitialCost = InitialCost(:,1:ProblemParams.M);
        InitialCountries = InitialCountries(SortInd,:); % 根据代价对种群进行排序 ，从而和InitialCost一一对应
        Empires = CreateInitialEmpires(InitialCountries,InitialCost,AlgorithmParams, ProblemParams); % 创建初始帝国
        Solutions = [];
        ArchInd = 1;
        numberofempiresindex= zeros(AlgorithmParams.NumOfDecades,1);
        Solutionscost_max = zeros(AlgorithmParams.NumOfDecades,1);
        Solutionscost_min = zeros(AlgorithmParams.NumOfDecades,1);
        Solutionscost_even = zeros(AlgorithmParams.NumOfDecades,1);

        for Decade = 1:AlgorithmParams.NumOfDecades
            for ii = 1:numel(Empires) %大帝国的个数，遍历每一个殖民帝国

                Empires(ii) = AssimilateColonies(Empires(ii),ProblemParams, Empires,Decade,AlgorithmParams); % 吸收殖民地？
                Empires(ii) = RevolveColonies(Empires(ii),AlgorithmParams,Gcombination(numberofGcombination,:),Fcombination,formula,time,clean,mcost,speed,hcost,htime); % 革命殖民地？

                %% % 计算新的殖民地的代价
                Empires(ii).ColoniesCost = feval(ProblemParams.CostFuncName,Empires(ii).ColoniesPosition,numberofm,Fcombination(numberofGcombination,:),formula,time,clean,mcost,speed,hcost,htime); % 计算殖民地的代价

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
            numberofempires = numel(Empires);
            numberofempiresindex(Decade) = numel(Empires);

            %% 帝国竞争
            Empires = ImperialisticCompetition(Empires,AlgorithmParams); % 帝国竞争%%

            %% 非支配排序解
            AllCosts = [];
            AllPositions = [];
            AllCostsIndex = 1;

            for u=1:numel(Empires)
                AllCosts(AllCostsIndex:AllCostsIndex + size(Empires(u).ImperialistCost,1) - 1,:) = Empires(u).ImperialistCost;
                AllPositions = vertcat(AllPositions, Empires(u).ImperialistPosition);
                AllCostsIndex = AllCostsIndex + size(Empires(u).ImperialistCost,1);
            end
            %把所有帝国中的殖民国家位置和cost录入到ALL里面

            Solutions = AllCosts;
            SolutionPositions=AllPositions;

            % 乘以系数
            first_col = AllCosts(:, 1) * AlgorithmParams.coef;
            % 加上第二列
            Solutionscost = first_col + AllCosts(:, 2);
%             Solutionscost_max(Decade,1) = max(Solutionscost);
            [Solutionscost_min(Decade,1), row] = min(Solutionscost);
%             Solutionscost_even(Decade,1) = sum(Solutionscost)/(AllCostsIndex-1);

            offcost = Solutions(row,:);
            offposition = AllPositions(row,:);
            disp(['第',num2str(numberofGcombination),'批次 ',num2str(numberofm),'号机器上的','Decade ', num2str(Decade), ' 已经结束了。']);
            Gcombination(numberofGcombination,:) = offposition;
        end % 算法结束
        


        
        data = Solutionscost_min;
        figure;  % 创建一个新的图形窗口
        plot(data);  % 绘制折线图
        title('Solutionscostmin');  % 添加标题
        xlabel('Index');  % 添加x轴标签
        ylabel('Value');  % 添加y轴标签
        %





        data = numberofempiresindex;
        figure;  % 创建一个新的图形窗口
        plot(data);  % 绘制折线图
        title('numberofempiresindex');  % 添加标题
        xlabel('Index');  % 添加x轴标签
        ylabel('Value');  % 添加y轴标签


    if numberofm == 1
        op_1(numberofGcombination,:) = offposition;
        c_1(numberofGcombination,:) = offcost;
    end
    
    if numberofm == 5
        op_5(numberofGcombination,:) = offposition;
        c_5(numberofGcombination,:) = offcost;
    end

    if numberofm == 8
        op_8(numberofGcombination,:) = offposition;
        c_8(numberofGcombination,:) = offcost;
    end




    end



end
toc

%  save batchdata c_1 c_5 c_8 op_1 op_5 op_8
% save combination.mat Gcombination Fcombination
% 
% load batchdata1.mat c_1 op_1
% load batchdata58.mat c_5 op_5 c_8 op_8
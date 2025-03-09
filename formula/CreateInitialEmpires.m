%% This function creates initial empires.
% Initial Empires are created based on the NumOfInitialImperialists parameter.
% Costs of colonies and imperialists are also calculated in every newly
% created empire.
function Empires = CreateInitialEmpires(InitialCountries,InitialCost,AlgorithmParams, ProblemParams)
AllImperialistsCost = InitialCost(1:AlgorithmParams.NumOfInitialImperialists,:);%选出所有国家中的第一梯队

AllImperialistsPower = 1.05 * repmat(max(AllImperialistsCost),size(AllImperialistsCost,1),1) - AllImperialistsCost;
%这个系数可以进行更改，
%%%加个随机数的变化



%%！！！！！！！！
AllImperialistsPower(:,2) =  AllImperialistsPower(:,2)*1;%%可以增加一个比重系数！！！
AllImperialistsPower_ = sum(AllImperialistsPower')';%每一行求和%%%可以增加一个比重系数！！！
AllImperialistNumOfColonies = round(AllImperialistsPower_/sum(AllImperialistsPower_) * AlgorithmParams.NumOfAllColonies);
AllImperialistNumOfColonies(end) = AlgorithmParams.NumOfAllColonies - sum(AllImperialistNumOfColonies(1:end-1));
%分配殖民地

%countrys = InitialCountries(1:8,:);%八个预制国家

RandomIndex = randperm(AlgorithmParams.NumOfCountries-AlgorithmParams.NumOfInitialImperialists) + AlgorithmParams.NumOfInitialImperialists;

Empires(AlgorithmParams.NumOfInitialImperialists).ImperialistPosition = 0;


for ii = 1:AlgorithmParams.NumOfInitialImperialists%开始创建帝国
    AllColoniesCost = InitialCost;
    AllColoniesPosition = InitialCountries;
    
    R = RandomIndex(1:AllImperialistNumOfColonies(ii));
    RandomIndex = RandomIndex(AllImperialistNumOfColonies(ii)+1:end);
    AllColoniesCost = AllColoniesCost(R,:);%添加国家
    AllColoniesCost = [AllColoniesCost;InitialCost(ii,:)];%添加预制帝国
    AllColoniesPosition = AllColoniesPosition(R,:);%添加国家
    AllColoniesPosition = [AllColoniesPosition;InitialCountries(ii,:)];%添加预制帝国
    %先全部按照殖民地判断
    %先按照r随机放进殖民地个数个国家，后把之前提到的第一梯队的第i个最后放进去，保证一一对应
    
    [AllColoniesCost, SortInd] = NonDominationSort(AllColoniesCost,ProblemParams.M); % apply non-domination sorting...
    AllColoniesPosition = AllColoniesPosition(SortInd,:); % Sort the population with respect to their cost.
    
    Empires(ii).ImperialistCost = AllColoniesCost(AllColoniesCost(:,ProblemParams.M+1) == 1,1:ProblemParams.M);
    Empires(ii).ImperialistPosition = AllColoniesPosition(AllColoniesCost(:,ProblemParams.M+1) == 1,1:end);
    
    Empires(ii).ColoniesCost = AllColoniesCost(AllColoniesCost(:,ProblemParams.M+1) ~= 1,1:ProblemParams.M);
    Empires(ii).ColoniesPosition = AllColoniesPosition(AllColoniesCost(:,ProblemParams.M+1) ~= 1,1:end);
    
    %%Compute the Total Cost of an Empire...
    Empires(ii).TotalCost = size(Empires(ii).ImperialistCost, 1);
    Empires(ii) = PossesEmpire(Empires(ii), ProblemParams, AlgorithmParams);
end
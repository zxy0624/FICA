%% Possesing Empire
% 个函数的目的是确定帝国的非支配解，并找到所有帝国主义者。
%过程是放在一起非支配排序，然后第一梯队就是帝国。然后多余的随机丢入殖民地。
% 在构建帝国主义者和殖民地集合之后，它还检查帝国主义者百分比是否超过。
% 如果帝国主义者百分比超过了，那么一些帝国主义者将被随机选择并投入殖民地集合。
% 最后，在非支配集（帝国主义者）中的解被认为拥有帝国。
function TheEmpire = PossesEmpire(TheEmpire, ProblemParams, AlgorithmParams)
ColoniesCost = TheEmpire.ColoniesCost;
ColoniesPosition = TheEmpire.ColoniesPosition;

ColoniesCost(end+1:end+size(TheEmpire.ImperialistCost,1),:) = TheEmpire.ImperialistCost;
ColoniesPosition(end+1:end+size(TheEmpire.ImperialistPosition,1),:) = TheEmpire.ImperialistPosition;
%将殖民地成本和位置与帝国主义者成本和位置合并在一起。

[AllColoniesCost, SortInd] = NonDominationSort(ColoniesCost,ProblemParams.M); % apply non-domination sorting...
AllColoniesPosition = ColoniesPosition(SortInd,:); % Sort the population with respect to their cost.
%非支配排序

ImpCosts = AllColoniesCost(AllColoniesCost(:,ProblemParams.M+1) == 1,:);

TheEmpire.ImperialistCost = AllColoniesCost(AllColoniesCost(:,ProblemParams.M+1) == 1,1:ProblemParams.M);
TheEmpire.ImperialistPosition = AllColoniesPosition(AllColoniesCost(:,ProblemParams.M+1) == 1,1:end);

TheEmpire.ColoniesCost = AllColoniesCost(AllColoniesCost(:,ProblemParams.M+1) ~= 1,1:ProblemParams.M);
TheEmpire.ColoniesPosition = AllColoniesPosition(AllColoniesCost(:,ProblemParams.M+1) ~= 1,1:end);

%% Apply non-dominancy and keep at most 'ImperialistPercentage' of the population in Empire to be Imperialists 
totalImperialists = size(TheEmpire.ImperialistCost, 1);
totalPopulation = size(AllColoniesCost, 1);

if AlgorithmParams.ImperialistPercentage <= (totalImperialists/totalPopulation)
    
    NumOfRevolvingImperialists = totalImperialists - round(AlgorithmParams.ImperialistPercentage*totalPopulation);
    NumberOfImp = totalImperialists-NumOfRevolvingImperialists;
    [~, order] = sort(ImpCosts(:,end));
    order = fliplr(order')';
    SortedImperialistCosts = TheEmpire.ImperialistCost(order,:);
    SortedImperialistPositions = TheEmpire.ImperialistPosition(order,:);
    
    TheEmpire.ImperialistCost = SortedImperialistCosts(1:NumberOfImp,:);
    TheEmpire.ImperialistPosition = SortedImperialistPositions(1:NumberOfImp,:);
    TheEmpire.ColoniesPosition(end+1:end+NumOfRevolvingImperialists,:) = SortedImperialistPositions(NumberOfImp+1:end,:);
    TheEmpire.ColoniesCost(end+1:end+NumOfRevolvingImperialists,:) = SortedImperialistCosts(NumberOfImp+1:end,:);
end

end
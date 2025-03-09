%% Possesing Empire
% ��������Ŀ����ȷ���۹��ķ�֧��⣬���ҵ����е۹������ߡ�
%�����Ƿ���һ���֧������Ȼ���һ�ݶӾ��ǵ۹���Ȼ�������������ֳ��ء�
% �ڹ����۹������ߺ�ֳ��ؼ���֮���������۹������߰ٷֱ��Ƿ񳬹���
% ����۹������߰ٷֱȳ����ˣ���ôһЩ�۹������߽������ѡ��Ͷ��ֳ��ؼ��ϡ�
% ����ڷ�֧�伯���۹������ߣ��еĽⱻ��Ϊӵ�е۹���
function TheEmpire = PossesEmpire(TheEmpire, ProblemParams, AlgorithmParams)
ColoniesCost = TheEmpire.ColoniesCost;
ColoniesPosition = TheEmpire.ColoniesPosition;

ColoniesCost(end+1:end+size(TheEmpire.ImperialistCost,1),:) = TheEmpire.ImperialistCost;
ColoniesPosition(end+1:end+size(TheEmpire.ImperialistPosition,1),:) = TheEmpire.ImperialistPosition;
%��ֳ��سɱ���λ����۹������߳ɱ���λ�úϲ���һ��

[AllColoniesCost, SortInd] = NonDominationSort(ColoniesCost,ProblemParams.M); % apply non-domination sorting...
AllColoniesPosition = ColoniesPosition(SortInd,:); % Sort the population with respect to their cost.
%��֧������

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
%% This function creates initial empires.
% Initial Empires are created based on the NumOfInitialImperialists parameter.
% Costs of colonies and imperialists are also calculated in every newly
% created empire.
function Empires = CreateInitialEmpires(InitialCountries,InitialCost,AlgorithmParams, ProblemParams)
AllImperialistsCost = InitialCost(1:AlgorithmParams.NumOfInitialImperialists,:);%ѡ�����й����еĵ�һ�ݶ�

AllImperialistsPower = 1.05 * repmat(max(AllImperialistsCost),size(AllImperialistsCost,1),1) - AllImperialistsCost;
%���ϵ�����Խ��и��ģ�
%%%�Ӹ�������ı仯



%%����������������
AllImperialistsPower(:,2) =  AllImperialistsPower(:,2)*1;%%��������һ������ϵ��������
AllImperialistsPower_ = sum(AllImperialistsPower')';%ÿһ�����%%%��������һ������ϵ��������
AllImperialistNumOfColonies = round(AllImperialistsPower_/sum(AllImperialistsPower_) * AlgorithmParams.NumOfAllColonies);
AllImperialistNumOfColonies(end) = AlgorithmParams.NumOfAllColonies - sum(AllImperialistNumOfColonies(1:end-1));
%����ֳ���

%countrys = InitialCountries(1:8,:);%�˸�Ԥ�ƹ���

RandomIndex = randperm(AlgorithmParams.NumOfCountries-AlgorithmParams.NumOfInitialImperialists) + AlgorithmParams.NumOfInitialImperialists;

Empires(AlgorithmParams.NumOfInitialImperialists).ImperialistPosition = 0;


for ii = 1:AlgorithmParams.NumOfInitialImperialists%��ʼ�����۹�
    AllColoniesCost = InitialCost;
    AllColoniesPosition = InitialCountries;
    
    R = RandomIndex(1:AllImperialistNumOfColonies(ii));
    RandomIndex = RandomIndex(AllImperialistNumOfColonies(ii)+1:end);
    AllColoniesCost = AllColoniesCost(R,:);%��ӹ���
    AllColoniesCost = [AllColoniesCost;InitialCost(ii,:)];%���Ԥ�Ƶ۹�
    AllColoniesPosition = AllColoniesPosition(R,:);%��ӹ���
    AllColoniesPosition = [AllColoniesPosition;InitialCountries(ii,:)];%���Ԥ�Ƶ۹�
    %��ȫ������ֳ����ж�
    %�Ȱ���r����Ž�ֳ��ظ��������ң����֮ǰ�ᵽ�ĵ�һ�ݶӵĵ�i�����Ž�ȥ����֤һһ��Ӧ
    
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
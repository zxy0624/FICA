close all
clc; clear
dbstop if error

%% ��������
load data formula time speed mcost clean hcost htime hptime
%formula���䷽��time��ÿ���������һ��ƿ��ʱ�䣬speed����ԽС�������ӹ�ʱ��Խ�ã�mcost�ǻ����ĺ���,
% clean����������ƿ�������ʱ���Լ��ܺ�,hcost,htime (��ƿ������)���滻ͬһ������ƿ�ӵ�ʱ��Ĺ�����ĺ͹���ʱ��.hptime������֮�����ʱ��
load batchdata.mat;
load combination.mat;
%% Problem Statement
ProblemParams.CostFuncName = 'BenchmarkFunction'; % ���ۺ���������
ProblemParams.M = 2; % ÿ������Ŀ�꺯����ά��
ProblemParams.N = 20;%һ���⼯�и���ĸ���

numofdeal = 10; %һ���⼯�ж����ĸ���%��Ҫ��
numofmec = 8;%4.5.8.10 ����������

% Deals20 = Creatdeal(numofdeal,lenofdeal,formula);%����⼯
% save Deals.mat Deals5 Deals10 Deals15 Deals20
%400/5=80��һ��80����80=4*20  5*16   8*10 10*8  ���Ի�����Ϊ4 5 8 10
load Deals.mat
Deals = Deals20;
lenofdeal = 20; % ����������ĸ���!!!������Ϊ5.10.15.20
Deals(:,lenofdeal:40) = 0;%�Ȳ��䵽����
%% Algorithmic Parameter Setting
AlgorithmParams.NumOfCountries = 100; % ��ʼ��������
AlgorithmParams.NumOfInitialImperialists = 8; % ��ʼ�۹�����
AlgorithmParams.NumOfAllColonies = AlgorithmParams.NumOfCountries - AlgorithmParams.NumOfInitialImperialists; % ֳ�������
AlgorithmParams.NumOfDecades = 6000; % ��������
AlgorithmParams.RevolutionRate_1 = 0.1; % �������ʣ��۹����������ĸ���
AlgorithmParams.RevolutionRate_2 = 0.3; % �������ʣ��۹����������ĸ���
AlgorithmParams.ImperialisticCompetition = 0.1;%�۹�������������
AlgorithmParams.ImperialistPercentage = 0.3; % �۹���������İٷֱȣ���Ϊ�۹�����������
AlgorithmParams.coef = 2;%%ʱ���cost������ϵ��

%% Creation of Initial Empires
InitialCountries = GenerateNewCountry(AlgorithmParams.NumOfCountries ,Deals,numofmec); % ������ʼ����

% ����ÿ�����ҵĴ��ۡ�����ԽС�����ҵ�Ȩ��Խ��
InitialCost = feval(ProblemParams.CostFuncName,InitialCountries,mcost,Deals,hptime,Fcombination,op_1,op_5,op_8,c_1,c_5,c_8,speed,numofmec,lenofdeal);%feval,ִ�к�������
[InitialCost, SortInd] = NonDominationSort(InitialCost,ProblemParams.M); % ���з�֧������InitialCost�����ݶ�����
InitialCost = InitialCost(:,1:ProblemParams.M);
InitialCountries = sort_matrix(InitialCountries,SortInd,numofmec,AlgorithmParams); % ���ݴ��۶���Ⱥ�������� ���Ӷ���InitialCostһһ��Ӧ
InitialCountries = mat2cell(InitialCountries, repmat(numofmec,AlgorithmParams.NumOfCountries,1), 400/numofmec);
Empires = CreateInitialEmpires(InitialCountries,InitialCost,AlgorithmParams, ProblemParams); % ������ʼ�۹�

Solutions = [];
ArchInd = 1;
Solutionscost_max = zeros(AlgorithmParams.NumOfDecades,1);
Solutionscost_min = zeros(AlgorithmParams.NumOfDecades,1);
Solutionscost_even = zeros(AlgorithmParams.NumOfDecades,1);
numberofempiresindex= zeros(AlgorithmParams.NumOfDecades,1);
tic
for Decade = 1:AlgorithmParams.NumOfDecades
    for ii = 1:numel(Empires) %��۹��ĸ���������ÿһ��ֳ��۹�

        Empires(ii) = AssimilateColonies(Empires(ii),ProblemParams, Empires,Decade,AlgorithmParams,Deals,numofmec); % ����ֳ��أ�
        Empires(ii) = RevolveColonies(Empires(ii),AlgorithmParams,ProblemParams,Deals,numofmec); % ����ֳ��أ�

        %% % �����µ�ֳ��صĴ���
        Empires(ii).ColoniesCost = feval(ProblemParams.CostFuncName,Empires(ii).ColoniesPosition,mcost,Deals,hptime,Fcombination,op_1,op_5,op_8,c_1,c_5,c_8,speed,numofmec,lenofdeal); % ����ֳ��صĴ���

        %% % �����۹������ֳ��ص�λ�ã��۹�ռ�У�
        Empires(ii) = PossesEmpire(Empires(ii), ProblemParams, AlgorithmParams);%���¸��ݷ�֧���������˭�ǵ۹�

        %% �ѵ۹���ֳ��ص�cost���е�һ��
        empirePop = [Empires(ii).ImperialistCost
            Empires(ii).ColoniesCost];%�ѵ۹���ֳ��ص�cost���е�һ��
        [TotalCosts, ~] = NonDominationSort(empirePop,ProblemParams.M);
        FirstFront =  find(TotalCosts(:,ProblemParams.M+1) == 1); %�ҵ�ǰ���ٸ��ǵ�һ�ݶ�
        Empires(ii).TotalCost = size(FirstFront, 1);%%%����ʵ�ʵĵ�һ�ݶ���ֵ��

    end

    %     uncomment below line to see the decrease of number of empires in each
    %      generation...
    numberofempires = numel(Empires)
    numberofempiresindex(Decade) = numel(Empires);

    %% �۹�����
    Empires = ImperialisticCompetition(Empires,AlgorithmParams); % �۹�����%%

    %% ��֧�������
    AllCosts = [];
    AllPositions = [];
    AllCostsIndex = 1;

    for u=1:numel(Empires)
        AllCosts(AllCostsIndex:AllCostsIndex + size(Empires(u).ImperialistCost,1) - 1,:) = Empires(u).ImperialistCost;
        [AllPositions{AllCostsIndex:AllCostsIndex + size(Empires(u).ImperialistPosition,1) - 1,1}] = Empires(u).ImperialistPosition{:};
        AllCostsIndex = AllCostsIndex + size(Empires(u).ImperialistCost,1);
    end
    %�����е۹��е�ֳ�����λ�ú�cost¼�뵽ALL����

    %     tempArr = [];
    %     tempArrPositions = [];
    %     tempInd = 1;
    %     for y=1:size(AllCosts,1)
    %         if isempty(find(sum(ismember(tempArr,AllCosts(y,:)),2) == 2))
    %             %ʹ��find��ismember�������tempArr�������Ƿ�����뵱ǰ����ȫ��ͬ���С�����������������У���ִ����һ����
    %             tempArr(tempInd,:) = AllCosts(y,:);
    %             tempArrPositions(tempInd, :) = AllPositions(y,:);
    %             tempInd = tempInd + 1;
    %         end
    %     end
    %     %AllCosts������ɸѡ�����ظ����У��������Ǳ�����һ���µľ����С�ͬʱ�������ᱣ��ÿһ�ж�Ӧ��λ����Ϣ��
    %     [tempArr, NewIn] = NonDominationSort(tempArr,ProblemParams.M); % ���з�֧������...
    %
    %     tempArrPositions = tempArrPositions(NewIn,:);

    %     Solutions(ArchInd:ArchInd+size(tempArr(find(tempArr(:,ProblemParams.M+1) == 1),1:ProblemParams.M),1)-1,:) = tempArr(find(tempArr(:,ProblemParams.M+1) == 1),1:ProblemParams.M);
    %     SolutionPositions(ArchInd:ArchInd+size(tempArr(find(tempArr(:,ProblemParams.M+1) == 1),1:ProblemParams.M),1)-1,:) = tempArrPositions(1:size(tempArr(find(tempArr(:,ProblemParams.M+1) == 1),1:ProblemParams.M),1),:);
    %     ArchInd = ArchInd + size(tempArr(find(tempArr(:,ProblemParams.M+1) == 1),1:ProblemParams.M),1);

    Solutions = AllCosts;
    %     SolutionPositions=AllPositions;
    %     ArchInd =  AllCostsIndex -1;


    % ����ϵ��
    first_col = AllCosts(:, 1) * AlgorithmParams.coef;
    % ���ϵڶ���
    Solutionscost = first_col + AllCosts(:, 2);
    Solutionscost_max(Decade,1) = max(Solutionscost);
    Solutionscost_min(Decade,1) = min(Solutionscost);
    Solutionscost_even(Decade,1) = sum(Solutionscost)/(AllCostsIndex-1);

    disp(['Decade ', num2str(Decade), ' �Ѿ������ˡ�']);

end % �㷨����
toc

FinalSolutions = AllCosts;
FinalSolutionPositions=AllPositions;
FinalArchInd =  AllCostsIndex -1;

save Solutions.mat FinalArchInd FinalSolutionPositions FinalSolutions Solutionscost_even Solutionscost_max Solutionscost_min

x = AllCosts(:, 1); % ��һ����Ϊ������
y = AllCosts(:, 2); % �ڶ�����Ϊ������

figure; % ����һ���µ�ͼ�δ���
scatter(x, y); % ���Ƶ���ͼ

xlabel('AllCosts ��һ��'); % ���ú��������ǩ
ylabel('AllCosts �ڶ���'); % �������������ǩ
title('AllCosts ��һ�к͵ڶ��еĵ���ͼ'); % ����ͼ�α���


% data = Solutionscost_max;
% figure;  % ����һ���µ�ͼ�δ���
% plot(data);  % ��������ͼ
% title('Solutionscostmax');  % ��ӱ���
% xlabel('Index');  % ���x���ǩ
% ylabel('Value');  % ���y���ǩ

data = Solutionscost_min;
figure;  % ����һ���µ�ͼ�δ���
plot(data);  % ��������ͼ
title('Solutionscostmin');  % ��ӱ���
xlabel('Index');  % ���x���ǩ
ylabel('Value');  % ���y���ǩ

data = numberofempiresindex;
figure;  % ����һ���µ�ͼ�δ���
plot(data);  % ��������ͼ
title('numberofempiresindex');  % ��ӱ���
xlabel('Index');  % ���x���ǩ
ylabel('Value');  % ���y���ǩ

% data = Solutionscost_even;
% figure;  % ����һ���µ�ͼ�δ���
% plot(data);  % ��������ͼ
% title('Solutionscosteven');  % ��ӱ���
% xlabel('Index');  % ���x���ǩ
% ylabel('Value');  % ���y���ǩ
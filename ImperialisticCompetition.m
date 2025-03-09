%% Imperialistic Competition
% �۹����徺����һ�������ĵ۹������ɱ����ĵ۹�����������ֳ��أ����ɱ���ߵ�ֳ��أ�
% ������ɱ��ϸߵĸ�ǿ�۹��Ĺ��̡�
% ���ǻ��ڸ��ʡ���ˣ��۹�Խǿ�󣨼��۹�
% �ɱ��������˸ߣ�������Խ�л���ӵ�������۹���������ֳ��ء�

function Empires=ImperialisticCompetition(Empires,AlgorithmParams)
     if rand > AlgorithmParams.ImperialisticCompetition %�����ֵ���Ը��ģ����Ǿ���̫����������
         return
     end
    if numel(Empires)<=1
        return;
    end
TotalCost = [];
for i = 1:length(Empires)
    TotalCost = [TotalCost; Empires(i).ImperialistCost; Empires(i).ColoniesCost];
end
    
TotalPower = 1.05 * repmat(max(TotalCost), size(TotalCost, 1), 1) - TotalCost;


% ��Empires�л�ȡÿ��Empire��ImperialistCost��ColoniesCost�ĳ���
lengthsImperialist = zeros(length(Empires), 1);
lengthsColonies = zeros(length(Empires), 1);
for i = 1:length(Empires)
    lengthsImperialist(i) = size(Empires(i).ImperialistCost, 1);
    lengthsColonies(i) = size(Empires(i).ColoniesCost, 1);
end

% ����һ���µĽṹ��E
E = struct();

% ��ʼ��һ��ָ�룬ָ��TotalCost�Ŀ�ʼ
pointer = 1;

% ��TotalCost�ֽ��ImperialistCost��ColoniesCost��������E��ÿһ��Empire��
for i = 1:length(Empires)
    E(i).ImperialistCost = TotalPower(pointer:pointer+lengthsImperialist(i)-1, :);
    pointer = pointer + lengthsImperialist(i);
    E(i).ColoniesCost = TotalPower(pointer:pointer+lengthsColonies(i)-1, :);
    pointer = pointer + lengthsColonies(i);
end





        power = zeros(numel(Empires),2);
    for i= 1:numel(Empires)
        power_1 = sum(E(i).ImperialistCost,1);
        power_2 = sum(Empires(i).ColoniesCost,1);
        power(i,:) = power_1/(numel(Empires(i).ImperialistCost)/2) + 0.1*power_2/(numel(Empires(i).ColoniesCost)/2);
    end%%%0.1��ϵ�������Ը���
    
    power(:,2) =  power(:,2)*0.8;

TotalPowers = sum(power,2);


    [~, WeakestEmpireInd] = min(TotalPowers);%���ص����������ŵ�w����
    WeakestEmpireInd = WeakestEmpireInd(1);%�Ӽ���ͬʱ��С����ѡȡ��һ��
    PossessionProbability = TotalPowers / sum(TotalPowers);
    
    SelectedEmpireInd = SelectAnEmpire(PossessionProbability);%ѡȡ���ֳ��صĹ��ҵ�����
    
    nn = size((Empires(WeakestEmpireInd).ColoniesCost),1);%����Ȩ����С�Ĺ��ҵ�ֳ��ظ���
    
    if(nn == 0)
        Empires(SelectedEmpireInd).ColoniesPosition = [Empires(SelectedEmpireInd).ColoniesPosition
                                                       Empires(WeakestEmpireInd).ImperialistPosition];
                                                   
        Empires(SelectedEmpireInd).ColoniesCost = [Empires(SelectedEmpireInd).ColoniesCost
                                                   Empires(WeakestEmpireInd).ImperialistCost];
        Empires=Empires([1:WeakestEmpireInd-1 WeakestEmpireInd+1:end]);%��ԭʼ�۹�������ɾ�������۹���
    else
        jj = randi(nn,1);

        Empires(SelectedEmpireInd).ColoniesPosition = [Empires(SelectedEmpireInd).ColoniesPosition
                                                       Empires(WeakestEmpireInd).ColoniesPosition(jj,:)];

        Empires(SelectedEmpireInd).ColoniesCost = [Empires(SelectedEmpireInd).ColoniesCost
                                                   Empires(WeakestEmpireInd).ColoniesCost(jj,:)];

        Empires(WeakestEmpireInd).ColoniesPosition = Empires(WeakestEmpireInd).ColoniesPosition([1:jj-1 jj+1:end],:);
        Empires(WeakestEmpireInd).ColoniesCost = Empires(WeakestEmpireInd).ColoniesCost([1:jj-1 jj+1:end],:);

        
        %% Collapse of the weakest colony-less Empire
        nn = numel(Empires(WeakestEmpireInd).ColoniesCost);%���ص�Ԫ������
        if nn<=2
            Empires(SelectedEmpireInd).ColoniesPosition = [Empires(SelectedEmpireInd).ColoniesPosition
                                                           Empires(WeakestEmpireInd).ImperialistPosition
                                                           Empires(WeakestEmpireInd).ColoniesPosition
                                                           ];
            Empires(SelectedEmpireInd).ColoniesCost = [Empires(SelectedEmpireInd).ColoniesCost
                                                       Empires(WeakestEmpireInd).ImperialistCost
                                                       Empires(WeakestEmpireInd).ColoniesCost];
            Empires=Empires([1:WeakestEmpireInd-1 WeakestEmpireInd+1:end]);
        end
    end


end

function Index = SelectAnEmpire(Probability)
    R = rand(size(Probability));
    D = Probability - R;
    [MaxD,Index] = max(D);
end

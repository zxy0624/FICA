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

        power = zeros(numel(Empires),1);
    for i= 1:numel(Empires)
        power_1 = evaluate(Empires(i).ImperialistCost,AlgorithmParams);
        power_2 = evaluate(Empires(i).ColoniesCost,AlgorithmParams);
        power(i) = power_1/(numel(Empires(i).ImperialistCost)/2) + 0.1*power_2/(numel(Empires(i).ColoniesCost)/2);
    end%%%0.1��ϵ�������Ը���


NormalizedPowers = power / sum(power);


%     TotalPowers = [Empires.TotalCost];
    TotalPowers = 1./NormalizedPowers;
    [~, WeakestEmpireInd] = min(TotalPowers);%���ص����������ŵ�w����
    WeakestEmpireInd = WeakestEmpireInd(1);%�Ӽ�����С����ѡȡһ��
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

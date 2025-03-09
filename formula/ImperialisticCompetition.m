%% Imperialistic Competition
% 帝国主义竞争是一个最弱的帝国（即成本最差的帝国）中最弱的殖民地（即成本最高的殖民地）
% 被给予成本较高的更强帝国的过程。
% 这是基于概率。因此，帝国越强大（即帝国
% 成本比其他人高），它就越有机会拥有最弱帝国中最弱的殖民地。

function Empires=ImperialisticCompetition(Empires,AlgorithmParams)
     if rand > AlgorithmParams.ImperialisticCompetition %这个数值可以更改，但是竞争太多容易早熟
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
    end%%%0.1是系数，可以更改


NormalizedPowers = power / sum(power);


%     TotalPowers = [Empires.TotalCost];
    TotalPowers = 1./NormalizedPowers;
    [~, WeakestEmpireInd] = min(TotalPowers);%返回的是索引，放到w里面
    WeakestEmpireInd = WeakestEmpireInd(1);%从几个最小的中选取一个
    PossessionProbability = TotalPowers / sum(TotalPowers);
    
    SelectedEmpireInd = SelectAnEmpire(PossessionProbability);%选取获得殖民地的国家的序列
    
    nn = size((Empires(WeakestEmpireInd).ColoniesCost),1);%返回权利最小的国家的殖民地个数
    
    if(nn == 0)
        Empires(SelectedEmpireInd).ColoniesPosition = [Empires(SelectedEmpireInd).ColoniesPosition
                                                       Empires(WeakestEmpireInd).ImperialistPosition];
                                                   
        Empires(SelectedEmpireInd).ColoniesCost = [Empires(SelectedEmpireInd).ColoniesCost
                                                   Empires(WeakestEmpireInd).ImperialistCost];
        Empires=Empires([1:WeakestEmpireInd-1 WeakestEmpireInd+1:end]);%从原始帝国数组中删除最弱帝国。
    else
        jj = randi(nn,1);

        Empires(SelectedEmpireInd).ColoniesPosition = [Empires(SelectedEmpireInd).ColoniesPosition
                                                       Empires(WeakestEmpireInd).ColoniesPosition(jj,:)];

        Empires(SelectedEmpireInd).ColoniesCost = [Empires(SelectedEmpireInd).ColoniesCost
                                                   Empires(WeakestEmpireInd).ColoniesCost(jj,:)];

        Empires(WeakestEmpireInd).ColoniesPosition = Empires(WeakestEmpireInd).ColoniesPosition([1:jj-1 jj+1:end],:);
        Empires(WeakestEmpireInd).ColoniesCost = Empires(WeakestEmpireInd).ColoniesCost([1:jj-1 jj+1:end],:);

        
        %% Collapse of the weakest colony-less Empire
        nn = numel(Empires(WeakestEmpireInd).ColoniesCost);%返回的元素数量
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

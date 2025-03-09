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
TotalCost = [];
for i = 1:length(Empires)
    TotalCost = [TotalCost; Empires(i).ImperialistCost; Empires(i).ColoniesCost];
end
    
TotalPower = 1.05 * repmat(max(TotalCost), size(TotalCost, 1), 1) - TotalCost;


% 从Empires中获取每个Empire的ImperialistCost和ColoniesCost的长度
lengthsImperialist = zeros(length(Empires), 1);
lengthsColonies = zeros(length(Empires), 1);
for i = 1:length(Empires)
    lengthsImperialist(i) = size(Empires(i).ImperialistCost, 1);
    lengthsColonies(i) = size(Empires(i).ColoniesCost, 1);
end

% 创建一个新的结构体E
E = struct();

% 初始化一个指针，指向TotalCost的开始
pointer = 1;

% 将TotalCost分解回ImperialistCost和ColoniesCost，并存入E的每一个Empire中
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
    end%%%0.1是系数，可以更改
    
    power(:,2) =  power(:,2)*0.8;

TotalPowers = sum(power,2);


    [~, WeakestEmpireInd] = min(TotalPowers);%返回的是索引，放到w里面
    WeakestEmpireInd = WeakestEmpireInd(1);%从几个同时最小的中选取第一个
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

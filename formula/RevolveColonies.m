%%革命
%革命是一个殖民地围绕其
%从地方非支配群体中随机选择的地方帝国主义
%解决方案集。
%局部交换，多点变异
function TheEmpire = RevolveColonies(TheEmpire,AlgorithmParams,Gcombination,Fcombination,formula,time,clean,mcost,speed,hcost,htime)

%邻域搜索
%%革命概率有待调整,
for ii=1:size(TheEmpire.ColoniesCost,1)%遍历这个国家中中每一个殖民地
    r = rand();%%%%

    %%随机生成
    if r <= AlgorithmParams.RevolutionRate_1%%%概率可以更改
        %%%%%全新生成

        P1 = randi(size(TheEmpire.ImperialistPosition,1), 1);
        parent_1 = TheEmpire.ImperialistPosition(P1, :);
        %在本帝国中，随机选取一个殖民国家

        if size(TheEmpire.ImperialistPosition,1) > 1
            P2 = randi(size(TheEmpire.ImperialistPosition,1), 1);
            while P1 == P2
                P2 = randi(size(TheEmpire.ImperialistPosition,1), 1);
            end
            parent_2 = TheEmpire.ImperialistPosition(P2, :);
        else
            parent_2 = GenerateNewCountry(1 ,Gcombination); %如果殖民国家只有一个，则重新生成一个
        end
        %从本帝国殖民国家中随机选取两个，作为亲本


        parent1d = parent_1;
        Point1=randi(numel(parent1d),1);
        Point2=Point1;
        while Point2==Point1
            Point2=randi(numel(parent1d),1);
        end

        if Point2<Point1
            Temp=Point1;
            Point1=Point2;
            Point2=Temp;
        end
        %选取交换的点位


        parent1d = parent_1;
        parent2d = parent_2;

        tihuan = parent1d(Point1:Point2);
        %找到具体是哪些是父本来的.存储替换的序列

        offspring = zeros(1,numel(parent1d));
        offspring(Point1:Point2)=tihuan;

        % 从parent2d中剔除与刚刚被选取的相同内容
        remain = setdiff(parent2d, tihuan, 'stable');
        % 将剩下的部分前后顺序不变，填补到x1至x2片段之外的地方

        % 找到 offspring 中为0的位置
        zero_indices = find(offspring == 0);

        % 将 remain 中的值按顺序填入 offspring 中为0的位置
        for i = 1:numel(zero_indices)
            offspring(zero_indices(i)) = remain(i);
        end

        TheEmpire.ColoniesPosition(ii,:) = offspring;
        %%
        %综上，新的矩阵在此产生，替换这个殖民地



        %%多点变异
    elseif (AlgorithmParams.RevolutionRate_1<r) && (r<=AlgorithmParams.RevolutionRate_2) %多点变异
        parent1d = TheEmpire.ColoniesPosition(ii,:);
        R = rand(1, numel(parent1d));%先生成对应的序列
        Rexchange = find(R > 0.8);%找到R中大于0.90的数索引%%%可以改变革命因子


        if numel(Rexchange) >1
            for i = 1:10%集群单点变异
                %重复20次
                %随机挑选Rexchange矩阵中的两个数作为索引x1，x2，
                %将1*400的矩阵parent1d中索引为x1，x2的元素交换位置，并返回交换的元素的值result
                index = datasample(Rexchange, 2, 'Replace', false);
                temp = parent1d(index(1));
                parent1d(index(1)) = parent1d(index(2));
                parent1d(index(2)) = temp;
            end
        end
        TheEmpire.ColoniesPosition(ii,:) = parent1d;

    end

end
    
end

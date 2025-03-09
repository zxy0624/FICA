%% Assimilation of colonies
% ����AssimilateColonies�����Ķ��塣�������������������TheEmpire��ProblemParams��Empires��
% ���������Ŀ���ǽ�ֳ���ͬ���� ȫ�� ��֧��⼯�����ѡ���һ���۹����������
% ��ͬ��֮����20%�ĸ���Ӧ�þ��ñ仯����
%�ֶ��滻����������ȫ��ѡ����������
%�ֲ�̽�����Լ�
function TheEmpire = AssimilateColonies(TheEmpire,ProblemParams, Empires,Decade,AlgorithmParams,Deals,numofmec)
GlobalNDS.Cost = [];
GlobalNDS.Position = [];

for i=1:numel(Empires) %%��۹��ĸ���,��ÿ�������е۹������ߵ�λ�úͳɱ���ӵ�GlobalNDS�ṹ���С�
    Empires(i).ImperialistPosition = cell2mat(Empires(i).ImperialistPosition);
    GlobalNDS.Position(end+1:end+size(Empires(i).ImperialistPosition),:) = Empires(i).ImperialistPosition;
    GlobalNDS.Cost(end+1:end+size(Empires(i).ImperialistPosition)/numofmec,:) = Empires(i).ImperialistCost;
end

GlobalNDS.Position = matrix_to_cell(GlobalNDS.Position,numofmec);%���еĵ�һ�ݶ�����ȡ��һ�ݶ�
[GlobalNDS.Cost, NewIn] = NonDominationSort(GlobalNDS.Cost,ProblemParams.M); % ��֧������
GlobalNDS.Position = GlobalNDS.Position(NewIn,:);%��λ����������֧��������һһ��Ӧ

GlobalNDS.Position = GlobalNDS.Position(GlobalNDS.Cost(:,ProblemParams.M+1) == 1,:);%���еĵ�һ�ݶ�����ȡ��һ�ݶ�%�õ����е۹���λ��
GlobalNDS.Cost =  GlobalNDS.Cost(GlobalNDS.Cost(:,ProblemParams.M+1) == 1,1:ProblemParams.M);%%�õ����е۹���cost

%%
%%���ˣ����е������е�ֳ����ң���������

NumOfColonies = size(TheEmpire.ColoniesPosition,1);
for n = 1:NumOfColonies%������ÿ��ֳ��صı仯

    if Decade <= AlgorithmParams.NumOfDecades*0.2%���Ը���%ǰxxx���������е۹������ѡȡ������һ�ٴ�֮�󣬴�����ĵ۹���ѡȡ
        R = randi(size(GlobalNDS.Position,1), 1);
        parent1 = GlobalNDS.Position(R);
    else
        R = randi(size(TheEmpire.ImperialistPosition,1), 1);
        parent1=TheEmpire.ImperialistPosition(R);
    end%ǰxxx���������е۹������ѡȡ������xxx��֮�󣬴�����ĵ۹���ѡȡ

    parent1 = cell2mat(parent1);
    parent2 = cell2mat(TheEmpire.ColoniesPosition(n));
    parent1d = reshape(parent1(:,1:400/numofmec)', [], 1)';%�����ж�ȡ�����嵥�����룬����������н���
    parent2d = reshape(parent2(:,1:400/numofmec)', [], 1)';%�����ж�ȡ�����嵥�����룬����������н���

    myfun = @(g, G) exp(-(g-0.5*G).^2/(2*(0.2*G)^2));%ֵ��Ϊ0-1,g==0.5G��ʱ��ȡ�����ֵ
         g = linspace(0, 1); % ���� g ��ȡֵ��Χ
         G = 1; % ���� G ��ֵ
         y = myfun(g, G); % ���� y ��ֵ
         plot(g, y) % ����ͼ��
    Q=myfun(Decade,AlgorithmParams.NumOfDecades);%Q��Ӱ�����ӣ���̬�ֲ���������ֵ�����������١����Խ�������Ҳ����������
    a = rand;%0-1�����ϵ��
    length_1 = round(Q*a*numel(parent1d)*0.5+6);%һ��Ҫ�滻�ĳ���%%ϵ�����Ըı䣬+6��֤�ʼҲ�еı�
    if length_1 >= numel(parent1d)*0.5
        length_1 = numel(parent1d)*0.5;%�ų����+6��Ӱ��
    end%ͬʱ��֤length_1������200�����仯�ܳ��Ȳ���������һ��
    parts=4;%�ָ�ķ���
    lengthofpart = numel(parent1d)/parts;
    length = zeros(1,4);

 part = zeros(parts,1);
    for i = 1:3
        upper_limit = min(length_1 - sum(part), lengthofpart/2);
        part(i) = randi([0, upper_limit]);
    end
    part(4) = length_1 - sum(part(1:3));
    
    % Check if any part is greater than lengthofpart/2
    for i = 1:4
        if part(i) > lengthofpart/2
            excess = part(i) - lengthofpart/2;
            part(i) = lengthofpart/2;
            
            % Distribute the excess to other parts
            while excess > 0
                for j = 1:4
                    if j ~= i && part(j) < lengthofpart/2
                        transfer = min(excess, lengthofpart/2 - part(j));
                        part(j) = part(j) + transfer;
                        excess = excess - transfer;
                    end
                end
            end
        end
    end




    %%������滻����
    point = zeros(parts,2);%point����λ���󣬴���Ȼ�ͬ������ʼ�����ֹ��
    x = zeros(1,4);
    for part = 1 : parts%ȷ����λ
        x(part) = randi(lengthofpart) + lengthofpart*(part - 1);%ѡȡ��ʼ�ĵ�λx
        if x(part) + length(part) <= lengthofpart
            point(part,1)=x(part);
            point(part,2)=x(part) + length(part)-1;
        else
            point(part,1) = x(part) - length(part)+1;
            point(part,2) = x(part); 
        end
    end
    %ѡȡx֮����x�ӳ��ȴ��ڸ�part�ĳ��ȣ����x��ǰȡ  length(part)�����֣�
    %ǰ�ı�֤ length(part)С��һ��� lengthofpart��������ǰȥ������Ȼ��һ������ȡ��

    offspring = zeros(size(parent1d));%�Ӵ���ʼ��

    tihuan=[];%�洢�滻�����У�����num��������ʽ��
    for part = 1 : parts%��ʼ����

        x1 = point(part,1);
        x2 = point(part,2);

        % ѡȡparent1d��x1��x2��Ƭ�Σ����Ƶ��Ӵ�ͬ����λ��
        offspring(x1:x2) = parent1d(x1:x2);

        tihuan(1,end+1:end + numel(parent1d(x1:x2))) = parent1d(x1:x2);
        %�ҵ���������Щ�Ǹ�������.�洢�滻������
    end

    % ��parent2d���޳���ոձ�ѡȡ����ͬ����
    remain = setdiff(parent2d, tihuan, 'stable');
    % ��ʣ�µĲ���ǰ��˳�򲻱䣬���x1��x2Ƭ��֮��ĵط�

    % �ҵ� offspring ��Ϊ0��λ��
    zero_indices = find(offspring == 0);


    % �� remain �е�ֵ��˳������ offspring ��Ϊ0��λ��
    for i = 1:numel(zero_indices)
        offspring(zero_indices(i)) = remain(i);
    end

    %�����յ����зֱ�Ϊx1��x2������ĸ��Ϊparent1d��parent2d��1.ѡȡparent1d��x1��x2��Ƭ�Σ����Ƶ��Ӵ�ͬ����λ�á�
    %2����parent2d���޳���ոձ�ѡȡ����ͬ���ݣ���ʣ�µĲ���ǰ��˳�򲻱䣬���x1��x2Ƭ��֮��ĵط�
    offspring = reshape(offspring, [400/numofmec, numofmec])';%���±�Ϊ����
    

        result = offspring;
%        aaa = setdiff(parent1, result, 'stable');
%         result == parent1;%�������
    TheEmpire.ColoniesPosition{n} = result;%�洢Ϊcell

end
end

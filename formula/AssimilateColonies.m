%% Assimilation of colonies
% ����AssimilateColonies�����Ķ��塣�������������������TheEmpire��ProblemParams��Empires��
% ���������Ŀ���ǽ�ֳ���ͬ���� ȫ�� ��֧��⼯�����ѡ���һ���۹����������
% ��ͬ��֮����20%�ĸ���Ӧ�þ��ñ仯����
%�ֶ��滻����������ȫ��ѡ����������
%�ֲ�̽�����Լ�
function TheEmpire = AssimilateColonies(TheEmpire,ProblemParams, Empires,Decade,AlgorithmParams)
GlobalNDS.Cost = [];
GlobalNDS.Position = [];

for i=1:numel(Empires) %%��۹��ĸ���,��ÿ�������е۹������ߵ�λ�úͳɱ���ӵ�GlobalNDS�ṹ���С�
    GlobalNDS.Position(end+1:end+size(Empires(i).ImperialistPosition),:) = Empires(i).ImperialistPosition;
    GlobalNDS.Cost(end+1:end+size(Empires(i).ImperialistPosition),:) = Empires(i).ImperialistCost;
end

[GlobalNDS.Cost, NewIn] = NonDominationSort(GlobalNDS.Cost,ProblemParams.M); % ��֧������
GlobalNDS.Position = GlobalNDS.Position(NewIn,:);%��λ����������֧��������һһ��Ӧ

GlobalNDS.Position = GlobalNDS.Position(GlobalNDS.Cost(:,ProblemParams.M+1) == 1,:);%���еĵ�һ�ݶ�����ȡ��һ�ݶ�%�õ����е۹���λ��
GlobalNDS.Cost =  GlobalNDS.Cost(GlobalNDS.Cost(:,ProblemParams.M+1) == 1,1:ProblemParams.M);%%�õ����е۹���cost

%%
%%���ˣ����е������е�ֳ����ң���������

NumOfColonies = size(TheEmpire.ColoniesPosition,1);
for n = 1:NumOfColonies%������ÿ��ֳ��صı仯

    if Decade <= 1000%���Ը���%ǰ1000���������е۹������ѡȡ������һ�ٴ�֮�󣬴�����ĵ۹���ѡȡ
        R = randi(size(GlobalNDS.Position,1), 1);
        parent1 = GlobalNDS.Position(R,:);
    else
        R = randi(size(TheEmpire.ImperialistPosition,1), 1);
        parent1=TheEmpire.ImperialistPosition(R,:);
    end%ǰ1000���������е۹������ѡȡ������һǧ��֮�󣬴�����ĵ۹���ѡȡ

    parent2 = TheEmpire.ColoniesPosition(n,:);

    myfun = @(g, G) exp(-(g-0.5*G).^2/(2*(0.2*G)^2));%ֵ��Ϊ0-1,g==0.5G��ʱ��ȡ�����ֵ
    %      g = linspace(0, 1); % ���� g ��ȡֵ��Χ
    %      G = 1; % ���� G ��ֵ
    %      y = myfun(g, G); % ���� y ��ֵ
    %      plot(g, y) % ����ͼ��
    Q=myfun(Decade,AlgorithmParams.NumOfDecades);%Q��Ӱ�����ӣ���̬�ֲ���������ֵ�����������١����Խ�������Ҳ����������
    a = rand;%0-1�����ϵ��
    length_1 = round(Q*a*numel(parent1)*0.5+2);%һ��Ҫ�滻�ĳ���%%ϵ�����Ըı䣬+6��֤�ʼҲ�еı�
    if length_1 >= numel(parent1)*0.5
        length_1 = numel(parent1)*0.5;%�ų����+2��Ӱ��
    end%ͬʱ��֤length_1������200�����仯�ܳ��Ȳ���������һ��



    %%������滻����
    point = zeros(1,2);%point����λ���󣬴���Ȼ�ͬ������ʼ�����ֹ��
        x = randi(numel(parent1)) ;%ѡȡ��ʼ�ĵ�λx
        if x + length_1 <= numel(parent1)
            point(1,1)=x;
            point(1,2)=x + length_1;
        else
            point(1,1) = x - length_1+1;
            point(1,2) = x; 
        end
    %ѡȡx֮����x�ӳ��ȴ��ڸ�part�ĳ��ȣ����x��ǰȡ  length(part)�����֣�
    %ǰ�ı�֤ length(part)С��һ��� lengthofpart��������ǰȥ������Ȼ��һ������ȡ��

    offspring = zeros(size(parent1));%�Ӵ���ʼ��

    tihuan=[];%�洢�滻�����У�����num��������ʽ��

        x1 = point(1,1);
        x2 = point(1,2);

        % ѡȡparent1d��x1��x2��Ƭ�Σ����Ƶ��Ӵ�ͬ����λ��
        offspring(x1:x2) = parent1(x1:x2);

        tihuan(1,end+1:end + numel(parent1(x1:x2))) = parent1(x1:x2);
        %�ҵ���������Щ�Ǹ�������.�洢�滻������


    % ��parent2d���޳���ոձ�ѡȡ����ͬ����
    remain = setdiff(parent2, tihuan, 'stable');
    % ��ʣ�µĲ���ǰ��˳�򲻱䣬���x1��x2Ƭ��֮��ĵط�

    % �ҵ� offspring ��Ϊ0��λ��
    zero_indices = find(offspring == 0);


    % �� remain �е�ֵ��˳������ offspring ��Ϊ0��λ��
    for i = 1:numel(zero_indices)
        offspring(zero_indices(i)) = remain(i);
    end

    %�����յ����зֱ�Ϊx1��x2������ĸ��Ϊparent1d��parent2d��1.ѡȡparent1d��x1��x2��Ƭ�Σ����Ƶ��Ӵ�ͬ����λ�á�
    %2����parent2d���޳���ոձ�ѡȡ����ͬ���ݣ���ʣ�µĲ���ǰ��˳�򲻱䣬���x1��x2Ƭ��֮��ĵط�
    

        result = offspring;
%        aaa = setdiff(parent1, result, 'stable');
%         result == parent1;%�������
    TheEmpire.ColoniesPosition(n,:) = result;%�洢

end
end

%%����
%������һ��ֳ���Χ����
%�ӵط���֧��Ⱥ�������ѡ��ĵط��۹�����
%�����������
%�ֲ�������������
function TheEmpire = RevolveColonies(TheEmpire,AlgorithmParams,ProblemParams,Deals,numofmec)

%��������
%%���������д�����,
for ii=1:size(TheEmpire.ColoniesCost,1)%���������������ÿһ��ֳ���
    r = rand();%%%%

     %%�������
    if r <= 0.1%%%���ʿ��Ը���
        %%%%%ȫ������

        P1 = randi(size(TheEmpire.ImperialistPosition,1), 1);
        parent_1 = TheEmpire.ImperialistPosition(P1, :);
        %�ڱ��۹��У����ѡȡһ��ֳ�����

        if size(TheEmpire.ImperialistPosition,1) > 1
            P2 = randi(size(TheEmpire.ImperialistPosition,1), 1);
            while P1 == P2
                P2 = randi(size(TheEmpire.ImperialistPosition,1), 1);
            end
            parent_2 = TheEmpire.ImperialistPosition(P2, :);
        else
            parent_2 = GenerateNewCountry(1 , Deals,numofmec); %���ֳ�����ֻ��һ��������������һ��
            parent_2 = matrix_to_cell(parent_2,numofmec);
        end
        %�ӱ��۹�ֳ����������ѡȡ��������Ϊ�ױ�



        Point1=randi(400,1);
        Point2=Point1;
        while Point2==Point1
            Point2=randi(400,1);
        end

        if Point2<Point1
            Temp=Point1;
            Point1=Point2;
            Point2=Temp;
        end
        %ѡȡ�����ĵ�λ

        parent1 = cell2mat(parent_1);
        parent2 = cell2mat(parent_2);

        parent1d = reshape(parent1(:,1:400/numofmec)', [], 1)';%�����ж�ȡ�����嵥�����룬����������н���
        parent2d = reshape(parent2(:,1:400/numofmec)', [], 1)';%�����ж�ȡ�����嵥�����룬����������н���

        tihuan = parent1d(Point1:Point2);
        %�ҵ���������Щ�Ǹ�������.�洢�滻������

        offspring = zeros(1,400);
        offspring(Point1:Point2)=tihuan;

        % ��parent2d���޳���ոձ�ѡȡ����ͬ����
        remain = setdiff(parent2d, tihuan, 'stable');
        % ��ʣ�µĲ���ǰ��˳�򲻱䣬���x1��x2Ƭ��֮��ĵط�

        % �ҵ� offspring ��Ϊ0��λ��
        zero_indices = find(offspring == 0);

        % �� remain �е�ֵ��˳������ offspring ��Ϊ0��λ��
        for i = 1:numel(zero_indices)
            offspring(zero_indices(i)) = remain(i);
        end

        offspring = reshape(offspring, [400/numofmec, numofmec])';%���±�Ϊ����
        TheEmpire.ColoniesPosition{ii} = offspring;
        %%
        %���ϣ��µľ����ڴ˲������滻���ֳ���



        %%������
elseif (0.1<r) && (r<=0.3) %������
   

        parent1 = TheEmpire.ColoniesPosition(ii);
        parent1 = cell2mat(parent1);
        parent1d = reshape(parent1(:,1:400/numofmec)', [], 1)';%�����ж�ȡ�����嵥�����룬����������н���
        R = rand(1, 400);%�����ɶ�Ӧ������
        Rexchange = find(R > 0.90);%�ҵ�R�д���0.90��������%%%���Ըı��������

        for i = 1:20%��Ⱥ�������
            %�ظ�20��
            %�����ѡRexchange�����е���������Ϊ����x1��x2��
            %��1*400�ľ���parent1d������Ϊx1��x2��Ԫ�ؽ���λ�ã������ؽ�����Ԫ�ص�ֵresult
            index = datasample(Rexchange, 2, 'Replace', false);
            temp = parent1d(index(1));
            parent1d(index(1)) = parent1d(index(2));
            parent1d(index(2)) = temp;
        end

        result = reshape(parent1d, [numofmec, 400/numofmec]);
        TheEmpire.ColoniesPosition{ii} = result;



    end

end

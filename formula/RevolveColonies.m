%%����
%������һ��ֳ���Χ����
%�ӵط���֧��Ⱥ�������ѡ��ĵط��۹�����
%�����������
%�ֲ�������������
function TheEmpire = RevolveColonies(TheEmpire,AlgorithmParams,Gcombination,Fcombination,formula,time,clean,mcost,speed,hcost,htime)

%��������
%%���������д�����,
for ii=1:size(TheEmpire.ColoniesCost,1)%���������������ÿһ��ֳ���
    r = rand();%%%%

    %%�������
    if r <= AlgorithmParams.RevolutionRate_1%%%���ʿ��Ը���
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
            parent_2 = GenerateNewCountry(1 ,Gcombination); %���ֳ�����ֻ��һ��������������һ��
        end
        %�ӱ��۹�ֳ����������ѡȡ��������Ϊ�ױ�


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
        %ѡȡ�����ĵ�λ


        parent1d = parent_1;
        parent2d = parent_2;

        tihuan = parent1d(Point1:Point2);
        %�ҵ���������Щ�Ǹ�������.�洢�滻������

        offspring = zeros(1,numel(parent1d));
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

        TheEmpire.ColoniesPosition(ii,:) = offspring;
        %%
        %���ϣ��µľ����ڴ˲������滻���ֳ���



        %%������
    elseif (AlgorithmParams.RevolutionRate_1<r) && (r<=AlgorithmParams.RevolutionRate_2) %������
        parent1d = TheEmpire.ColoniesPosition(ii,:);
        R = rand(1, numel(parent1d));%�����ɶ�Ӧ������
        Rexchange = find(R > 0.8);%�ҵ�R�д���0.90��������%%%���Ըı��������


        if numel(Rexchange) >1
            for i = 1:10%��Ⱥ�������
                %�ظ�20��
                %�����ѡRexchange�����е���������Ϊ����x1��x2��
                %��1*400�ľ���parent1d������Ϊx1��x2��Ԫ�ؽ���λ�ã������ؽ�����Ԫ�ص�ֵresult
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

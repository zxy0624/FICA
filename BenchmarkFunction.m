function y = BenchmarkFunction(InitialCountries,mcost,Deals,hptime,Fcombination,op_1,op_5,op_8,c_1,c_5,c_8,speed,numofmec,lenofdeal)
%���������������������Ч��

if iscell(InitialCountries)
    InitialCountries = cell2mat(InitialCountries);
end

[numberofcountry,~] = size(InitialCountries);
numberofcountry = numberofcountry/numofmec;
y=zeros(numberofcountry,2);

for n = 1:numberofcountry%ÿ������
    t=zeros(numofmec,1);
    c=zeros(numofmec,1);
    country = InitialCountries(numofmec*(n-1)+1:numofmec*(n-1)+numofmec,:);
    for h = 1:numofmec%ÿ�����е�1--numofmec��,Ҳ����ÿ������
        t(h)=0;
        c(h)=0;
        np = 0;%ʵ�ʵ�����
        if numofmec==4  %����Ϊ4��ʱ�򣬾�������
            if h==1
                data = c_1;
            end
            if ismember(h,[2,3])
                data = c_5;
            end
            if h==4
                data = c_8;
            end
        end

        if numofmec==5  %����Ϊ5��ʱ�򣬾�������
            if ismember(h,[1,2])
                data = c_1;
            end
            if h==3
                data = c_5;
            end
            if ismember(h,[4,5])
                data = c_8;
            end
        end
        if numofmec==8  %����Ϊ8��ʱ�򣬾�������
            if ismember(h,[1,2,3])
                data = c_1;
            end
            if ismember(h,[4,5])
                data = c_5;
            end
            if ismember(h,[6,7,8])
                data = c_8;
            end
        end
        if numofmec==10  %����Ϊ10��ʱ�򣬾�������
            if ismember(h,[1,2,3])
                data = c_1;
            end
            if ismember(h,[4,5,6,7])
                data = c_5;
            end
            if ismember(h,[8,9,10])
                data = c_8;
            end
        end
        
        temp = country(h,:);
        for p = 1:400/5/numofmec
            batchindex = temp(5*(p-1)+1:5*(p-1)+5);
            if all(batchindex > lenofdeal*10)
                np = np+0;
            else
                np = np +1;
            end%��¼ʵ�ʲ���������
            batch = Deals(batchindex);
            batch(batch==0) = 8;
            batch = sort(batch);

            rowIndex = true(size(Fcombination, 1), 1);
            % ����Ŀ�����е�ÿһ��
            for i = 1:size(batch, 2)
                % �����߼�����������ֻ�����ڵ�ǰ����Ŀ������ƥ�����
                rowIndex = rowIndex & (Fcombination(:, i) == batch(i));
            end

            % ���ص�һ����Ŀ����ƥ����е�����
            rowIndex = find(rowIndex, 1);

            t(h) = t(h) + data(rowIndex,1);
            c(h) = c(h) + data(rowIndex,2) ;
            %%%%%cw1�� cw2�������ñ���ϵ��
            %t(h) = t(h) + np*(hptime);%�����м任����ʱ��
        end
        t(h) = t(h) + np*(hptime);%�����м任����ʱ��
    end

    y(n,1) = max(t);
    y(n,2) = sum(c);

end

end

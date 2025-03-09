function y = BenchmarkFunction(InitialCountries,mcost,Deals,hptime,Fcombination,op_1,op_5,op_8,c_1,c_5,c_8,speed,numofmec,lenofdeal)
%采用逐级收缩法，显著提高效率

if iscell(InitialCountries)
    InitialCountries = cell2mat(InitialCountries);
end

[numberofcountry,~] = size(InitialCountries);
numberofcountry = numberofcountry/numofmec;
y=zeros(numberofcountry,2);

for n = 1:numberofcountry%每个国家
    t=zeros(numofmec,1);
    c=zeros(numofmec,1);
    country = InitialCountries(numofmec*(n-1)+1:numofmec*(n-1)+numofmec,:);
    for h = 1:numofmec%每国家中的1--numofmec行,也就是每个机器
        t(h)=0;
        c(h)=0;
        np = 0;%实际的批次
        if numofmec==4  %机器为4的时候，就这样做
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

        if numofmec==5  %机器为5的时候，就这样做
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
        if numofmec==8  %机器为8的时候，就这样做
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
        if numofmec==10  %机器为10的时候，就这样做
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
            end%记录实际操作的批次
            batch = Deals(batchindex);
            batch(batch==0) = 8;
            batch = sort(batch);

            rowIndex = true(size(Fcombination, 1), 1);
            % 对于目标行中的每一列
            for i = 1:size(batch, 2)
                % 更新逻辑索引向量，只保留在当前列与目标行相匹配的行
                rowIndex = rowIndex & (Fcombination(:, i) == batch(i));
            end

            % 返回第一个与目标行匹配的行的索引
            rowIndex = find(rowIndex, 1);

            t(h) = t(h) + data(rowIndex,1);
            c(h) = c(h) + data(rowIndex,2) ;
            %%%%%cw1和 cw2可以设置比重系数
            %t(h) = t(h) + np*(hptime);%加上中间换批的时间
        end
        t(h) = t(h) + np*(hptime);%加上中间换批的时间
    end

    y(n,1) = max(t);
    y(n,2) = sum(c);

end

end

function result = test(Gcombination,numberofm,Fcombination,formula,time,clean,mcost,speed,hcost,htime)
%计算这个批次排序带来的time和cost
%没有限定机器
%切换工序的时候，怎么知道是换了瓶子呢,使用index

[m,n] = size(Gcombination);%读要计算的矩阵有几行
tw = zeros(m,1);%这是全部t和c的汇总
cw = zeros(m,1);%
for  h = 1:m
    t = 0;
    mt= 0;
    c = 0;%除了机器冲气损耗的损耗
    mc =0;%仅仅是机器充气损耗，耗电
    a0 = 0;%初始气瓶为0.之后气瓶如果与之前不同就要有一个换装时间
    zhonglei0 = 0;%初始气体种类设置为zhonglei0=0
    for l = 1:n
        index = Gcombination(h,l); % 找出要执行的工序的索引
        a = floor(index / 100);%索引得到在这个批次中的瓶号
        b = mod(index, 100);%索引得到要冲的这瓶要用的配方中气体序号
        num = Fcombination(a)*100 +b ; %从索引还原为具体的配方加气体的表达
        peifang = floor(num / 100);%读取这里工序执行的配方和气体种类
        zhonglei = mod(num, 100);%读取这里工序执行的配方和气体种类
        hanliang = formula(peifang,zhonglei);%读取要冲气的含量百分比
        if hanliang==0
            continue
        end%如果含量0就不管
%         if zhonglei ~= zhonglei0%如果气体种类不同
%             t = t + clean(1);
%             c = c + clean(2);
%             zhonglei0 = zhonglei; %更新gas，并加入吹扫的消耗和时间
%         end%气体种类不同的话就加一个吹扫的时间和功耗

        if a ~= a0%如果瓶子不同
            a0 = a;
            c = c + hcost;
            t = t + htime;
        elseif zhonglei ~= zhonglei0%如果气体种类不同
            t = t + clean(1);
            c = c + clean(2);
            zhonglei0 = zhonglei; %更新gas，并加入吹扫的消耗和时间
        %气体种类不同的话就加一个吹扫的时间和功耗

        end
        mt = mt + time(zhonglei)*hanliang/100;
        mc = mc +  time(zhonglei)*hanliang/100;%mc是跟时间正比例相关的。最后乘一个机器系数，就是具体机器的mc

    end
    tw(h) = mt/speed(numberofm) + t;
    cw(h) = mc*mcost(numberofm) + c;

end
result = [tw cw]; % 将两个向量组合成一个矩阵
end
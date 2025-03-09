function deals = Creatdeal(numofdeal,lenofdeal,formula)
%根据订单数量和订单长度，以及订单可选范围，随机创造订单
%   
formula(end,:) = [];
[a,~]=size(formula);
deals = zeros(numofdeal,lenofdeal);
deals(1,:)=randi([1, a], 1, lenofdeal);
for i = 2: numofdeal

    deal = randi([1, a], 1, lenofdeal);
    deals(i,:) = deal;
end
end


function deals = Creatdeal(numofdeal,lenofdeal,formula)
%���ݶ��������Ͷ������ȣ��Լ�������ѡ��Χ��������충��
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


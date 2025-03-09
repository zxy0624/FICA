%% Generates new countries randomly
%�ٰѴ��Ž��д�������Ϊ��һ������8�У�ǰ50����������ű�ʾ��Щ�����Ǹû����ϼӹ�����300�б�ʾ����˳��
function NewCountry = GenerateNewCountry(NumOfCountries, TheGcombination)
    lengthOfGcombination = length(TheGcombination); % �����������ĳ���
    NewCountry = zeros(NumOfCountries, lengthOfGcombination); % ��ʼ���������

    for i = 1:NumOfCountries
        NewCountry(i, :) = TheGcombination(randperm(lengthOfGcombination));
    end
end

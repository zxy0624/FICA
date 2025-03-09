%% Generates new countries randomly
%再把代号进行处理，最后成为，一个国家8行，前50列用气体代号表示哪些气体是该机器上加工，后300行表示工序顺序
function NewCountry = GenerateNewCountry(NumOfCountries, TheGcombination)
    lengthOfGcombination = length(TheGcombination); % 计算行向量的长度
    NewCountry = zeros(NumOfCountries, lengthOfGcombination); % 初始化结果矩阵

    for i = 1:NumOfCountries
        NewCountry(i, :) = TheGcombination(randperm(lengthOfGcombination));
    end
end

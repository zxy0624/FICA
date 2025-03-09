%% Generates new countries randomly
%设置的是每台机器开始有25个瓶子的分配，并且全程最多做五十个瓶子。（这五十和25的比例，可以根据瓶子之间的
%效率变化来改变。总批次也就是50*6=300，所以每个350列。其中有很多的0.
%此处采用先生成一个和deals一样大小的代号，（代号可以方便后续气体与气体之间的交换，不然相同的气体可能不知道该换哪一个。）
%再把代号进行处理，最后成为，一个国家8行，前50列用气体代号表示哪些气体是该机器上加工，后300行表示工序顺序
function NewCountry = GenerateNewCountry(NumOfCountries,Deals,numofmec)
m = numofmec;
max = 400;
NewCountry = zeros(NumOfCountries*m,max/m);
[a,b]=size(Deals);
vec = (1:a*b)';%生成每瓶气的代号

for x = 1: NumOfCountries
    
    Gasdistribute = zeros(m,max/m);%先生成一个最初的原始序列，后续根据这个进行随机出初始国家
    
    % 计算可以分配的元素个数
    num = min(a*b, numel(Gasdistribute));
    
    % 随机选择 num 个位置
    idx = randperm(numel(Gasdistribute), num);
    
    % 将 vec 矩阵中的所有元素随机分配到 NewCountry 矩阵中
    Gasdistribute(idx) = vec(:);
    

    for i = 1 : m
        for j=1:max/m
            NewCountry(i+m*x-m,j) = Gasdistribute(i,j);
        end
    end%把分配情况读入国家
    


end
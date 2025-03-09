%% Generates new countries randomly
%���õ���ÿ̨������ʼ��25��ƿ�ӵķ��䣬����ȫ���������ʮ��ƿ�ӡ�������ʮ��25�ı��������Ը���ƿ��֮���
%Ч�ʱ仯���ı䡣������Ҳ����50*6=300������ÿ��350�С������кܶ��0.
%�˴�����������һ����dealsһ����С�Ĵ��ţ������ſ��Է����������������֮��Ľ�������Ȼ��ͬ��������ܲ�֪���û���һ������
%�ٰѴ��Ž��д�������Ϊ��һ������8�У�ǰ50����������ű�ʾ��Щ�����Ǹû����ϼӹ�����300�б�ʾ����˳��
function NewCountry = GenerateNewCountry(NumOfCountries,Deals,numofmec)
m = numofmec;
max = 400;
NewCountry = zeros(NumOfCountries*m,max/m);
[a,b]=size(Deals);
vec = (1:a*b)';%����ÿƿ���Ĵ���

for x = 1: NumOfCountries
    
    Gasdistribute = zeros(m,max/m);%������һ�������ԭʼ���У�����������������������ʼ����
    
    % ������Է����Ԫ�ظ���
    num = min(a*b, numel(Gasdistribute));
    
    % ���ѡ�� num ��λ��
    idx = randperm(numel(Gasdistribute), num);
    
    % �� vec �����е�����Ԫ��������䵽 NewCountry ������
    Gasdistribute(idx) = vec(:);
    

    for i = 1 : m
        for j=1:max/m
            NewCountry(i+m*x-m,j) = Gasdistribute(i,j);
        end
    end%�ѷ�������������
    


end
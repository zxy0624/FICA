function Gastime=Gastimecreat(formula,time)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
[a,b]=size(formula);
time_1=0;

for j= 1:b
        time_1 = time_1 + formula(1,j)*time(j)*0.01;
        Gastime = time_1;
end
       
for i = 2:a
    time_i = 0;
    for j= 1:b
        time_i = time_i + formula(i,j)*time(j)*0.01;
    end
    Gastime = [Gastime;
            time_i];
end
end


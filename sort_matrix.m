function A_sorted = sort_matrix(A, B,numofmec,AlgorithmParams)
%һ��800*350�ľ��󣬺�һ��100*1�о������У���800*50�ľ���ÿ8����Ϊһ�飬
%һ��100�飬Ȼ��100�鰴���о�����������
    % �� A ����ֳ� 100 �飬ÿ�� 8 ��
    A_cell = mat2cell(A, repmat(numofmec,AlgorithmParams.NumOfCountries,1), 400/numofmec);
    % ���� B �����е�˳��� A_cell �е�Ԫ�ؽ�������
    A_sorted_cell = A_cell(B);
    % ��������Ԫ������ת���ؾ���
    A_sorted = cell2mat(A_sorted_cell);
end


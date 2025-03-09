function A_sorted = sort_matrix(A, B,numofmec,AlgorithmParams)
%一个800*350的矩阵，和一个100*1列矩阵序列，把800*50的矩阵每8行设为一组，
%一共100组，然后100组按照列矩阵序列排序
    % 将 A 矩阵分成 100 组，每组 8 行
    A_cell = mat2cell(A, repmat(numofmec,AlgorithmParams.NumOfCountries,1), 400/numofmec);
    % 按照 B 矩阵中的顺序对 A_cell 中的元素进行排序
    A_sorted_cell = A_cell(B);
    % 将排序后的元胞数组转换回矩阵
    A_sorted = cell2mat(A_sorted_cell);
end


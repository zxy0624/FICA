function exam(matrix)
    % 将矩阵转换为一维向量
    vector = matrix(:);

    % 创建一个包含1到400的列向量
    expected = (1:400)';

    % 检查vector是否包含expected中的所有元素，且没有重复
    if numel(vector) == numel(expected) & all(sort(vector) == expected)
        disp('矩阵中包含1到400的所有整数，且没有重复');
    else
        disp('矩阵中不包含1到400的所有整数，或者有重复的元素');
    end
end

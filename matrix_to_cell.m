function result = matrix_to_cell(matrix,numofmec)
%把一个矩阵每numofmec行合成一个cell
    result = {};
    for i = 1:numofmec:size(matrix, 1)
        result{end+1} = matrix(i:min(i+numofmec-1, end), :);
    end
    result = (result');
end



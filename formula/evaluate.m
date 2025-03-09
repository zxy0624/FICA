function result = evaluate(Cost,AlgorithmParams)
    coef = AlgorithmParams.coef;
    % 乘以系数
    first_col = Cost(:, 1) * coef;
    % 加上第二列
    Cost(:, 2) = first_col + Cost(:, 2);
    % 计算第二列所有数的和
    result = sum(Cost(:, 2));
end

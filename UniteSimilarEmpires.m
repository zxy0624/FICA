%% Uniting of similar empires
% Empires are united based on the generational distance metric and
% TheresholdDistance parameter.
function Empires=UniteSimilarEmpires(Empires,AlgorithmParams,ProblemParams)
    
    TheresholdDistance = AlgorithmParams.UnitingThreshold * norm(ProblemParams.SearchSpaceSize);
    NumOfEmpires = numel(Empires);

    for ii = 1:NumOfEmpires-1
        for jj = ii+1:NumOfEmpires
            
            AllCosts_1 = [];
            AllCosts_1(1:size(Empires(ii).ImperialistCost,1), :) = Empires(ii).ImperialistCost;
            AllCosts_1(end+1:end + size(Empires(ii).ColoniesCost,1),:) = Empires(ii).ColoniesCost;
            [AllCosts_1, ~] = NonDominationSort(AllCosts_1,ProblemParams.M); % apply non-domination sorting...
            EmpiresInd = AllCosts_1(:,ProblemParams.M+1) == min(AllCosts_1(:,ProblemParams.M+1)); % get the Empires in the first front...
            E1 = AllCosts_1(EmpiresInd,1:ProblemParams.M);

            AllCosts_2 = [];
            AllCosts_2(1:size(Empires(jj).ImperialistCost,1), :) = Empires(jj).ImperialistCost;
            AllCosts_2(end+1:end + size(Empires(jj).ColoniesCost,1),:) = Empires(jj).ColoniesCost;

            [AllCosts_2, ~] = NonDominationSort(AllCosts_2,ProblemParams.M); % apply non-domination sorting...
            EmpiresInd = AllCosts_2(:,ProblemParams.M+1) == min(AllCosts_1(:,ProblemParams.M+1));% get the Empires in the first front...

            E2 = AllCosts_2(EmpiresInd,1:ProblemParams.M);

            LessSolutionsSet = E1;
            MoreSolutionsSet = E2;%less和more 代表帕累托前言个数的比较
            if(size(E1,1)>size(E2,1))
                LessSolutionsSet = E2;
                MoreSolutionsSet = E1;
            end


            d_min = zeros(1,min(size(E1,1),size(E2,1)));
            for k=1:min(size(E1,1),size(E2,1))
                d = zeros(1,max(size(E1,1),size(E2,1)));
                for kk=1:max(size(E1,1),size(E2,1))
                    if(ProblemParams.M == 2)
                        d(kk) = d(kk) + sqrt((LessSolutionsSet(k, 1)-MoreSolutionsSet(kk, 1))^2+(LessSolutionsSet(k, 2)-MoreSolutionsSet(kk, 2))^2);
                    else
                        d(kk) = d(kk) + sqrt((LessSolutionsSet(k, 1)-MoreSolutionsSet(kk, 1))^2+(LessSolutionsSet(k, 2)-MoreSolutionsSet(kk, 2))^2+(LessSolutionsSet(k, 3)-MoreSolutionsSet(kk, 3))^2);
                    end

                end%k中取值累加kk的取值
                d_min(k) = min(d);
            end
            Distance = sum(d_min)/min(size(E1,1),size(E2,1));%d的平均值

            if Distance<=TheresholdDistance
                Empires(ii).ColoniesPosition = [Empires(ii).ColoniesPosition
                                                Empires(jj).ImperialistPosition
                                                Empires(jj).ColoniesPosition];

                Empires(ii).ColoniesCost = [Empires(ii).ColoniesCost
                                            Empires(jj).ImperialistCost
                                            Empires(jj).ColoniesCost];
                
                Empires = Empires([1:jj-1 jj+1:end]);

                %% Recompute Imperialists from the newly created Empire's
                %% population...
                ColoniesCost = Empires(ii).ColoniesCost;
                ColoniesPosition = Empires(ii).ColoniesPosition;

                ColoniesCost(end+1: end+size(Empires(ii).ImperialistCost,1),:) = Empires(ii).ImperialistCost;
                ColoniesPosition(end+1:end+size(Empires(ii).ImperialistCost,1),:) = Empires(ii).ImperialistPosition;

                [AllColoniesCost, SortInd] = NonDominationSort(ColoniesCost,ProblemParams.M); % apply non-domination sorting...
                AllColoniesPosition = ColoniesPosition(SortInd,:); % Sort the population with respect to their cost.

                Empires(ii).ImperialistCost = AllColoniesCost(AllColoniesCost(:,ProblemParams.M+1) == 1,1:ProblemParams.M);
                Empires(ii).ImperialistPosition = AllColoniesPosition(AllColoniesCost(:,ProblemParams.M+1) == 1,1:end);

                Empires(ii).ColoniesCost = AllColoniesCost(AllColoniesCost(:,ProblemParams.M+1) ~= 1,1:ProblemParams.M);
                Empires(ii).ColoniesPosition = AllColoniesPosition(AllColoniesCost(:,ProblemParams.M+1) ~= 1,1:end);

                %%Compute the Total Cost of an Empire...
                empirePop = [Empires(ii).ImperialistCost
                             Empires(ii).ColoniesCost];
                [TotalCosts, ~] = NonDominationSort(empirePop,ProblemParams.M);
                FirstFront =  find(TotalCosts(:,ProblemParams.M+1) == 1);
                Empires(ii).TotalCost = size(FirstFront, 1);
                
                return;
            end
       end
    end
   
end

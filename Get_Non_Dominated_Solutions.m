%% Getting Non-Dominated Solutions
% This function splits all solutions into several parts
% and then computes non-dominated solutions for each of them in order to 
% improve the performance.
function f = Get_Non_Dominated_Solutions(x, M)

f = [];
%% First Ten parts...
Ind = floor(size(x,1)/10);
Remainder = mod(size(x,1),10);
Start = 1;

[p1, ~] = NonDominationSort(x(Start:Ind,end-M+1:end),M);

p1 = p1(p1(:,end-1) == 1,1:end-2);
Start = Ind+1;
Ind = Ind + floor(size(x,1)/10);
disp('1 of 10 sorted...');
[p2, ~] = NonDominationSort(x(Start:Ind,end-M+1:end),M);
p2 = p2(p2(:,end-1) == 1,1:end-2);
Start = Ind+1;
Ind = Ind + floor(size(x,1)/10);
disp('2 of 10 sorted...');
[p3, ~] = NonDominationSort(x(Start:Ind,end-M+1:end),M);
p3 = p3(p3(:,end-1) == 1,1:end-2);
Start = Ind+1;
Ind = Ind + floor(size(x,1)/10);
disp('3 of 10 sorted...');
[p4, ~] = NonDominationSort(x(Start:Ind,end-M+1:end),M);
p4 = p4(p4(:,end-1) == 1,1:end-2);
Start = Ind+1;
Ind = Ind + floor(size(x,1)/10);
disp('4 of 10 sorted...');
[p5, ~] = NonDominationSort(x(Start:Ind,end-M+1:end),M);
p5 = p5(p5(:,end-1) == 1,1:end-2);
Start = Ind+1;
Ind = Ind + floor(size(x,1)/10);
disp('5 of 10 sorted...');
[p6, ~] = NonDominationSort(x(Start:Ind,end-M+1:end),M);
p6 = p6(p6(:,end-1) == 1,1:end-2);
Start = Ind+1;
Ind = Ind + floor(size(x,1)/10);
disp('6 of 10 sorted...');
[p7, ~] = NonDominationSort(x(Start:Ind,end-M+1:end),M);
p7 = p7(p7(:,end-1) == 1,1:end-2);
Start = Ind+1;
Ind = Ind + floor(size(x,1)/10);
disp('7 of 10 sorted...');
[p8, ~] = NonDominationSort(x(Start:Ind,end-M+1:end),M);
p8 = p8(p8(:,end-1) == 1,1:end-2);
Start = Ind+1;
Ind = Ind + floor(size(x,1)/10);
disp('8 of 10 sorted...');
[p9, ~] = NonDominationSort(x(Start:Ind,end-M+1:end),M);
p9 = p9(p9(:,end-1) == 1,1:end-2);
Start = Ind+1;
Ind = Ind + floor(size(x,1)/10);
disp('9 of 10 sorted...');
[p10, ~] = NonDominationSort(x(Start:Ind+Remainder,end-M+1:end),M);
p10 = p10(p10(:,end-1) == 1,1:end-2);
disp('10 of 10 sorted...');
%% Next five parts...
P = p1;
P(size(P,1)+1:size(P,1)+size(p2,1),:) = p2;
P(size(P,1)+1:size(P,1)+size(p3,1),:) = p3;
P(size(P,1)+1:size(P,1)+size(p4,1),:) = p4;
P(size(P,1)+1:size(P,1)+size(p5,1),:) = p5;
P(size(P,1)+1:size(P,1)+size(p6,1),:) = p6;
P(size(P,1)+1:size(P,1)+size(p7,1),:) = p7;
P(size(P,1)+1:size(P,1)+size(p8,1),:) = p8;
P(size(P,1)+1:size(P,1)+size(p9,1),:) = p9;
P(size(P,1)+1:size(P,1)+size(p10,1),:) = p10;

Ind = floor(size(P,1)/5);
Remainder = mod(size(P,1),5);
Start = 1;

[p1, ~] = NonDominationSort(P(Start:Ind,end-M+1:end),M);
p1 = p1(p1(:,end-1) == 1,1:end-2);
Start = Ind+1;
Ind = Ind + floor(size(P,1)/5);
disp('1 of 5 sorted...');
[p2, ~] = NonDominationSort(P(Start:Ind,end-M+1:end),M);
p2 = p2(p2(:,end-1) == 1,1:end-2);
Start = Ind+1;
Ind = Ind + floor(size(P,1)/5);
disp('2 of 5 sorted...');
[p3, ~] = NonDominationSort(P(Start:Ind,end-M+1:end),M);
p3 = p3(p3(:,end-1) == 1,1:end-2);
Start = Ind+1;
Ind = Ind + floor(size(P,1)/5);
disp('3 of 5 sorted...');
[p4, ~] = NonDominationSort(P(Start:Ind,end-M+1:end),M);
p4 = p4(p4(:,end-1) == 1,1:end-2);
Start = Ind+1;
Ind = Ind + floor(size(P,1)/5);
disp('4 of 5 sorted...');
[p5, ~] = NonDominationSort(P(Start:Ind+Remainder,end-M+1:end),M);
p5 = p5(p5(:,end-1) == 1,1:end-2);
disp('5 of 5 sorted...');

R = p1;
R(size(R,1)+1:size(R,1)+size(p2,1),:) = p2;
R(size(R,1)+1:size(R,1)+size(p3,1),:) = p3;
R(size(R,1)+1:size(R,1)+size(p4,1),:) = p4;
R(size(R,1)+1:size(R,1)+size(p5,1),:) = p5;

%% Next three parts...
Ind = floor(size(R,1)/3);
Remainder = mod(size(R,1),3);
Start = 1;

[p1, ~] = NonDominationSort(R(Start:Ind,end-M+1:end),M);
p1 = p1(p1(:,end-1) == 1,1:end-2);
Start = Ind+1;
Ind = Ind + floor(size(R,1)/3);
disp('1 of 3 sorted...');
[p2, ~] = NonDominationSort(R(Start:Ind,end-M+1:end),M);
p2 = p2(p2(:,end-1) == 1,1:end-2);
Start = Ind+1;
Ind = Ind + floor(size(R,1)/3);
disp('2 of 3 sorted...');  
[p3, ~] = NonDominationSort(R(Start:Ind+Remainder,end-M+1:end),M);
p3 = p3(p3(:,end-1) == 1,1:end-2);
disp('3 of 3 sorted...');
X = p1;
X(size(X,1)+1:size(X,1)+size(p2,1),:) = p2;
X(size(X,1)+1:size(X,1)+size(p3,1),:) = p3;

[X, ~] = NonDominationSort(X(:,end-M+1:end),M);
X = X(X(:,end-1) == 1,1:end-2);
disp('done...');
f = X;

end

%Problem 7.1
Noofvariables = 3;
C=[0.5 0.6 0];
Info = [1/60 2/60 0 ; 5/60 4/60 0 ; 3/60 1/60 0];
b = [14;40;15];

s= eye(size(Info,1));
A=[Info s b];

cost = zeros(1,size(A,2));
cost(1:Noofvariables) = C;

%%% CONSTRAINT BV
BV = Noofvariables+1:1:size(A,2)-1;

%%% Calculate Zj-Cj row
ZjCj=cost(BV)*A-cost;

%%% For Print Table

ZCj = [ZjCj; A];
SimpTable= array2table (ZCj);
 
SimpTable.Properties. VariableNames (1:size (ZCj, 2)) = {'x_1','x_2', 'x_3', 's_1','s_2', 's_3', 'Sol'}

%%%%%%%%% SIMPLEX TABLE START

RUN=true;
while RUN

if any (ZjCj<0);     % check if any negative value there


fprintf('      The Current BFS is NOT optimal      \n')

fprintf("\n====== THE NEXT ITERATION RESULTS=======\n")

disp('OLD Basic Variable (BV) = ');

disp (BV);

%%% FINDING THE ENTERING VARIABLE
ZC=ZjCj (1:end-1);
[EnterCol, pvt_col]= min(ZC);
fprintf(' The Minimum Element in Zj-Cj row is %d Corresponding to column %d \n', EnterCol, pvt_col);
fprintf(' ENTERING VARIABLE is %d \n', pvt_col);

%%% FINDING THE LEAVING VARIABLE

       sol = A(:,end);
       Column = A(:,pvt_col);
    if all(Column<=0)
        error('LPP is UNBOUNDED. ALL entries <=0 in column %d',pvt_col);
    else
        
        for i=1:size(A,1)
            if Column(i)>0
                ratio(i) = sol(i)./Column(i);
            else
                ratio(i)=inf;
            end
        end

%%% FINDING THE MINIMUM
[MinRatio, pvt_row]=min (ratio);
fprintf('Minimum Ratio corresponding to PIVOT Row is %d \n', pvt_row); 
fprintf(' LEAVING variable is %d \n', BV (pvt_row));

end

BV(pvt_row)=pvt_col;
disp('New Basic Variable (BV) =');
disp(BV);


%%% PIVOT KEY
pvt_key = A (pvt_row,pvt_col);

%%% UPDATE THE TABLE FOR NEXT ITERATION
A(pvt_row,:) = A (pvt_row, :)./pvt_key;
for i=1:size (A, 1)
    if i~=pvt_row
        A(i,:)=A(i, :)-A(i,pvt_col).*A(pvt_row, :);
    end
end
ZjCj = ZjCj - ZjCj(pvt_col).*A (pvt_row, :);

%%% For printing purpose
ZCj =[ZjCj;A];
TABLE= array2table (ZCj);
TABLE.Properties. VariableNames (1:size (ZCj, 2)) = {'x_1','x_2', 'x 3', 's_1','s_2', 's_3', 'Sol'}


BFS = zeros (1, size (A, 2));
BFS (BV) = A(:, end);
BFS (end) = sum (BFS.*cost);
Current_BFS= array2table (BFS);
Current_BFS.Properties.VariableNames(1:size (Current_BFS, 2)) = {'x_1','x_2', 'x_3', 's_1','s_2', 's_3', 'Sol'}

else
    RUN=false;
    fprintf('=======********************==========\n')
    fprintf('    The current BFS is Optimal\n')
    fprintf('========******************==========\n')
end


end

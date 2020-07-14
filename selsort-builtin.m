%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Program description: Demonstrate Matlab builtin sort
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Reading...\n');
fid = fopen('200000nums');

list=fscanf(fid, '%d');
list_size=list(1);
fclose(fid);

fprintf('Sorting...\n');
tic
list = sort(list);
toc

for c = 1:list_size
    fprintf('%d\n', list(c));
end

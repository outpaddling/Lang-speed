%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Program description: Selection sort
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

arg_list = argv();
fprintf('Reading %s...\n', arg_list{1});
fid = fopen(arg_list{1});

list=fscanf(fid, '%d');
list_size=list(1);
list=list(2:list_size+1);
fclose(fid);

fprintf('Sorting...\n');
tic
for start = 1:list_size
    % Find lowest
    [junk,low] = min(list(start:list_size));
    low = low + start - 1;
    
    % Swap with first
    temp = list(low);
    list(low) = list(start);
    list(start) = temp;
end
toc

for c = 1:list_size
    fprintf('%d\n', list(c));
end
exit

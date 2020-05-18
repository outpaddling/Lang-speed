%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Program description:
%   Usage:
%   History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Reading...\n');
fid = fopen('100000nums');
#list_size = fscanf(fid, '%d')
#fprintf('%d\n', list_size);
#exit
#for c = 1:list_size
#    list(c) = fscanf(fid, '%d');
#end
list=fscanf(fid, '%d');
list_size=list(1);
fclose(fid);

%for c = 1:list_size
%    fprintf('%d\n', list(c));
%end

fprintf('Sorting...\n');
tic
list = sort(list);
toc

for c = 1:list_size
    % fprintf('%d\n', list(c));
end


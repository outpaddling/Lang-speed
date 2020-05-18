%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Program description: Selection sort
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

arg_list = argv();
fprintf('Reading %s...\n', arg_list{1});
fid = fopen(arg_list{1});

list=fscanf(fid, '%d');
list_size=list(1);
fclose(fid);

fprintf('Sorting...\n');
tic
for start = 1:list_size
    % Find lowest
    low = start;
    for c = start+1:list_size
	if ( list(c) < list(low) )
	    low = c;
	end
    end
    
    % Swap with first
    temp = list(low);
    list(low) = list(start);
    list(start) = temp;
end
toc

for c = 1:list_size
    fprintf('%d\n', list(c));
end

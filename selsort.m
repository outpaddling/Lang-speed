%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Program description:
%   Usage:
%   History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

arg_list = argv();
fprintf('Reading %s...\n', arg_list{1});
fid = fopen(arg_list{1});
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
for start = 1:list_size
    % fprintf('%d\n', list(start));
    
    % Find lowest
    low = start;
    %if ( mod(start,1000) == 0 )
    %    fprintf('%d\n', start);
    %end
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
    % fprintf('%d\n', list(c));
end


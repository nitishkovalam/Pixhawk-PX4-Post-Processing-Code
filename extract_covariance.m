function cov = extract_sensorcomb
global folder n s2 
s1 = folder;
s3 = 'log001_estimator_status_0.csv';
%%
for i = 1:n
%s2 = strcat('P',num2str(i),'\'); 



%% Initialize variables.
filename = strcat(s1,s2{i},s3);
delimiter = ',';
startRow = 2;

%% Format string for each line of text:
formatSpec = '%f%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
raw_data{i} = [dataArray{1:end-1}];

cov{i} = [raw_data{i}(:,1:11) ];%raw_data{i}(:,2) raw_data{i}(:,3) raw_data{i}(:,4) raw_data{i}(:,5) ]; 

%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

end

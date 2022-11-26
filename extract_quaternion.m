function quaternion = extract_quaternion
global folder n s2;
s1 = folder;
s3 = 'log001_vehicle_attitude_0.csv';
%%
for i = 1:n
%s2 = strcat('P',num2str(i),'\'); 



%% Initialize variables.
filename = strcat(s1,s2{i},s3);
delimiter = ',';
startRow = 2;

%% Format string for each line of text:
formatSpec = '%f%f%f%f%f%*s%*s%*s%*s%*s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.

dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Create output variable
quaternion{i} = [dataArray{1:end-1}];
%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

end
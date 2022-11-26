function gps_data = extract_gps

global folder n s2 ;
s1 = folder;
s3 = 'log001_vehicle_gps_position_0.csv';
%%
for i = 1:n
%s2 = strcat('P',num2str(i),'\');

%% Initialize variables.
filename = strcat(s1,s2{i},s3);
delimiter = ',';
startRow = 3000;

%% Format string for each line of text:
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Create output variable
raw_data{i} = [dataArray{1:end-1}];
gps_data{i} = [raw_data{i}(:,1) raw_data{i}(:,2) raw_data{i}(:,11) raw_data{i}(:,12) raw_data{i}(:,16) raw_data{i}(:,17) raw_data{i}(:,18) raw_data{i}(:,25) raw_data{i}(:,18) raw_data{i}(:,5) raw_data{i}(:,6)];
%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

end
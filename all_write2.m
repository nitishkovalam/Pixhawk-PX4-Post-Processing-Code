function allwrite2(global_data_utc,sensorcomb_utc,quaternion_utc,gps_data,local_position_utc,input_datenum,filtered_rates_utc,sortienumber,stop_datenum)
global n s4
s3 = {'Helicopter','Underslung'};
%% Velocities
heli_temp_vel = interp1(gps_data{1}(:,2),[gps_data{1}(:,5) gps_data{1}(:,6) gps_data{1}(:,7)],gps_data{2}(:,2));
ris_gps_data = [ gps_data{2}(:,2) gps_data{2}(:,5) gps_data{2}(:,6) gps_data{2}(:,7)];
heli_gps_data =  [gps_data{2}(:,2) heli_temp_vel ];

start_index = find(datenum(datetime(gps_data{2}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>input_datenum,1);
end_index = find(datenum(datetime(gps_data{2}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>stop_datenum,1);
%     start_index1 = find(datenum(datetime(gps_data{3}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>input_datenum,1);
%         end_index1 = find(datenum(datetime(gps_data{3}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>stop_datenum,1);
           
 fid = fopen(['E:\EMT2\MeasuredData\S1\EMT2_S',num2str(sortienumber),'_Helicopter_Vel_R0.txt'],'w');
fprintf(fid,'%%  Time (s) \t Velocity North (m/s) \t Velocity East (m/s) \t Velocity Down (m/s) \n');
for j2 = 1:length(heli_gps_data(start_index:end_index,1))
fprintf(fid,'%8.2f %8.4f %8.4f %8.4f \n',...
    (heli_gps_data(start_index-1+j2,1)-heli_gps_data(start_index,1))*1e-6,heli_gps_data(start_index-1+j2,2),heli_gps_data(start_index-1+j2,3),...
    heli_gps_data(start_index-1+j2,4));
end

 fid = fopen(['E:\EMT2\MeasuredData\S1\EMT2_S',num2str(sortienumber),'_Underslung_Vel_R0.txt'],'w');
fprintf(fid,'%%  Time (s) \t Velocity North (m/s) \t Velocity East (m/s) \t Velocity Down (m/s) \n');
for j2 = 1:length(ris_gps_data(start_index:end_index,1))
fprintf(fid,'%8.2f %8.4f %8.4f %8.4f \n',...
    (ris_gps_data(start_index-1+j2,1)-ris_gps_data(start_index,1))*1e-6,ris_gps_data(start_index-1+j2,2),ris_gps_data(start_index-1+j2,3),...
    ris_gps_data(start_index-1+j2,4));
end

load 'E:\EMT2\MeasuredData\S1\EMT2_S2_Underslung_Vel_R0.txt'
load 'E:\EMT2\MeasuredData\S1\EMT2_S2_Helicopter_Vel_R0.txt'
% 
 figure(1)
 plot(EMT2_S2_Helicopter_Vel_R0(:,1),EMT2_S2_Helicopter_Vel_R0(:,2))
 grid on; hold on;
 plot(EMT2_S2_Underslung_Vel_R0(:,1),EMT2_S2_Underslung_Vel_R0(:,2))
%% Quaternions
heli_temp_quat = interp1(quaternion_utc{1}(:,1),[quaternion_utc{1}(:,2) quaternion_utc{1}(:,3) quaternion_utc{1}(:,4) quaternion_utc{1}(:,5) ],quaternion_utc{2}(:,1));
ris_quat_data = [ quaternion_utc{2}(:,1) quaternion_utc{2}(:,2) quaternion_utc{2}(:,3) quaternion_utc{2}(:,4) quaternion_utc{2}(:,5)];
heli_quat_data = [quaternion_utc{2}(:,1) heli_temp_quat ];

start_index = find(datenum(datetime(quaternion_utc{2}(:,1)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>input_datenum,1);
end_index = find(datenum(datetime(quaternion_utc{2}(:,1)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>stop_datenum,1);
%     start_index1 = find(datenum(datetime(gps_data{3}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>input_datenum,1);
%         end_index1 = find(datenum(datetime(gps_data{3}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>stop_datenum,1);
           
 fid = fopen(['E:\EMT2\MeasuredData\S1\EMT2_S',num2str(sortienumber),'_Helicopter_Quat_R0.txt'],'w');
fprintf(fid,'%%  Time (s) \t Q0 \t Q1 \t Q2 \t Q3 \n');
for j2 = 1:length(heli_quat_data(start_index:end_index,1))
fprintf(fid,'%8.4f %8.4f %8.4f %8.4f %8.4f \n',...
    (heli_quat_data(start_index-1+j2,1)-heli_quat_data(start_index,1))*1e-6,heli_quat_data(start_index-1+j2,2),heli_quat_data(start_index-1+j2,3),...
    heli_quat_data(start_index-1+j2,4),heli_quat_data(start_index-1+j2,5));
end

 fid = fopen(['E:\EMT2\MeasuredData\S1\EMT2_S',num2str(sortienumber),'_Underslung_Quat_R0.txt'],'w');
fprintf(fid,'%%  Time (s) \t Q0 \t Q1 \t Q2 \t Q3 \n');
for j2 = 1:length(ris_quat_data(start_index:end_index,1))
fprintf(fid,'%8.4f %8.4f %8.4f %8.4f %8.4f \n',...
    (ris_quat_data(start_index-1+j2,1)-ris_quat_data(start_index,1))*1e-6,ris_quat_data(start_index-1+j2,2),ris_quat_data(start_index-1+j2,3),...
    ris_quat_data(start_index-1+j2,4),ris_quat_data(start_index-1+j2,5));
end

load 'E:\EMT2\MeasuredData\S1\EMT2_S2_Underslung_Quat_R0.txt'
load 'E:\EMT2\MeasuredData\S1\EMT2_S2_Helicopter_Quat_R0.txt'
% 
 figure(1)
 plot(EMT2_S2_Helicopter_Quat_R0(:,1),EMT2_S2_Helicopter_Quat_R0(:,2))
 grid on; hold on;
 plot(EMT2_S2_Underslung_Quat_R0(:,1),EMT2_S2_Underslung_Quat_R0(:,2))

%% Accelerations
heli_temp_acc = interp1(sensorcomb_utc{1}(:,1),[sensorcomb_utc{1}(:,5) sensorcomb_utc{1}(:,6) sensorcomb_utc{1}(:,7)],sensorcomb_utc{2}(:,1));
ris_acc_data = [ sensorcomb_utc{2}(:,1) sensorcomb_utc{2}(:,5) sensorcomb_utc{2}(:,6) sensorcomb_utc{2}(:,7)];
heli_acc_data =  [sensorcomb_utc{2}(:,1) heli_temp_acc ];

start_index = find(datenum(datetime(sensorcomb_utc{2}(:,1)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>input_datenum,1);
end_index = find(datenum(datetime(sensorcomb_utc{2}(:,1)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>stop_datenum,1);
%     start_index1 = find(datenum(datetime(gps_data{3}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>input_datenum,1);
%         end_index1 = find(datenum(datetime(gps_data{3}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>stop_datenum,1);
           
 fid = fopen(['E:\EMT2\MeasuredData\S1\EMT2_S',num2str(sortienumber),'_Helicopter_Acc_R0.txt'],'w');
fprintf(fid,'%%  Time (s) \t Acc X (m/s2) \t Acc Y (m/s2) \t Acc Z (m/s2) \n');
for j2 = 1:length(heli_acc_data(start_index:end_index,1))
fprintf(fid,'%8.3f %8.4f %8.4f %8.4f \n',...
    (heli_acc_data(start_index-1+j2,1)-heli_acc_data(start_index,1))*1e-6,heli_acc_data(start_index-1+j2,2),heli_acc_data(start_index-1+j2,3),...
    heli_acc_data(start_index-1+j2,4));
end

 fid = fopen(['E:\EMT2\MeasuredData\S1\EMT2_S',num2str(sortienumber),'_Underslung_Acc_R0.txt'],'w');
fprintf(fid,'%%  Time (s) \t Acc X (m/s2) \t Acc Y (m/s2) \t Acc Z (m/s2) \n');
for j2 = 1:length(ris_acc_data(start_index:end_index,1))
fprintf(fid,'%8.3f %8.4f %8.4f %8.4f \n',...
    (ris_acc_data(start_index-1+j2,1)-ris_acc_data(start_index,1))*1e-6,ris_acc_data(start_index-1+j2,2),ris_acc_data(start_index-1+j2,3),...
    ris_acc_data(start_index-1+j2,4));
end

load 'E:\EMT2\MeasuredData\S1\EMT2_S2_Underslung_Acc_R0.txt'
load 'E:\EMT2\MeasuredData\S1\EMT2_S2_Helicopter_Acc_R0.txt'
% 
 figure(1)
 plot(EMT2_S2_Helicopter_Acc_R0(:,1),EMT2_S2_Helicopter_Acc_R0(:,3))
 grid on; hold on;
 plot(EMT2_S2_Underslung_Acc_R0(:,1),EMT2_S2_Underslung_Acc_R0(:,3))
 %% Rates
heli_temp_rate = interp1(filtered_rates_utc{1}(:,1),[filtered_rates_utc{1}(:,2) filtered_rates_utc{1}(:,3) filtered_rates_utc{1}(:,4)],filtered_rates_utc{2}(:,1));
ris_rate_data = [ filtered_rates_utc{2}(:,1) filtered_rates_utc{2}(:,2) filtered_rates_utc{2}(:,3) filtered_rates_utc{2}(:,4)];
heli_rate_data =  [filtered_rates_utc{2}(:,1) heli_temp_rate ];

start_index = find(datenum(datetime(filtered_rates_utc{2}(:,1)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>input_datenum,1);
end_index = find(datenum(datetime(filtered_rates_utc{2}(:,1)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>stop_datenum,1);
%     start_index1 = find(datenum(datetime(gps_data{3}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>input_datenum,1);
%         end_index1 = find(datenum(datetime(gps_data{3}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>stop_datenum,1);
           
 fid = fopen(['E:\EMT2\MeasuredData\S1\EMT2_S',num2str(sortienumber),'_Helicopter_Rates_R0.txt'],'w');
fprintf(fid,'%%  Time (s) \t Roll Rate (rad/s) \t Pitch Rate (rad/s) \t Yaw Rate (rad/s) \n');
for j2 = 1:length(heli_rate_data(start_index:end_index,1))
fprintf(fid,'%8.3f %8.4f %8.4f %8.4f \n',...
    (heli_rate_data(start_index-1+j2,1)-heli_rate_data(start_index,1))*1e-6,heli_rate_data(start_index-1+j2,2),heli_rate_data(start_index-1+j2,3),...
    heli_rate_data(start_index-1+j2,4));
end

 fid = fopen(['E:\EMT2\MeasuredData\S1\EMT2_S',num2str(sortienumber),'_Underslung_Rates_R0.txt'],'w');
fprintf(fid,'%%  Time (s) \t Roll Rate (rad/s) \t Pitch Rate (rad/s) \t Yaw Rate (rad/s) \n');
for j2 = 1:length(ris_rate_data(start_index:end_index,1))
fprintf(fid,'%8.3f %8.4f %8.4f %8.4f \n',...
    (ris_rate_data(start_index-1+j2,1)-ris_rate_data(start_index,1))*1e-6,ris_rate_data(start_index-1+j2,2),ris_rate_data(start_index-1+j2,3),...
    ris_rate_data(start_index-1+j2,4));
end

load 'E:\EMT2\MeasuredData\S1\EMT2_S2_Underslung_Rates_R0.txt'
load 'E:\EMT2\MeasuredData\S1\EMT2_S2_Helicopter_Rates_R0.txt'
% 
 figure(1)
 plot(EMT2_S2_Helicopter_Rates_R0(:,1),EMT2_S2_Helicopter_Rates_R0(:,4))
 grid on; hold on;
 plot(EMT2_S2_Underslung_Rates_R0(:,1),EMT2_S2_Underslung_Rates_R0(:,4))
%% Position
heli_temp_pos = interp1(global_data_utc{1}(:,1),[global_data_utc{1}(:,2) global_data_utc{1}(:,3) global_data_utc{1}(:,4)],global_data_utc{2}(:,1));
ris_pos_data = [ global_data_utc{2}(:,1) global_data_utc{2}(:,2) global_data_utc{2}(:,3) global_data_utc{2}(:,4)];
heli_pos_data =  [global_data_utc{2}(:,1) heli_temp_pos ];

start_index = find(datenum(datetime(global_data_utc{2}(:,1)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>input_datenum,1);
end_index = find(datenum(datetime(global_data_utc{2}(:,1)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>stop_datenum,1);
%     start_index1 = find(datenum(datetime(gps_data{3}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>input_datenum,1);
%         end_index1 = find(datenum(datetime(gps_data{3}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>stop_datenum,1);
           
 fid = fopen(['E:\EMT2\MeasuredData\S1\EMT2_S',num2str(sortienumber),'_Helicopter_Position_R0.txt'],'w');
fprintf(fid,'%%  Time (s) \t Latitude \t Longitude \t MSL Altitude (m) \n');
for j2 = 1:length(heli_pos_data(start_index:end_index,1))
fprintf(fid,'%8.3f %8.4f %8.4f %8.4f \n',...
    (heli_pos_data(start_index-1+j2,1)-heli_pos_data(start_index,1))*1e-6,heli_pos_data(start_index-1+j2,2),heli_pos_data(start_index-1+j2,3),...
    heli_pos_data(start_index-1+j2,4));
end

 fid = fopen(['E:\EMT2\MeasuredData\S1\EMT2_S',num2str(sortienumber),'_Underslung_Position_R0.txt'],'w');
fprintf(fid,'%%  Time (s) \t \t Latitude \t Longitude \t MSL Altitude (m) \n');
for j2 = 1:length(ris_pos_data(start_index:end_index,1))
fprintf(fid,'%8.3f %8.4f %8.4f %8.4f \n',...
    (ris_pos_data(start_index-1+j2,1)-ris_pos_data(start_index,1))*1e-6,ris_pos_data(start_index-1+j2,2),ris_pos_data(start_index-1+j2,3),...
    ris_pos_data(start_index-1+j2,4));
end

load 'E:\EMT2\MeasuredData\S1\EMT2_S2_Underslung_Position_R0.txt'
load 'E:\EMT2\MeasuredData\S1\EMT2_S2_Helicopter_Position_R0.txt'
% 
 figure(1)
 plot(EMT2_S2_Helicopter_Position_R0(:,1),EMT2_S2_Helicopter_Position_R0(:,4))
 grid on; hold on;
 plot(EMT2_S2_Underslung_Position_R0(:,1),EMT2_S2_Underslung_Position_R0(:,4))


function [ sensorcomb_utc,quaternion_utc,local_position_utc,filtered_rates_utc,global_data_utc,cov_utc] = interpolate_gps(sensorcomb,quaternion,gps_data,local_position,filtered_rates, global_data,cov)

global n
sensorcomb_utc = sensorcomb;
quaternion_utc = quaternion;
local_position_utc = local_position;
filtered_rates_utc = filtered_rates;
global_data_utc = global_data;
cov_utc = cov ;
%mag_utc = mag;
% accel_temp_utc = accel_temp ;
% baro_temp_utc = baro_temp;
% gyro_temp_utc = gyro_temp;
% mag_temp_utc = mag_temp;

   for i = 1:n   
    sensorcomb_utc{i}(:,1) = interp1(gps_data{i}(:,1),gps_data{i}(:,2),sensorcomb{i}(:,1),'linear','extrap');
    quaternion_utc{i}(:,1) = interp1(gps_data{i}(:,1),gps_data{i}(:,2),quaternion{i}(:,1),'linear','extrap');
    local_position_utc{i}(:,1) = interp1(gps_data{i}(:,1),gps_data{i}(:,2),local_position{i}(:,1),'linear','extrap');
    filtered_rates_utc{i}(:,1) = interp1(gps_data{i}(:,1),gps_data{i}(:,2),filtered_rates{i}(:,1),'linear','extrap');
    cov_utc{i}(:,1) = interp1(gps_data{i}(:,1),gps_data{i}(:,2),cov{i}(:,1),'linear','extrap');
   % mag_utc{i}(:,1) =  interp1(gps_data{i}(:,1),gps_data{i}(:,2),mag{i}(:,1),'linear','extrap');
%     accel_temp_utc{i}(:,1) = interp1(gps_data{i}(:,1),gps_data{i}(:,2),accel_temp{i}(:,1),'linear','extrap');
%     baro_temp_utc{i}(:,1) = interp1(gps_data{i}(:,1),gps_data{i}(:,2),baro_temp{i}(:,1),'linear','extrap');
%     gyro_temp_utc{i}(:,1) = interp1(gps_data{i}(:,1),gps_data{i}(:,2),gyro_temp{i}(:,1),'linear','extrap');
%     mag_temp_utc{i}(:,1) = interp1(gps_data{i}(:,1),gps_data{i}(:,2),mag_temp{i}(:,1),'linear','extrap');

   end
 for i = 1:n
      global_data_utc{i}(:,1) = interp1(gps_data{i}(:,1),gps_data{i}(:,2),global_data_utc{i}(:,1),'linear','extrap');
 end
 
end
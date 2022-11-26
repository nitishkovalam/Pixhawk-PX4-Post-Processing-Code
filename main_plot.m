tic
clc;
clear all;
close all;

set(0,'DefaultLineLineWidth', 2)
set(0,'DefaultaxesLineWidth', 0.5)
set(0,'DefaultaxesFontSize', 14)
set(0,'DefaultTextFontSize', 14)
set(0,'DefaultaxesFontName', 'arial')

sortienumber = 2;
global folder n s2 s4 heliparams

s2 = {''};
s4 = {''};
n=2;
folder = '';
%%
sensorcomb = extract_sensorcomb;
quaternion = extract_quaternion;
gps_data   = extract_gps;
local_position = extract_local_position;
filtered_rates = extract_rates;
global_data = extract_global_pos;
cov = extract_covariance;
%mag = extract_mag;
%[accel_temp baro_temp gyro_temp mag_temp] = extract_temp;



% GPS Output
% 1)Timestamp (raw) - in seconds
% 2)Timestamp (UTC) close-in seconds
% 3) HDOP
% 4) VDOP
% 5) Velocity North - in m/s
% 6) Velocity East  - in m/s
% 7) Velocity Down  - in m/s
% 8) No. of Satellites 
% 5 hz

%%Global Position file
%1) Timestamp (Raw)
%2) Lat
%3) Lon
%4) Alt
%7) Ve

% Sensor Combined Output 
% 1) Timestamp (raw) - in seconds
% 2,3,4) Roll,Pitch,Yaw Rates in radians/s 
% 5,6,7) X,Y,Z Accelerations in m/s^2 
% 250 Hz

% Quaternion Output 
% 1) Timestamp (raw) - in seconds
% 2,3,4,5) Components of Quaternion
% Sampling 20 Hz

% Local Position Output
% 1) Timestamp (Raw) - seconds
% 2,3) Lat Long - regular in decimals
% 4) 5) 6) x y z - in metres
% 7) Yaw angle - in radians
% 10 Hz 

% Filtered Rates
% 1) Timestamp(Raw) in seconds
% 2) 3) 4) Roll Rate, Pitch Rate, Yaw Rate in radian/sec
% 40 Hz


%Covariance 
% 1) Timestamp(Raw) in seconds
% 2) Q0,Q1,Q2,Q3 
% 3) Vn Ve Vd
% 4) Pn Pe Pd
%[ sensorcomb_utc , quaternion_utc, local_position_utc,filtered_rates_utc, global_data_utc, accel_temp_utc,baro_temp_utc, gyro_temp_utc, mag_temp_utc ] = interpolate_gps(sensorcomb,quaternion,gps_data,local_position,filtered_rates, global_data, accel_temp, baro_temp, gyro_temp, mag_temp);
[ sensorcomb_utc , quaternion_utc, local_position_utc,filtered_rates_utc, global_data_utc,cov_utc] = interpolate_gps(sensorcomb,quaternion,gps_data,local_position,filtered_rates, global_data,cov);


% x2 = gps_data{3}(:,2);
% sensorcomb_utc{1}(:,3) = -sensorcomb_utc{1}(:,3);
% sensorcomb_utc{1}(:,4) = -sensorcomb_utc{1}(:,4);
% sensorcomb_utc{1}(:,6) = -sensorcomb_utc{1}(:,6);
% sensorcomb_utc{1}(:,7) = -sensorcomb_utc{1}(:,7);

%load 'wind_26092021_0803.mat'
load 'wind_27092021_0737.mat'
%load 'wind_27092021_0530.mat'
 %load 'temp_data_sortie4.mat'
%load 'load_data_sortie4.mat'
%time1 = time1+182;

%% To Calculate Data Missing
% for i =1:n
%    for j = 1:length(gps_data{i}(:,1)) - 1
%       out{i}(j) = (gps_data{i}(j+1,1)-gps_data{i}(j,1))*(1e-6);
%       idenum = ((gps_data{i}(end,2)- gps_data{i}(1,2))*(1e-6))/(0.2);
%       actnum = length(gps_data{i}(:,1));
%       per{i} = (actnum./idenum)*100; 
%    end
% end

%%
% n = 2 ;
Ve = griddedInterpolant(wind(:,1),1*wind(:,2),'linear'); % Zonal Component
Vn = griddedInterpolant(wind(:,1),1*wind(:,3),'linear') ; % Meridional Component
dens = griddedInterpolant(wind(:,1),wind(:,5),'linear') ; % Density
tempi = griddedInterpolant(wind(:,1),wind(:,4),'linear') ; % Temperature
%alt = griddedInterpolant(local_position_utc{n}(:,1),-local_position_utc{n}(:,6),'linear');
alt = griddedInterpolant(gps_data{n}(:,2),(gps_data{n}(:,10)*1e-3)-611,'linear');
iq1 =  griddedInterpolant(quaternion_utc{n}(:,1),quaternion_utc{n}(:,2),'linear');
iq2 =  griddedInterpolant(quaternion_utc{n}(:,1),quaternion_utc{n}(:,3),'linear');
iq3 =  griddedInterpolant(quaternion_utc{n}(:,1),quaternion_utc{n}(:,4),'linear');
iq4 =  griddedInterpolant(quaternion_utc{n}(:,1),quaternion_utc{n}(:,5),'linear');


for i = 1:length(gps_data{n}(:,2))
   vn_rel(i) =   gps_data{n}(i,5) - Vn(alt(gps_data{n}(i,2))) ;    
   k1(i) = Vn(alt(gps_data{n}(i,2)));
   ve_rel(i) =   gps_data{n}(i,6) - Ve(alt(gps_data{n}(i,2))) ;
   k2(i) = Ve(alt(gps_data{n}(i,2)));
   tas(i) = sqrt(vn_rel(i)^2+ve_rel(i)^2+gps_data{n}(i,7)^2);
   d(i) = dens(alt(gps_data{n}(i,2)));
   ias(i) = tas(i)/(sqrt(1.225/d(i)))   ;
   vtot(i) = sqrt(gps_data{n}(i,5)^2+gps_data{n}(i,6)^2+gps_data{n}(i,7)^2);
   
   v = quat2dcm([iq1(gps_data{n}(i,2)) iq2(gps_data{n}(i,2)) iq3(gps_data{n}(i,2)) iq4(gps_data{n}(i,2))])*[vn_rel(i) ; ve_rel(i) ; gps_data{n}(i,7)];
  %v = eye(3)*[vn_rel(i) ; ve_rel(i) ; gps_data{n}(i,7)];
 
   vx(i) = v(1);
   vy(i) = v(2);
   vz(i) = v(3);
   alpha(i) = atan2(vz(i),vx(i));
   %alpha(i) = atan(vz(i)/vx(i));
   beta(i) = atan(vy(i)/(sqrt(vx(i)^2 + vz(i)^2))); 
%    
% %     ang1 = quat2eul([iq1(gps_data{n}(i,2)) iq2(gps_data{n}(i,2)) iq3(gps_data{n}(i,2)) iq4(gps_data{n}(i,2))]);
% %     vtest = angle2dcm(ang1(1),ang1(2),ang1(3))*[vn_rel(i) ; ve_rel(i) ; gps_data{n}(i,7)];
% %    vx_t(i) = vtest(1);
% %    vy_t(i) = vtest(2);
% %    vz_t(i) = vtest(3);
% %    alphat(i) = atan(vz_t(i)/vx_t(i));
% %    betat(i) = atan(vy_t(i)/(sqrt(vx_t(i)^2 + vz_t(i)^2))); 
%    
%    
%    % without wind beta 
%    v_ww = quat2dcm([iq1(gps_data{n}(i,2)) iq2(gps_data{n}(i,2)) iq3(gps_data{n}(i,2)) iq4(gps_data{n}(i,2))])*[gps_data{n}(i,5) ;gps_data{n}(i,6) ; gps_data{n}(i,7)];
%    %v_ww = eye(3)*[gps_data{n}(i,5) ;gps_data{n}(i,6) ; gps_data{n}(i,7)];
%    vx_ww(i) = v_ww(1);
%    vy_ww(i) = v_ww(2);
%    vz_ww(i) = v_ww(3);
%    %alpha_ww(i) = atan2(vz_ww(i),vx_ww(i));
%    alpha_ww(i) = atan(vz_ww(i)/vx_ww(i));
%    beta_ww(i) = atan(vy_ww(i)/(sqrt(vx_ww(i)^2 + vz_ww(i)^2))); 
%    
%    
% % N(i) = Far.cn(alpha(i)*(180/pi),beta(i)*(180/pi))*0.5*d(i)*(tas(i)^2)*6;
%  %N2(i) = Fae.cn(alpha(i)*(180/pi),beta(i)*(180/pi))*0.5*d(i)*(tas(i)^2)*6;
%  % omegan = sqrt((Fa.cymbeta(alpha,beta)*d(i)*(tas(i)^2)*Fa.s_ref*Fa.b_ref)/(2*6596.88));
%    temp_f(i) = tempi(alt(gps_data{n}(i,2)));
%    dyna(i) = 0.5*d(i)*tas(i)*tas(i);
%    
 end



%%
input_t = datetime(2021,09,26,06,48,30);
%input_t = datetime(2020,01,30,07,20,20); % format = [Y,M,D,H,MI,S]; in IST
input_t.TimeZone = 'Asia/Kolkata'  ;   %Sortie 1 -  2021,09,26,06,48,30 - 2021,09,26,07,51,46
input_t_pos = posixtime(input_t);      % Sortie 2 - 2021,09,27,06,26,30 - 2021,09,27,07,25,11
input_datenum = datenum(input_t);       % Sortie 3 - 2021,09,27,09,21,30 - 2021,09,27,09,44,30
                                      %Sortie 4 - 2021,09,27,11,58,40-  %2021,09,27,12,37,15
                                        %08:03: 48
                                           % Use 08 03 for adams
%stop_t = datetime(2021,09,23,07,27,00);     % format = [Y,M,D,H,MI,S]; in IST
stop_t = datetime(2021,09,26,07,51,46);
stop_t.TimeZone = 'Asia/Kolkata' ;
stop_t_pos = posixtime(stop_t);  
stop_datenum = datenum(stop_t);


stop_datenum;
%  
%  
%  
%  %input_t_pos - (sensorcomb_utc{2}(1,1)/1e6)
% % T1 = datetime(sensorcomb_utc{2}(1,1)/1e6,'ConvertFrom','posixtime')
%  T2 = datetime(sensorcomb_utc{2}(1,1)/1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata');

 
%%
%   input_utc = input_datenum;
%   input_utc_end = stop_t_pos;
 % all_write2(global_data_utc,sensorcomb_utc,quaternion_utc,gps_data,local_position_utc,input_datenum,filtered_rates_utc,sortienumber,stop_datenum)
%% Plot Airdata
  airdata_plots(gps_data,input_datenum, stop_datenum,tas,alpha,beta)
%% 
for i = 1:n
    sensorcomb_utc{i}(:,1) = datenum(datetime(sensorcomb_utc{i}(:,1)/1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'));   
    quaternion_utc{i}(:,1) =  datenum(datetime(quaternion_utc{i}(:,1)/1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'));
    local_position_utc{i}(:,1) = datenum(datetime(local_position_utc{i}(:,1)/1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'));
    filtered_rates_utc{i}(:,1) = datenum(datetime(filtered_rates_utc{i}(:,1)/1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'));
end

for i=1:n
    global_data_utc{i}(:,1) = datenum(datetime(global_data_utc{i}(:,1)/1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'));
end
%

all_plot(sensorcomb_utc,quaternion_utc,gps_data,local_position_utc,input_datenum,filtered_rates_utc,global_data_utc, stop_datenum)


%[alp,bet,betd,ias,tas] = extract_airdata(wind,local_position_utc,quaternion_utc,gps_data,input_datenum,stop_datenum);

   
%%
ppt_creator();





toc

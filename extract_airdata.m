function [alp,bet,betdot,ias,tas] = extract_airdata(wind,local_position_utc,quaternion_utc,gps_data,input_datenum,stop_datenum)
global n 
for n = 2:3

Ve = griddedInterpolant(wind(:,1),wind(:,2),'linear') ; % Zonal Component
Vn = griddedInterpolant(wind(:,1),wind(:,3),'linear') ; % Meridional Component
dens = griddedInterpolant(wind(:,1),wind(:,5),'linear') ; % Density
tempi = griddedInterpolant(wind(:,1),wind(:,4),'linear') ; % Temperature
alt = griddedInterpolant(local_position_utc{n}(:,1),-local_position_utc{n}(:,6),'linear');
iq1 =  griddedInterpolant(quaternion_utc{n}(:,1),quaternion_utc{n}(:,2),'linear');
iq2 =  griddedInterpolant(quaternion_utc{n}(:,1),quaternion_utc{n}(:,3),'linear');
iq3 =  griddedInterpolant(quaternion_utc{n}(:,1),quaternion_utc{n}(:,4),'linear');
iq4 =  griddedInterpolant(quaternion_utc{n}(:,1),quaternion_utc{n}(:,5),'linear');


for i = 1:length(gps_data{n}(:,2))
   vn_rel(i) =   gps_data{n}(i,5) - Vn(alt(gps_data{n}(i,2))) ;    
   k1(i) = Vn(alt(gps_data{n}(i,2)));
   ve_rel(i) =   gps_data{n}(i,6) - Ve(alt(gps_data{n}(i,2))) ;
   k2(i) = Ve(alt(gps_data{n}(i,2)));
   tas{n}(i) = sqrt(vn_rel(i)^2+ve_rel(i)^2+gps_data{n}(i,7)^2);
   d(i) = dens(alt(gps_data{n}(i,2)));
   ias{n}(i) = tas{n}(i)/(sqrt(1.225/d(i)));
   vtot(i) = sqrt(gps_data{n}(i,5)^2+gps_data{n}(i,6)^2+gps_data{n}(i,7)^2);
   
   v = quat2dcm([iq1(gps_data{n}(i,2)) iq2(gps_data{n}(i,2)) iq3(gps_data{n}(i,2)) iq4(gps_data{n}(i,2))])*[vn_rel(i) ; ve_rel(i) ; gps_data{n}(i,7)];
  %v = eye(3)*[vn_rel(i) ; ve_rel(i) ; gps_data{n}(i,7)];
   vx(i) = v(1);
   vy(i) = v(2);
   vz(i) = v(3);
 %  alpha(i) = atan2(vz(i),vx(i));
   alp{n}(i) = atan(vz(i)/vx(i));
   bet{n}(i) = atan(vy(i)/(sqrt(vx(i)^2 + vz(i)^2))); 
   betdot{n} = diff(bet{n});
   
   
end
figure(1)
 start_index = find(datenum(datetime(gps_data{n}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>input_datenum,1);
        end_index = find(datenum(datetime(gps_data{n}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>stop_datenum,1);
        plot(datetime(gps_data{n}(start_index:end_index,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'),tas{n}(start_index:end_index),'linewidth',2);
        hold on;
        grid on;
         xlabel('Time (s)','FontSize',17,'FontWeight','b')
 

figure(2)
 start_index = find(datenum(datetime(gps_data{n}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>input_datenum,1);
        end_index = find(datenum(datetime(gps_data{n}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>stop_datenum,1);
        plot(datetime(gps_data{n}(start_index:end_index,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'),ias{n}(start_index:end_index),'linewidth',2);
        hold on;
        grid on;
         xlabel('Time (s)','FontSize',17,'FontWeight','b')


figure(3)
 start_index = find(datenum(datetime(gps_data{n}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>input_datenum,1);
        end_index = find(datenum(datetime(gps_data{n}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>stop_datenum,1);
        plot(datetime(gps_data{n}(start_index:end_index,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'),alp{n}(start_index:end_index)*(180/pi),'linewidth',2);
        hold on;
        
        grid on;
         xlabel('Time (s)','FontSize',17,'FontWeight','b')
        

figure(4)
 start_index = find(datenum(datetime(gps_data{n}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>input_datenum,1);
        end_index = find(datenum(datetime(gps_data{n}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>stop_datenum,1);
        plot(datetime(gps_data{n}(start_index:end_index,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'),bet{n}(start_index:end_index)*(180/pi),'linewidth',2);
        hold on;
        grid on;
         xlabel('Time (s)','FontSize',17,'FontWeight','b')
         
         
 figure(5)
 start_index = find(datenum(datetime(gps_data{n}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>input_datenum,1);
        end_index = find(datenum(datetime(gps_data{n}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>stop_datenum,1);
        plot(datetime(gps_data{n}(start_index:end_index,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'),betdot{n}(start_index:end_index)*(180/pi),'linewidth',2);
        hold on;
        grid on;
         xlabel('Time (s)','FontSize',17,'FontWeight','b')
%     figure(6)
%  start_index = find(datenum(datetime(gps_data{n}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>input_datenum,1);
%  end_index = find(datenum(datetime(gps_data{n}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>stop_datenum,1);        
%  plot(bet{2}(start_index:end_index)*(180/pi),betdot{2}(start_index:end_index)*(180/pi),'linewidth',2);    
end

figure(1)
legend('RIS','RLV')
ylabel('True Air Speed','FontSize',17,'FontWeight','b')
figure(2)
legend('RIS','RLV')
 ylabel('Indicated Air Speed','FontSize',17,'FontWeight','b')
figure(3)
legend('RIS','RLV')
 ylabel('Angle of Attack \alpha (in deg)','FontSize',17,'FontWeight','b')
figure(4)
legend('RIS','RLV')
 ylabel('Angle of Sideslip \beta (in deg)','FontSize',17,'FontWeight','b') 
 figure(5)
legend('RIS','RLV')
 ylabel(' Beta dot','FontSize',17,'FontWeight','b') 
%  figure(6)
%  ylabel(' \beta ','FontSize',17,'FontWeight','b') 
%   ylabel(' Beta dot','FontSize',17,'FontWeight','b') 
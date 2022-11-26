function  all_plot(sensorcomb_utc,quaternion_utc,gps_data,local_position_utc,input_datenum,filtered_rates_utc,global_data_utc, stop_datenum)
global n heliparams slungparams

%% Plotting velocities in NED Frame

for kk = 1 : n
    for mm = 1:3
        fnew = figure(6+mm)
        start_index = find(datenum(datetime(gps_data{kk}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>input_datenum,1);
        end_index = find(datenum(datetime(gps_data{kk}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>stop_datenum,1);
        plot(datetime(gps_data{kk}(start_index:end_index,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'),gps_data{kk}(start_index:end_index,mm+4),'linewidth',2);
        hold on;
        grid on;
         xlabel('Time (s)','FontSize',17,'FontWeight','b')
        %legend('Helicopter','RIS',' RLV - Aft')
        legend('Helicopter','Underslung','Location','northwest')
        if mm==1 
         ylabel(' Velocity North (m/s)','FontSize',17,'FontWeight','b')
         elseif mm==2
             ylabel(' Velocity East (m/s)','FontSize',17,'FontWeight','b') 
         elseif mm==3
             ylabel(' Velocity Down (m/s)','FontSize',17,'FontWeight','b')
        end
%             pic_name = strcat('Velocity_',num2str(mm));
%         savefig(fnew,strcat(pic_name,'.fig'));
%         print(fnew,pic_name,'-dpng');
    end
end


    
%% Plotting the body attitudes

for kkk = 1:n
    start_index = find(quaternion_utc{kkk}(:,1)>input_datenum,1);
    end_index = find(quaternion_utc{kkk}(:,1)>stop_datenum,1);
        q = [ quaternion_utc{kkk}(start_index:end_index,2) quaternion_utc{kkk}(start_index:end_index,3) quaternion_utc{kkk}(start_index:end_index,4) quaternion_utc{kkk}(start_index:end_index,5)];
    [y, p ,r ] = quat2angle(q) ;
   
    y = y*(180/pi);
    p = p*(180/pi);
    r = r*(180/pi);
    
    %%rmid{n} = r;
    
    
    
    tsp{kkk} = [quaternion_utc{kkk}(start_index:end_index,1) y p r ];
   for j = 1:length(tsp{kkk}(:,1))
       if tsp{kkk}(j,2)<0 
            tsp{kkk}(j,2) = tsp{kkk}(j,2) + 360;
       end
   end
   
    for mmm = 1:3
        fnew = figure(9+mmm)
        plot(datetime(tsp{kkk}(:,1),'ConvertFrom','datenum','TimeZone','Asia/Kolkata'),tsp{kkk}(:,mmm+1),'linewidth',2);
         hold on;
        grid on;
         xlabel('Time (s)','FontSize',17,'FontWeight','b')
         if mmm==1
             ylabel(' Yaw Angle (in deg)','FontSize',17,'FontWeight','b')
 elseif mmm==2
     ylabel(' Pitch Angle (in deg)','FontSize',17,'FontWeight','b') 
 elseif mmm==3
     ylabel(' Roll Angle (in deg)','FontSize',17,'FontWeight','b')
    end
       %legend('Helicopter','RIS',' RLV - Aft')   
          legend('Helicopter','Underslung','Location','northwest')
       
%        pic_name = strcat('Euler_',num2str(mmm));
%         savefig(fnew,strcat(pic_name,'.fig'));
%         print(fnew,pic_name,'-dpng');
end

end
    

% for k = 1:n
%     for m=2:4
%         figure(19+m-1)
%         start_index = find(sensorcomb_utc{k}(:,1)>input_datenum,1);
% plot(datetime(sensorcomb_utc{k}(start_index:end,1),'ConvertFrom','datenum','TimeZone','Asia/Kolkata'),cumtrapz(sensorcomb_utc{k}(start_index:end,1),sensorcomb_utc{k}(start_index:end,m))*(180/pi),'linewidth',2)
% hold on;
%  grid on;
%   legend('P1','P2','P3','P4','P5')
%  xlabel('Time (s)','FontSize',17,'FontWeight','b')
%  if m==2 
%  ylabel(' Roll Angle (deg/s)','FontSize',17,'FontWeight','b')
%  elseif m==3
%      ylabel(' Pitch Pitch (deg/s)','FontSize',17,'FontWeight','b') 
%  elseif m==4
%      ylabel(' Yaw Angle (deg/s)','FontSize',17,'FontWeight','b')
%  
%     end
%  
%  
% end
% end

for kj = 1:n
   start_index = find(datenum(datetime(gps_data{kj}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>input_datenum,1);
    end_index = find(datenum(datetime(gps_data{kj}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>stop_datenum,1);    
    fnew=figure(25)
    plot(datetime(gps_data{kj}(start_index:end_index,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'),atan2d(gps_data{kj}(start_index:end_index,6),gps_data{kj}(start_index:end_index,5)),'linewidth',2);
    hold on;
        grid on;
         xlabel('Time (s)','FontSize',17,'FontWeight','b')
         ylabel('Heading')
   % legend('Helicopter','RIS',' RLV - Aft')
      legend('Helicopter','Underslung','Location','northwest')
%     pic_name = 'Heading';
%         savefig(fnew,strcat(pic_name,'.fig'));
%         print(fnew,pic_name,'-dpng');
    
    fnew = figure(267)
     plot(datetime(gps_data{kj}(start_index:end_index,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'),atan2d(-gps_data{kj}(start_index:end_index,7),(sqrt((gps_data{kj}(start_index:end_index,5)).^2+(gps_data{kj}(start_index:end_index,6)).^2))),'linewidth',2);
    hold on;
        grid on;
         xlabel('Time (s)','FontSize',17,'FontWeight','b')
         ylabel('Flight Path Angle')
   % legend('Helicopter','RIS',' RLV - Aft')
      legend('Helicopter','Underslung','Location','northwest')
%     pic_name = 'Flight Path Angle';
%         savefig(fnew,strcat(pic_name,'.fig'));
%         print(fnew,pic_name,'-dpng');
    % xlim([600 1120])
end


for h = 1:n
    start_index = find(local_position_utc{h}(:,1)>input_datenum,1);
    end_index = find(local_position_utc{h}(:,1)>stop_datenum,1);
    fnew=figure(30)
    plot(datetime(local_position_utc{h}(start_index:end_index,1),'ConvertFrom','datenum','TimeZone','Asia/Kolkata'),local_position_utc{h}(start_index:end_index,7)*(180/pi),'linewidth',2)
    hold on;
    grid on;
     xlabel('Time (s)','FontSize',17,'FontWeight','b')
      ylabel(' Yaw Angle (in deg)','FontSize',17,'FontWeight','b')
%       pic_name = 'Yaw Angle';
%         savefig(fnew,strcat(pic_name,'.fig'));
%         print(fnew,pic_name,'-dpng');
end
% 

 for hh = 1:n
     start_index = find(local_position_utc{hh}(:,1)>input_datenum,1);
     end_index = find(local_position_utc{hh}(:,1)>stop_datenum,1);
     fnew=figure(31)
      plot3(local_position_utc{hh}(start_index:end_index,5),local_position_utc{hh}(start_index:end_index,4),-local_position_utc{hh}(start_index:end_index,6),'linewidth',2)
      hold on;
    grid on;
    axis equal
xlabel('West-East (in m)','FontSize',17,'FontWeight','b')
      ylabel(' South-North (in m)','FontSize',17,'FontWeight','b')   
      zlabel(' Altitiude (in m)','FontSize',17,'FontWeight','b')
%       pic_name = 'Trajectory';
%         savefig(fnew,strcat(pic_name,'.fig'));
%         print(fnew,pic_name,'-dpng');
 end


 
for zz = 1:n
    start_index = find(local_position_utc{zz}(:,1)>input_datenum,1);
    end_index = find(local_position_utc{zz}(:,1)>stop_datenum,1);
    figure(32)
%     keyboard
     plot(local_position_utc{zz}(start_index:end_index,3),local_position_utc{zz}(start_index:end_index,2),'linewidth',2)
     hold on;
     grid on;
     
     
     
end

for zk = 1:n
         
     for nn=1:3
      fnew1 = figure(40+nn)
      
        start_index = find(filtered_rates_utc{zk}(:,1)>input_datenum,1);
        end_index = find(filtered_rates_utc{zk}(:,1)>stop_datenum,1);
plot(datetime(filtered_rates_utc{zk}(start_index:end_index,1),'ConvertFrom','datenum','TimeZone','Asia/Kolkata'),filtered_rates_utc{zk}(start_index:end_index,nn+1)*(180/pi),'linewidth',2)
hold on;
 grid on;
  %legend('Helicopter','RIS',' RLV - Aft')
     legend('Helicopter','Underslung','Location','northwest')
 xlabel('Time (s)','FontSize',17,'FontWeight','b')
 if nn==1 
 ylabel(' Roll Rate (deg/s)','FontSize',17,'FontWeight','b')
 elseif nn==2
     ylabel(' Pitch Rate (deg/s)','FontSize',17,'FontWeight','b') 
 elseif nn==3
     ylabel(' Yaw Rate(deg/s)','FontSize',17,'FontWeight','b')
 
 end
 
%  pic_name = strcat('Rate_',num2str(nn));
%         savefig(fnew1,strcat(pic_name,'.fig'));
%         print(fnew1,pic_name,'-dpng');
     end
end
     
% dat_ris = [global_data_utc{2}(:,2),global_data_utc{2}(:,3), global_data_utc{2}(:,4) ]
% dat_heli = [global_data_utc{1}(:,2),global_data_utc{1}(:,31), global_data_utc{1}(:,4) ]
% keyboard
for b = 1:n
    fnew=figure(350)
    %start_index = find(latlong_utc{b}(:,1)>input_datenum,1);
    plot(global_data_utc{b}(:,3),global_data_utc{b}(:,2),'linewidth',2)
    hold on;
    grid on;
  %legend('RIS',' RLV - Aft')
     legend('Helicopter','Underslung','Location','northwest')
   xlabel('Longitude','FontSize',17,'FontWeight','b')
    ylabel('Latitude','FontSize',17,'FontWeight','b')
axis equal
% pic_name = 'Lat_long';
%         savefig(fnew,strcat(pic_name,'.fig'));
%         print(fnew,pic_name,'-dpng');
end 




for zk = 1:n
         
     for nn=2:3
      fnew=figure(35+nn-2)
        start_index = find(global_data_utc{zk}(:,1)>input_datenum,1);
        end_index = find(global_data_utc{zk}(:,1)>stop_datenum,1);
plot(datetime(global_data_utc{zk}(start_index:end_index,1),'ConvertFrom','datenum','TimeZone','Asia/Kolkata'),global_data_utc{zk}(start_index:end_index,nn),'linewidth',2)
hold on;
 grid on;
  %legend('RIS',' RLV - Aft')
     legend('Helicopter','Underslung','Location','northwest')
 xlabel('Time (s)','FontSize',17,'FontWeight','b')
 if nn==2
 ylabel(' Latitude (deg)','FontSize',17,'FontWeight','b')
 elseif nn==3
     ylabel('Longitude (deg)','FontSize',17,'FontWeight','b') 
 
 end
%  pic_name = strcat('geodetic_',num2str(nn));
%         savefig(fnew,strcat(pic_name,'.fig'));
%         print(fnew,pic_name,'-dpng');
     end
end


for k = 1:n
      
     for m=8:10
        fnew=figure(50+m)
        start_index = find(local_position_utc{k}(:,1)>input_datenum,1);
        end_index = find(local_position_utc{k}(:,1)>stop_datenum,1);
plot(datetime(local_position_utc{k}(start_index:end_index,1),'ConvertFrom','datenum','TimeZone','Asia/Kolkata'),local_position_utc{k}(start_index:end_index,m),'linewidth',2)
hold on;
 grid on;
% legend('Helicopter','RIS',' RLV - Aft')
   legend('Helicopter','Underslung','Location','northwest')
 xlabel('Time (s)','FontSize',17,'FontWeight','b')
    if m==8
     ylabel(' Acc - X (m/s^{2})','FontSize',17,'FontWeight','b')
      elseif m==9
     ylabel(' Acc - Y (m/s^{2})','FontSize',17,'FontWeight','b')
      elseif m==10
     ylabel(' Acc - Z (m/s^{2})','FontSize',17,'FontWeight','b')
 
    end
%      pic_name = strcat('Acceleration_',num2str(m-7));
%         savefig(fnew,strcat(pic_name,'.fig'));
%         print(fnew,pic_name,'-dpng');
end

end

 for kk = 1:n
    
    start_index = find(local_position_utc{kk}(:,1)>input_datenum,1);
        end_index = find(local_position_utc{kk}(:,1)>stop_datenum,1);
        for m=4:6
            fnew=figure(65+m)
            if m == 4
        plot(datetime(local_position_utc{kk}(start_index:end_index,1),'ConvertFrom','datenum','TimeZone','Asia/Kolkata'),local_position_utc{kk}(start_index:end_index,m),'linewidth',2);
            elseif m == 5
        plot(datetime(local_position_utc{kk}(start_index:end_index,1),'ConvertFrom','datenum','TimeZone','Asia/Kolkata'),local_position_utc{kk}(start_index:end_index,m),'linewidth',2);
            elseif m ==6
        plot(datetime(local_position_utc{kk}(start_index:end_index,1),'ConvertFrom','datenum','TimeZone','Asia/Kolkata'),-local_position_utc{kk}(start_index:end_index,m),'linewidth',2);
            end
    hold on;
 grid on;
 %legend('Helicopter','RIS',' RLV - Aft')
    legend('Helicopter','Underslung','Location','northwest')
 xlabel('Time (s)','FontSize',17,'FontWeight','b')
    if m==4
     ylabel(' North (in m)','FontSize',17,'FontWeight','b')
      elseif m==5
     ylabel(' East (in m) ','FontSize',17,'FontWeight','b')
      elseif m==6
     ylabel(' Altitude (in m)','FontSize',17,'FontWeight','b') 
    end
%      pic_name = strcat('NED_',num2str(m-3));
%         savefig(fnew,strcat(pic_name,'.fig'));
%         print(fnew,pic_name,'-dpng');
        end
 end
 
 figure(80)
start_index = find(datenum(datetime(gps_data{1}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>input_datenum,1);
        end_index = find(datenum(datetime(gps_data{1}(:,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'))>stop_datenum,1);
        plot(datetime(gps_data{1}(start_index:end_index,2)./1e6,'ConvertFrom','posixtime','TimeZone','Asia/Kolkata'),sqrt(gps_data{1}(start_index:end_index,5).^2 +gps_data{1}(start_index:end_index,6).^2+gps_data{1}(start_index:end_index,7).^2),'linewidth',2);
        hold on;
        grid on;
         xlabel('Time (s)','FontSize',17,'FontWeight','b')
 
         
         
         
      
%close all


% ppt_creator();

 
clc
close all
grid_x = zeros(20,20);
grid_y = zeros(20,20);
for i=1:20
   for j=1:20
        grid_x(i,j) = 200*(i-1);
        grid_y(i,j) = 200*(j-1);
   end
end 

UE_count = 10;
gNB_count =1;
hold on
axis( [0 4000 0 4000] );

rng(7);
UE_Coord=rand(UE_count,2)*4000;

for i=1:UE_count
    plot(UE_Coord(i,1),UE_Coord(i,2),'b+')
end 

rng(3);
gNB_Coord=rand(gNB_count,2)*4000;
p=plot(gNB_Coord(1,1),gNB_Coord(1,2),'m*')
p(1).LineWidth=1.5;
k=convhull(UE_Coord);
plot(UE_Coord(k,1),UE_Coord(k,2),'r--')
IN = inpolygon(grid_x, grid_y,UE_Coord(k,1),UE_Coord(k,2));
plot(grid_x(IN),grid_y(IN),'g*')
plot(grid_x(~IN),grid_y(~IN),'y*')
reqi_x= zeros(20,20);
reqi_y= zeros(20,20);
reqi_x=grid_x(IN);
reqi_y=grid_y(IN);
legend('UE positions')
title('Convex hull and grid points within')
% for i=1:UE_count
%     p=line([UE_Coord(i,1) gNB_Coord(1,1)],[UE_Coord(i,2) gNB_Coord(1,2)]);
%     p.LineStyle="--";
%     hold on
% end

% for i=1:UE_count
% %     uex=UE_x(i);
% %     uey=UE_y(i);
% %     dist=15000;
%     max_dist=9999999;
%     for j=1:gNB_count
% %         gnbx=gNB_x(j);
% %         gnby=gNB_y(j);
% %         dis=sqrt((uex-gnbx).^2 + (uey-gnby).^2);
%         curr_dist=norm(UE_Coord(i,:)-gNB_Coord(j,:));
%         if (curr_dist < max_dist)
% %            best_gnbx(i)= gnbx;
% %            best_gnby(i)= gnby;
% %             conn(i)=j;
%             max_dist = curr_dist;
%             Assoc_gNB_ID(i)=j;
%         end    
%     end
% end
% % for i=1:Ue_count
% %    plot([UE_Coord(i,1) gNB_Coord( Assoc_gNB_ID(i),1) ],[UE_Coord(i,1) gNB_Coord( Assoc_gNB_ID(i),2) ],'r--')
% % end  
% Assoc_UE_Coord=[];
% for i=1:gNB_count
%     for j=1:UE_count
%         if(Assoc_gNB_ID(j)==i)
%             Assoc_UE_Coord=[Assoc_UE_Coord;UE_Coord(j,:)];
% %             Uex(j)=UE_Coord(j,1);
% %             Uey(j)=UE_Coord(j,2);
%         end
%     end 
% k=convhull(Assoc_UE_Coord);
% plot(Assoc_UE_Coord(k,1),Assoc_UE_Coord(k,2),'r--');
% IN = inpolygon(grid_x, grid_y,Assoc_UE_Coord(:,1),Assoc_UE_Coord(:,2));
% plot(grid_x(IN),grid_y(IN),'g*')
% % pause(5);
% % null(Uex)
% % null(Uey)
% null(Assoc_UE_Coord)
% end    
% hold off
    

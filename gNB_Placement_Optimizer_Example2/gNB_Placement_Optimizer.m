function [best_gNB_Pos]= gNB_Placement_Optimizer(gNB_count, UE_count)

grid_x = zeros(50,50);
grid_y = zeros(50,50);
for i=1:50
    for j=1:50
        grid_x(i,j) = 200*(i-1);
        grid_y(i,j) = 200*(j-1);
    end
end

UE_count = 100;
gNB_count =10;

axis( [0 10000 0 10000] );
rng(7);
UE_Coord=rand(UE_count,2)*10000;
gNB_Coord=rand(gNB_count,2)*10000;

for K=1:3
    clc
    %clear all
    close all
    hold on
    
    for i=1:UE_count
        plot(UE_Coord(i,1),UE_Coord(i,2),'b+')
    end
    rng(3);
    
    for i=1:gNB_count
        plot(gNB_Coord(i,1),gNB_Coord(i,2),'m*')
    end
    Assoc_gNB_ID=zeros(100,1);
    
    for i=1:UE_count
        max_dist=9999999;
        for j=1:gNB_count
            
            curr_dist=norm(UE_Coord(i,:)-gNB_Coord(j,:));
            if (curr_dist < max_dist)
                max_dist = curr_dist;
                Assoc_gNB_ID(i)=j;
            end
        end
    end
    
    Assoc_UE_Coord=[];
    [gNB_Pos] = MultiParameterSweeper(gNB_Coord,[0,0],Assoc_gNB_ID,0,0);
    for i=1:gNB_count
        Assoc_UE_Coord=[];
        for j=1:UE_count
            if(Assoc_gNB_ID(j)==i)
                Assoc_UE_Coord=[Assoc_UE_Coord;UE_Coord(j,:)];
                p=plot([UE_Coord(j,1),gNB_Coord(i,1)],[UE_Coord(j,2),gNB_Coord(i,2)],'b+');% Blue plus is UE positions
                p.LineStyle = '--';
                p.Color = [0.85 0.32 0.098 ];
                p.MarkerEdgeColor = 'b' ;
            end
        end
        if size(Assoc_UE_Coord,1) < 3
            shg
            [gNB_Pos] = MultiParameterSweeper(gNB_Coord,[gNB_Coord(i,1),gNB_Coord(i,2)],Assoc_gNB_ID,i,K);
        else 
            k=convhull(Assoc_UE_Coord);
            plot(Assoc_UE_Coord(k,1),Assoc_UE_Coord(k,2),'r--');
            IN = inpolygon(grid_x, grid_y,Assoc_UE_Coord(k,1),Assoc_UE_Coord(k,2));
            plot(grid_x(IN),grid_y(IN),'g*')
            % pause(5);
            shg
            [gNB_Pos] = MultiParameterSweeper(gNB_Coord,[grid_x(IN),grid_y(IN)],Assoc_gNB_ID,i,K);
        end    
        gNB_Coord=gNB_Pos;
    end
    saveas(gcf,"Plot_K_"+string(K)+".png")
    hold off
    best_gNB_Pos=gNB_Coord;
end
end



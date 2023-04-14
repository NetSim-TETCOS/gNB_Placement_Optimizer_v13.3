clc
close all

UE_count = 100;
gNB_count =10;
hold on
axis( [0 10000 0 10000] );
rng(7);
UE_Coord=rand(UE_count,2)*10000;

for i=1:UE_count
    plot(UE_Coord(i,1),UE_Coord(i,2),'b+')
end    
%rng(4);
gNB_Coord=rand(gNB_count,2)*10000;
for i=1:gNB_count
    plot(gNB_Coord(i,1),gNB_Coord(i,2),'g*','MarkerSize',15)
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
for i=1:gNB_count
    for j=1:UE_count
        if(Assoc_gNB_ID(j)==i)
           Assoc_UE_Coord=[Assoc_UE_Coord;UE_Coord(j,:)];
             Uex(j)=UE_Coord(j,1);
             Uey(j)=UE_Coord(j,2);
        end
    end 
end    

for i=1:UE_count % Random X, Y co-ordinates for the UEs
    for j=1:gNB_count
        if( Assoc_gNB_ID(i)==j)
            p=line([Uex(i) gNB_Coord(j,1)],[Uey(i) gNB_Coord(j,2)]);% Blue plus is UE positions
            p.LineStyle = '--';
            p.Color = [0.85 0.32 0.098 ];
            p.MarkerEdgeColor = 'b' ;
        end
    end
    %fprintf('X = %g, Y = %g, \n', UE_x(i), UE_y(i))
end 
hold off
    

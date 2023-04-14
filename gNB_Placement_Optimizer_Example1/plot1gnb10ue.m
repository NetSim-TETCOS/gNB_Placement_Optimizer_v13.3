rng(7);
UE_count=10;
UE_Coord=zeros(UE_count,2);
hold on
for i=1:UE_count
    UE_Coord(i,1) = rand()*4000;
    UE_Coord(i,2) = rand()*4000;
    plot(UE_Coord(i,1),UE_Coord(i,2),'b*')
end
% for i=1:UE_count
%     plot(UE_Coord(i,1),UE_Coord(i,2),'b+')
% end 
gNB_Coord=[3500 2200];
p=plot(gNB_Coord(1,1),gNB_Coord(1,2),'r*');
p(1).LineWidth = 5;

for i=1:UE_count
    plot([UE_Coord(i,1),gNB_Coord(1,1)],[UE_Coord(i,2),gNB_Coord(1,2)],'g--')
end 
sum_dis = 0;
for i=1:UE_count
   sum_dis=sum_dis + norm(UE_Coord(i,:)-gNB_Coord(1,:));
end
hold off
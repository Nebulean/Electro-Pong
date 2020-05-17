[x,y] = meshgrid(0:0.5:3, 0:0.5:3);

u = cos(x);
v = cos(y);

f=figure
quiver(x,y,u,v,'linewidth',3)
box off
axis off
pbaspect([1,1,1])
set(gca, 'Color', 'None')

saveas(f, "vector_field.eps", "epsc")
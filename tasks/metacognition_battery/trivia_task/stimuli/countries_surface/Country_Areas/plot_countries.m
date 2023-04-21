
figure

surfaces = log(CIAdatabase.SurfaceArea(1:end-1))

raincloud_plot(log(surfaces), 'box_on', 1)

%%

% Create a matrix of all the pairwise differences
%areas = zeros(length(surfaces), 1);
areas = surfaces

for r = 1:length(areas)
    for c = 1:length(areas)
        diff_square_cities(r,c) = areas(r) - areas(c);
    end
end

pos_diff = diff_square_cities(diff_square_cities>0);


%%

figure, raincloud_plot(pos_diff)

xlabel('Log City Surface Area')
ylabel('Probability Density')

figure, imagesc(diff_square_cities); colorbar
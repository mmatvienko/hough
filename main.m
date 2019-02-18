% original image]
name = "box.jpg";
original = imread(name);
subplot(4,2,1);
imshow(original);
title("Original Image");

% gray image
img = rgb2gray(original);
subplot(4,2,2);
imshow(img);
title("Grayscale Image");

% image ran through canny edge detection
h = fspecial('gaussian', 3, 3);
img = imfilter(img, h);
edges = edge(img, 'Canny');
subplot(4,2,3);
imshow(edges);
title('Canny Edge Detection');

sz = size(edges);
y = sz(1); % height
x = sz(2); % width

% scaling factors
p_factor = 4; % y axis
angle_factor = 1; % x axis

votes = zeros(uint32((y+x) / p_factor), uint8(180/angle_factor) + 1);

for j = 1:x
    for i = 1:y
        if edges(i,j) > 0
            votes = votes + hough(votes, j,i, p_factor, angle_factor);
        end
    end    
end

votes([1], :) = []; % clear out the first row which is absolute ass
votes(:, [171:181]) = [];
% heat map
subplot(4,2,4);
imagesc(votes);
title('Heat map of valid \theta and \rho');
xlabel('\theta');
ylabel('\rho');


locs = find(votes>uint32(max(votes(:))*0.7))
toplot = imread(name);
sz = size(toplot);

% final image to plot on
subplot(4,2,[5 6 7 8]);
imshow(toplot);
title('Final Result')
for i=1:size(locs)
    loc = locs(i);
    [row, col] = ind2sub(size(votes), loc);
    p = (row - 1)*p_factor;
    theta = (col - 91) * (pi/180) * angle_factor;
    hold on;

    x = (1:sz(1));
    y = (p - x.*(cos(theta)))./sin(theta);
    plot(x, y,'LineWidth',1);
end
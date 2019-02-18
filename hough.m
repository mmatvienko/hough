function [toadd] = hough(votes, x1, y1, p_factor, angle_factor)
    angles_ = -90/angle_factor:90/angle_factor;
    angles = angles_.*(pi/180);
    toadd = zeros(size(votes));
    for x = 1:181/angle_factor
        j = x;
        i = uint32(( x1*cos(angles(x)) + y1*sin(angles(x)))/ p_factor) + 1;
        toadd(i, j) = toadd(i, j) + 1;
    end
end
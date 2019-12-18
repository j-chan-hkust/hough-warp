function [img_marked, corners, corners_flipped] = hough_transform(img)

% Implement the Hough transform to detect the target A4 paper
% Input parameter:
% .    img - original input image
% .    (You can add other input parameters if you need. If you have added
% .    other input parameters, please state for what reasons in the PDF file)
% Output parameter:
% .    img_marked - image with marked sides and corners detected by Hough transform
% .    corners - the 4 corners of the target A4 paper

% Remember to print the line functions and the corner points in the command window
% Convert the input image to the binary image
    IM = rgb2gray(img);
    % Display the input image
    figure;
    imshow(img);title('Input image');
    imgBW = medfilt2(IM);
    %imgBW = imdiffusefilt(IM, 'NumberofIterations', 100);
    
    %figure;    
    %imshow(imgBW);title('diffusion filter');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % TODO_1: Find the edge of the image
    % imgBW = ??
    
    imgBW = edge(imgBW,'Prewitt');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure;    
    imshow(imgBW);title('Edge');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % TODO_2: Perform the circular Hough Transform. Given that the radius
    % of the circles is 50 pixels. Create a varible 'Accumulator' to store
    % the bin counts.
    % Accumulator = ??
    
    % rho, theta - I will just be using single degree
    diagonal = size(imgBW,1)^2+size(imgBW,2)^2;
    diagonal = sqrt(diagonal);
    diagonal = ceil(diagonal);
    theta_resolution = 180;
    Accumulator = zeros(diagonal*2, theta_resolution);
    for i=1:size(imgBW,1)
        for j=1:size(imgBW,2)
            for k=1:theta_resolution
                theta = k*180/theta_resolution-90;
                rho = i*cosd(theta)+j*sind(theta);
                rho = round(rho)+diagonal;
                Accumulator(rho,k) = Accumulator(rho,k) + imgBW(i,j);
            end
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Visualize the Accumulator cells
    figure;
    imagesc(Accumulator);title('Accumulator cells');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % TODO_3: Search for the highest count cell in 'Accumulator' and store the
    % x,y-coordinate in two separate arrays.
    % we look 
    Accumulator_copy = Accumulator;
    Index = [0,0;0,0;0,0;0,0];
    for j = 1:4
       [a, b] = max(Accumulator_copy(:));
       [Index(j,1),Index(j,2)] = ind2sub(size(Accumulator), b);
       for m=-80:1:80
           for n=-10:1:10
               lazyfix = Index(j,2)+n;
               lazyfix2 = Index(j,1)+m;
               if lazyfix>180
                   lazyfix = lazyfix-180;
                   lazyfix2 = diagonal*2-lazyfix2;
               end
               if lazyfix<1
                   lazyfix = lazyfix+180;
                   lazyfix2 = diagonal*2-lazyfix2;
               end
               try
                   Accumulator_copy(lazyfix2,lazyfix) = -inf; %we do this because we want 4 seperated points
               catch ME %catch the error that occurs when theta is close to 0
                   
               end
           end
       end
    end
    eqns = [];
    
    figure;
    imshow(img);title('Draw some lines!');
    hold on;
    syms x y
    for i = 1:4
        theta = Index(i,2)*180/theta_resolution-90;
        rho = Index(i,1)-diagonal;
        m = -cosd(theta)/sind(theta);
        c = rho/sind(theta);
        fprintf("The function of line %d is: y = %d*x + %d\n", i, m, c);
        col = 1:size(img,2);
        plot(m*col+c,col,'x','LineWidth',5,'Color','green');
        eqns = [eqns y == m*x+c];
    end
    
    
    combinations = nchoosek(eqns,2);
    
    fprintf("The intersection points are: ");
    
    corners = [];
    corners_flipped = [];
    
    for i=1:size(combinations)
        sol = solve([combinations(i,1), combinations(i,2)], [x,y]);
        if ~isempty(sol.x)&&~isempty(sol.y)
            if sol.x>=1 && sol.x<size(img,1) && sol.y>=1 && sol.y<size(img,2) 
                fprintf("(%d, %d) ", sol.y, sol.x); %y and x are swapped? 
                corners = [corners; [sol.y, sol.x]];
                corners_flipped = [corners_flipped; [sol.x sol.y]];
                plot(sol.y, sol.x, 'r*');
            end
        end
    end
    
    corners = double(corners);
    corners_flipped = double(corners_flipped);
    
    x = corners(:,1).';
    y = corners(:,2).';
    cx = mean(x);
    cy = mean(y);
    a = atan2(y - cy, x - cx);
    [~, order] = sort(a);
    corners = [x(order);y(order)].'
    
    x = corners_flipped(:,1).';
    y = corners_flipped(:,2).';
    cx = mean(x);
    cy = mean(y);
    a = -atan2(y - cy, x - cx);
    [~, order] = sort(a);
    corners_flipped = [x(order);y(order)].'
    
    fprintf("\n");
    
    F = getframe(gcf);
    [img_marked, Map] = frame2im(F);


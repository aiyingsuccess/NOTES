function [neigh] = get_neigh_4(A, r, c) 
%get_neigh_4 Gets the neighboring grid cells of the input grid cell that are not background

%   The function gets a geometry matrix A and a specific element of it in row(r) and column(c) and returns a 0/1 vector with 1s at the points where there is an active neighbor(not background). The orientation of the 4-element vector is north->west->east->south

    neigh = zeros(1,4);
    meg = size(A);
    if r-1==0 && c-1==0 % If cell on top-left corner 
        if A(r,c+1) > 0  
            neigh(3) = 1;
        end
        if A(r+1,c) > 0  
            neigh(4) = 1;
        end
    elseif r-1==0 && c==meg(2) % else if cell on top-right corner
        if A(r,c-1) > 0  
            neigh(2) = 1;
        end
        if A(r+1,c) > 0  
            neigh(4) = 1;
        end
        
    elseif r==meg(1) && c-1==0 % else if cell on bottom-left corner
        if A(r-1,c) > 0  
            neigh(1) = 1;
        end
        if A(r,c+1) > 0  
            neigh(3) = 1;
        end
    elseif r==meg(1) && c==meg(2) % else if cell on bottom-right corner
        if A(r-1,c) > 0  
            neigh(1) = 1;
        end
        if A(r,c-1) > 0  
            neigh(2) = 1;
        end
        
    elseif r-1 == 0 % else if cell on top edge
        if A(r,c-1) > 0  
            neigh(2) = 1;
        end
        if A(r,c+1) > 0  
            neigh(3) = 1;
        end
        if A(r+1,c) > 0  
            neigh(4) = 1;
        end
    elseif r==meg(1) % else if cell on bottom edge
        if A(r-1,c) > 0  
            neigh(1) = 1;
        end
        if A(r,c-1) > 0  
            neigh(2) = 1;
        end
        if A(r,c+1) > 0  
            neigh(3) = 1;
        end
        
     elseif c-1==0  % else if cell on left edge
        if A(r-1,c) > 0  
            neigh(1) = 1;
        end
        if A(r,c+1) > 0  
            neigh(3) = 1;
        end
        if A(r+1,c) > 0  
            neigh(4) = 1;
        end
    elseif c==meg(2) % else if cell on right edge
        if A(r-1,c) > 0  
            neigh(1) = 1;
        end
        if A(r,c-1) > 0  
            neigh(2) = 1;
        end
        if A(r+1,c) > 0  
            neigh(4) = 1;
        end
    elseif r-1>0 && r<meg(1) && c-1>0 && c<meg(2) % else if cell inside the matrix
        if A(r-1,c) > 0  
            neigh(1) = 1;
        end
        if A(r,c-1) > 0  
            neigh(2) = 1;
        end
        if A(r,c+1) > 0  
            neigh(3) = 1;
        end
        if A(r+1,c) > 0  
            neigh(4) = 1;
        end
        
    end
end

function [ neighbors_vect ] = neighbors_vect(i, G, indices)
%neighbors_vect Returns a vector, whose first two entries are the row(r)
%and the column(c) of the element in the geometry matrix(G) and the next
%four entries are 0s and 1s depending on the entry's neighbors

%   The function gets the matrix of active indices abd concentrates on a
%   specific entry(i). Given those, it finds the row and column of the
%   entry and finds its neighbors in the geometry matrix. It returns a
%   6-entry vector consisting of the row(r), the column(c)and four 0/1
%   indicating the active neighbors of the entry.

    c = floor(indices(i)/size(G, 1))+1; % Reconstruct the entry's coordinates 
    r = mod(indices(i), size(G, 1)); % from its index
    if r == 0
        r = r+size(G, 1);
        c = c-1;
    end
    temp_neigh = get_neigh_4(G, r, c); % Find the neighbors of the specific
    neighbors_vect = [r c temp_neigh];
end


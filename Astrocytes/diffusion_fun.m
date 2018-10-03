function [b1, b2] = diffusion_fun(ii, CaC, IC, neighbors, d_coeff_Ca, d_coeff_I)
%diffusion_fun Updates the value of a grid cell by diffusing to and from its neighbors
%   row(r) and column(c) of the grid cell are specified and the updated values(b1 for Ca and b2 for IP3) after diffusion are calculated
       r = neighbors(ii,2);
       c = neighbors(ii,3);
       b1 = diff_neigh_4(CaC, r, c, neighbors(ii,4:end), d_coeff_Ca);
       b2 = diff_neigh_4(IC, r, c, neighbors(ii,4:end), d_coeff_I);
end


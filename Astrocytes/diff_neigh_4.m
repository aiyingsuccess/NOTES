function [el] = diff_neigh_4(C, r, c, neigh, d_coeff)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    val = C(r,c);
    sum = 0;
    pin = 1;
    i=r-1;j=c;
    if neigh(pin) ==1
       sum = sum + (C(i,j) - val);
    end
    pin=pin+1;
    i=r;j=c-1;
    if neigh(pin) ==1
       sum = sum + (C(i,j) - val);
    end
    pin=pin+1;
    i=r;j=c+1;
    if neigh(pin) ==1
       sum = sum + (C(i,j) - val);
    end
    pin=pin+1;
    i=r+1;j=c;
    if neigh(pin) ==1
       sum = sum + (C(i,j) - val);
    end
    el = C(r,c) + sum*d_coeff*(1/(0.2*10^(-6))^2)*(1/1000)*(1*10^(-12));
end
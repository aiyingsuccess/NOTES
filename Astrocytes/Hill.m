function [res] = Hill(x, n, k)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    num = power(x, n);
    den = power(x, n) + power(k, n);
    res = num./den;
end


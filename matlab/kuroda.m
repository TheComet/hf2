function [Zk, Xk] = kuroda(Z, X, type)
    if type == 'C2L'
        n = 1 + X*Z;
        Xk = (n-1) * Z / n;
        Zk = Z/n;
    elseif type == 'L2C'
        n = 1 + X/Z;
        Xk = (n-1) / (n*Z);
        Zk = Z * n;
    else
        error('Unknown transformation type');
    end
end

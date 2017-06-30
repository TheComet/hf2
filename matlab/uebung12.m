%         L2    L4
% R0 o----^^^---^^^----o R6
% -->  _|_   _|_   _|_  <--
%      ---   ---   ---
%       | C1  | C3  | C5
%    o-----------------o

% Prototype filter params
g0 = 1;
g1 = 0.973;
g2 = 1.372;
g3 = 1.803;
g4 = g2;
g5 = g1;
g6 = g0;

% Prototype components (subscript "p" for "prototype")
R0p = g0;
C1p = g1;
L2p = g2;
C3p = g3;
L4p = g4;
C5p = g5;
R6p = g6;

w = logspace(-1, 2, 1000);
s = j*w;
B = 1./(s*C5p + 1/R6p);
A = s*L4p + 1./(s*C5p + 1/R6p);
T = B ./ A;
hold off
semilogx(w, 20*log10(abs(T))); grid on, grid minor

w = logspace(-1, 2, 5000);
s = j*tan(pi/2 * w/2);
B = 1./(s*C5p + 1/R6p);
A = s*L4p + 1./(s*C5p + 1/R6p);
T = B ./ A;
hold on
semilogx(w, 20*log10(abs(T))); grid on, grid minor
ylim([-40 10]);
ylabel('Amplitude (dB)');
xlabel('Frequenz (rad/s)');
legend('Vor Transformation', 'Nach Transformation');
title('Transformation eines Tiefpassfilters');

% Richard's (dick) transformation for fc=0.8 GHz, f@90° = 2 GHz
fc = 0.8e9;
fl4 = 2e9;
Omega = tan(pi/2 * fc / fl4);

% Normalise impedance to 50
Z = 50;

% Transform components (subscript "r" for "Richard")
R0r = R0p * Z;
C1r = C1p / Z / Omega;
L2r = L2p * Z / Omega;
C3r = C3p / Z / Omega;
L4r = L4p * Z / Omega;
C5r = C5p / Z / Omega;
R6r = R6p * Z;

% Kuroda transformation (subscript "k" for "Kuroda")
% C to L
%    n = 1+C*Z0
%    Z0' = Z0/n
%    L' = (n-1)*Z0 / n
% L to C
%    n = 1 + L/Z0
%    Z0' = Z0*n
%    C' = (n-1)/(n*Z0)

% Input impedances are all the same when shoving in new unit elements
Z1k = R0r;
Z2k = R0r;
Z3k = R0r;
Z4k = R0r;

% Insert first U.E.
[Z1k, L1k] = kuroda(Z1k, C1r, 'C2L');
[Z2k, C2k] = kuroda(Z2k, L2r, 'L2C');
[Z3k, L3k] = kuroda(Z3k, C3r, 'C2L');
[Z4k, C4k] = kuroda(Z4k, L4r, 'L2C');

% Insert second U.E. and shift first
[Z2k, C1k] = kuroda(Z2k, L1k, 'L2C');
[Z1k, C2k] = kuroda(Z1k, L2r, 'L2C');

% Insert third U.E. and shift first and second
% [Z3k, L1k] = kuroda(Z3k, C1k, 'C2L');
% [Z2k, L2k] = kuroda(Z2k, C2k, 'C2L');
% [Z1k, L3k] = kuroda(Z1k, C3r, 'C2L');

% Insert fourth U.E. and shift, first, second and third
% [Z4k, C1k] = kuroda(Z4k, L1k, 'L2C');
% [Z3k, C2k] = kuroda(Z3k, L2k, 'L2C');
% [Z2k, C3k] = kuroda(Z2k, L3k, 'L2C');
% [Z1k, C4k] = kuroda(Z1k, L4r, 'L2C');


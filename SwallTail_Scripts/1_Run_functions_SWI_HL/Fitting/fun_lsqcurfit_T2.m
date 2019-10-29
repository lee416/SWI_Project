function SIc=fun_lsqcurfit_T2(g,xdata)

SIc = g(1).*exp(-xdata./g(2));
% gamm=g(1).*(xdata-g(2)).^g(3).*exp(-g(4).*(xdata-g(2)));
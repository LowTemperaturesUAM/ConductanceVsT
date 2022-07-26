function dFermiDist = FermiDeriv(Temperature,E)
    kB = 8.617e-2;
    Beta = 1/(kB*Temperature);
    dFermiDist = Beta./(4*(cosh(Beta*E/2)).^2);
end
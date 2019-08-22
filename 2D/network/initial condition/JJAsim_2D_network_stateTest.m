function validQ = JJAsim_2D_network_stateTest(array,out,I,f,n,z,tol)
%f,z,n: Np* by W*
%I:     W* by 1
%
M = array.M;
A = array.A;
th = out.th;
if array.customcpQ
    II = array.cp(array.Ic,th);
else
    II = array.Ic.*sin(th);
end
dI = M*II - shiftdim(I,-1).*array.IExtBase;
check1 = mean(abs(dI),1) < tol;
check2 = mean(abs(z - A*round(th/2/pi) - n),1) < tol;

if ~array.inductanceQ
    dF = A*th - 2*pi*(z - array.pathArea.*f);
else
    switch array.inductanceMode
        case 'uniform self'
            dF = A*th - 2*pi*(z - array.pathArea.*f) + A*(array.betaL*II);
        case 'self'
            dF = A*th - 2*pi*(z - array.pathArea.*f) + A*(array.betaL.*II);
        case 'matrix'
            dF = A*th - 2*pi*(z - array.pathArea.*f) + A*(array.betaL*II);
    end
end
check3 = mean(abs(dF),1) < tol;
if isfield(out,'I')
    check4 = mean(abs(II - out.I),1) < tol;
else
    check4 = true(size(check1));
end

if isfield(out,'E')
    E = JJAsim_2D_network_method_getEJ(array,th) + JJAsim_2D_network_method_getEM(array,II);
    check5 = abs(out.E' - sum(E,1)) < tol;
else
    check5 = true(size(check1));
end
[check1;check2;check3;check4;check5]
check = (check1 & check2 & check3 & check4 & check5)';
validQ = isequal(check,out.solutionQ);

end

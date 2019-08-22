function U = JJAsim_2D_network_method_getU(array,V)
%U = JJAsim_2D_network_method_getU(array,V)
%
%DESCRIPTION
% obtains the island potential U from the junction voltage drop V. 
%
%FIXED INPUT
% array     struct                  information about Josephson junction array    
% V         Nj* by W by Nt          junction voltage drop
%
%OUTPUT
% U         Np by W by Nt           island potential

if size(V,1) == 1
    V = repmat(V,array.Nj,1);
end
Cred = array.CComponentsReduced;
Ncomp = array.nrOfConnectedComponents;
if Ncomp > 1
    iscomp = array.islandComponents;
else
    iscomp = ones(array.Nis,1);
end
sz = size(V);
U = -JJAsim_2D_network_method_CSolve(array.M*reshape(V,array.Nj,[]),Cred,iscomp,Ncomp);
U = reshape(U,[array.Nis,sz(2:end)]);
end
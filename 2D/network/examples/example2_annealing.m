close all; 
% - this example shows how to find low energy stationairy states with simulated annealing.
% - Done in the presence of an external magnetic field, which is represented by
%   the frustration factor f.

%array size
Nx = 10;                %nr of islands in x-direction
Ny = 10;                %nr of islands in y-direction
ax = 1;                 %island spacing in x-direction
ay = 1;                 %island spacing in y-direction

%other parameters
f = 1/3;                %frustration factor
inputMode = 'sweep';    %input mode (only relevant if computing multiple problems in one function call)
IExt = 0;               %External current
t = (0:0.5:20000)';      %time points
Nt = length(t);
z = 0;                  %phase zone
th1 = 0;                %initial condition 

%create annealing temperature profile (first stay at T0, then quench to 0)
T0 = 0.15;
T = linspace(T0,0,Nt);

%visualise temperature profile
plot(t,T); xlabel('t'); ylabel('T'); title('anneal temperature profile')
disp('paused; press enter to continue')
pause

%create square array
array = JJAsim_2D_network_square(Nx,Ny);

%time evolution
out = JJAsim_2D_network_simulate(array,t,inputMode,IExt,T,f,z,th1);
nOut = JJAsim_2D_network_method_getn(array,out.th,z);   

%visualize annealing process
selectedTimePoints = false(Nt,1);
selectedTimePoints(1:20:end) = true;
JJAsim_2D_visualize_movie(array,t,zeros(array.Np,Nt),out.I,'showPathQuantityQ',true,...
    'pathQuantity',nOut,'selectedTimePoints',selectedTimePoints,'showIslandsQ',false,...
    'arrowColor',[0,0,0],'pathQuantityLabel','n');
close all;

%visualize final configuration (note, this is timestep Nt-1 because at timestep Nt one cannot
%     obtain the current because it depends on the voltage derivative which is forward difference)
nFinal = nOut(:,:,end-1);
IFinal = out.I(:,:,end-1);
JJAsim_2D_visualize_snapshot(array,nFinal,IFinal,'showIExtBaseQ',false);

disp(['energy of final state (per junction): ',num2str(out.E(end)/array.Nj)])






plot(t,T,'LineWidth',1.5,'Color',[0,0,0]); 
xlabel('$t$','Interpreter','latex','FontSize',15); 
ylabel('$T(t)$','Interpreter','latex','FontSize',15); 
title('anneal temperature profile','Interpreter','latex','FontSize',15);
ah = gca;
ah.LineWidth = 1.5;
ah.FontSize = 15;
ah.XAxis.TickLabelInterpreter = 'latex';
ah.YAxis.TickLabelInterpreter = 'latex';



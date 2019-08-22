islandPositions = [0,0;1,0;0.5,1];
junctionIsland1 = [1;2;3];
junctionIsland2 = [2;3;1];
externalCurrentBase = [1;-1;0];
betaC = [0;1.4;1];
array = JJAsim_2D_network_create(islandPositions,junctionIsland1,...
    junctionIsland2,externalCurrentBase,'betaC',betaC);
JJAsim_circuit(array);

%problem 1
IExt_1 = 2;
T_1 = 0;
f_1 = 0;
th1_1 = 0;

%problem 2
IExt_2 = 0;
T_2 = 0.0001;
f_2 = 0.5;
th1_2 = 0;

%problem 3
IExt_3 = 0;
T_3 = 0.0001;
f_3 = 0;
n_3 = 1;
out = JJAsim_2D_network_stationairyState(array,'sweep',IExt_3,f_3,n_3,0);
th1_3 = out.th;

t = (0:0.05:30)';
out_1 = JJAsim_2D_network_simulate(array,t,'sweep',IExt_1,T_1,f_1,0,th1_1);
out_2 = JJAsim_2D_network_simulate(array,t,'sweep',IExt_2,T_2,f_2,0,th1_2);
out_3 = JJAsim_2D_network_simulate(array,t,'sweep',IExt_3,T_3,f_3,0,th1_3);

n_1 = JJAsim_2D_network_method_getn(array,out_1.th,0);
JJAsim_2D_movie(array,t,n_1,out_1.I,'saveQ',true,'filename','ex1_1_movie');

n_2 = JJAsim_2D_network_method_getn(array,out_2.th,0);
JJAsim_2D_movie(array,t,n_2,out_2.I,'saveQ',true,'filename','ex1_2_movie');

n_3 = JJAsim_2D_network_method_getn(array,out_3.th,0);
JJAsim_2D_movie(array,t,n_3,out_3.I,'saveQ',true,'filename','ex1_3_movie');

n_1 = JJAsim_2D_network_method_getn(array,out_1.th,0);
JJAsim_2D_movie(array,t,n_1,out_1.I,'saveQ',true,'filename','ex1_1_movie');
figure;
plot(t,squeeze(out_1.th)/2/pi);
xlabel('$t/t_J$','Interpreter','latex')
ylabel('$\theta(t)$','Interpreter','latex')
legend({'junction 1','junction 2','junction 3'},'Location','NorthWest')

figure;
plot(t,squeeze(out_2.th)/2/pi);
xlabel('$t/t_J$','Interpreter','latex')
ylabel('$\theta(t)$','Interpreter','latex')
legend({'junction 1','junction 2','junction 3'},'Location','NorthEast')

figure;
plot(t,squeeze(out_3.th)/2/pi);
xlabel('$t/t_J$','Interpreter','latex')
ylabel('$\theta(t)$','Interpreter','latex')
legend({'junction 1','junction 2','junction 3'},'Location','NorthWest')
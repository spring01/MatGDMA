

molcart = [8 1.33208109 2.5992915701 -0.0190596757
           6 0.125452809 2.6016797996 -0.0189995159
           1 -0.4676123128 3.5399463671 0.0137769679
           1 -0.4713215863 1.6657822631 -0.0517177763];
basisname = '6-31g**';

mp = MatPsi2(molcart, basisname);
mg1 = MatPsiGDMA(mp);
mg1.limit = [1 2 2 5];
mg1.bigexp = inf;

mp.SCF_RunRHF();
psi4_occOrb = mp.SCF_OrbitalAlpha();
psi4_occOrb = psi4_occOrb(:, 1:mp.Molecule_NumElectrons()/2);

% tic
% for i = 1:1000
mg1.RunGDMA(psi4_occOrb);
% end
% toc

mg1.multipoles(1:10, 1:4)

mexp1 = MultipoleExpansion.Create(mg1, 1);
mexp2 = MultipoleExpansion.Create(mg1, 4);

mat1 = mexp1.InteractionMatrixWith(mexp2);
mat2 = mexp2.InteractionMatrixWith(mexp1);


% tic
% for i = 1:1000
mexp1.InteractionWith(mexp2);
mexp2.InteractionWith(mexp1);
% end
% toc


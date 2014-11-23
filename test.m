

molstr = ['O 1.33208109 2.5992915701 -0.0190596757', char(10), ...
          'C 0.125452809 2.6016797996 -0.0189995159', char(10), ...
          'H -0.4676123128 3.5399463671 0.0137769679', char(10), ...
          'H -0.4713215863 1.6657822631 -0.0517177763'];
basisname = 'sto-3g';

m1 = MatPsi(molstr, basisname);
m1.RHF();
psi4_occOrb = m1.RHF_C();
psi4_occOrb = psi4_occOrb(:, 1:m1.nelec()/2);

mg1 = MatGDMA(m1);
mg1.psi4_occOrb = psi4_occOrb;

mg1.RunGDMA();

mg1.multipoles(1:10, 1:4)


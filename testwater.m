water = [8 0         0   -0.0617
         1 0   -0.7116    0.4893
         1 0    0.7116    0.4893];


mp = MatPsi2(water, 'sto-3g');

gdma = MatPsiGDMA(mp);
gdma.SetLimitHeavyHydrogen(5, 5);

mp.SCF_RunSCF();
orb = mp.SCF_OrbitalAlpha();
occOrb = orb(:, 1:mp.Molecule_NumElectrons()/2);

gdma.RunGDMA(occOrb);
gdma.RemoveCore();



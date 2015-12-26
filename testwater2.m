water_2 = [8 0         0   -0.0617
           1 0   -0.7116    0.4893
           1 0    0.7116    0.4893
           8 0         0    5.9383
           1 0   -0.7116   6.4893
           1 0    0.7116   6.4893];


mp = MatPsi2(water_2, '6-311+g**');
mp.SCF_RunSCF();

h2 = mp.Integrals_AllTEIs();
density = 2*mp.SCF_DensityAlpha();

nbf = mp.BasisSet_NumFunctions();
water1_ind = 1:nbf/2;
water2_ind = nbf/2+1:nbf;


densVec = reshape(density(water1_ind, water1_ind), [], 1);
sum1 = densVec' * reshape(h2(water1_ind, water1_ind, water2_ind, water2_ind), length(water1_ind)^2, []) * densVec;

gdma = MatPsiGDMA(mp);
gdma.SetLimitHeavyHydrogen(5, 5);
orb = mp.SCF_OrbitalAlpha;
occOrb = orb(:, 1:mp.Molecule_NumElectrons()/2);
gdma.RunGDMA(occOrb);
gdma.RemoveCores();
for i = 1:length(gdma.limit)
    sites{i} = MultipoleExpansion.Create(gdma, i);
end


sum2 = 0;
for i = 1:3
    for j = 4:6
        sum2 = sum2 + sites{i}.InteractionWith(sites{j});
    end
end

627.5095*(sum1-sum2)


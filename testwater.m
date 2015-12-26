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
gdma.RemoveCores();



numPrims = sum(gdma.shellNprims);
sum_mp = zeros(size(gdma.pairs{1, 1}.moved));
for i = 1:numPrims
    for j = 1:numPrims
        sum_mp = sum_mp + gdma.pairs{i, j}.moved;
    end
end

[sum_mp(1:40, :), gdma.multipoles(1:40, :)] % should match


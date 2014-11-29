classdef MatPsiGDMA < handle
    
    % Note for dimension check:
    % We "implicitly" use "limit", "shellNfuncs", and "shellNprims" to
    % determine some dimension of our vectors or matrices; this may result
    % in that if these 3 properties had some wrong dimension, the program
    % would rather complain about other properties, but not them.
    
    properties (SetAccess = private)
        
        %! input section
        % sites info
        nucleiCharges    % nuclei charges of sites; 0 for non-atom sites
        xyzSites         % cartesian coordinates of sites
        
        % shell info
        shellNfuncs     % how many basis functions each site has
        shell2atom      % on which atom each site locates
        shellNprims     % how many primitive gaussians each site has
        
        % gaussian primitive info
        primExps        % exponentials of primitive gaussians
        primCoefs       % contraction coefficients of primtive gaussians
        
        % density matrix
        density
        
        
        %! output
        % GDMA output
        multipoles;
        
    end
    
    properties
        
        % maximum order of multipoles of sites
        limit;
        % algorithm threshold, if primExps(i) > bigexp then use old algorithm
        bigexp;
        
    end
    
    properties (Access = private)
        
        psi4_sphericalAM; % used in psi4->gaussian density format converting
        
    end
    
    methods
        
        function obj = MatPsiGDMA(matpsi)
            obj.shellNprims = matpsi.shellNprims();
            obj.shell2atom = matpsi.shell2center();
            obj.shellNfuncs = matpsi.shellNfuncs();
            obj.nucleiCharges = matpsi.Zlist();
            obj.xyzSites = matpsi.geom()'; % xyzSites in Bohr
            obj.primExps = matpsi.primExps();
            obj.primCoefs = matpsi.primCoefs(); % un-normalized
            
            obj.psi4_sphericalAM = matpsi.basis_has_puream();
            
            % default limit is 4 for non-H and 1 for H
            heavyOrNot = (obj.nucleiCharges~=1);
            obj.limit = zeros(size(heavyOrNot));
            obj.limit(heavyOrNot==1) = 4;
            obj.limit(heavyOrNot==0) = 1;
            
            % default algorithm threshold is 0 (always use old algorithm)
            obj.bigexp = 0.0;
            
        end
        
        function multipoles_ = RunGDMA(obj, occOrb)
            
            % GDMA wants a Gaussian style density matrix
            obj.density = obj.Psi4OccOrb2GaussianDensity(occOrb);
            
            %!!! GDMA DRIVER MEX !!!
            multipoles_ = MatPsiGDMA.matgdma_mex(obj.InputStruct());
            
            % output
            multipoles_ = multipoles_(2:end, 1:length(obj.limit));
            obj.multipoles = multipoles_;
        end
        
        function res = NthOrderMthSite(obj, nthOrder, mthSite)
            % Qn0 Qn1s Qn1c Qn2s Qn2c ...
            res = obj.multipoles(nthOrder^2+1:(nthOrder+1)^2, mthSite);
        end
        
        % Convert a Psi4 style occupied molecular orbital matrix to 
        % a Gaussian style density matrix
        density = Psi4OccOrb2GaussianDensity(obj, psi4_occOrb);
        
    end
    
    methods (Access = private)
        
        function struct = InputStruct(obj)
            struct.nucleiCharges = obj.nucleiCharges;
            struct.xyzSites = obj.xyzSites;
            struct.shellNfuncs = obj.shellNfuncs;
            struct.shell2atom = obj.shell2atom;
            struct.shellNprims = obj.shellNprims;
            struct.primExps = obj.primExps;
            struct.primCoefs = obj.primCoefs;
            struct.density = obj.density;
            struct.limit = obj.limit;
            struct.bigexp = obj.bigexp;
        end
        
    end
    
    methods (Static, Access = private)
        
        % mex claimed as a static mathod (to wrap it under @folder)
        multipoles = matgdma_mex(struct);
        
    end
    
end

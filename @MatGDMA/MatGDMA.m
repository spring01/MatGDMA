classdef MatGDMA < handle
    
    % Note for dimension check:
    % We "implicitly" use "limit", "shellNfuncs", and "shellNprims" to
    % determine some dimension of our vectors or matrices; this may result
    % in that if these 3 properties had some wrong dimension, the program
    % would rather complain about other properties, but not these.
    
    properties (SetAccess = private)
        
        %! input section
        % sites info
        nucleiCharges
        xyzSites
        limit % each entry is the maximum order of multipoles of each site
        
        % shell info
        shellNfuncs
        shell2atom
        shellNprims
        
        % gaussian primitive info
        primExps
        primCoefs
        
        % density matrix
        density
        
        % algorithm threshold
        bigexp
        
        %! output
        % GDMA output
        multipoles;
        
    end
    
    properties
        
        default_limit;
        default_bigexp;
        
        density_format = 'Psi4';
        
    end
    
    properties (Access = private)
        
        psi4_sphericalAM; % used in psi4->gaussian density format converting
        
    end
    
    methods
        
        function obj = MatGDMA(matpsi)
            obj.shellNprims = matpsi.shellNprims();
            obj.shell2atom = matpsi.shell2center();
            obj.shellNfuncs = matpsi.shellNfuncs();
            obj.nucleiCharges = matpsi.Zlist();
            obj.xyzSites = matpsi.geom()'; % xyzSites in Bohr
            obj.primExps = matpsi.primExps();
            obj.primCoefs = matpsi.primCoefs(); % un-normalized
            
            obj.psi4_sphericalAM = matpsi.basis_has_puream();
            
            % default limit is 4 for non-H and 1 for H
            obj.default_limit = (obj.nucleiCharges~=1); % [O H H] -> [1 0 0]
            obj.default_limit = obj.default_limit * 3; % [1 0 0] -> [3 0 0]
            obj.default_limit = obj.default_limit + 1; % [3 0 0] -> [4 1 1]
            
            % default algorithm threshold is 0 (always use old algorithm)
            obj.default_bigexp = 0.0;
            
        end
        
        function multipoles_ = RunGDMA(obj, occOrb, bigexp, limit)
            if(nargin < 3)
                bigexp = obj.default_bigexp;
            end
            if(nargin < 4)
                limit = obj.default_limit;
            end
            if(length(limit) < length(obj.default_limit)) % if limit is too short fill with defaults
                limit(end+1:length(obj.default_limit)) = obj.default_limit(length(limit)+1:end);
            end
            obj.limit = limit;
            obj.bigexp = bigexp;
            
            % GDMA wants a Gaussian style density matrix
            if(strcmpi(obj.density_format, 'Psi4') || strcmpi(obj.density_format, 'MatPsi'))
                obj.density = obj.Psi4OccOrb2GaussianDensity(occOrb);
            end
            
            % turn off warning
            warning('off', 'MATLAB:structOnObject')
            
            %!!! GDMA driver !!!
            multipoles_ = matgdma_mex(struct(obj));
            
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
    
end

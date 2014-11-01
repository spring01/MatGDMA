classdef MatGDMA < handle
    
    properties (SetAccess = private)
        
        input_args;
        multipoles;
        
    end
    
    properties
        
        default_limit;
        default_bigexp;
        
    end
    
    methods
        
        function obj = MatGDMA(matpsi)
            obj.input_args.numSites = matpsi.natom();
            obj.input_args.numShells = matpsi.nshell();
            obj.input_args.numPrims = sum(matpsi.shellNprims());
            obj.input_args.shellNprims = matpsi.shellNprims();
            obj.input_args.shell2atom = matpsi.shell2center();
            obj.input_args.shellType = matpsi.shellTypes();
            obj.input_args.shellNfuncs = matpsi.shellNfuncs();
            obj.input_args.nucleiCharges = matpsi.Zlist();
            obj.input_args.xyzSites = matpsi.geom()'; % xyzSites in Bohr
            obj.input_args.primExps = matpsi.primExps();
            obj.input_args.primCoefs = matpsi.primCoefs(); % un-normalized
            obj.input_args.density = obj.MatPsi2GaussianDensity(matpsi);
            
            % default limit is 4 for non-H and 1 for H
            obj.default_limit = (obj.input_args.nucleiCharges~=1); % [O H H] -> [1 0 0]
            obj.default_limit = obj.default_limit * 3; % [1 0 0] -> [3 0 0]
            obj.default_limit = obj.default_limit + 1; % [3 0 0] -> [4 1 1]
            
            % default algorithm threshold is 0 (always use old algorithm)
            obj.default_bigexp = 0.0;
            
            obj.RunGDMA();
        end
        
        function multipoles_ = RunGDMA(obj, limit, bigexp)
            if(nargin < 2)
                limit = obj.default_limit;
            end
            if(nargin < 3)
                bigexp = obj.default_bigexp;
            end
            if(length(limit) < length(obj.default_limit)) % if limit is too short fill with defaults
                limit(end+1:length(obj.default_limit)) = obj.default_limit(length(limit)+1:end);
            end
            obj.input_args.limit = limit;
            obj.input_args.bigexp = bigexp;
            multipoles_ = matgdma_mex(obj.input_args);
            multipoles_ = multipoles_(2:end, 1:obj.input_args.numSites);
            obj.multipoles = multipoles_;
        end
        
        function res = NthOrderMthSite(obj, nthOrder, mthSite)
            % Qn0 Qn1s Qn1c Qn2s Qn2c ...
            res = obj.multipoles(nthOrder^2+1:(nthOrder+1)^2, mthSite);
        end
        
    end
    
    methods (Access = private)
        
        function density = MatPsi2GaussianDensity(~, matpsi)
            matpsi.RHF();
            occOrb = matpsi.RHF_C();
            occOrb = occOrb(:, 1:matpsi.nelec()/2);
            
            nshell = matpsi.nshell();
            
            shellNfuncs = matpsi.shellNfuncs();
            shell2startFunc = cumsum([1 shellNfuncs]);
            shell2startFunc = shell2startFunc(1:end-1);
            
            if(matpsi.basis_has_puream()) % spherical
                for i = 1:nshell
                    if(shellNfuncs(i) == 3) % 3p; need to change [z x y] -> [x y z]
                        occOrb((1:3)+shell2startFunc(i)-1, :) = ...
                            occOrb([2 3 1]+shell2startFunc(i)-1, :);
                    end
                end
            else % cartesian
                for i = 1:nshell
                    if(shellNfuncs(i) == 6) % 6d; need to change [xx xy xz yy yz zz] -> [xx yy zz xy xz yz]
                        occOrb((1:6)+shell2startFunc(i)-1, :) = ...
                            occOrb([1 4 6 2 3 5]+shell2startFunc(i)-1, :);
                        occOrb((4:6)+shell2startFunc(i)-1, :) = ...
                            occOrb((4:6)+shell2startFunc(i)-1, :) ./ sqrt(3);
                    end
                    if(shellNfuncs(i) == 10) % 10f; need to change
                        % [xxx xxy xxz xyy xyz xzz yyyyyz yzz zzz]
                        % -> [xxx yyy zzz xyy xxy xxz xzz yzz yyz xyz]
                        occOrb((1:10)+shell2startFunc(i)-1, :) = ...
                            occOrb([1 7 10 4 2 3 6 9 8 5]+shell2startFunc(i)-1, :);
                        occOrb((1:10)+shell2startFunc(i)-1, :) = ...
                            occOrb((1:10)+shell2startFunc(i)-1, :) ...
                            ./ repmat([ones(1,3) sqrt(5)*ones(1,6) sqrt(15)]',1,size(occOrb,2));
                    end
                    if(shellNfuncs(i) == 15) % 15g; reverse order
                        occOrb((1:15)+shell2startFunc(i)-1, :) = ...
                            occOrb((15:-1:1)+shell2startFunc(i)-1, :);
                        occOrb((1:15)+shell2startFunc(i)-1, :) = ...
                            occOrb((1:15)+shell2startFunc(i)-1, :) ...
                            ./ repmat( ...
                            [1 sqrt(7) sqrt(35/3) sqrt(7) 1, ...
                            sqrt(7) sqrt(35) sqrt(35) sqrt(7) sqrt(35/3), ...
                            sqrt(35) sqrt(35/3) sqrt(7) sqrt(7) 1]',1,size(occOrb,2));
                    end
                end
            end
            density = 2.*occOrb*occOrb';
        end
        
    end
    
end

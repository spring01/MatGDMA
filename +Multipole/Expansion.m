classdef Expansion < handle
    
    properties (SetAccess = private)
        
        xyz;
        coeffs; % make sure to reorder this into [z y x 20 21s 21c ...]
        
        multipoles; % cell array holds multipoles of different orders
        
    end
    
    methods
        
        function obj = Expansion(matpsiGDMA, iSite)
            obj.xyz = matpsiGDMA.xyzSites(:, iSite);
            obj.coeffs = ...
                matpsiGDMA.multipoles(1:(matpsiGDMA.limit(iSite)+1)^2, iSite);
            for i = 1:sqrt(length(obj.coeffs))
                % order = i - 1;
                obj.multipoles{i} = Multipole.Factory.CreateOrder(i-1);
            end
        end
        
        function matrix = InteractionWith(multiExpA, multiExpB)
            matrix = zeros(length(multiExpA.coeffs), ...
                length(multiExpB.coeffs));
            vecA2B = multiExpB.xyz - multiExpA.xyz; % vector A to B
            vecA2B = vecA2B([3 2 1]); % change into z y x
            one_over_bigR = 1 / norm(vecA2B);
            vecA2B = vecA2B .* one_over_bigR; % normalize vecAB
            
            for i = 1:multiExpA.MaxOrderPlus1()
                matrix((i-1)^2+1:i^2, :) = multiExpA.multipoles{i}.WithMaxOrder(vecA2B, multiExpB.MaxOrderPlus1());
            end
            
            exponent_mat = repmat((1:multiExpA.MaxOrderPlus1())', 1, multiExpB.MaxOrderPlus1()) ...
                + repmat((1:multiExpB.MaxOrderPlus1()), multiExpA.MaxOrderPlus1(), 1);
            exponent_mat = exponent_mat - ones(size(exponent_mat));
            
            mapping = [1 ...
                2 2 2 ...
                3 3 3 3 3 ...
                4 4 4 4 4 4 4 ...
                5 5 5 5 5 5 5 5 5];
            mappingA = mapping(1:length(multiExpA.coeffs));
            mappingB = mapping(1:length(multiExpB.coeffs));
            
            bigR_to_minusN_mat = one_over_bigR .^ exponent_mat;
            matrix = bigR_to_minusN_mat(mappingA, mappingB) .* matrix;
        end
        
    end
    
    methods (Access = private)
        
        function maxOrderPlus1 = MaxOrderPlus1(obj)
            maxOrderPlus1 = length(obj.multipoles);
        end
        
    end
    
end

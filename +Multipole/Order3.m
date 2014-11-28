classdef Order3 < Multipole.Base
    
    methods (Access = protected)
        
        function res = BlockWith0(obj, vecAB)
            res = obj.Block30(vecAB);
        end
        
        function res = BlockWith1(obj, vecAB)
            res = obj.Block31(vecAB);
        end
        
        function res = BlockWith2(obj, vecAB)
            res = obj.Block32(vecAB);
        end
        
        function res = BlockWith3(obj, vecAB)
            res = obj.Block33(vecAB);
        end
        
        function res = BlockWith4(obj, vecAB)
            res = obj.Block43(-vecAB)';
        end
        
    end
    
end

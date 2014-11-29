classdef Order3 < Multipole.Base
    
    methods (Access = protected)
        
        function res = With0(obj, vecAB)
            res = obj.Block30(vecAB);
        end
        
        function res = With1(obj, vecAB)
            res = obj.Block31(vecAB);
        end
        
        function res = With2(obj, vecAB)
            res = obj.Block32(vecAB);
        end
        
        function res = With3(obj, vecAB)
            res = obj.Block33(vecAB);
        end
        
        function res = With4(obj, vecAB)
            res = obj.Block43(-vecAB)';
        end
        
    end
    
end

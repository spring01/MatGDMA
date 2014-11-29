classdef Order1 < Multipole.Base
    
    methods (Access = protected)
        
        function res = With0(obj, vecAB)
            res = obj.Block10(vecAB);
        end
        
        function res = With1(obj, vecAB)
            res = obj.Block11(vecAB);
        end
        
        function res = With2(obj, vecAB)
            res = obj.Block21(-vecAB)';
        end
        
        function res = With3(obj, vecAB)
            res = obj.Block31(-vecAB)';
        end
        
        function res = With4(obj, vecAB)
            res = obj.Block41(-vecAB)';
        end
        
    end
    
end

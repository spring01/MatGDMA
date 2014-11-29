classdef Order2 < Multipole.Base
    
    methods (Access = protected)
        
        function res = With0(obj, vecAB)
            res = obj.Block20(vecAB);
        end
        
        function res = With1(obj, vecAB)
            res = obj.Block21(vecAB);
        end
        
        function res = With2(obj, vecAB)
            res = obj.Block22(vecAB);
        end
        
        function res = With3(obj, vecAB)
            res = obj.Block32(-vecAB)';
        end
        
        function res = With4(obj, vecAB)
            res = obj.Block42(-vecAB)';
        end
        
    end
    
end

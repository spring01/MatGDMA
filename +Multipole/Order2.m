classdef Order2 < Multipole.Base
    
    methods (Access = protected)
        
        function res = BlockWith0(obj, vecAB)
            res = obj.Block20(vecAB);
        end
        
        function res = BlockWith1(obj, vecAB)
            res = obj.Block21(vecAB);
        end
        
        function res = BlockWith2(obj, vecAB)
            res = obj.Block22(vecAB);
        end
        
        function res = BlockWith3(obj, vecAB)
            res = obj.Block32(-vecAB)';
        end
        
        function res = BlockWith4(obj, vecAB)
            res = obj.Block42(-vecAB)';
        end
        
    end
    
end

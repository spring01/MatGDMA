classdef Order1 < Multipole.Base
    
    methods (Access = protected)
        
        function res = BlockWith0(obj, vecAB)
            res = obj.Block10(vecAB);
        end
        
        function res = BlockWith1(obj, vecAB)
            res = obj.Block11(vecAB);
        end
        
        function res = BlockWith2(obj, vecAB)
            res = obj.Block21(-vecAB)';
        end
        
        function res = BlockWith3(obj, vecAB)
            res = obj.Block31(-vecAB)';
        end
        
        function res = BlockWith4(obj, vecAB)
            res = obj.Block41(-vecAB)';
        end
        
    end
    
end
